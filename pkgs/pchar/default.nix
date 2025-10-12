{ stdenv, fetchzip }:
stdenv.mkDerivation {
  name = "pchar";
  src = fetchzip {
    url = "https://www.kitchenlab.org/www/bmah/Software/pchar/pchar-1.5.tar.gz";
    hash = "sha256-MD14I/wrEXTziMQVrD9ZZCYvGbKiqprUNY/4SHRG5J8=";
  };
}
