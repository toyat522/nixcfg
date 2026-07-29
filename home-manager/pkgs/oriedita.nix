{ lib, maven, jre, makeWrapper, fetchFromGitHub }:

maven.buildMavenPackage rec {
  pname = "oriedita";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "oriedita";
    repo = "oriedita";
    rev = "v${version}";
    hash = "sha256-xXb8lTWRlR2ybgAAUhRgdBTZXj+aJZ19d8MNkNKf4ds=";
  };

  mvnHash = "sha256-/gW+BSq32nP179N4lIlRvACAiwoTPfbnqNp3wZzuM3I=";

  mvnParameters = "-DskipTests -pl oriedita --also-make";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    # Copy the shaded JAR into the Nix store
    install -Dm644 oriedita/target/oriedita-${version}.jar \
      $out/share/java/oriedita.jar

    # Flags directly from upstream oriedita/build/jpackage-common.txt
    makeWrapper ${jre}/bin/java $out/bin/oriedita \
      --add-flags "-Dfile.encoding=UTF-8" \
      --add-flags "-Xmx8g" \
      --add-flags "-jar $out/share/java/oriedita.jar"

    # Install the oriedita desktop entry and icon
    install -Dm644 build/Oriedita.png \
      $out/share/icons/hicolor/256x256/apps/oriedita.png
    install -Dm644 /dev/stdin $out/share/applications/oriedita.desktop << EOF
    [Desktop Entry]
    Name=Oriedita
    Exec=oriedita
    Icon=oriedita
    Type=Application
    Categories=Graphics;
    EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Origami editor with a focus on origami design";
    homepage = "https://oriedita.github.io/";
    license = licenses.gpl3Plus;
    mainProgram = "oriedita";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
