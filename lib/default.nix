{lib}: {
  configs = import ./configs {inherit lib;};
  imports = import ./imports {inherit lib;};
  options = import ./options {inherit lib;};
}
