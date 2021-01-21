{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, musl-fts, obstack, m4, zlib, bzip2, bison, flex, gettext, xz, setupDebugInfoDirs, argp-standalone }:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  pname = "elfutils";
  version = "0.182";

  src = fetchurl {
    url = "https://sourceware.org/elfutils/ftp/${version}/${pname}-${version}.tar.bz2";
    sha256 = "7MQGkU7fM18Lf8CE6+bEYMTW1Rdb/dZojBx42RRriFg=";
  };

  patches = [ ./debug-info-from-env.patch ]
    ++ lib.optional stdenv.hostPlatform.isMusl ./musl-compat.patch;

  hardeningDisable = [ "format" ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [ m4 bison flex gettext bzip2 ]
    ++ lib.optional stdenv.hostPlatform.isMusl
        [ pkg-config autoreconfHook ] ;
  buildInputs = [ zlib bzip2 xz ]
    ++ lib.optional stdenv.hostPlatform.isMusl
        [ argp-standalone musl-fts obstack ];

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -fgnu89-inline"
    NIX_CFLAGS_COMPILE+=" -Wno-null-dereference"
  '';

  configureFlags =
    [ "--program-prefix=eu-" # prevent collisions with binutils
      "--enable-deterministic-archives"
      "--disable-libdebuginfod"
      "--disable-debuginfod"
    ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 out of 174 tests
  doInstallCheck = false; # fails 70 out of 174 tests

  meta = with lib; {
    homepage = "https://sourceware.org/elfutils/";
    description = "A set of utilities to handle ELF objects";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.eelco ];
  };
}
