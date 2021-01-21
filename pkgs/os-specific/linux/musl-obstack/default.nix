{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "musl-obstack";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "musl-obstack";
    rev = "d0493f4726835a08c5a145bce42b61a65847c6a9";
    sha256 = "v0RTnrqAmJfOeGsJFc04lqFR8QZhYiLyvy8oRYiuC80=";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/void-linux/musl-obstack";
    description = "An extraction of the obstack functions and macros from GNU libiberty for use with musl-libc";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.eelco ];
  };
}
