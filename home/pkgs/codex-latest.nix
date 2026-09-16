{ lib, stdenvNoCC, makeBinaryWrapper, ripgrep, bubblewrap }:

let
  target = "x86_64-unknown-linux-musl";
  srcs = [
    (builtins.fetchurl "https://github.com/openai/codex/releases/latest/download/codex-${target}.tar.gz")
    (builtins.fetchurl "https://github.com/openai/codex/releases/latest/download/codex-code-mode-host-${target}.tar.gz")
  ];
in
stdenvNoCC.mkDerivation {
  pname = "codex";
  version = "latest";
  inherit srcs;

  nativeBuildInputs = [ makeBinaryWrapper ];

  sourceRoot = ".";
  unpackCmd = "tar xzf $curSrc";

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-${target} $out/bin/codex
    install -Dm755 codex-code-mode-host-${target} $out/bin/codex-code-mode-host
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
