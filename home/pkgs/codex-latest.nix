{ lib, stdenvNoCC, makeBinaryWrapper, ripgrep, bubblewrap }:

let
  target = "x86_64-unknown-linux-musl";
  src = builtins.fetchurl "https://github.com/openai/codex/releases/latest/download/codex-${target}.tar.gz";
in
stdenvNoCC.mkDerivation {
  pname = "codex";
  version = "latest";
  inherit src;

  nativeBuildInputs = [ makeBinaryWrapper ];

  sourceRoot = ".";
  unpackCmd = "tar xzf $curSrc";

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-${target} $out/bin/codex
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/codex --prefix PATH : ${lib.makeBinPath [ ripgrep bubblewrap ]}
  '';

  meta = {
    description = "ChatGPT agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    platforms = [ "x86_64-linux" ];
  };
}
