{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "musl-fts";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "musl-fts";
    rev = "0bde52df588e8969879a2cae51c3a4774ec62472";
    sha256 = "Azw5qrz6OKDcpYydE6jXzVxSM5A8oYWAztrHr+O/DOE=";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/void-linux/musl-fts";
    description = "An implementation of fts(3) for musl-libc";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.pjjw ];
  };
}
