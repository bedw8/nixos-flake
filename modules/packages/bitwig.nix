final: prev:
{
  bw = prev.bitwig-studio.overrideAttrs (old: let
    bjar = ./bitwig.jar;
  in
    {
      postInstall = ''
        cp ${bjar} "$out/bin/bitwig.jar"
        '' + old.postInstall
      });
}
