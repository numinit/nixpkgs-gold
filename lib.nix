let
  inherit (builtins)
    fromJSON
    throw
    ;
in
rec {
  nixpkgsGold = fromJSON ''"\u001b[33mnixpkgs gold\u001b[0m"'';

  throwGold =
    {
      msg ? null,
      drv ? null,
    }:
    let
      subject = if drv == null then "This derivation" else "Package '${drv.name}'";
      prefix = if msg == null then subject else "${msg}: ${subject}";
    in
    throw "${prefix} requires ${nixpkgsGold}, refusing to evaluate.";
}
