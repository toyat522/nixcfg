{ claude-code, stdenv }:

let
  baseUrl = "https://downloads.claude.ai/claude-code-releases";
  version = builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile (builtins.fetchurl "${baseUrl}/latest"));
  platformKey = "${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}";
in
claude-code.overrideAttrs (_: {
  inherit version;
  src = builtins.fetchurl "${baseUrl}/${version}/${platformKey}/claude";
})
