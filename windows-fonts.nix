{
  lib,
  stdenv,
  
  isoUrl,
  windowsVersion,
  outputHash,

  kmod,
  iproute2,
  httpdirfs,
  cacert,
  util-linux,
  p7zip,
}:
stdenv.mkDerivation {
  pname = "windows-fonts";
  version = "win${windowsVersion}";

  builder = ./builder.sh;
  inherit isoUrl;

  nativeBuildInputs = [
    kmod
    iproute2
    httpdirfs
    cacert
    util-linux
    p7zip
  ];

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  inherit outputHash;

  QEMU_OPTS = "-netdev user,id=net0,net=10.0.0.0/24,dhcpstart=10.0.0.10 -device virtio-net-pci,netdev=net0";

  meta = with lib; {
    description = "Fonts bundled in Windows ${windowsVersion}";
    homepage = "https://learn.microsoft.com/en-us/typography/";
    license = licenses.unfree;
  };
}
