{
  craneLib,
  pkgs,
  fetchFromGitHub,
  rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "linux-broadcast";
  version = "0.4.0";
  src = craneLib.cleanCargoSource (fetchFromGitHub {
    owner = "Pedrojok01";
    repo = pname;
    tag = "v${version}";
    sha256 = "3CTK4xelkQgWFhW80PlcL0+j+C4+ylff/o/H8KTuofM=";
  });
  cargoHash = "sha256-1OM+pOtMDcODX/6g2z1jDIV3yAsL840glFGTtYR2WFE";

  buildInputs = with pkgs; [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-libav
    atk
    libxcb
    gdk-pixbuf
    pango
    gtk3
    cairo
  ];
  nativeBuildInputs = with pkgs; [
    pkg-config
    glib
  ];
}
# craneLib.buildPackage rec {
#   pname = "linux-broadcast";
#   version = "0.4.0";
#   src = craneLib.cleanCargoSource (fetchFromGitHub {
#     owner = "Pedrojok01";
#     repo = pname;
#     tag = "v${version}";
#     sha256 = "3CTK4xelkQgWFhW80PlcL0+j+C4+ylff/o/H8KTuofM=";
#   });
#   buildInputs = with pkgs; [
#     pkg-config
#     glib
#     gst_all_1.gstreamer
#     gst_all_1.gst-plugins-good
#     gst_all_1.gst-plugins-bad
#     gst_all_1.gst-plugins-base
#     gst_all_1.gst-libav
#     atk
#     libxcb
#   ];
# }
