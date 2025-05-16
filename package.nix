{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  zlib,
  elfutils,
  dmidecode,
  jq,
  gcc-unwrapped,
}:
stdenv.mkDerivation {
  pname = "sentinelone";
  version = "25.1.2.17";

  src = fetchurl {
    url = "file:///home/felix/SentinelAgent_linux_x86_64_v25_1_2_17.deb";
    hash = "sha256-M3o+d3/abk8M/9ghScJwtRVwCRSEYvPbcpB+bSIGIzk=";
  };

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    zlib
    elfutils
    dmidecode
    jq
    gcc-unwrapped
  ];

  installPhase = ''
    mkdir -p $out/opt/
    mkdir -p $out/cfg/
    mkdir -p $out/bin/

    cp -r opt/* $out/opt

    ln -s $out/opt/sentinelone/bin/sentinelctl $out/bin/sentinelctl
    ln -s $out/opt/sentinelone/bin/sentinelone-agent $out/bin/sentinelone-agent
    ln -s $out/opt/sentinelone/bin/sentinelone-watchdog $out/bin/sentinelone-watchdog
    ln -s $out/opt/sentinelone/lib $out/lib
  '';

  preFixup = ''
    patchelf --replace-needed libelf.so.0 libelf.so $out/opt/sentinelone/lib/libbpf.so
  '';
}
