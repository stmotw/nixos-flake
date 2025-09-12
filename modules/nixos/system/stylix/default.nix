{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
}
