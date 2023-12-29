{lib}: {
  asDisplays = allDisplays: configured: let
    missing = builtins.filter (display: (lib.lists.findSingle (x: x.name == display) null null) configured == null) allDisplays;
    asDisplay = builtins.map (display: {name = display;}) missing;
  in
    asDisplay ++ configured;
}
