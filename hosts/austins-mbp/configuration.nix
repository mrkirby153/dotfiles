{...}: {
  config.aus = {
    username = "austin";
    uid = 501;
    home = "/Users/austin";

    sops.enable = true;

    programs = {
      shell.enable = true;
      git = {
        enable = true;
        sign = {
          enable = true;
          key = "90EF2AB021AB6FED";
        };
      };
      attic.enable = true;
      vim.enable = true;
      screenshot.enable = false;
    };
  };
}
