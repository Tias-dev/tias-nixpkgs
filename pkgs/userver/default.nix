{
  pkgs,
  lib,
  inputs',
  callPackage,
  stdenv,
  fetchFromGitHub,
  python3Packages,
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
  withMySQL ? false,
  withGrpc ? false,
}: let
  clickhouse-cpp = callPackage ./clickhouse-cpp.nix {};
  new-pkgs = inputs'.new-nixpkgs.legacyPackages;
  customPythonPackages = ( callPackage ./pythonLibs.nix {} ).pythonEnvWithAllIncluded;
  updatedPackages = {
    postgresql = new-pkgs.postgresql.overrideAttrs (_: _: {dontDisableStatic = true;});
    libpq = new-pkgs.libpq.overrideAttrs (_: _: {dontDisableStatic = true;});
  };
  api-common-protos = pkgs.fetchFromGitHub {
    owner = "googleapis";
    repo = "api-common-protos";
    rev = "3332dec527759859840a3a2ff108c67a54708130";
    hash = "sha256-GeWNBzT0lRncT+fz+TlEfp+J4FqmzuHwVhYxMN6e3FU";
  };
  grpc-api-common-proto-patch = pkgs.callPackage ./grpc-api-common-proto-patch.nix {inherit api-common-protos;};
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

    patches = [
      ./mysql.patch

      # Force virtualenv to use packages from buildInputs
      # and disable CPM downloading
      # as we dont need(and we can't) to download smth
      ./no-download.patch

      ./grpc.patch
      "${grpc-api-common-proto-patch}"
    ];

    cmakeFlags =
      with updatedPackages;
        [
          # Required
          "-DUSERVER_INSTALL=ON"

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
        ++ (lib.optionals (withAllComponents || withMySQL) ["-DUSERVER_FEATURE_MYSQL=ON" "-DPATHED_LIBMARIADB_PATH=${pkgs.mariadb-connector-c}/lib/mariadb"])
        ++ (lib.optionals (withAllComponents || withGrpc) ["-DUSERVER_FEATURE_GRPC=ON"])
      # # rocks disable for now via rocksdb have uring::uring target in interface but not this target not found
      # "-DUSERVER_FEATURE_ROCKS=ON"
      # # ydb disable for now due to i don't work on its building for a while
      # "-DUSERVER_FEATURE_YDB=ON"
      # # grpc disable for now via grpc package export upb related targets but not define it
      # # otlp disabled as it is require grpc to work
      # "-DUSERVER_FEATURE_OTLP=ON"
      # # grpc-reflection disabled as it is require grpc to work
      # "-DUSERVER_FEATURE_GRPC_REFLECTION=ON"
      # # s3 grpc client disabled as it is require grpc to work
      # "-DUSERVER_FEATURE_S3API=ON"
      # # odbc disable for now via it requires sql.h header which is not found
      # "-DUSERVER_FEATURE_ODBC=ON"
      ;
    propagatedNativeBuildInputs = with pkgs; [
      cmake
      pkg-config
    ];

    # fix mariadb.rc -> libmariadb.rc link for pkg-config
    preConfigure = (
      lib.optionalString withMySQL ''
                mkdir -p $out/mysql-tmp/pkgconfig
                ln -s ${pkgs.mariadb-connector-c.dev}/lib/pkgconfig/libmariadb.pc $out/mysql-tmp/pkgconfig/mariadb.pc
        export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$out/mysql-tmp/pkgconfig
      ''
    );
    postConfigure = lib.optionalString withMySQL "rm -rf $out/mysql-tmp";

    propagatedBuildInputs = with pkgs;
      [
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

        protobuf
        grpc
        abseil-cpp

        customPythonPackages
      ]
      ++ (lib.optional (withAllComponents || withRedis) hiredis)
      ++ (lib.optional (withAllComponents || withClickhouse) clickhouse-cpp)
      ++ (lib.optionals (withAllComponents || withKafka) [lz4 cyrus_sasl rdkafka])
      ++ (lib.optional (withAllComponents || withRabbitMQ) libamqpcpp)
      ++ (lib.optional (withAllComponents || withSQLite) sqlite)
      ++ (lib.optional (withAllComponents || withMongoDB) mongoc)
      ++ (lib.optionals (withAllComponents || withPostgresql) [openldap updatedPackages.libpq.dev libkrb5.dev])
      ++ (lib.optionals (withAllComponents || withMySQL) [mariadb-connector-c mariadb-connector-c.dev]);
  }
