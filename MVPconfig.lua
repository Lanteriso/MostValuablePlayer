MVP_Settings = {}

local cfg = MVP_Settings -- so you don't have to edit the rest

-- default value if 1st use
cfg.MVPvsframeP = "TOPLEFT";
cfg.MVPvsframeX = 22;
cfg.MVPvsframeY = -140;
cfg.MVPvsscale = 0.8;
cfg.MVPvsalpha = 1;
cfg.raidmenuid = 1;
cfg.MVPvsms = false; -- mouse scanning for target and raid progression
cfg.MVPvsme = false; -- enchant and gem reminder
cfg.MVPvsme2 = false; -- best enchant and gem reminder
cfg.MVPvscharilvl = false; -- Char Frame item level
cfg.MVPvsrpdetails = true; -- raid progression details
cfg.MVPvsgears = {}; -- players equipments
cfg.MVPvscache = {}; -- cache
cfg.MVPvsminimapicon = true;
cfg.MVPvsprintloaded = false;
cfg.MVPvssummaryshow = true;
cfg.MVPvsdp = 1; -- decimal places for item level
cfg.MVPvsun = true; -- show upgrade number
cfg.MVPvsge = true; -- show gem and enchant in character frame and inpection frame
cfg.MVPvscachesw = true; -- enable cache
cfg.MVPvsaltclickroll = true; -- alt click roll
cfg.MVPvsautoscan = true; -- auto scan ilvl
cfg.MVPvssamefaction = false; -- show ilvl of target for same faction only
cfg.MVPvsbagilvl = false; -- show item level of gear in bag
cfg.MVPvscolormatchitemrarity = true; -- item level color follow the color of item rarity

cfg.MVPvsnoti = true; -- 通报MVP
cfg.MVPvsline = true; -- 鼠标提示MVP
