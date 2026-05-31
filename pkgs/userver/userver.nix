{
  pkgs,
  callPackage,
  stdenv,
  fetchFromGitHub,
  clickhouse-cpp,
}: let
  customPythonPackages = callPackage ./pythonLibs.nix {};
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

    cmakeFlags = [
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

      # enabled features
      "-DUSERVER_FEATURE_REDIS=ON"
      "-DUSERVER_FEATURE_CLICKHOUSE=ON"
      "-DUSERVER_FEATURE_KAFKA=ON"
      "-DUSERVER_FEATURE_RABBITMQ=ON"
      "-DUSERVER_FEATURE_SQLITE=ON"
      "-DUSERVER_FEATURE_ODBC=ON"
      "-DUSERVER_FEATURE_MULTI_INDEX_LRU=ON"
      


      # # build all components
      # "-DUSERVER_BUILD_ALL_COMPONENTS=ON"
      #
      # # mongodb disable for now via bson_INCLUDE_DIRS not found in configure phase
      # "-DUSERVER_FEATURE_MONGODB=ON"
      #
      # # postgresql disable for now via Imported target "PostgreSQLInternal" includes non-existent path
      # "-DUSERVER_FEATURE_POSTGRESQL=ON"
      # "-DUSERVER_FEATURE_EASY=ON" # requires postgresql

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
    ];

    propagatedNativeBuildInputs = with pkgs; [
      cmake
      pkg-config

      boost186
      yaml-cpp
      cryptopp
      fmt_11
      cctz
      jemalloc
      re2
      openssl_3_6
      gtest
      git
      zstd
      zlib
      nghttp2
      libev
      c-ares
      curl
      clang-tools
      gbenchmark

      # redis
      hiredis

      # clickhouse
      clickhouse-cpp
      
      # kafka
      lz4
      cyrus_sasl
      rdkafka

      # rabbitMQ
      libamqpcpp

      # sqlite
      sqlite

      # # grpc
      # protobuf
      # grpc

      # # rocks
      # rocksdb

      # # mysql
      # mariadb-connector-c

      # # mongodb
      # mongoc
      #
      # # postgresql
      # openldap
      # postgresql
      #
      
      # # grpc
      # protobuf
      # grpc
    ];

    propagatedBuildInputs = with pkgs; [
      (python313.withPackages (
        ps:
          with ps;
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
          ]
      ))
    ];
  }
