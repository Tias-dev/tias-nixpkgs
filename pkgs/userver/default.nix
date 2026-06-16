{
  pkgs,
  lib,
  inputs',
  callPackage,
  stdenv,
  fetchFromGitHub,
  # features
  withAllComponents ? false,
  withRedis ? false,
  withClickhouse ? false,
  withMongoDB ? false,
  withPostgresql ? false,
  withKafka ? false,
  withRabbitMQ ? false,
  withSQLite ? false,
  withEasy ? false,
  withMultiIndexLRU ? false,
}: let
  clickhouse-cpp = callPackage ./clickhouse-cpp.nix {};
  new-pkgs = inputs'.new-nixpkgs.legacyPackages;
  customPythonPackages = callPackage ./pythonLibs.nix {};
  updatedPackages = {
    postgresql = new-pkgs.postgresql.overrideAttrs (final: prev: {dontDisableStatic = true;});
    libpq = new-pkgs.libpq.overrideAttrs (final: prev: {dontDisableStatic = true;});
  };
in
  stdenv.mkDerivation {
    pname = "userver-lib";
    version = "3.0";
    src = fetchFromGitHub {
      owner = "userver-framework";
      repo = "userver";
      rev = "v3.0";
      sha256 = "uI91z2pSIoc3Az/N4dwsmkFb7gcFGKx39cHmkPIhpOE=";
    };

    cmakeFlags =
      with updatedPackages;
        [
          # Required
          "-DUSERVER_INSTALL=ON"

          # All packages installed by buildInputs
          # so we dont need(and we can't) to download smth
          "-DUSERVER_DOWNLOAD_PACKAGES=OFF"
          "-DUSERVER_CHECK_PACKAGE_VERSIONS=0"

          # Force virtualenv to use packages from buildInputs
          # so we dont need(and we can't) to download smth
          "-DUSERVER_PIP_USE_SYSTEM_PACKAGES=ON"
          "-DUSERVER_PIP_OPTIONS=--no-index"

          # boost_stacktrace_backtrace is not provided by boost186 build input
          # TODO: create custom boost package with boost_stacktrace_backtrace support
          "-DUSERVER_FEATURE_STACKTRACE=OFF"
        ]
        # enabled features
        ++ (lib.optional (withAllComponents || withRedis) "-DUSERVER_FEATURE_REDIS=ON")
        ++ (lib.optional (withAllComponents || withClickhouse) "-DUSERVER_FEATURE_CLICKHOUSE=ON")
        ++ (lib.optional (withAllComponents || withKafka) "-DUSERVER_FEATURE_KAFKA=ON")
        ++ (lib.optional (withAllComponents || withRabbitMQ) "-DUSERVER_FEATURE_RABBITMQ=ON")
        ++ (lib.optional (withAllComponents || withSQLite) "-DUSERVER_FEATURE_SQLITE=ON")
        ++ (lib.optional (withAllComponents || withMultiIndexLRU) "-DUSERVER_FEATURE_MULTI_INDEX_LRU=ON")
        ++ (lib.optional (withAllComponents || withMongoDB) "-DUSERVER_FEATURE_MONGODB=ON")
        ++ (lib.optionals (withAllComponents || withPostgresql) [
          "-DUSERVER_FEATURE_POSTGRESQL=ON"
          "-DUSERVER_PG_SERVER_INCLUDE_DIR=${libpq.dev}/include/postgresql/server"
          "-DUSERVER_PG_SERVER_LIBRARY_DIR=${libpq.dev}/lib"
          "-DUSERVER_PG_INCLUDE_DIR=${libpq.dev}/include"
          "-DUSERVER_PG_LIBRARY_DIR=${libpq.dev}/lib"
        ])
        ++ (lib.optional (withAllComponents || withEasy) "-DUSERVER_FEATURE_EASY=ON")
      #  # mysql disable for now via libmariadb library can't be paired with cmake but it is installed via mariadb-connector-c
      # "-DUSERVER_FEATURE_MYSQL=ON"
      # # rocks disable for now via rocksdb have uring::uring target in interface but not this target not found
      # "-DUSERVER_FEATURE_ROCKS=ON"
      # # ydb disable for now due to i don't work on its building for a while
      # "-DUSERVER_FEATURE_YDB=ON"
      # # grpc disable for now via grpc package export upb related targets but not define it
      # "-DUSERVER_FEATURE_GRPC=ON"
      # # otlp disabled as it is require grpc to work
      # "-DUSERVER_FEATURE_OTLP=ON"
      # # grpc-reflection disabled as it is require grpc to work
      # "-DUSERVER_FEATURE_GRPC_REFLECTION=ON"
      # # s3 grpc client disabled as it is require grpc to work
      # "-DUSERVER_FEATURE_S3API=ON"
      # # odbc disable for now via it requires sql.h header which is not found
      # "-DUSERVER_FEATURE_ODBC=ON"
      ;


    propagatedBuildInputs = with pkgs;
      [
        cmake
        pkg-config

        git
        openssl_3_6
        boost186
        gtest
        yaml-cpp
        zstd
        cryptopp
        fmt_11
        cctz
        jemalloc
        re2
        gbenchmark
        zlib
        libev
        nghttp2
        c-ares
        curl
        clang-tools

        (pkgs.python313.withPackages
          (pythonPkgs:
            with pythonPkgs;
            with customPythonPackages; [
              pip
              virtualenv

              # chaotic requirements
              jinja2
              transliterate
              pydantic
              pyyaml

              # cmake2md
              tree-sitter
              tree-sitter-grammars.tree-sitter-cmake

              # pylint
              pylint

              # sql
              # jinja2

              # testsuite
              requests
              websockets_12_0
              pytest
              zstd
              yandex-taxi-testsuite
              clickhouse-driver
              python-redis
              pymysql
              aio-pika
              aiokafka

              # mongodb
              pymongo

              # grpc
              # There protobuf 6 by default but can be set protobuf(4/5/6) or all of them
              protobuf6
              grpcio
              grpcio-tools
              grpcio-reflection

              # redis
              redis

              # postgres
              yandex-pgmigrate

              # ydb
              ydb

              # yandex internal tests
              httpx
              h2

              wheel
              packaging
            ]))
      ]
      ++ (lib.optional (withAllComponents || withRedis) hiredis)
      ++ (lib.optional (withAllComponents || withClickhouse) clickhouse-cpp)
      ++ (lib.optionals (withAllComponents || withKafka) [lz4 cyrus_sasl rdkafka])
      ++ (lib.optional (withAllComponents || withRabbitMQ) libamqpcpp)
      ++ (lib.optional (withAllComponents || withSQLite) sqlite)
      ++ (lib.optional (withAllComponents || withMongoDB) mongoc)
      ++ (lib.optionals (withAllComponents || withPostgresql) [openldap updatedPackages.libpq.dev libkrb5.dev ]);
  }
