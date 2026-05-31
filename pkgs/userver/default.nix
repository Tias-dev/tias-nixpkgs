{pkgs, ...}:
let
  clickhouse-cpp = pkgs.callPackage ./clickhouse-cpp.nix {}; 
  # amqp-cpp = pkgs.callPackage ./amqp-cpp.nix {}; 
in
pkgs.callPackage ./userver.nix {inherit clickhouse-cpp;}
