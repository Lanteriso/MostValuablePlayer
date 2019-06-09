local cfg
local L = MVP_L

local HELM, NECK, SHOULDER, SHIRT, CHEST, WAIST, LEGS, FEET, WRISTS, HANDS, RING1, RING2, TRINK1, TRINK2, BACK, WEP, OFFHAND = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17;

local oenchantItem = {
	[0] = {0, INVTYPE_AMMO},
	[1] = {0, INVTYPE_HEAD},
	[2] = {0, INVTYPE_NECK},
	[3] = {0, INVTYPE_SHOULDER},
	[4] = {0, INVTYPE_BODY},
	[5] = {0, INVTYPE_CHEST},
	[6] = {0, INVTYPE_WAIST},
	[7] = {0, INVTYPE_LEGS},
	[8] = {0, INVTYPE_FEET},
	[9] = {0, INVTYPE_WRIST},
	[10] = {0, INVTYPE_HAND},
	[11] = {1, INVTYPE_FINGER.."1"},
	[12] = {1, INVTYPE_FINGER.."2"},
	[13] = {0, INVTYPE_TRINKET.."1"},
	[14] = {0, INVTYPE_TRINKET.."2"},
	[15] = {0, INVTYPE_CLOAK},
	[16] = {1, INVTYPE_WEAPON},
	[17] = {0, INVTYPE_SHIELD},
}

local gslot = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_NECK"] = 2,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_BODY"] = 4,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5,
	["INVTYPE_WAIST"] = 6,
	["INVTYPE_LEGS"] = 7,
	["INVTYPE_FEET"] = 8,
	["INVTYPE_WRIST"] = 9,
	["INVTYPE_HAND"] = 10,
	["INVTYPE_FINGER"] = 11,
	["INVTYPE_TRINKET"] = 13,
	["INVTYPE_CLOAK"] = 15,
	["INVTYPE_WEAPON"] = 16,17,
	["INVTYPE_SHIELD"] = 17,
	["INVTYPE_2HWEAPON"] = 16,
	["INVTYPE_WEAPONMAINHAND"] = 16,
	["INVTYPE_WEAPONOFFHAND"] = 17,
	["INVTYPE_HOLDABLE"] = 17,
}

-- RANGE MELEE
local RM = {}
RM[62]="R" RM[63]="R" RM[64]="R" RM[65]="R" RM[66]="M" RM[70]="M" RM[71]="M" RM[72]="M" RM[73]="M" RM[102]="R"
RM[103]="M" RM[104]="M" RM[105]="R" RM[250]="M" RM[251]="M" RM[252]="M" RM[253]="R" RM[254]="R" RM[255]="M" RM[256]="R"
RM[257]="R" RM[258]="R" RM[259]="M" RM[260]="M" RM[261]="M" RM[262]="R" RM[263]="M" RM[264]="R" RM[265]="R" RM[266]="R"
RM[267]="R" RM[268]="M" RM[269]="M" RM[270]="R" RM[577]="M" RM[581]="M"
local range = 0;
local melee = 0;

local LibQTip = LibStub('LibQTip-1.0');
local otooltip; -- target raid progression detail tooltips
local otooltip2; -- OiLvL raid progression detail tooltips
local otooltip4; -- save roll item and player rolls + items
local otooltip5; -- player alt
local otooltip6; -- LDB.OnEnter
local otooltip6sw = false -- otooltip6 pin or unpin
local oicomp = {};
local otooltip7; -- cache
local otooltip6rpi;
local otooltip6sortMethod = "ID";
local oroll = {};
local orolln = 0;

local LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("M V P ",
{
	type	= "data source",
	icon	= "Interface/AddOns/MostValuablePlayer/config.tga",
	label	= "M V P ",
	text	= "M V P ",
})
local LDB_ANCHOR;
local minimapicon = LibStub("LibDBIcon-1.0")

local ORole = {
	-- width = 64, height = 16
	-- left/width, right/width, top/height, bottom/height
	-- from x = 32 to 48,       from y = 0 to 16
	-- 32/64, 48/64, 0/16, 16/16
	["TANK"]   = {"Interface\\LFGFrame\\LFGRole", 0.5, 0.75, 0, 1},
	-- 48/64, 64/64, 0/16, 16/16
	["HEALER"] = {"Interface\\LFGFrame\\LFGRole", 0.75, 1, 0, 1},
	-- 16/64, 32/64, 0/16, 16/16
	["DAMAGER"] = {"Interface\\LFGFrame\\LFGRole", 0.25, 0.5, 0, 1},
	["NONE"] = {"",0,0,0,0}
}

local OPin = {
	[1] = "|TInterface\\AddOns\\Oilvl\\pin:0:0:0:0:32:16:0:16:0:16|t", -- pin
	[2] = "|TInterface\\AddOns\\Oilvl\\pin:0:0:0:0:32:16:16:32:0:16|t"  -- unpin
}

local OClassTexture = {
	["BASE"] = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",
    ["WARRIOR"] = {0, 0.25, 0, 0.25},
    ["MAGE"]    = {0.25, 0.49609375, 0, 0.25},
    ["ROGUE"]   = {0.49609375, 0.7421875, 0, 0.25},
    ["DRUID"]   = {0.7421875, 0.98828125, 0, 0.25},
    ["HUNTER"]  = {0, 0.25, 0.25, 0.5},
    ["SHAMAN"]  = {0.25, 0.49609375, 0.25, 0.5},
    ["PRIEST"]  = {0.49609375, 0.7421875, 0.25, 0.5},
    ["WARLOCK"] = {0.7421875, 0.98828125, 0.25, 0.5},
    ["PALADIN"] = {0, 0.25, 0.5, 0.75},
    ["DEATHKNIGHT"] = {0.25, 0.49609375, 0.5, 0.75},
    ["MONK"]    = {0.49609375, 0.7421875, 0.5, 0.75},
	["DEMONHUNTER"] = {0.7421875,0.98828125,0.5,0.75}
}

local OPvP = {"Interface/PVPFrame/UI-CHARACTER-PVP-ELEMENTS",460/512,1,0,75/512}
local pvpsw = false;

local ORole2 = {
	["TANK"]   = "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:32:48:0:16:255:255:255|t",
	["HEALER"] = "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:48:64:0:16:255:255:255|t",
	["DAMAGER"] = "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:16:32:0:16:255:255:255|t",
	["NONE"] = ""
}

local ORank = {
	[0] = {""},
	[1] = {"Interface\\GROUPFRAME\\UI-GROUP-ASSISTANTICON"},
	[2] = {"Interface\\GROUPFRAME\\UI-Group-LeaderIcon"},
}
local ospec={};
local oispec;
for oispec = 62, 66 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end
for oispec = 70, 73 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end
for oispec = 102, 105 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end
for oispec = 250, 270 do
	local _, name, _, _, _, _, _ = GetSpecializationInfoByID(oispec)
	ospec[oispec] = name;
end
local dhnamespec
local _, dhnamespec, _, _, _, _, _ = GetSpecializationInfoByID(581)
ospec[581] = dhnamespec;
local _, dhnamespec, _, _, _, _, _ = GetSpecializationInfoByID(577)
ospec[577] = dhnamespec;

local classcolor = {
	[6]= "|cFFC41F3B",
	[11]= "|cFFFF7D0A",
	[3]= "|cFFABD473",
	[8]= "|cFF69CCF0",
	[10]= "|cFF00FF96",
	[2]= "|cFFF58CBA",
	[5]= "|cFFFFFFFF",
	[4]= "|cFFFFF569",
	[7]= "|cFF0070DE",
	[9]= "|cFF9482C9",
	[1]= "|cFFC79C6E",
	[0]= "|cFFFFFF00",
	[12] = "|cFFA330C9",
}

local Oilvlrole = {};
local Oilvlrank = {};
local Oilvltimer = LibStub("AceAddon-3.0"):NewAddon("OilvlTimer", "AceTimer-3.0")

local OILVL = CreateFrame("Frame");
local oilvlframesw=false;
local MVPvsframedata = {};
MVPvsframedata.guid = {};

MVPvsframedata.name = {};
MVPvsframedata.spec = {}; -- specialization
MVPvsframedata.role = {};
MVPvsframedata.ilvl = {};

MVPvsframedata.me = {}; -- miss enchant
MVPvsframedata.mg = {}; -- miss gem
MVPvsframedata.gear = {};

local OILVL_Unit="";
local OTilvl=0;
local OTmia=0;
local OTTop=0;
local Omover=0;
local omover2=0;
local OTCurrent=""; -- current raid frame
local OTCurrent2=""; -- current unit id
local OTCurrent3=""; -- current raid frame number
local ail=0; -- average item level
local ailtank=0;
local aildps=0;
local ailheal=0;
local NumRole = {};
NumRole["TANK"] = 0;
NumRole["DAMAGER"] = 0;
NumRole["HEALER"] = 0;
local OVanq = 0
local OProt = 0
local OConq = 0
local miacount=0;
local miaunit={};
local rpunit="";
local rpsw=false;
local RpdWaitTime = 1;
local rpdframe = nil;
local rpdframesw = false;
local rpdounit = nil;
local orollgear = "";
local lootslotSW = false;
local oilvlOnHyperlinkClickSW = false;
local otooltip6rpd;
local otooltip6rpdunit;
local otooltip6rpdid;
local otooltip6gearsw=false; -- show all gear
local otooltip6gearsw2=false; -- show only specific raider

local bagilvltime=0

local BFA, _, _ = EJ_GetTierInfo(8);
local ULDname, _, _, _, _, _, _ = "大秘境" or EJ_GetInstanceInfo(1031) -- Uldir 
-- Each raid has its own entry,
-- 1-4 are Raid Finder, Normal, Heroic, and Mythic kills statistic ID
    --ids = { 12749, 12752, 12763, 12768, 12773, 12776, 12779, 12745, 12782, 12785 },

    --names = { "阿塔", "自由", "诸王", "风暴", "围攻", "神庙", "暴富", "地渊", "监狱", "庄园"},

local OSTATULD = {
	{
		7399, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [1]
	{
		12749, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [2]
	{
		12752, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [3]
	{
		12763, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [4]
	{
		12768, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [5]
	{
		12773, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [6]
	{
		12776, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [7]
	{
		12779, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [8]
		{
		12745, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [9]
		{
		12782, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [10]
		{
		12785, -- [1]
		13413, -- [2]
		13413, -- [3]
		13413, -- [4]
	}, -- [11]

}

local function round(number, digits)
    return tonumber(string.format("%." .. (digits or 0) .. "f", number))
end

local function CheckClass(s)
	if s >= 250 and s <= 252 then return 6 end
	if s >= 102 and s <= 105 then return 11 end
	if s >= 253 and s <= 255 then return 3 end
	if s >= 62 and s <= 64 then return 8 end
	if s >= 268 and s <= 270 then return 10 end
	if s >= 65 and s <= 70 then return 2 end
	if s >= 256 and s <= 258 then return 5 end
	if s >= 259 and s <= 261 then return 4 end
	if s >= 262 and s <= 264 then return 7 end
	if s >= 265 and s <= 267 then return 9 end
	if s >= 71 and s <= 73 then return 1 end
end

local function checknil(...)
	local nils = {...}
	local temp = nils[1]
	for i = 1, #nils do
		if type(temp) == "nil" then return true end
		if i < #nils then
			if type(temp) == "table" then temp = temp[nils[i+1]] else return true end
		end
	end
	return false
end

local function checktrue(...)
	return not checknil(...)
end

function _OT(...)
	local nils = {...}
	local temp = nils[1]
	for i = 1, #nils do
		if type(temp) == "nil" then return false end
		if i < #nils then
			if type(temp) == "table" then temp = temp[nils[i+1]] else return false end
		end
	end
	return true
end


function oilvl_link(link)
	local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
	if (not ChatFrameEditBox:IsShown()) then
		ChatEdit_ActivateChat(ChatFrameEditBox)
	end
	ChatFrameEditBox:Insert(link)
	ChatFrameEditBox:HighlightText()
	return
end

local OPvPFrame = CreateFrame('GameTooltip', 'OPvPTooltip', nil, 'GameTooltipTemplate');
OPvPFrame:SetOwner(UIParent, 'ANCHOR_NONE');
function OItemAnalysis_CheckPvPGear(unitid,slot)
	OPvPFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OPvPFrame:ClearLines();
	OPvPFrame:SetInventoryItem(unitid, slot)

	for i = 1, 30 do
		if _G["OPvPTooltipTextLeft"..i]:GetText() then
			local pvpilvl = _G["OPvPTooltipTextLeft"..i]:GetText():match(PVP_ITEM_LEVEL_TOOLTIP:gsub("%%d","(%%d+)"));
			if  pvpilvl then
				return tonumber(pvpilvl);
			end
		else
			break
		end
	end
	return 0;
end

local OILVLFrame = CreateFrame('GameTooltip', 'OILVLTooltip', nil, 'GameTooltipTemplate');

OILVLFrame:SetOwner(UIParent, 'ANCHOR_NONE');
function OItemAnalysis_CheckILVLGear(unitid,slot)
	if unitid and slot then
		for i = 1, 4 do
			if _G["OILVLTooltipTextLeft"..i]:GetText() then
				local xilvl = _G["OILVLTooltipTextLeft"..i]:GetText():match(ITEM_LEVEL:gsub("%%d","(%%d+)"));
				local xupgrade = nil;
				if _G["OILVLTooltipTextLeft"..(i+1)] and _G["OILVLTooltipTextLeft"..(i+1)]:GetText() then
					xupgrade,_ = _G["OILVLTooltipTextLeft"..(i+1)]:GetText():match(ITEM_UPGRADE_TOOLTIP_FORMAT:gsub("%%d","(%%d+)").."");
				end
				if xilvl then
					return tonumber(xilvl), tonumber(xupgrade);
				end
			else
				break
			end
		end
	end
	return 0;
end

function OItemAnalysis_CheckILVLGear4(unitid,slot)
	if unitid and slot then
		OILVLFrame:SetOwner(UIParent, 'ANCHOR_NONE');
		OILVLFrame:ClearLines();
		OILVLFrame:SetInventoryItem(unitid, slot)
		for i = 1, 4 do
			if _G["OILVLTooltipTextLeft"..i]:GetText() then
				local xilvl = _G["OILVLTooltipTextLeft"..i]:GetText():match(ITEM_LEVEL:gsub("%%d","(%%d+)"));
				local xupgrade = nil;
				if _G["OILVLTooltipTextLeft"..(i+1)] and _G["OILVLTooltipTextLeft"..(i+1)]:GetText() then
					xupgrade,_ = _G["OILVLTooltipTextLeft"..(i+1)]:GetText():match(ITEM_UPGRADE_TOOLTIP_FORMAT:gsub("%%d","(%%d+)").."");
				end
				if xilvl then
					return tonumber(xilvl), tonumber(xupgrade);
				end
			else
				break
			end
		end
	end
	return 0;
end


function OItemAnalysis_CheckILVLGear2(itemLink)
	if itemLink then
		OILVLFrame:SetOwner(UIParent, 'ANCHOR_NONE');
		OILVLFrame:ClearLines();
		OILVLFrame:SetHyperlink(itemLink)
		for i = 1, 4 do
			if _G["OILVLTooltipTextLeft"..i]:GetText() then
				local xilvl = _G["OILVLTooltipTextLeft"..i]:GetText():match(ITEM_LEVEL:gsub("%%d","(%%d+)"));
				if xilvl then
					return tonumber(xilvl)
				end
			else
				break
			end
		end
	end
	return 0;
end

function OItemAnalysis_CheckILVLGear3(container, slot)
	OILVLFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OILVLFrame:ClearLines();
	OILVLFrame:SetBagItem(container, slot)
	for i = 1, 4 do
		if _G["OILVLTooltipTextLeft"..i]:GetText() then
			local xilvl = _G["OILVLTooltipTextLeft"..i]:GetText():match(ITEM_LEVEL:gsub("%%d","(%%d+)"));
			if xilvl then
				return tonumber(xilvl)
			end
		else
			break
		end
	end
	return 0;
end

function OItemAnalysis_CheckILVLRelic(reliclink)
	if reliclink then
		OILVLFrame:SetOwner(UIParent, 'ANCHOR_NONE');
		OILVLFrame:ClearLines();
		OILVLFrame:SetHyperlink(reliclink)
		for i = 1, 4 do
			if _G["OILVLTooltipTextLeft"..i]:GetText() then
				local xilvl = _G["OILVLTooltipTextLeft"..i]:GetText():match(ITEM_LEVEL:gsub("%%d","(%%d+)"));
				if xilvl then
					return tonumber(xilvl), _G["OILVLTooltipTextLeft"..(i+4)]:GetText()
				end
			else
				break
			end
		end
	end
	return 0;
end

function oClassColor(unitid)
	local _, _, cclass = UnitClass(unitid);
	if classcolor[cclass] ~= nil then
		return classcolor[cclass];
	else
		return "|cFFFFFF00";
	end
end

-- OT Check Raid Item Level
function oilvl(unit)
	if InspectFrame and (InspectFrame.unit or InspectFrame:IsShown()) then return -1 end
	if InspectFrame and InspectFrame.unit then return -1 end
	if not UnitAffectingCombat("player") then
		OILVL_Unit=unit;
		if CheckInteractDistance(OILVL_Unit, 1) and CanInspect(OILVL_Unit) then
			OILVL:RegisterEvent("INSPECT_READY");
			NotifyInspect(OILVL_Unit);
		else
			OILVL_Unit="";
			miacount=0;
			miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
			OTCurrent = "";
			OTCurrent2 = "";
			OTCurrent3 = "";
		end
	end
end

-- Get Raid Frame Item Level
function ORfbIlvl(ounit)
	if InspectFrame and InspectFrame:IsShown() then return -1 end
	if not UnitAffectingCombat("player") and ounit ~= "" then
		local i=0;
		OTCurrent3 = tonumber(ounit);
		if IsInRaid() then
			OTCurrent = "OILVLRAIDFRAME"..ounit;
			OTCurrent2 = "raid"..ounit;
			if _G[OTCurrent] == nil then return -1 end
			if GetUnitName(OTCurrent2,"") ~= nil then
				--_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
				MVPvsframedata.name[tonumber(ounit)] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
				--MVPvsframedata.ilvl[tonumber(ounit)][1] = ""
				oilvl(OTCurrent2)
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			if ounit == "1" or ounit == 1 then
				OTCurrent = "OILVLRAIDFRAME1";
				OTCurrent2 = "player";
				if _G[OTCurrent] == nil then return -1 end
				if GetUnitName(OTCurrent2,"") ~= nil then
					--_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
					MVPvsframedata.name[1] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
					--MVPvsframedata.ilvl[1][1] = ""
					oilvl(OTCurrent2)
				end
			else
				OTCurrent = "OILVLRAIDFRAME"..ounit;
				OTCurrent2 = "party"..(tonumber(ounit)-1);
				if _G[OTCurrent] == nil then return -1 end
				if GetUnitName(OTCurrent2,"") ~= nil then
					--_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
					MVPvsframedata.name[tonumber(ounit)] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
					--MVPvsframedata.ilvl[tonumber(ounit)][1] = ""
					oilvl(OTCurrent2)
				end
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			if ounit == "1"  or ounit == 1 then
				OTCurrent = "OILVLRAIDFRAME1";
				OTCurrent2 = "player";
				if _G[OTCurrent] == nil then return -1 end
				if GetUnitName(OTCurrent2,"") ~= nil then
					--_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
					MVPvsframedata.name[1] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
					--MVPvsframedata.ilvl[1][1] = ""
					oilvl(OTCurrent2)
				end
			else
				OTCurrent = "OILVLRAIDFRAME"..ounit;
				OTCurrent2 = "party"..(tonumber(ounit)-1);
				if _G[OTCurrent] == nil then return -1 end
				if GetUnitName(OTCurrent2,"") ~= nil then
					--_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
					MVPvsframedata.name[tonumber(ounit)] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
					--MVPvsframedata.ilvl[tonumber(ounit)][1] = ""
					oilvl(OTCurrent2)
				end
			end
		else
			OTCurrent = "OILVLRAIDFRAME1";
			OTCurrent2 = "player";
			if _G[OTCurrent] == nil then return -1 end
			if GetUnitName(OTCurrent2,"") ~= nil then
				--_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
				MVPvsframedata.name[1] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
				--MVPvsframedata.ilvl[1][1] = ""
				oilvl(OTCurrent2)
			end
		end
	end
end

function OilvlSetRole(ounit, orole)
	Oilvlrole[ounit]:SetTexture(ORole[orole][1]);
	Oilvlrole[ounit]:SetTexCoord(ORole[orole][2],ORole[orole][3],ORole[orole][4],ORole[orole][5]);
	MVPvsframedata.role[ounit] = orole;
	if orole ~= "NONE" then NumRole[orole] = NumRole[orole] + 1; end
end

function OilvlSetRank(ounit, orole)
	Oilvlrank[ounit]:SetTexture(ORank[orole][1]);
end

function OilvlSetMouseoverTooltips(oframe, ounit)
	oframe:SetAttribute("unit", ounit);
end

local LoadRPDTooltip = CreateFrame('GameTooltip', 'LOADRPDTooltip', nil, 'GameTooltipTemplate');

function OilvlRunMouseoverTooltips(oframe)
	local ounit = oframe:GetAttribute("unit")
	if not otooltip2 then
		OilvlTooltip:SetOwner(oframe, "ANCHOR_BOTTOMRIGHT");
		OilvlTooltip:SetUnit(ounit)
		local i = tonumber(oframe:GetName():gsub("OILVLRAIDFRAME", "").."");
		if not ospec[MVPvsframedata.spec[i]] then return end
		if MVPvsframedata.spec[i] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(SPECIALIZATION.." |cFF00FF00"..ospec[MVPvsframedata.spec[i]]);
		end
		if MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(L["Not enchanted"]..":\n|cFF00FF00"..MVPvsframedata.me[i][1]);
		end
		if MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(L["Not socketed"]..":\n|cFF00FF00"..MVPvsframedata.mg[i][1]);
		end
		if MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(L["Low level enchanted"]..":\n|cFF00FF00"..MVPvsframedata.me[i][2]);
		end
		if MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
			OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(L["Low level socketed"]..":\n|cFF00FF00"..MVPvsframedata.mg[i][2]);
		end
		OilvlTooltip:Show()
		rpdframe = oframe;
		rpdframesw = true;
		rpdounit = ounit;
	end
end

function oilvlcheckunknown()
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		for i = 1, rnum do
			if MVPvsframedata.name[i] == "Unknown" then
				MVPvsframedata.guid[i] = UnitGUID("raid"..i);
				MVPvsframedata.name[i] = GetUnitName("raid"..i,""):gsub("%-.+", "");
				if _OT(MVPvsframedata.ilvl,i,4) and MVPvsframedata.ilvl[i][4] > 0 then
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..MVPvsframedata.name[i].."\n|r|cFFFF8000"..MVPvsframedata.ilvl[i][1]);
				else
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..MVPvsframedata.name[i].."\n|r|cFF00FF00"..MVPvsframedata.ilvl[i][1]);
				end
				_G["OILVLRAIDFRAME"..i]:Show();
			end
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
		for i = 2, rnum do
			if MVPvsframedata.name[i] == "Unknown" then
				MVPvsframedata.guid[i] = UnitGUID("party"..(i-1));
				MVPvsframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
				if _OT(MVPvsframedata.ilvl,i,4) and MVPvsframedata.ilvl[i][4] > 0 then
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..MVPvsframedata.name[i].."\n|r|cFFFF8000"..MVPvsframedata.ilvl[i][1]);
				else
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..MVPvsframedata.name[i].."\n|r|cFF00FF00"..MVPvsframedata.ilvl[i][1]);
				end
				_G["OILVLRAIDFRAME"..i]:Show();
			end
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		for i = 2, rnum do
			if MVPvsframedata.name[i] == "Unknown" then
				MVPvsframedata.guid[i] = UnitGUID("party"..(i-1));
				MVPvsframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
				if _OT(MVPvsframedata.ilvl,i,4) and MVPvsframedata.ilvl[i][4] > 0 then
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..MVPvsframedata.name[i].."\n|r|cFFFF8000"..MVPvsframedata.ilvl[i][1]);
				else
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..MVPvsframedata.name[i].."\n|r|cFF00FF00"..MVPvsframedata.ilvl[i][1]);
				end
				_G["OILVLRAIDFRAME"..i]:Show();
			end
		end
	else
		return 0
	end
end

function OILVLCheckUpdate()
	if not UnitAffectingCombat("player") and oilvlframesw and not (InspectFrame and InspectFrame:IsShown()) then
		oilvlcheckunknown();
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i] then return 0; end
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				return 0;
			end
			local ilvl
			if MVPvsframedata.ilvl[i] and MVPvsframedata.ilvl[i][1] then
				ilvl = MVPvsframedata.ilvl[i][1]
			else
				MVPvsframedata.ilvl[i] = {"",otooltip6gearsw,0,0};
				ilvl = MVPvsframedata.ilvl[i][1]
			end
			if ilvl == nil or ilvl == "" then
				ilvlupdate = 1
				if IsInRaid() then
					if CheckInteractDistance("raid"..i, 1) and CanInspect("raid"..i) then ORfbIlvl(i); return 0; end
				elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_HOME) then
					if i == 1 then
						ORfbIlvl(1); return 0;
					else
						if CheckInteractDistance("party"..(i-1), 1) and CanInspect("party"..(i-1)) then ORfbIlvl(i); return 0; end
					end
				else
					ORfbIlvl(1); return 0;
				end
			end
		end
	end
end

function OVILRefresh()
if not UnitAffectingCombat("player")  and oilvlframesw then
	local i=0;
	local rnum=0;
	OTCurrent=""; -- current raid frame
	OTCurrent2=""; -- current unit id
	OTCurrent3=""; -- current raid frame number
	OILVL_Unit="";
	for i = 1, 40 do
		-- reset the color of all frames
		if not _G["OILVLRAIDFRAME"..i]  then break; end
		-- reset data
		MVPvsframedata.guid[i] = "";
		MVPvsframedata.name[i] = "";
		MVPvsframedata.ilvl[i] = {"",otooltip6gearsw,0,0};
		MVPvsframedata.me[i] = "";
		MVPvsframedata.mg[i] = "";
		MVPvsframedata.spec[i] = "";
		MVPvsframedata.gear[i] = "";
		_G["Oilvltier"..i]:SetText("")
		_G["OilvlUpgrade"..i]:SetText("")
	end
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		if rnum < 16 then
			OIVLFRAME:SetWidth(400);
		end
		if rnum >= 16 and rnum <= 20 then
			OIVLFRAME:SetWidth(400);
		end
		if rnum >= 21 and rnum <= 25 then
			OIVLFRAME:SetWidth(430);
		end
		if rnum >= 26 and rnum <= 30 then
			OIVLFRAME:SetWidth(512);
		end
		if rnum >= 31 and rnum <= 35 then
			OIVLFRAME:SetWidth(594);
		end
		if rnum >= 36 and rnum <= 40 then
			OIVLFRAME:SetWidth(676);
		end
		for i = rnum+1, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			MVPvsframedata.guid[i] = "";
			MVPvsframedata.name[i] = "";
			MVPvsframedata.ilvl[i][1] = "";
			MVPvsframedata.me[i] = "";
			MVPvsframedata.mg[i] = "";
			MVPvsframedata.spec[i] = "";
			MVPvsframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		for i = 1, rnum do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..GetUnitName("raid"..i,""):gsub("%-.+", ""));
			_G["OILVLRAIDFRAME"..i]:Show();
			OilvlSetRole(i, UnitGroupRolesAssigned("raid"..i,""));
			local _, rank, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
			OilvlSetRank(i, rank);
			MVPvsframedata.guid[i] = UnitGUID("raid"..i);
			MVPvsframedata.name[i] = GetUnitName("raid"..i,""):gsub("%-.+", "");
			MVPvsframedata.ilvl[i][1] = "";
			MVPvsframedata.me[i] = "";
			MVPvsframedata.mg[i] = "";
			MVPvsframedata.spec[i] = "";
			MVPvsframedata.gear[i] = "";
			OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "raid"..i);
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
		for i = rnum, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			MVPvsframedata.guid[i] = "";
			MVPvsframedata.name[i] = "";
			MVPvsframedata.ilvl[i][1] = "";
			MVPvsframedata.me[i] = "";
			MVPvsframedata.mg[i] = "";
			MVPvsframedata.spec[i] = "";
			MVPvsframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		OILVLRAIDFRAME1:Show();
		OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
		OilvlSetRole(1, UnitGroupRolesAssigned("player"));
		if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
		MVPvsframedata.guid[1] = UnitGUID("player");
		MVPvsframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
		MVPvsframedata.ilvl[1][1] = "";
		MVPvsframedata.me[1] = "";
		MVPvsframedata.mg[1] = "";
		MVPvsframedata.spec[1] = "";
		MVPvsframedata.gear[1] = "";
		OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
		for i = 2, rnum do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..GetUnitName("party"..(i-1),""):gsub("%-.+", ""));
			_G["OILVLRAIDFRAME"..i]:Show();
			OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
			if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
			MVPvsframedata.guid[i] = UnitGUID("party"..(i-1));
			MVPvsframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
			MVPvsframedata.ilvl[i][1] = "";
			MVPvsframedata.me[i] = "";
			MVPvsframedata.mg[i] = "";
			MVPvsframedata.spec[i] = "";
			MVPvsframedata.gear[i] = "";
			OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
		end
		OIVLFRAME:SetWidth(400);
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
		for i = rnum, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			MVPvsframedata.guid[i] = "";
			MVPvsframedata.name[i] = "";
			MVPvsframedata.ilvl[i][1] = "";
			MVPvsframedata.me[i] = "";
			MVPvsframedata.mg[i] = "";
			MVPvsframedata.spec[i] = "";
			MVPvsframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		OILVLRAIDFRAME1:Show();
		OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
		OilvlSetRole(1, UnitGroupRolesAssigned("player"));
		if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
		MVPvsframedata.guid[1] = UnitGUID("player");
		MVPvsframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
		MVPvsframedata.ilvl[1][1] = "";
		MVPvsframedata.me[1] = "";
		MVPvsframedata.mg[1] = "";
		MVPvsframedata.spec[1] = "";
		MVPvsframedata.gear[1] = "";
		OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
		for i = 2, rnum do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..GetUnitName("party"..(i-1),""):gsub("%-.+", ""));
			_G["OILVLRAIDFRAME"..i]:Show();
			OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
			if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
			MVPvsframedata.guid[i] = UnitGUID("party"..(i-1));
			MVPvsframedata.name[i] = GetUnitName("party"..(i-1),""):gsub("%-.+", "")
			MVPvsframedata.ilvl[i][1] = "";
			MVPvsframedata.me[i] = "";
			MVPvsframedata.mg[i] = "";
			MVPvsframedata.spec[i] = "";
			MVPvsframedata.gear[i] = "";
			OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
		end
		OIVLFRAME:SetWidth(400);
	else
		for i = 2, 40 do
			if not _G["OILVLRAIDFRAME"..i]  then break; end
			_G["OILVLRAIDFRAME"..i]:SetText("");
			_G["OILVLRAIDFRAME"..i]:Hide();
			MVPvsframedata.guid[i] = "";
			MVPvsframedata.name[i] = "";
			MVPvsframedata.ilvl[i][1] = "";
			MVPvsframedata.me[i] = "";
			MVPvsframedata.mg[i] = "";
			MVPvsframedata.spec[i] = "";
			MVPvsframedata.gear[i] = "";
		end
		NumRole["TANK"] = 0;
		NumRole["DAMAGER"] = 0;
		NumRole["HEALER"] = 0;
		OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
		OilvlSetRole(1, UnitGroupRolesAssigned("player"));
		OilvlSetRank(1, 0);
		OIVLFRAME:SetWidth(400);
		MVPvsframedata.guid[1] = UnitGUID("player");
		MVPvsframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
		MVPvsframedata.ilvl[1][1] = "";
		MVPvsframedata.me[1] = "";
		MVPvsframedata.mg[1] = "";
		MVPvsframedata.spec[1] = "";
		MVPvsframedata.gear[1] = "";
		OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
	end
end
	OTCurrent=""; -- current raid frame
	OTCurrent2=""; -- current unit id
	OTCurrent3=""; -- current raid frame number
end
-- Same as OVILRefresh(), but do not clear item level.
function OilvlCheckFrame()
	if not UnitAffectingCombat("player") and oilvlframesw then
		local i=0;
		local j=0;
		local rnum=0;
		local td = {};
		td.guid = {};
		td.name = {};
		td.ilvl = {};
		td.me = {};
		td.mg = {};
		td.spec = {};
		td.gear = {};
		for i=1,40 do
			td.guid[i] = "";
			td.name[i] = "";
			td.ilvl[i] = {"",otooltip6gearsw};
			td.me[i] = "";
			td.mg[i] = "";
			td.spec[i] = "";
			td.gear[i] = "";
			_G["Oilvltier"..i]:SetText("")
			_G["OilvlUpgrade"..i]:SetText("")
		end
		--OTCurrent=""; -- current raid frame
		--OTCurrent2=""; -- current unit id
		--OTCurrent3=""; -- current raid frame number
		--OILVL_Unit="";
		if IsInRaid() then
			rnum = GetNumGroupMembers();
			if rnum < 16 then
				OIVLFRAME:SetWidth(400);
			end
			if rnum >= 16 and rnum <= 20 then
				OIVLFRAME:SetWidth(400);
			end
			if rnum >= 21 and rnum <= 25 then
				OIVLFRAME:SetWidth(430);
			end
			if rnum >= 26 and rnum <= 30 then
				OIVLFRAME:SetWidth(512);
			end
			if rnum >= 31 and rnum <= 35 then
				OIVLFRAME:SetWidth(594);
			end
			if rnum >= 36 and rnum <= 40 then
				OIVLFRAME:SetWidth(676);
			end

			for j=1, rnum do
				for i=1, 40 do
					if MVPvsframedata.guid[i] == "" then break end
					if UnitGUID("raid"..j) == MVPvsframedata.guid[i] then
						td.guid[j] = MVPvsframedata.guid[i];
						td.name[j] = MVPvsframedata.name[i];
						td.ilvl[j] = MVPvsframedata.ilvl[i];
						td.me[j] = MVPvsframedata.me[i];
						td.mg[j] = MVPvsframedata.mg[i];
						td.spec[j] = MVPvsframedata.spec[i];
						td.gear[j] = MVPvsframedata.gear[i];
						break;
					end
				end
				if td.guid[j] == "" then
					td.guid[j] = UnitGUID("raid"..j);
					td.name[j] = GetUnitName("raid"..j,""):gsub("%-.+", "");
					td.ilvl[j] = {"",otooltip6gearsw};
					td.me[j] = "";
					td.spec[j] = "";
					td.gear[j] = "";
				end
			end

			for i = rnum+1, 40 do
				if not _G["OILVLRAIDFRAME"..i]  then break; end
				_G["OILVLRAIDFRAME"..i]:SetText("");
				_G["OILVLRAIDFRAME"..i]:Hide();
				MVPvsframedata.guid[i] = "";
				MVPvsframedata.name[i] = "";
				MVPvsframedata.ilvl[i]= {"",otooltip6gearsw,0,0};
				MVPvsframedata.me[i] = "";
				MVPvsframedata.mg[i] = "";
				MVPvsframedata.spec[i] = "";
				MVPvsframedata.gear[i] = "";
			end
			NumRole["TANK"] = 0;
			NumRole["DAMAGER"] = 0;
			NumRole["HEALER"] = 0;
			for i = 1, rnum do
				if not _G["OILVLRAIDFRAME"..i] then break; end
				if _OT(td.ilvl,i,4) and td.ilvl[i][4] > 0 then
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..td.name[i].."\n|r|cFFFF8000"..td.ilvl[i][1]);
				else
					_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("raid"..i)..td.name[i].."\n|r|cFF00FF00"..td.ilvl[i][1]);
				end
				_G["OILVLRAIDFRAME"..i]:Show();
				OilvlSetRole(i, UnitGroupRolesAssigned("raid"..i,""));
				local _, rank, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
				OilvlSetRank(i, rank);
				MVPvsframedata.guid[i] = td.guid[i];
				MVPvsframedata.name[i] = td.name[i];
				MVPvsframedata.ilvl[i] = td.ilvl[i];
				MVPvsframedata.me[i] = td.me[i];
				MVPvsframedata.mg[i] = td.mg[i];
				MVPvsframedata.spec[i] = td.spec[i];
				MVPvsframedata.gear[i] = td.gear[i];
				OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "raid"..i);
				_G["Oilvltier"..i]:SetText(oilvlCheckTierBonusSet(i))
				_G["OilvlUpgrade"..i]:SetText(oilvlCheckUpgrade(i))
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) - 1
			if rnum > 0 then
				for j=1, rnum do
					for i=2, 5 do
						if MVPvsframedata.guid[i] == "" then break end
						if UnitGUID("party"..j) == MVPvsframedata.guid[i] then
							td.guid[j+1] = MVPvsframedata.guid[i];
							td.name[j+1] = MVPvsframedata.name[i];
							td.ilvl[j+1] = MVPvsframedata.ilvl[i];
							td.me[j+1] = MVPvsframedata.me[i];
							td.mg[j+1] = MVPvsframedata.mg[i];
							td.spec[j+1] = MVPvsframedata.spec[i];
							td.gear[j+1] = MVPvsframedata.gear[i];
							break;
						end
					end
					if td.guid[j+1] == "" then
						td.guid[j+1] = UnitGUID("party"..j);
						td.name[j+1] = GetUnitName("party"..j,""):gsub("%-.+", "");
						td.ilvl[j+1] = {"",otooltip6gearsw};
						td.me[j+1] = "";
						td.spec[j+1] = "";
						td.gear[j+1] = "";
					end
				end
				for i = rnum+1, 40 do
					if not _G["OILVLRAIDFRAME"..i]  then break; end
					_G["OILVLRAIDFRAME"..i]:SetText("");
					_G["OILVLRAIDFRAME"..i]:Hide();
					MVPvsframedata.guid[i] = "";
					MVPvsframedata.name[i] = "";
					MVPvsframedata.ilvl[i] = {"",otooltip6gearsw,0,0};
					MVPvsframedata.me[i] = "";
					MVPvsframedata.mg[i] = "";
					MVPvsframedata.spec[i] = "";
					MVPvsframedata.gear[i] = "";
				end
				NumRole["TANK"] = 0;
				NumRole["DAMAGER"] = 0;
				NumRole["HEALER"] = 0;
				OILVLRAIDFRAME1:Show();
				OilvlSetRole(1, UnitGroupRolesAssigned("player"));
				OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
				Oilvltier1:SetText(oilvlCheckTierBonusSet(1))
				OilvlUpgrade1:SetText(oilvlCheckUpgrade(1))
				if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
				for i = 2, (rnum+1) do
					if not _G["OILVLRAIDFRAME"..i]  then break; end
					if _OT(td.ilvl,i,4) and td.ilvl[i][4] > 0 then
						_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..td.name[i].."\n|r|cFFFF8000"..td.ilvl[i][1]);
					else
						_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..td.name[i].."\n|r|cFF00FF00"..td.ilvl[i][1]);
					end
					_G["OILVLRAIDFRAME"..i]:Show();
					OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
					if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
					MVPvsframedata.guid[i] = td.guid[i];
					MVPvsframedata.name[i] = td.name[i];
					MVPvsframedata.ilvl[i] = td.ilvl[i];
					MVPvsframedata.me[i] = td.me[i];
					MVPvsframedata.mg[i] = td.mg[i];
					MVPvsframedata.spec[i] = td.spec[i];
					MVPvsframedata.gear[i] = td.gear[i];
					OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
					_G["Oilvltier"..i]:SetText(oilvlCheckTierBonusSet(i))
					_G["OilvlUpgrade"..i]:SetText(oilvlCheckUpgrade(i))
				end
				OIVLFRAME:SetWidth(400);
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) - 1
			if rnum > 0 then
				for j=1, rnum do
					for i=2, 5 do
						if MVPvsframedata.guid[i] == "" then break end
						if UnitGUID("party"..j) == MVPvsframedata.guid[i] then
							td.guid[j+1] = MVPvsframedata.guid[i];
							td.name[j+1] = MVPvsframedata.name[i];
							td.ilvl[j+1] = MVPvsframedata.ilvl[i];
							td.me[j+1] = MVPvsframedata.me[i];
							td.mg[j+1] = MVPvsframedata.mg[i];
							td.spec[j+1] = MVPvsframedata.spec[i];
							td.gear[j+1] = MVPvsframedata.gear[i];
							break;
						end
					end
					if td.guid[j+1] == "" then
						td.guid[j+1] = UnitGUID("party"..j);
						td.name[j+1] = GetUnitName("party"..j,""):gsub("%-.+", "");
						td.ilvl[j+1] = {"",otooltip6gearsw};
						td.me[j+1] = "";
						td.spec[j+1] = "";
						td.gear[j+1] = "";
					end
				end
				for i = rnum+1, 40 do
					if not _G["OILVLRAIDFRAME"..i]  then break; end
					_G["OILVLRAIDFRAME"..i]:SetText("");
					_G["OILVLRAIDFRAME"..i]:Hide();
					MVPvsframedata.guid[i] = "";
					MVPvsframedata.name[i] = "";
					MVPvsframedata.ilvl[i] = {"",otooltip6gearsw,0,0};
					MVPvsframedata.me[i] = "";
					MVPvsframedata.mg[i] = "";
					MVPvsframedata.spec[i] = "";
					MVPvsframedata.gear[i] = "";
				end
				NumRole["TANK"] = 0;
				NumRole["DAMAGER"] = 0;
				NumRole["HEALER"] = 0;
				OILVLRAIDFRAME1:Show();
				OilvlSetRole(1, UnitGroupRolesAssigned("player"));
				OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
				Oilvltier1:SetText(oilvlCheckTierBonusSet(1))
				OilvlUpgrade1:SetText(oilvlCheckUpgrade(1))
				if UnitIsGroupLeader("player") then	OilvlSetRank(1, 2);	else OilvlSetRank(1, 0); end
				for i = 2, (rnum+1) do
					if not _G["OILVLRAIDFRAME"..i]  then break; end
					if _OT(td.ilvl,i,4) and td.ilvl[i][4] > 0 then
						_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..td.name[i].."\n|r|cFFFF8000"..td.ilvl[i][1]);
					else
						_G["OILVLRAIDFRAME"..i]:SetText(oClassColor("party"..(i-1))..td.name[i].."\n|r|cFF00FF00"..td.ilvl[i][1]);
					end
					_G["OILVLRAIDFRAME"..i]:Show();
					OilvlSetRole(i, UnitGroupRolesAssigned("party"..(i-1),""));
					if UnitIsGroupLeader("party"..(i-1)) then OilvlSetRank(i, 2); else OilvlSetRank(i, 0); end
					MVPvsframedata.guid[i] = td.guid[i];
					MVPvsframedata.name[i] = td.name[i];
					MVPvsframedata.ilvl[i] = td.ilvl[i];
					MVPvsframedata.me[i] = td.me[i];
					MVPvsframedata.mg[i] = td.mg[i];
					MVPvsframedata.spec[i] = td.spec[i];
					MVPvsframedata.gear[i] = td.gear[i];
					OilvlSetMouseoverTooltips(_G["OILVLRAIDFRAME"..i], "party"..(i-1));
					_G["Oilvltier"..i]:SetText(oilvlCheckTierBonusSet(i))
					_G["OilvlUpgrade"..i]:SetText(oilvlCheckUpgrade(i))
				end
				OIVLFRAME:SetWidth(400);
			end
		else
			OIVLFRAME:SetWidth(400);
			for i = 2, 40 do
				if not _G["OILVLRAIDFRAME"..i]  then break; end
				if MVPvsframedata.name[i] == UnitName("player") then
					MVPvsframedata.guid[1] = MVPvsframedata.guid[i];
					MVPvsframedata.name[1] = MVPvsframedata.name[i];
					MVPvsframedata.ilvl[1] = MVPvsframedata.ilvl[i]
					MVPvsframedata.me[1] = MVPvsframedata.me[i];
					MVPvsframedata.mg[1] = MVPvsframedata.mg[i];
					MVPvsframedata.spec[1] = MVPvsframedata.spec[i];
					MVPvsframedata.gear[1] = MVPvsframedata.gear[i];
					OILVLRAIDFRAME1:SetText(_G["OILVLRAIDFRAME"..i]:GetText())
				end
				_G["OILVLRAIDFRAME"..i]:SetText("");
				_G["OILVLRAIDFRAME"..i]:Hide();
				MVPvsframedata.guid[i] = "";
				MVPvsframedata.name[i] = "";
				MVPvsframedata.ilvl[i] = {"",otooltip6gearsw,0,0};
				MVPvsframedata.me[i] = "";
				MVPvsframedata.mg[i] = "";
				MVPvsframedata.spec[i] = "";
				MVPvsframedata.gear[i] = "";
			end
			NumRole["TANK"] = 0;
			NumRole["DAMAGER"] = 0;
			NumRole["HEALER"] = 0;
			if _OT(MVPvsframedata.ilvl,1,1) and MVPvsframedata.ilvl[1][1] then
				if MVPvsframedata.ilvl[1][1] == "" or MVPvsframedata.guid[1] ~= UnitGUID("player") then
					OILVLRAIDFRAME1:SetText(oClassColor("player")..GetUnitName("player",""):gsub("%-.+", ""));
					OIVLFRAME:SetWidth(400);
					MVPvsframedata.guid[1] = UnitGUID("player");
					MVPvsframedata.name[1] = GetUnitName("player",""):gsub("%-.+", "");
					MVPvsframedata.ilvl[1] = {"",otooltip6gearsw};
					MVPvsframedata.me[1] = "";
					MVPvsframedata.mg[1] = "";
					MVPvsframedata.spec[1] = "";
					MVPvsframedata.gear[1] = "";
				end
			end
			OilvlSetRank(1, 0);
			OilvlSetRole(1, UnitGroupRolesAssigned("player"));
			OilvlSetMouseoverTooltips(OILVLRAIDFRAME1, "player");
			Oilvltier1:SetText(oilvlCheckTierBonusSet(1))
			OilvlUpgrade1:SetText(oilvlCheckUpgrade(1))
		end
	end
	--OTCurrent=""; OTCurrent2=""; OTCurrent3="";
end

function OilvlRPDTimeCheck()
	if not UnitAffectingCombat("player") and OilvlTooltip:IsShown() then
		if GetMouseFocus() == rpdframe and rpdframesw then
			OilvlSetCA();
			rpdframesw = false;
		end
	end
end

function oilvlcheckrange()
	if not UnitAffectingCombat("player") and oilvlframesw then
		local i=0;
		local rnum=0;
		local total=0;
		local n=0;
		local ntank=0;
		local totaltank=0;
		local ndps=0;
		local totaldps=0;
		local nheal=0;
		local totalheal=0;
		ail=0; ailtank=0; aildps=0; ailheal=0;
		range = 0 melee = 0
		if IsInRaid() then
			rnum = GetNumGroupMembers();
			for i = 1, rnum do
				if RM[MVPvsframedata.spec[i]] == "M" then melee = melee + 1 end
				if RM[MVPvsframedata.spec[i]] == "R" then range = range + 1 end
				if not CheckInteractDistance("raid"..i, 1) then
					if OTCurrent2 == "raid"..i then
						miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
						OTCurrent=""; OTCurrent2=""; OTCurrent3=""; OILVL_Unit="";
					end
					local ntex4 = _G["OILVLRAIDFRAME"..i]:CreateTexture()
					ntex4:SetColorTexture(0,0,0,1)
					ntex4:SetAllPoints()
					_G["OILVLRAIDFRAME"..i]:SetNormalTexture(ntex4)
					if otooltip6 and oicomp then
						for k = 1, #oicomp do
							if oicomp[k].id == i then otooltip6:SetCellColor(k+4,2,0.5,0.5,0.5,1) break end
						end
					end
				else
					local ntex4 = _G["OILVLRAIDFRAME"..i]:CreateTexture()
					ntex4:SetColorTexture(0.2,0.2,0.2,0.5)
					ntex4:SetAllPoints()
					_G["OILVLRAIDFRAME"..i]:SetNormalTexture(ntex4)
					if otooltip6 and oicomp then
						for k = 1, #oicomp do
							if oicomp[k].id == i then otooltip6:SetCellColor(k+4,2,0,0,0,0) break end
						end
					end
				end

				if MVPvsframedata.ilvl[i] and MVPvsframedata.ilvl[i][1] ~= "" then
					n = n + 1;
					total = total + MVPvsframedata.ilvl[i][1];
					if MVPvsframedata.role[i] == "TANK" then
						ntank = ntank + 1;
						totaltank = totaltank + MVPvsframedata.ilvl[i][1];
					end
					if MVPvsframedata.role[i] == "DAMAGER" then
						ndps = ndps + 1;
						totaldps = totaldps + MVPvsframedata.ilvl[i][1];
					end
					if MVPvsframedata.role[i] == "HEALER" then
						nheal = nheal + 1;
						totalheal = totalheal + MVPvsframedata.ilvl[i][1];
					end
				end
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) - 1
			for i = 1, rnum do
				if not CheckInteractDistance("party"..i, 1) then
					if OTCurrent2 == "party"..i then
						miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
						OTCurrent=""; OTCurrent2=""; OTCurrent3=""; OILVL_Unit="";
					end
					local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
					ntex4:SetColorTexture(0,0,0,1)
					ntex4:SetAllPoints()
					_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)
					if otooltip6 and oicomp then
						for k = 1, #oicomp do
							if oicomp[k].id == i+1 then otooltip6:SetCellColor(k+4,2,0.5,0.5,0.5,1) break end
						end
					end
				else
					local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
					ntex4:SetColorTexture(0.2,0.2,0.2,0.5)
					ntex4:SetAllPoints()
					_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)
					if otooltip6 and oicomp then
						for k = 1, #oicomp do
							if oicomp[k].id == i+1 then otooltip6:SetCellColor(k+4,2,0,0,0,0) break end
						end
					end
				end
			end
			for i = 1, rnum + 1 do
				if MVPvsframedata.ilvl[i] and MVPvsframedata.ilvl[i][1] ~= "" then
					n = n + 1;
					total = total + MVPvsframedata.ilvl[i][1];
					if MVPvsframedata.role[i] == "TANK" then
						ntank = ntank + 1;
						totaltank = totaltank + MVPvsframedata.ilvl[i][1];
					end
					if MVPvsframedata.role[i] == "DAMAGER" then
						ndps = ndps + 1;
						totaldps = totaldps + MVPvsframedata.ilvl[i][1];
					end
					if MVPvsframedata.role[i] == "HEALER" then
						nheal = nheal + 1;
						totalheal = totalheal + MVPvsframedata.ilvl[i][1];
					end
				end
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) - 1
			for i = 1, rnum do
				if not CheckInteractDistance("party"..i, 1) then
					if OTCurrent2 == "party"..i then
						miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
						OTCurrent=""; OTCurrent2=""; OTCurrent3=""; OILVL_Unit="";
					end
					local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
					ntex4:SetColorTexture(0,0,0,1)
					ntex4:SetAllPoints()
					_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)
					if otooltip6 and oicomp then
						for k = 1, #oicomp do
							if oicomp[k].id == i+1 then otooltip6:SetCellColor(k+4,2,0.5,0.5,0.5,1) break end
						end
					end
				else
					local ntex4 = _G["OILVLRAIDFRAME"..(i+1)]:CreateTexture()
					ntex4:SetColorTexture(0.2,0.2,0.2,0.5)
					ntex4:SetAllPoints()
					_G["OILVLRAIDFRAME"..(i+1)]:SetNormalTexture(ntex4)
					if otooltip6 and oicomp then
						for k = 1, #oicomp do
							if oicomp[k].id == i+1 then otooltip6:SetCellColor(k+4,2,0,0,0,0) break end
						end
					end
				end
			end
			for i = 1, rnum + 1 do
				if MVPvsframedata.ilvl[i] and MVPvsframedata.ilvl[i][1] ~= "" then
					n = n + 1;
					total = total + MVPvsframedata.ilvl[i][1];
					if MVPvsframedata.role[i] == "TANK" then
						ntank = ntank + 1;
						totaltank = totaltank + MVPvsframedata.ilvl[i][1];
					end
					if MVPvsframedata.role[i] == "DAMAGER" then
						ndps = ndps + 1;
						totaldps = totaldps + MVPvsframedata.ilvl[i][1];
					end
					if MVPvsframedata.role[i] == "HEALER" then
						nheal = nheal + 1;
						totalheal = totalheal + MVPvsframedata.ilvl[i][1];
					end
				end
			end
		else
			local ntex4 = OILVLRAIDFRAME1:CreateTexture()
			ntex4:SetColorTexture(0.2,0.2,0.2,0.5)
			ntex4:SetAllPoints()
			OILVLRAIDFRAME1:SetNormalTexture(ntex4)
		end
		if cfg.MVPvsautoscan then OILVLCheckUpdate() end
		-- Calculate Average Item Level
		if IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_HOME) then
			ONumTank:Show(); ONumDPS:Show(); ONumHeal:Show();
			ONumDEATHKNIGHT:Show(); ONumDRUID:Show(); ONumHUNTER:Show(); ONumMAGE:Show();
			ONumMONK:Show(); ONumPALADIN:Show(); ONumPRIEST:Show(); ONumROGUE:Show();
			ONumSHAMAN:Show(); ONumWARLOCK:Show(); ONumWARRIOR:Show(); ONumDEMONHUNTER:Show();
			if(n ~= 0) then ail = round(total/n,1); end
			if(ntank ~= 0) then ailtank = round(totaltank/ntank,1); end
			if(ndps ~= 0) then aildps = round(totaldps/ndps,1); end
			if(nheal ~= 0) then ailheal = round(totalheal/nheal,1); end
			if ail then
				OilvlAIL:SetText(L["Average Item Level"].."("..GetNumGroupMembers().."): "..ail);
				LDB.text = ail
			else
				OilvlAIL:SetText(L["Average Item Level"]..": 0");
				LDB.text = ""
				ail = 0;
			end
			if ailtank then
				OilvlAIL_TANK:SetText(NumRole["TANK"].." ("..ailtank..")");
			else
				OilvlAIL_TANK:SetText(NumRole["TANK"]);
				ailtank = 0;
			end
			if aildps then
				OilvlAIL_DPS:SetText(NumRole["DAMAGER"].." ("..aildps..")");
			else
				OilvlAIL_DPS:SetText(NumRole["DAMAGER"]);
				aildps = 0;
			end
			if ailheal then
				OilvlAIL_HEAL:SetText(NumRole["HEALER"].." ("..ailheal..")");
			else
				OilvlAIL_HEAL:SetText(NumRole["HEALER"]);
				ailheal = 0;
			end
			-- counting class numbers
			rnum = GetNumGroupMembers();
			local cnum = {};
			for j = 1, 12 do cnum[j]=0 end
			if IsInRaid() then
				for i = 1, rnum do
					local _, _, cclass = UnitClass("raid"..i);
					for j = 1, 12 do if cclass == j then cnum[j] = cnum[j] + 1 end	end
				end
			else
				for i = 1, rnum do
					local _, _, cclass = UnitClass("party"..i);
					for j = 1, 12 do if cclass == j then cnum[j] = cnum[j] + 1 end	end
				end
				local _, _, cclass = UnitClass("player");
				for j = 1, 12 do if cclass == j then cnum[j] = cnum[j] + 1 end	end
			end
			OilvlAIL_WARRIOR:SetText(cnum[1])
			OilvlAIL_PALADIN:SetText(cnum[2])
			OilvlAIL_HUNTER:SetText(cnum[3])
			OilvlAIL_ROGUE:SetText(cnum[4])
			OilvlAIL_PRIEST:SetText(cnum[5])
			OilvlAIL_DEATHKNIGHT:SetText(cnum[6])
			OilvlAIL_SHAMAN:SetText(cnum[7])
			OilvlAIL_MAGE:SetText(cnum[8])
			OilvlAIL_WARLOCK:SetText(cnum[9])
			OilvlAIL_MONK:SetText(cnum[10])
			OilvlAIL_DRUID:SetText(cnum[11])
			OilvlAIL_DEMONHUNTER:SetText(cnum[12])
			OVanq = cnum[4]+cnum[8]+cnum[6]+cnum[11]
			OProt = cnum[1]+cnum[3]+cnum[7]+cnum[10]
			OConq = cnum[2]+cnum[5]+cnum[9]+cnum[12]
			VanqText:SetText(OVanq.." "..L["Vanquisher"])
			ProtText:SetText(OProt.." "..L["Protector"])
			ConqText:SetText(OConq.." "..L["Conqueror"])
		else
			ONumTank:Hide(); ONumDPS:Hide(); ONumHeal:Hide();
			ONumDEATHKNIGHT:Hide(); ONumDRUID:Hide(); ONumHUNTER:Hide(); ONumMAGE:Hide();
			ONumMONK:Hide(); ONumPALADIN:Hide(); ONumPRIEST:Hide(); ONumROGUE:Hide();
			ONumSHAMAN:Hide(); ONumWARLOCK:Hide(); ONumWARRIOR:Hide();ONumDEMONHUNTER:Hide();
			OilvlAIL:SetText(L["Average Item Level"]..": "..MVPvsframedata.ilvl[1][1]);
			LDB.text = MVPvsframedata.ilvl[1][1]
			ail = MVPvsframedata.ilvl[1][1];
			OilvlAIL_TANK:SetText(""); OilvlAIL_DPS:SetText(""); OilvlAIL_HEAL:SetText("");
			OilvlAIL_WARRIOR:SetText("")
			OilvlAIL_PALADIN:SetText("")
			OilvlAIL_HUNTER:SetText("")
			OilvlAIL_ROGUE:SetText("")
			OilvlAIL_PRIEST:SetText("")
			OilvlAIL_DEATHKNIGHT:SetText("")
			OilvlAIL_SHAMAN:SetText("")
			OilvlAIL_MAGE:SetText("")
			OilvlAIL_WARLOCK:SetText("")
			OilvlAIL_MONK:SetText("")
			OilvlAIL_DRUID:SetText("")
			OilvlAIL_DEMONHUNTER:SetText("")
			VanqText:SetText("")
			ProtText:SetText("")
			ConqText:SetText("")
		end

		-- Optimize Raid Progression Details
		if otooltip2 then return -1 end
		local oframe = GetMouseFocus();
		local function resetrpd()
			--ClearAchievementComparisonUnit();
			rpsw=false;
			rpunit="";
			Omover2=0;
		end

		if oframe == nil then resetrpd() return -1 end
		if oframe:IsForbidden() then resetrpd() return -1 end
		if oframe:GetName() == nil and otooltip6 == nil then resetrpd() return -1 end
		if oframe:GetName() == nil then return -1 end
		if oframe:GetName():gsub("%d","").."" ~= "OILVLRAIDFRAME" and otooltip6 == nil then resetrpd() return -1; end
		if oframe:GetName():gsub("%d","").."" ~= "OILVLRAIDFRAME" then return -1; end
		if OilvlTooltip:IsShown() then
			local msg = nil
			for i = 2, OilvlTooltip:NumLines() do
				msg = _G["OilvlTooltipTextLeft"..i]:GetText();
				if msg then
					--if cfg.raidmenuid == 5 then msg = msg:find(TENname); if msg then break end end
					--if cfg.raidmenuid == 4 then msg = msg:find(TOVname); if msg then break end end
					--if cfg.raidmenuid == 3 then msg = msg:find(TNname); if msg then break end end
					--if cfg.raidmenuid == 2 then msg = msg:find(TOSname); if msg then break end end
					if cfg.raidmenuid == 1 then msg = msg:find(ULDname); if msg then break end end
				end
			end
			if not msg then
				OilvlRunMouseoverTooltips(oframe)
			end
		end
	end
end

function oilvlprintrm()
	print("Range: "..range.." Melee: "..melee)
end

function OCheckSendMark()
	for i = 1, 40 do
		if not _G["OILVLRAIDFRAME"..i]:IsShown() then
			break;
		end
		if _G["Oilvlmark"..i]:IsVisible() then
			return true;
		end
	end
	return false
end

function OResetSendMark()
	for i = 1, 40 do
		if _G["OILVLRAIDFRAME"..i] == nil then return -1 end
		_G["Oilvlmark"..i]:Hide();
	end
end

function OSendToTarget(button)
	local i=0;local q=0;
	if not UnitExists("target") then
		return -1;
	end
	local comp = {};
	local targetname, trealm = UnitName("target");
	if trealm ~= nil then
		targetname = targetname.."-"..trealm
	end
	SendChatMessage(L["Item Level"]..":", "WHISPER", nil, targetname);
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
			if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
				msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
			end
			if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
				msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
				msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
			end
			if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
				local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
				local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
				msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
				end
			else
				comp[i] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl)
		end)
		if button ~= "RightButton" then
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "WHISPER", nil, targetname) end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].." ("..NumRole["TANK"].." "..TANK.."): "..ailtank, "WHISPER", nil, UnitName("target"));
			SendChatMessage(L["Average Item Level"].." ("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "WHISPER", nil, UnitName("target"));
			SendChatMessage(L["Average Item Level"].." ("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "WHISPER", nil, UnitName("target"));
			SendChatMessage(L["Average Item Level"]..": "..ail, "WHISPER", nil, targetname);
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
				if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
					msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
				end
				if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
					msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
					msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
				end
				if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
					local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
					local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
					msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
				end
				SendChatMessage(msg, "WHISPER", nil, targetname);
			end
		end
	end
end

function OSendToParty(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "PARTY");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
			if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
				msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
			end
			if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
				msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
				msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
			end
			if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
				local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
				local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
				msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
				end
			else
				comp[i] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl)
		end)
		if button ~= "RightButton" then
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "PARTY") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].." ("..NumRole["TANK"].." "..TANK.."): "..ailtank, "PARTY");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "PARTY");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "PARTY");
			SendChatMessage(L["Average Item Level"]..": "..ail, "PARTY");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
				if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
					msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
				end
				if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
					msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
					msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
				end
				if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
					local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
					local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
					msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
				end
				SendChatMessage(msg, "PARTY");
			end
		end
	end
end

function OSendToInstance(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "INSTANCE_CHAT");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
			if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
				msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
			end
			if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
				msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
				msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
			end
			if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
				local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
				local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
				msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
				end
			else
				comp[i] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl)
		end)
		if button ~= "RightButton" then
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "INSTANCE_CHAT") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].." ("..NumRole["TANK"].." "..TANK.."): "..ailtank, "INSTANCE_CHAT");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "INSTANCE_CHAT");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "INSTANCE_CHAT");
			SendChatMessage(L["Average Item Level"]..": "..ail, "INSTANCE_CHAT");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
				if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
					msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
				end
				if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
					msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
					msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
				end
				if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
					local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
					local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
					msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
				end
				SendChatMessage(msg, "INSTANCE_CHAT");
			end
		end
	end
end

function OSendToGuild(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "GUILD");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
			if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
				msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
			end
			if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
				msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
				msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
			end
			if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
				local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
				local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
				msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
				end
			else
				comp[i] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl)
		end)
		if button ~= "RightButton" then
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "GUILD") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].." ("..NumRole["TANK"].." "..TANK.."): "..ailtank, "GUILD");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "GUILD");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "GUILD");
			SendChatMessage(L["Average Item Level"]..": "..ail, "GUILD");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
				if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
					msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
				end
				if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
					msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
					msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
				end
				if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
					local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
					local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
					msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
				end
				SendChatMessage(msg, "GUILD");
			end
		end
	end
end

function OSendToRaid(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "RAID");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
			if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
				msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
			end
			if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
				msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
				msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
			end
			if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
				local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
				local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
				msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
				end
			else
				comp[i] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl)
		end)
		if button ~= "RightButton" then
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "RAID") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].." ("..NumRole["TANK"].." "..TANK.."): "..ailtank, "RAID");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "RAID");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "RAID");
			SendChatMessage(L["Average Item Level"]..": "..ail, "RAID");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
				if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
					msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
				end
				if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
					msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
					msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
				end
				if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
					local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
					local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
					msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
				end
				SendChatMessage(msg, "RAID");
			end
		end
	end
end

function OSendToOfficer(button)
	local i=0;local q=0;
	local comp = {};
	SendChatMessage(L["Item Level"]..":", "OFFICER");
	if not OCheckSendMark() then
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
			if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
				msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
			end
			if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
				msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
				msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
			end
			if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
				msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
			end
			if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
				local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
				local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
				msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
			end
			if button == "MiddleButton" then
				if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
					q = q + 1;
					comp[q] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
				end
			else
				comp[i] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
			end
		end
		sort(comp, function(a,b)
			if tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
			if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
			return tonumber(a.ilvl) > tonumber(b.ilvl)
		end)
		if button ~= "RightButton" then
			for _, info in ipairs(comp) do  SendChatMessage(info.mmsg, "OFFICER") end
		end
		if button ~= "MiddleButton" then
			SendChatMessage(L["Average Item Level"].." ("..NumRole["TANK"].." "..TANK.."): "..ailtank, "OFFICER");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["HEALER"].." "..HEALER.."): "..ailheal, "OFFICER");
			SendChatMessage(L["Average Item Level"].." ("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps, "OFFICER");
			SendChatMessage(L["Average Item Level"]..": "..ail, "OFFICER");
		end
	else
		for i = 1, 40 do
			if not _G["OILVLRAIDFRAME"..i]:IsShown() then
				break;
			end
			if _G["Oilvlmark"..i]:IsVisible() then
				local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1]
				if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
					msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
				end
				if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
					msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
					msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
				end
				if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
					msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
				end
				if cfg.MVPvsun and _G["OilvlUpgrade"..i]:GetText() and _G["OilvlUpgrade"..i]:GetText() ~= "" then
					local u1,u2 = _G["OilvlUpgrade"..i]:GetText():match("(%d+)/(%d+)")
					local milvl = round(tonumber(MVPvsframedata.ilvl[i][1]) + (tonumber(u2) - tonumber(u1))*10/MVPvsframedata.ilvl[i][3],cfg.MVPvsdp)
					msg = msg.." ("..UPGRADE..":".._G["OilvlUpgrade"..i]:GetText()..", "..milvl..")";
				end
				SendChatMessage(msg, "OFFICER");
			end
		end
	end
end

local function CopyEditBox(cname, cx, cy, cw, ch)
	local f = CreateFrame("ScrollFrame", cname.."Frame",UIParent,"UIPanelScrollFrameTemplate")
	f:SetPoint("CENTER", cx, cy)
	f:SetSize(cw+10,ch+10)
	f:SetFrameStrata("HIGH");
	f:SetMovable(true);
	f:EnableMouse(true);
	f:RegisterForDrag("LeftButton");
	f:SetScript("OnDragStart", f.StartMoving);
	f:SetScript("OnDragStop", function() f:StopMovingOrSizing();  end);

	local g = CreateFrame("EditBox", cname, f, InputBoxTemplate)
	g:SetAutoFocus(true)
	g:SetWidth(cw)
	g:SetHeight(20)
	g:SetMultiLine(true)
	g:SetScript("OnEscapePressed", function(self)
		_G[cname.."Frame"]:Hide();
		_G[cname.."_bodyBackground"]:Hide();
	end)
	g:SetFontObject("ChatFontNormal")
	f:SetScrollChild(g)
	g:SetCursorPosition(0);
	f:Hide();

	h = CreateFrame("Button", cname.."_bodyBackground", UIParent)
	h:SetPoint("BOTTOMLEFT", f, -10,-10)
	h:SetPoint("TOPRIGHT", f, 27,10)
	h:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16
	})
	h:Hide();
	local gg = CreateFrame("Button", nil, g)
	gg:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	gg:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	gg:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	gg:SetWidth(30)
	gg:SetHeight(30)
	gg:SetPoint("TOPRIGHT", g, "TOPRIGHT", 15, 5)
	gg:SetScript("OnClick", function(self) OIlvlCopyEB_bodyBackground:Hide(); OIlvlCopyEBFrame:Hide() end)
end

local function CopyEditBox2(cname, cx, cy, cw, ch, cbfunc)
	local f=CreateFrame("frame",cname,UIParent);
	f:SetWidth(cw+10); f:SetHeight(ch+10);
	f:SetPoint("CENTER",cx,cy);
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16
	})
	f:SetFrameStrata("HIGH");
	f:SetMovable(true);
	f:EnableMouse(true);
	f:RegisterForDrag("LeftButton");
	f:SetScript("OnDragStart", f.StartMoving);
	f:SetScript("OnDragStop", function() f:StopMovingOrSizing(); end);
	tinsert(UISpecialFrames,cname);
	f:Hide();

	local fsc = CreateFrame("ScrollingMessageFrame",cname.."Frame",f);
	fsc:SetWidth(cw); fsc:SetHeight(ch);
	fsc:SetPoint("TOPLEFT",f,10,-10);
	fsc:SetFontObject("ChatFontNormal")
	fsc:SetJustifyH("LEFT")
	fsc:SetFading(false)
	fsc:SetMaxLines(18)
	fsc:SetHyperlinksEnabled(true)
	fsc:SetInsertMode("TOP")
	fsc:SetScript("OnHyperlinkEnter", function(self,linkData,link)
		OilvlInspectTooltip:SetOwner(f, "ANCHOR_NONE");
		OilvlInspectTooltip:SetPoint("TOPLEFT",f,"TOPRIGHT",0,0)
		OilvlInspectTooltip:ClearLines()
		OilvlInspectTooltip:SetHyperlink(link)
	end
	)
	fsc:SetScript("OnHyperlinkClick", function(self, linkData, link, button)
		if IsShiftKeyDown() then
			local chatWindow = ChatEdit_GetActiveWindow()
			if chatWindow then
				chatWindow:Insert(link)
			end
		end
		if IsControlKeyDown() then
			DressUpItemLink(link)
		end
	end
	)
	fsc:SetScript("OnHyperlinkLeave", function(self,linkData,link) OilvlInspectTooltip:Hide() end)
	local g = CreateFrame("Button", nil, f)
	g:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	g:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	g:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	g:SetWidth(30)
	g:SetHeight(30)
	g:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	g:SetScript("OnClick", cbfunc)
end

function oilvlminbutton(parent, mname, func, x,y)
	local g = CreateFrame("Button", mname, parent)
	g:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	g:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	g:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	g:SetWidth(30)
	g:SetHeight(30)
	g:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)
	g:SetScript("OnClick", func)
end

CopyEditBox("OIlvlCopyEB", 0, 250, 500, 300)
CopyEditBox2("OIlvlInspect", 0, 250, 400, 260, function(self) OIlvlInspect:Hide() end)
CopyEditBox2("OIlvlInspect2", 0, -20, 400, 260, function(self) OIlvlInspect2:Hide() end)

local function obfbutton2(btnName, btnText, btnParent, btnTemplate, btnPoint, btnX, btnY, btnW, btnH, btnFunc)
	local button = CreateFrame("Button", btnName, btnParent, btnTemplate)
	button:SetPoint(btnPoint, btnX, btnY)
	button:SetWidth(btnW)
	button:SetHeight(btnH)

	button:SetText(btnText)
	button:SetNormalFontObject("GameFontNormal")

	local ntex = button:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()
	button:SetNormalTexture(ntex)

	local htex = button:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)

	button:RegisterForClicks("LeftButtonDown");
	button:SetScript("OnClick", btnFunc);
	button:SetFrameStrata("TOOLTIP")
end

function OSendToCopy(button)
	local i=0;local q=0;
	local comp = {};
	local ebmsg="";
	ebmsg = L["Item Level"]..":";
	for i = 1, 40 do
		if not _G["OILVLRAIDFRAME"..i]:IsShown() then
			break;
		end
		local msg = MVPvsframedata.name[i]..":"..MVPvsframedata.ilvl[i][1];
		if cfg.MVPvsme and MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
			msg = msg.." ("..L["Not enchanted"]..": "..MVPvsframedata.me[i][1]..")";
		end
		if cfg.MVPvsme and MVPvsframedata.mg[i][1] and MVPvsframedata.mg[i][1] ~= "" then
			msg = msg.." ("..L["Not socketed"]..": "..MVPvsframedata.mg[i][1]..")";
		end
		if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
			msg = msg.." ("..L["Low level enchanted"]..": "..MVPvsframedata.me[i][2]..")";
		end
		if cfg.MVPvsme and cfg.MVPvsme2 and MVPvsframedata.mg[i][2] and MVPvsframedata.mg[i][2] ~= "" then
			msg = msg.." ("..L["Low level socketed"]..": "..MVPvsframedata.mg[i][2]..")";
		end
		if button == "MiddleButton" then
			if (msg:sub(1,1) == "!") or (msg:sub(1,1) == "~") then
				q = q + 1;
				comp[q] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
			end
		else
			comp[i] = {ilvl = MVPvsframedata.ilvl[i][1], mmsg = msg}
		end
	end

	sort(comp, function(a,b)
		if tonumber(a.ilvl) == nil then return false end
		if tonumber(b.ilvl) == nil and tonumber(a.ilvl) == nil then return false end
		if tonumber(b.ilvl) == nil and tonumber(a.ilvl) ~= nil then return true end
		return tonumber(a.ilvl) > tonumber(b.ilvl)
	end)
	if button ~= "RightButton" then
		for _, info in ipairs(comp) do  ebmsg = ebmsg.."\n"..info.mmsg end
	end
	if button ~= "MiddleButton" then
		ebmsg = ebmsg.."\n"..L["Average Item Level"].."("..NumRole["TANK"].." "..TANK.."): "..ailtank;
		ebmsg = ebmsg.."\n"..L["Average Item Level"].."("..NumRole["HEALER"].." "..HEALER.."): "..ailheal;
		ebmsg = ebmsg.."\n"..L["Average Item Level"].."("..NumRole["DAMAGER"].." "..DAMAGER.."): "..aildps;
		ebmsg = ebmsg.."\n"..L["Average Item Level"]..": "..ail;
	end

	OIlvlCopyEB:SetText(ebmsg);
	OIlvlCopyEB:HighlightText(0)
	OIlvlCopyEBFrame:Show();
	OIlvlCopyEB_bodyBackground:Show();
	OIlvlCopyEBFrame:SetVerticalScroll(OIlvlCopyEBFrame:GetVerticalScrollRange())
end

function oilvlbutton(btnName, btnText, btnParent, btnTemplate, btnPoint, btnX, btnY, btnW, btnH, btnFunc)
	local button = CreateFrame("Button", btnName, btnParent, btnTemplate)
	button:SetPoint(btnPoint, btnX, btnY)
	button:SetWidth(btnW)
	button:SetHeight(btnH)

	button:SetText(btnText)
	button:SetNormalFontObject("GameFontNormal")

	local ntex = button:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()
	button:SetNormalTexture(ntex)

	local htex = button:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)

	local ptex = button:CreateTexture()
	ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	button:SetPushedTexture(ptex)

	button:RegisterForClicks("LeftButtonDown","MiddleButtonDown","RightButtonDown");
	button:SetScript("OnClick", btnFunc);
end

function OPvPButton(btnParent)
	local button = CreateFrame("Button", "OPvPBtn", btnParent)
	button:SetPoint("TOPLEFT", 65, -38)
	button:SetWidth(20)
	button:SetHeight(20)

	local ntex = button:CreateTexture(nil, "BACKGROUND")
	ntex:SetSize(20,20);
	ntex:SetPoint("CENTER",-1,1);
	ntex:SetTexture(OPvP[1])
	ntex:SetTexCoord(OPvP[2],OPvP[3],OPvP[4],OPvP[5])

	local ptex = button:CreateTexture("OPvPSet", "BACKGROUND")
	ptex:SetSize(20,20);
	ptex:SetPoint("CENTER",-1,1);
	ptex:SetColorTexture(1,0,0,0.2)
	ptex:Hide();

	local htex = button:CreateTexture()
	htex:SetSize(20,20);
	htex:SetPoint("CENTER",-1,1);
	htex:SetColorTexture(1,1,1,0.3)
	button:SetHighlightTexture(htex)

	button:RegisterForClicks("LeftButtonDown", "MiddleButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button)
		if OPvPSet:IsVisible() then
			OPvPSet:Hide();
			pvpsw = false;
		else
			OPvPSet:Show();
			pvpsw = true;
		end
		for s = 1, 40 do
			if MVPvsframedata.ilvl[s][1] ~= nil and MVPvsframedata.ilvl[s][1] ~= "" then
				MVPvsframedata.ilvl[s][1] = OTgathertilPvP(s);
			end
		end
		OilvlCheckFrame();
	end)
	button:SetScript("OnEnter", function(self)
		OilvlPvPTooltip:SetOwner(button, "ANCHOR_CURSOR");
		OilvlPvPTooltip:AddLine(PVP);
		OilvlPvPTooltip:Show();
	end)
	button:SetScript("OnLeave", function(self) OilvlPvPTooltip:Hide(); end)
end

function oilvlcfgbutton(btnParent)
	local button = CreateFrame("Button", "oilvlcfgbutton", btnParent)
--	button:SetPoint("TOPLEFT", 39, 20)
	button:SetPoint("TOPLEFT", -10, 10)
	button:SetWidth(70)
	button:SetHeight(70)

--    local border = button:CreateTexture(nil, "BORDER");
--    border:SetSize(64,64);
--    border:SetPoint("CENTER", 12, -13);
--    border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");

	local ntex = button:CreateTexture(nil, "BACKGROUND")
--	ntex:SetSize(52,52);
	ntex:SetSize(120,120);
	ntex:SetPoint("CENTER",-1,1);
	ntex:SetTexture("Interface/AddOns/MostValuablePlayer/config.tga")

	local htex = button:CreateTexture()
--	htex:SetSize(40,40);
	htex:SetSize(70,70);
	htex:SetPoint("CENTER",-1,1);
	htex:SetTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight")
	button:SetHighlightTexture(htex)

	button:RegisterForClicks("LeftButtonDown", "MiddleButtonDown", "RightButtonDown");
	button:SetScript("OnClick", function(self, button)
		if button == "MiddleButton" or button == "MiddleButtonDown" then
			if otooltip5 ~= nil then
				if LibQTip:IsAcquired("OiLvLAlt") then otooltip5:Clear() end
				otooltip5:Hide()
				LibQTip:Release(otooltip5)
				otooltip5 = nil
			else
				otooltip5func()
			end
		elseif button == "LeftButton" or button == "LeftButtonDown" then
				otooltip7func()
		else
			--PlaySound("igMainMenuOption");
			InterfaceOptionsFrameTab2:Click();
			InterfaceOptionsFrame_OpenToCategory("M V P  (Jany)")
		end
	end);
--	button:SetScript("OnEnter", function(self, button) LDB_ANCHOR=btnParent; otooltip6func() end);
end

function OilvlSetCA()
	ounit = rpdounit
	if not rpsw and CheckInteractDistance(ounit, 1) and UnitExists(ounit) and cfg.MVPvsms then
		Omover2=1;
		ClearAchievementComparisonUnit();
		OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		rpsw=true;
		rpunit=ounit;
		SetAchievementComparisonUnit(ounit);
		if cfg.MVPvsrpdetails then
			LoadRPDTooltip:SetOwner(OilvlTooltip, "ANCHOR_BOTTOM",0,-20);
			LoadRPDTooltip:AddLine(L["Raid Progression Details"]..": |cFFFFFFFF"..LFG_LIST_LOADING);
			LoadRPDTooltip:SetBackdropColor(1, 0, 0,1)
			LoadRPDTooltip:Show();
		end
	end
end

function oilvlframe()
	local f = CreateFrame("Frame", "OIVLFRAME", UIParent, "ButtonFrameTemplate");
	f:SetWidth(676);
	f:SetHeight(404);
	f:SetFrameStrata("LOW");

-- set moveable and dragable
	f:SetMovable(true);
	f:EnableMouse(true);
	f:RegisterForDrag("LeftButton");
	f:SetScript("OnDragStart", f.StartMoving);
	f:SetScript("OnDragStop", function() f:StopMovingOrSizing();  cfg.MVPvsframeP, _, _, cfg.MVPvsframeX, cfg.MVPvsframeY = f:GetPoint() end);

-- Set Title
	f.text = f.text or f:CreateFontString("oilvlname","ARTWORK", "GameTooltipText");
	f.text:SetAllPoints(true);
	f.text:SetPoint("TOPLEFT",0,-6);
	f.text:SetJustifyH("CENTER");
	f.text:SetJustifyV("TOP");
	f.text:SetTextColor(1,1,1,1);
	f.text:SetFont("Fonts\\FRIZQT__.TTF",12,"")
	f.text:SetText("M V P ");

--background texture
	local t = f:CreateTexture(nil,"BACKGROUND")
	t:SetColorTexture(0.1,0.1,0.1,0.5)
	t:SetAllPoints(f)
	f.texture = t
	f:SetPoint("TOPLEFT",15,-60);

 --icon
--    local icon = f:CreateTexture("$parentIcon", "OVERLAY", nil, -8);
--    icon:SetSize(60,60);
--    icon:SetPoint("TOPLEFT",-5,7);
--    icon:SetTexture("Interface/AddOns/Oilvl/config.tga");
--    icon:SetTexCoord(0,1,0,1);
--    f.icon = icon;

-- Average Item Level
	local adjustl = 5;
	local ail = f:CreateFontString("OilvlAIL","ARTWORK","GameFontHighlight")
	ail:SetPoint("BOTTOMLEFT",10,30)
	ail:SetText(L["Average Item Level"]..":");

	local function CreateTextureFontString(tname,p,q,tt,t1,t2,t3,t4,fsname,x,y)
		local g = f:CreateTexture(tname, "OVERLAY", nil, -8);
		g:SetSize(15,15);
		g:SetPoint("BOTTOMLEFT",p,q);
		g:SetTexture(tt);
		g:SetTexCoord(t1,t2,t3,t4);
		local t = f:CreateFontString(fsname,"ARTWORK","GameFontHighlight")
		t:SetPoint("BOTTOMLEFT",x,y)
		t:SetText(" ");
	end

	local function OCreateFontString(fsname,x,y)
		local t = f:CreateFontString(fsname,"ARTWORK","GameFontHighlight")
		t:SetPoint("BOTTOMLEFT",x,y)
		t:SetText(" ");
	end
	-- number of tanks, dps and healers
	CreateTextureFontString("ONumTank",10,50,ORole["TANK"][1],ORole["TANK"][2],ORole["TANK"][3],ORole["TANK"][4],ORole["TANK"][5],"OilvlAIL_TANK",28,50)
	CreateTextureFontString("ONumDPS",100+adjustl,50,ORole["DAMAGER"][1],ORole["DAMAGER"][2],ORole["DAMAGER"][3],ORole["DAMAGER"][4],ORole["DAMAGER"][5],"OilvlAIL_DPS",118+adjustl,50)
	CreateTextureFontString("ONumHeal",200+adjustl*2,50,ORole["HEALER"][1],ORole["HEALER"][2],ORole["HEALER"][3],ORole["HEALER"][4],ORole["HEALER"][5],"OilvlAIL_HEAL",218+adjustl*2,50)

	-- Vanquisher
	CreateTextureFontString("ONumDEATHKNIGHT",10,104,OClassTexture["BASE"],OClassTexture["DEATHKNIGHT"][1],OClassTexture["DEATHKNIGHT"][2],OClassTexture["DEATHKNIGHT"][3],OClassTexture["DEATHKNIGHT"][4],"OilvlAIL_DEATHKNIGHT",28,104)
	CreateTextureFontString("ONumDRUID",60,104,OClassTexture["BASE"],OClassTexture["DRUID"][1],OClassTexture["DRUID"][2],OClassTexture["DRUID"][3],OClassTexture["DRUID"][4],"OilvlAIL_DRUID",78,104)
	CreateTextureFontString("ONumMAGE",110,104,OClassTexture["BASE"],OClassTexture["MAGE"][1],OClassTexture["MAGE"][2],OClassTexture["MAGE"][3],OClassTexture["MAGE"][4],"OilvlAIL_MAGE",128,104)
	CreateTextureFontString("ONumROGUE",160,104,OClassTexture["BASE"],OClassTexture["ROGUE"][1],OClassTexture["ROGUE"][2],OClassTexture["ROGUE"][3],OClassTexture["ROGUE"][4],"OilvlAIL_ROGUE",178,104)
	OCreateFontString("VanqText",200,104)

	-- Protector
	CreateTextureFontString("ONumHUNTER",10,86,OClassTexture["BASE"],OClassTexture["HUNTER"][1],OClassTexture["HUNTER"][2],OClassTexture["HUNTER"][3],OClassTexture["HUNTER"][4],"OilvlAIL_HUNTER",28,86)
	CreateTextureFontString("ONumMONK",60,86,OClassTexture["BASE"],OClassTexture["MONK"][1],OClassTexture["MONK"][2],OClassTexture["MONK"][3],OClassTexture["MONK"][4],"OilvlAIL_MONK",78,86)
	CreateTextureFontString("ONumSHAMAN",110,86,OClassTexture["BASE"],OClassTexture["SHAMAN"][1],OClassTexture["SHAMAN"][2],OClassTexture["SHAMAN"][3],OClassTexture["SHAMAN"][4],"OilvlAIL_SHAMAN",128,86)
	CreateTextureFontString("ONumWARRIOR",160,86,OClassTexture["BASE"],OClassTexture["WARRIOR"][1],OClassTexture["WARRIOR"][2],OClassTexture["WARRIOR"][3],OClassTexture["WARRIOR"][4],"OilvlAIL_WARRIOR",178,86)
	OCreateFontString("ProtText",200,86)

	-- Conqueror
	CreateTextureFontString("ONumPALADIN",10,68,OClassTexture["BASE"],OClassTexture["PALADIN"][1],OClassTexture["PALADIN"][2],OClassTexture["PALADIN"][3],OClassTexture["PALADIN"][4],"OilvlAIL_PALADIN",28,68)
	CreateTextureFontString("ONumPRIEST",60,68,OClassTexture["BASE"],OClassTexture["PRIEST"][1],OClassTexture["PRIEST"][2],OClassTexture["PRIEST"][3],OClassTexture["PRIEST"][4],"OilvlAIL_PRIEST",78,68)
	CreateTextureFontString("ONumWARLOCK",110,68,OClassTexture["BASE"],OClassTexture["WARLOCK"][1],OClassTexture["WARLOCK"][2],OClassTexture["WARLOCK"][3],OClassTexture["WARLOCK"][4],"OilvlAIL_WARLOCK",128,68)
	CreateTextureFontString("ONumDEMONHUNTER",160,68,OClassTexture["BASE"],OClassTexture["DEMONHUNTER"][1],OClassTexture["DEMONHUNTER"][2],OClassTexture["DEMONHUNTER"][3],OClassTexture["DEMONHUNTER"][4],"OilvlAIL_DEMONHUNTER",178,68)
	OCreateFontString("ConqText",200,68)

-- 	Enchantment Reminder
	local ercb = CreateFrame("CheckButton", "oilvlercb", f, "ChatConfigCheckButtonTemplate");
	ercb:SetPoint("BOTTOMRIGHT", -20,25);
	oilvlercbText:SetText("ER");
	ercb.tooltip = L["Enable Sending Enchantment Reminder"];
	ercb:SetHitRectInsets(0,0,0,0);
	ercb:SetSize(25,25);
	ercb:SetScript("PostClick", function()
		cfg.MVPvsme = oilvlercb:GetChecked();
		oilvleer:SetChecked(cfg.MVPvsme)
		if oilvleer:GetChecked() then oilvlbestenchant:Enable(); else	oilvlbestenchant:Disable(); end
	end);
	ercb:SetChecked(cfg.MVPvsme);

-- 	Auto Scan
	local autoscan = CreateFrame("CheckButton", "oilvlautoscan", f, "ChatConfigCheckButtonTemplate");
	autoscan:SetPoint("BOTTOMRIGHT", -80,25);
	oilvlautoscanText:SetText("AS");
	autoscan.tooltip = L["Auto Scan"];
	autoscan:SetHitRectInsets(0,0,0,0);
	autoscan:SetSize(25,25);
	autoscan:SetScript("PostClick", function()
		if cfg.MVPvsautoscan then
			cfg.MVPvsautoscan = false
			autoscan:SetChecked(cfg.MVPvsautoscan);
		else
			cfg.MVPvsautoscan = true
			autoscan:SetChecked(cfg.MVPvsautoscan);
		end
	end);
	autoscan:SetChecked(cfg.MVPvsautoscan);


	OPvPButton(f)

-- Config Button
	oilvlcfgbutton(f);
--Refresh button
	oilvlbutton("OILVLREFRESH", LFG_LIST_REFRESH, f, "OptionsButtonTemplate", "TOPRIGHT", -6, -35, 80, 22, function(self, button) OVILRefresh() end);
--Party button
	oilvlbutton("OILVLParty", PARTY, f, "OptionsButtonTemplate", "TOPRIGHT", -88, -35, 60, 22, function(self, button) OSendToParty(button) end);
--Target button
	oilvlbutton("OILVLTarget", STATUS_TEXT_TARGET, f, "OptionsButtonTemplate", "TOPRIGHT", -150, -35, 70, 22, function(self, button) OSendToTarget(button) end);
--Reset button
	oilvlbutton("OILVLReset", RESET, f, "OptionsButtonTemplate", "TOPRIGHT", -222, -35, 90, 22, function(self, button) OResetSendMark() end);
--Instance button
	oilvlbutton("OILVLINSTANCE", BATTLEGROUND_INSTANCE, f, "OptionsButtonTemplate", "BOTTOMLEFT", 3, 3, 80, 22, function(self, button) OSendToInstance(button) end);
-- Guild button
	if GetLocale() == "itIT" then
		oilvlbutton("OILVLGUILD", CHAT_MSG_GUILD, f, "OptionsButtonTemplate", "BOTTOMLEFT", 85, 3, 70, 22, function(self, button) OSendToGuild(button) end);
	else
		oilvlbutton("OILVLGUILD", CHAT_MSG_GUILD, f, "OptionsButtonTemplate", "BOTTOMLEFT", 85, 3, 100, 22, function(self, button) OSendToGuild(button) end);
	end
-- Raid button
	if GetLocale() == "deDE" then
		oilvlbutton("OILVLRAID", "Raid", f, "OptionsButtonTemplate", "BOTTOMLEFT", 187, 3, 60, 22, function(self, button) OSendToRaid(button)	end);
	elseif GetLocale() == "itIT" then
		oilvlbutton("OILVLRAID", CHAT_MSG_RAID, f, "OptionsButtonTemplate", "BOTTOMLEFT", 157, 3, 90, 22, function(self, button) OSendToRaid(button)	end);
	else
		oilvlbutton("OILVLRAID", CHAT_MSG_RAID, f, "OptionsButtonTemplate", "BOTTOMLEFT", 187, 3, 60, 22, function(self, button) OSendToRaid(button)	end);
	end
-- Officer button
	oilvlbutton("OILVLOfficer", GUILD_RANK1_DESC, f, "OptionsButtonTemplate", "BOTTOMLEFT", 250, 3, 70, 22, function(self, button) OSendToOfficer(button)	end);
--Copy button
	oilvlbutton("OILVLCopy", L["Export"], f, "OptionsButtonTemplate", "BOTTOMLEFT", 322, 3, 70, 22, function(self, button) OSendToCopy(button) end);
-- Party / Raid Frame
	local rfb=1; -- raid frame button
	local b4i=0;
	local b4j=0;
	for b4j = 1, 8 do
		for b4i = 1, 5 do
			local button4 = CreateFrame("Button", "OILVLRAIDFRAME"..rfb, f, "SecureUnitButtonTemplate")
			button4:SetText("")
			button4:SetNormalFontObject("GameFontNormalSmall")
			local _,bheight,_ = button4:GetNormalFontObject():GetFont()
			button4:SetSize(80,bheight*4)
			button4:SetPoint("TOPLEFT",OIVLFRAME,"TOPLEFT",10+(b4j-1)*82, -66-(b4i-1)*(bheight*4+2))

			local ntex4 = button4:CreateTexture()
			ntex4:SetColorTexture(0.2,0.2,0.2,0.5)
			ntex4:SetAllPoints()
			button4:SetNormalTexture(ntex4)

			local htex4 = button4:CreateTexture()
			htex4:SetColorTexture(0,0,1,0.5)
			htex4:SetAllPoints()
			button4:SetHighlightTexture(htex4)

			local ptex4 = button4:CreateTexture()
			ptex4:SetColorTexture(0,1,1,0.5)
			ptex4:SetAllPoints()
			button4:SetPushedTexture(ptex4)

			-- Right Click
			button4:SetAttribute("type2", "target");
			button4:SetAttribute("target2", "mouseover");

			-- Ctrl Right Click
			button4:SetAttribute("ctrl-type2", "macro");
			button4:SetAttribute("ctrl-macrotext2", "/tar mouseover\n/inspect");

			-- Alt Right Click
			button4:SetAttribute("alt-type2", "macro");
			button4:SetAttribute("alt-macrotext2", "/tar mouseover\n/inspect");

			-- hide tooltips
			button4:SetScript("OnLeave", function(self)
				OilvlTooltip:Hide()
				LoadRPDTooltip:Hide()
				--ClearAchievementComparisonUnit();
				if not otooltip2 then
					OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
					--ClearAchievementComparisonUnit();
					rpsw=false;
					rpunit="";
					Omover2=0;
				end
			end)

			button4:SetScript("OnEnter", function(self)
				if not otooltip2 then
					local ounit = self:GetAttribute("unit");
					OilvlTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
					OilvlTooltip:SetUnit(ounit)
					local i = tonumber(self:GetName():gsub("OILVLRAIDFRAME", "").."");
					if not ospec[MVPvsframedata.spec[i]] then return end
					if MVPvsframedata.spec[i] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(SPECIALIZATION..": |cFF00FF00"..ospec[MVPvsframedata.spec[i]]);
					end
					if MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(L["Not enchanted"]..":\n|cFF00FF00"..MVPvsframedata.me[i][1]);
					end
					if MVPvsframedata.me[i][1] and MVPvsframedata.mg[i][1] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(L["Not socketed"]..":\n|cFF00FF00"..MVPvsframedata.mg[i][1]);
					end
					if MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(L["Low level enchanted"]..":\n|cFF00FF00"..MVPvsframedata.me[i][2]);
					end
					if MVPvsframedata.me[i][2] and MVPvsframedata.mg[i][2] ~= "" then
						OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
						OilvlTooltip:AddLine(L["Low level socketed"]..":\n|cFF00FF00"..MVPvsframedata.mg[i][2]);
					end
					OilvlTooltip:Show()
					rpdframe = self;
					rpdframesw = true;
					rpdounit = ounit;
				end
			end)

			-- set role variable
			Oilvlrole[rfb] = button4:CreateTexture("Oilvlrole"..rfb, "OVERLAY", nil, -8);
			Oilvlrole[rfb]:SetSize(15,15);
			Oilvlrole[rfb]:SetPoint("BOTTOMRIGHT",0,0);
			Oilvlrole[rfb]:SetTexture(nil);
			Oilvlrole[rfb]:SetTexCoord(0,0,0,0);

			-- set rank variable
			Oilvlrank[rfb] = button4:CreateTexture("Oilvlrank"..rfb, "OVERLAY", nil, -8);
			Oilvlrank[rfb]:SetSize(15,15);
			Oilvlrank[rfb]:SetPoint("TOPLEFT",0,5);
			Oilvlrank[rfb]:SetTexture(nil);
--			Oilvlrank[rfb]:SetTexCoord(0,0,0,0);

			-- set mark for send
			button4:CreateTexture("Oilvlmark"..rfb, "OVERLAY", nil, -8);
			_G["Oilvlmark"..rfb]:SetSize(15,15);
			_G["Oilvlmark"..rfb]:SetPoint("RIGHT",0,0);
			_G["Oilvlmark"..rfb]:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready");
			_G["Oilvlmark"..rfb]:Hide();

			-- set tier
			local tier = button4:CreateFontString("Oilvltier"..rfb,"ARTWORK","GameFontNormalLarge")
			tier:SetPoint("TOPRIGHT")
			tier:SetText("")

			-- total upgrade
			local tier = button4:CreateFontString("OilvlUpgrade"..rfb,"ARTWORK","GameFontNormalSmall")
			tier:SetPoint("BOTTOMLEFT")
			tier:SetTextHeight(10)
			tier:SetText("")

			-- Left Click, Middle Click, Right Click
			button4:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown");
			button4:SetScript("PostClick", function(self, button, down)
					if (button == "LeftButton" or button == "LeftButtonDown") and not IsControlKeyDown() and not IsAltKeyDown()then
						ORfbIlvl(self:GetName():gsub("OILVLRAIDFRAME", "").."",true)
					end
					if button == "MiddleButton" or button == "MiddleButtonDown" then
						if _G["Oilvlmark"..self:GetName():gsub("OILVLRAIDFRAME","")]:IsShown() then
							_G["Oilvlmark"..self:GetName():gsub("OILVLRAIDFRAME","")]:Hide();
						else
							_G["Oilvlmark"..self:GetName():gsub("OILVLRAIDFRAME","")]:Show();
						end
					end
					if (button == "LeftButton" or button == "LeftButtonDown") and IsAltKeyDown() then
						local nn = tonumber(self:GetName():gsub("OILVLRAIDFRAME","").."");
						if MVPvsframedata.gear[nn] ~= "" then
							OIlvlInspectFrame:Clear();
							local nline = 0
							for crg = 17,1,-1 do
								if MVPvsframedata.gear[nn][crg] ~= nil then
									if pvpsw then
										if MVPvsframedata.gear[nn][crg][7] ~= 0 then
											OIlvlInspectFrame:AddMessage(MVPvsframedata.gear[nn][crg][7].." "..MVPvsframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",MVPvsframedata.gear[nn][crg][3]*MVPvsframedata.gear[nn][crg][5],1,MVPvsframedata.gear[nn][crg][4]*MVPvsframedata.gear[nn][crg][6])
										else
											OIlvlInspectFrame:AddMessage(MVPvsframedata.gear[nn][crg][1].." "..MVPvsframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",MVPvsframedata.gear[nn][crg][3]*MVPvsframedata.gear[nn][crg][5],1,MVPvsframedata.gear[nn][crg][4]*MVPvsframedata.gear[nn][crg][6])
										end
									else
										OIlvlInspectFrame:AddMessage(MVPvsframedata.gear[nn][crg][1].." "..MVPvsframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",MVPvsframedata.gear[nn][crg][3]*MVPvsframedata.gear[nn][crg][5],1,MVPvsframedata.gear[nn][crg][4]*MVPvsframedata.gear[nn][crg][6]);
									end
									nline = nline + 1
								end
							end
							OIlvlInspectFrame:AddMessage(MVPvsframedata.ilvl[nn][1].." "..MVPvsframedata.name[nn].."\n")
							OIlvlInspect:Show();
						end
					end
					if (button == "LeftButton" or button == "LeftButtonDown") and IsControlKeyDown() then
						local nn = tonumber(self:GetName():gsub("OILVLRAIDFRAME","").."");
						if MVPvsframedata.gear[nn] ~= "" then
							OIlvlInspect2Frame:Clear();
							for crg = 17,1,-1 do
								if MVPvsframedata.gear[nn][crg] ~= nil then
									if pvpsw then
										if MVPvsframedata.gear[nn][crg][7] ~= 0 then
											OIlvlInspect2Frame:AddMessage(MVPvsframedata.gear[nn][crg][7].." "..MVPvsframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",MVPvsframedata.gear[nn][crg][3]*MVPvsframedata.gear[nn][crg][5],1,MVPvsframedata.gear[nn][crg][4]*MVPvsframedata.gear[nn][crg][6])
										else
											OIlvlInspect2Frame:AddMessage(MVPvsframedata.gear[nn][crg][1].." "..MVPvsframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",MVPvsframedata.gear[nn][crg][3]*MVPvsframedata.gear[nn][crg][5],1,MVPvsframedata.gear[nn][crg][4]*MVPvsframedata.gear[nn][crg][6])
										end
									else
										OIlvlInspect2Frame:AddMessage(MVPvsframedata.gear[nn][crg][1].." "..MVPvsframedata.gear[nn][crg][2].."  ("..oenchantItem[crg][2]..")",MVPvsframedata.gear[nn][crg][3]*MVPvsframedata.gear[nn][crg][5],1,MVPvsframedata.gear[nn][crg][4]*MVPvsframedata.gear[nn][crg][6]);
									end
								end
							end
							OIlvlInspect2Frame:AddMessage(MVPvsframedata.ilvl[nn][1].." "..MVPvsframedata.name[nn].."\n")
							OIlvlInspect2:Show();
						end
					end
			end);
			rfb = rfb + 1;
		end
	end

-- Set OiLvLFrame height
	OIVLFRAME:SetHeight(66+5*(OILVLRAIDFRAME1:GetHeight()+2)+128)

-- Oilvl Game Tooltips
	CreateFrame("GameTooltip", "OilvlTooltip", UIParent, "GameTooltipTemplate");

-- Oilvl Inspect Tooltips
	CreateFrame("GameTooltip", "OilvlInspectTooltip", UIParent, "GameTooltipTemplate");

-- Oilvl Roll Tooltips
	CreateFrame("GameTooltip", "OilvlRollTooltip", UIParent, "GameTooltipTemplate");

-- Oilvl PvP Tooltips
	CreateFrame("GameTooltip", "OilvlPvPTooltip", UIParent, "GameTooltipTemplate");

-- Refresh
	oilvlframesw=true;
	OVILRefresh();
	f:SetScale(0.8);
	f:Show();
	f:Hide();
--	tinsert(UISpecialFrames,"OIVLFRAME");
--	f:SetUserPlaced(true);
end
-- OCategory is the expansion title.
-- ORaidname is the raid title.
-- Oprint is to print out the result if true.
-- Example:
-- OilvlGetStatisticId("Warlords of Draenor", "Highmaul", OSTATHM, false)
-- OilvlGetStatisticId("Warlords of Draenor", "Blackrock Foundry", OSTATBF, false)
function OilvlGetStatisticId(OCategory, ORaidName, OTable, Oprint)
	local str = ""
	for _, CategoryId in pairs(GetStatisticsCategoryList()) do
		local Title, ParentCategoryId, Something
		Title, ParentCategoryId, Something = GetCategoryInfo(CategoryId)

		if Title == OCategory then
			local i
			local statisticCount = GetCategoryNumAchievements(CategoryId)
			local j=1; -- boss Count
			local k=1; -- difficulties Count
			for i = 1, statisticCount do
				local IDNumber, OOName, _, _, _, _, _, _, _, _, _ = GetAchievementInfo(CategoryId, i)
				if OOName:find(ORaidName) then
					if k == 1 then
						OTable[j] = {}
					end
					OTable[j][k] = IDNumber;
					if k < 4 then
						k = k + 1;
					else
						OTable[j][k+1] = OOName:gsub(" defeats ",""):gsub(" kills ",""):gsub(" destructions ",""):gsub("%(.*%)","").."";
						k = 1;
						j = j + 1;
					end
					if Oprint then
						print(OOName..":"..IDNumber)
					end
				end
			end
		end
	end
end

function oilvlSetOSTATULD()
	for i = 1,11 do
		OSTATULD[i][5] = select(2,GetAchievementInfo(OSTATULD[i][1])):gsub(" %(.*%)","")..""
	end
end

-- function oilvlSetOSTATTN()
-- 	for i = 1,10 do
-- 		OSTATTN[i][5] = select(2,GetAchievementInfo(OSTATTN[i][1])):gsub(" %(.*%)","")..""
-- 	end
-- end
--
-- function oilvlSetOSTATTOV()
-- 	for i = 1,3 do
-- 		OSTATTOV[i][5] = select(2,GetAchievementInfo(OSTATTOV[i][1])):gsub(" %(.*%)","")..""
-- 	end
-- end
--
-- function oilvlSetOSTATTOS()
-- 	for i = 1,9 do
-- 		OSTATTOS[i][5] = select(2,GetAchievementInfo(OSTATTOS[i][1])):gsub(" %(.*%)","")..""
-- 	end
-- end
--
-- function oilvlSetOSTATABT()
-- 	for i = 1,11 do
-- 		OSTATABT[i][5] = select(2,GetAchievementInfo(OSTATABT[i][1])):gsub(" %(.*%)","")..""
-- 	end
-- end

-----------------------------------------
-- Font definitions.
-----------------------------------------
-- Setup the Title Font. 14
local ssTitleFont = CreateFont("ssTitleFont")
ssTitleFont:SetTextColor(1,0.823529,0)
ssTitleFont:SetFont(GameTooltipText:GetFont(), 14)

-- Setup the Header Font. 12
local ssHeaderFont = CreateFont("ssHeaderFont")
ssHeaderFont:SetTextColor(1,0.823529,0)
ssHeaderFont:SetFont(GameTooltipHeaderText:GetFont(), 12)

-- Setup the Regular Font. 12
local ssRegFont = CreateFont("ssRegFont")
ssRegFont:SetTextColor(1,0.823529,0)
ssRegFont:SetFont(GameTooltipText:GetFont(), 12)

local orp={};
orp["LFR"]={};
orp["Normal"]={};
orp["Heroic"]={};
orp["Mythic"]={};

function OGetRaidProgression(RaidName, OSTAT, NumRaidBosses)
	local i=0;
	local omatch=false; -- check if some word repeat
	local twohighest=0;
	local progression="";
	local matchi=0; -- line that word repeat + 1
	wipe(orp);
	orp={};
	orp["LFR"]={};
	orp["Normal"]={};
	orp["Heroic"]={};
	orp["Mythic"]={};
	orp["unitname"], orp["unitid"] = GameTooltip:GetUnit();
	orp["oframe"] = GameTooltip:GetOwner();
	if rpunit == "" or not UnitExists("target") or not CheckInteractDistance("target", 1) or orp["oframe"] == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		return -1;
	end
	if orp["unitname"] == nil then
		ClearAchievementComparisonUnit();
		OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		SetAchievementComparisonUnit("target");
		rpunit = "target";
		rpsw=true;
		return -1;
	end
	if orp["unitid"] == nil then
		ClearAchievementComparisonUnit();
		OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		SetAchievementComparisonUnit("target");
		rpunit = "target";
		rpsw=true;
		return -1;
	end
	if UnitGUID(rpunit) ~= UnitGUID(orp["unitid"]) then
		ClearAchievementComparisonUnit();
		OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
		SetAchievementComparisonUnit("target");
		rpunit = "target";
		rpsw=true;
		return -1;
	end
	for i = 2, GameTooltip:NumLines() do
		local msg = _G["GameTooltipTextLeft"..i]:GetText();
		if msg then
			msg = msg:find(RaidName);
		end
		if msg then
			omatch=true;
			matchi=i+1;
			break;
		end
	end
	if not omatch then
		GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
		GameTooltip:AddLine(RaidName);--奥迪尔
	end
	local op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][4]) ~= "--" then
			op = op + 1;
		end
		orp["Mythic"][i] = GetComparisonStatistic(OSTAT[i][4]);
	end
	if op > 0 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY6.." ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][3]) ~= "--" then
			op = op + 1;
		end
		orp["Heroic"][i] = GetComparisonStatistic(OSTAT[i][3]);
	end
	if op > 0 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY2.." ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][2]) ~= "--" then
			op = op + 1;
		end
		orp["Normal"][i] = GetComparisonStatistic(OSTAT[i][2]);
	end
	if op > 0 and twohighest < 2 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY1.." ";
		twohighest = twohighest + 1
	end
	op=0;
	for i = 1, NumRaidBosses do
		if GetComparisonStatistic(OSTAT[i][1]) ~= "--" then
			op = op + 1;
		end
		orp["LFR"][i] = GetComparisonStatistic(OSTAT[i][1]);
	end
	if op > 0 and twohighest < 2 then
		progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..PLAYER_DIFFICULTY3.." ";
		twohighest = twohighest + 1
	end
	if twohighest == 0 then
		progression=progression.."|cFF00FF00 --";
	end
	if not omatch then
		if progression ~= "" then
			GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
			GameTooltip:AddLine(progression);
		end
	else
		_G["GameTooltipTextLeft"..matchi]:SetText(progression);
	end
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	--ClearAchievementComparisonUnit();
	rpsw=false;
	rpunit="";

	-- Show raid progression on tooltip:
	if cfg.MVPvsrpdetails then
		if LibQTip:IsAcquired("Oraidprog") then
			otooltip:Clear()
		else
			otooltip = LibQTip:Acquire("Oraidprog", 5, "LEFT", "CENTER", "CENTER", "CENTER", "CENTER")
			otooltip:SetBackdropColor(0,0,0,1)
			otooltip:SetHeaderFont(ssHeaderFont)
			otooltip:SetFont(ssRegFont)
			otooltip:ClearAllPoints()
			otooltip:SetClampedToScreen(false)
			otooltip:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT")
		end

		local line = otooltip:AddLine()
		otooltip:SetCell(line, 1, "|cffffffff" ..RaidName.. "|r", "LEFT", 3)
		line = otooltip:AddHeader()
		line = otooltip:SetCell(line, 1, NAME)
		line = otooltip:SetCell(line, 2, PLAYER_DIFFICULTY6)
		line = otooltip:SetCell(line, 3, "--")
		line = otooltip:SetCell(line, 4, "--")
		line = otooltip:SetCell(line, 5, "--")
		otooltip:AddSeparator()

		for m = 1, NumRaidBosses do
			line = otooltip:AddLine()
			line = otooltip:SetCell(line, 1, OSTAT[m][5])
			line = otooltip:SetCell(line, 2, orp["LFR"][m])
			line = otooltip:SetCell(line, 3, orp["Normal"][m])
			line = otooltip:SetCell(line, 4, orp["Heroic"][m])
			line = otooltip:SetCell(line, 5, orp["Mythic"][m])
		end
		otooltip:Show();--指向目标提示
	end
end

testabc=""
-- OiLvL Frame
local function SaveAOTCCE(tt,...)
	local an = {...}
	for j = 1, #an do
		local temp = {GetAchievementComparisonInfo(an[j])}
		local _,temp2,_ = GetAchievementInfo(an[j]);
		for i = 1, 4 do tt[#tt+1] = temp[i] end
		tt[#tt+1] = temp2
		if temp[1] then
			_, cunitid = OilvlTooltip:GetUnit();
			local clink = GetAchievementLink(an[j]):gsub(UnitGUID("player"):gsub("-","%%-"),UnitGUID(cunitid):gsub("-","%%-"))
			local cdate = temp[2]..":"..temp[3]..":"..temp[4]
			if GetAchievementLink(an[j]):match(UnitGUID("player"):gsub("-","%%-")..":1:(%d+:%d+:%d+)") then
				clink = clink:gsub(GetAchievementLink(an[j]):match(UnitGUID("player"):gsub("-","%%-")..":1:(%d+:%d+:%d+)"),cdate)
			else
				clink = clink:gsub("0:0:0:%-1","1:"..cdate)
			end
			tt[#tt+1] = clink
		end
	end
end

local difficulties = {
	{"Mythic",PLAYER_DIFFICULTY6.." ",4,"M "},
	{"Heroic",PLAYER_DIFFICULTY2.." ",3,"H "},
	{"Normal",PLAYER_DIFFICULTY1.." ",2,"N "},
	{"LFR",PLAYER_DIFFICULTY3.." ",1,"L "},
}

function OGetRaidProgression2(RaidName, OSTAT, NumRaidBosses)
	--collectgarbage()
	local i=0;
	local omatch=false; -- check if some word repeat
	local matchi=0; -- line that word repeat + 1
	wipe(orp);
	orp={};
	orp["unitname"], orp["unitid"] = OilvlTooltip:GetUnit();
	orp["oframe"] = OilvlTooltip:GetOwner();
	if orp["oframe"] == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	if rpunit == "" or rpunit == "target" or not UnitExists(rpunit) or not UnitExists(orp["unitid"]) or not CheckInteractDistance(rpunit, 1) or not CheckInteractDistance(orp["unitid"], 1) then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	if orp["oframe"]:GetName() ~= nil then
		if orp["oframe"]:GetName():gsub("%d","") ~= "OILVLRAIDFRAME" then
			OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
			--ClearAchievementComparisonUnit();
			rpsw=false;
			rpunit="";
			Omover2=0;
			LoadRPDTooltip:Hide();
			return -1;
		end
	end
	if orp["oframe"]:GetName() == nil and orp["oframe"] ~= otooltip6 then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	if orp["unitname"] == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	if orp["unitid"] == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	if UnitGUID(rpunit) ~= UnitGUID(orp["unitid"]) then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	local gcs1197 = GetComparisonStatistic(1197)
	if gcs1197 == nil or tonumber(gcs1197) == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	local nn = tonumber(orp["oframe"]:GetName():gsub("OILVLRAIDFRAME", "").."");
	orp["spec"] = ospec[MVPvsframedata.spec[nn]];
	orp["class"], _ =  UnitClass(orp["unitid"]);
	if not orp["spec"] or not orp["class"] then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		return -1;
	end
	orp["ilvl"] = string.format("%d", MVPvsframedata.ilvl[nn][1]);
	for i = 2, OilvlTooltip:NumLines() do
		local msg = _G["OilvlTooltipTextLeft"..i]:GetText();
		if msg then
			msg = msg:find(RaidName);
		end
		if msg then
			OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
			--ClearAchievementComparisonUnit();
			rpsw=false;
			rpunit="";
			Omover2=0;
			LoadRPDTooltip:Hide();
			return -1;
		end
	end
	if not omatch and not cfg.MVPvsrpdetails then
		OilvlTooltip:SetHeight(OilvlTooltip:GetHeight()+15);
		OilvlTooltip:AddLine(RaidName);
	end

	local twohighest=0;
	local progression="";
	twohighest=0;
	progression="";
	orp["raidname"]=RaidName;
	orp["progression"]="";
	orp["LFR"]={};
	orp["Normal"]={};
	orp["Heroic"]={};
	orp["Mythic"]={};
	local bigorp = {}

	local function Save_orp(RaidName, OSTAT, NumRaidBosses)
		--collectgarbage()
		local twohighest=0;
		local progression="";
		local orp = {}
		orp["raidname"]=RaidName;
		orp["progression"]="";
		orp["LFR"]={};
		orp["Normal"]={};
		orp["Heroic"]={};
		orp["Mythic"]={};
		local op=0;
		for d = 1, #difficulties do
			op=0
			for i = 1, NumRaidBosses do
				if GetComparisonStatistic(OSTAT[i][difficulties[d][3]]) ~= "--" then
					op = op + 1;
				end
				orp[difficulties[d][1]][i] = GetComparisonStatistic(OSTAT[i][difficulties[d][3]]);
			end
			if op > 0 and twohighest < 2 then
				progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..difficulties[d][2];
				orp["progression"]=orp["progression"]..op.."/"..NumRaidBosses..difficulties[d][4];
				twohighest = twohighest + 1
			end
		end
		if twohighest == 0 then
			progression=progression.."|cFF00FF00none";
			orp["progression"]="none";
		end
		local ORP = {OSTAT, NumRaidBosses, twohighest, progression, orp["raidname"], orp["progression"], orp["LFR"], orp["Normal"], orp["Heroic"], orp["Mythic"], progression}
		return ORP;
	end

	--bigorp[TNname] = Save_orp(TNname, OSTATTN, 10)
	bigorp[ULDname] = Save_orp(ULDname, OSTATULD, 11)
	--bigorp[TOVname] = Save_orp(TOVname, OSTATTOV, 3)
	--bigorp[TOSname] = Save_orp(TOSname, OSTATTOS, 9)
	--bigorp[ABTname] = Save_orp(ABTname, OSTATABT, 11)

	local function Save_orp_vars(raidname3)
		OSTAT, NumRaidBosses, twohighest, progression, orp["raidname"], orp["progression"], orp["LFR"], orp["Normal"], orp["Heroic"], orp["Mythic"] = bigorp[raidname3][1],bigorp[raidname3][2],bigorp[raidname3][3],bigorp[raidname3][4],bigorp[raidname3][5],bigorp[raidname3][6],bigorp[raidname3][7],bigorp[raidname3][8],bigorp[raidname3][9],bigorp[raidname3][10]
	end
	Save_orp_vars(RaidName)
	if not omatch and not cfg.MVPvsrpdetails then
		if progression ~= "" then
			OilvlTooltip:SetHeight(OilvlTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(progression);
		end
	else
		if not cfg.MVPvsrpdetails then
			_G["OilvlTooltipTextLeft"..matchi]:SetText(progression);
		end
	end

	-- check Achivements for 3 raids
	local RaidAchiv = {}
	RaidAchiv[ULDname] ={}
	--SaveAOTCCE(RaidAchiv[TNname],11195,11192)
	SaveAOTCCE(RaidAchiv[ULDname],12536,12535)
	--SaveAOTCCE(RaidAchiv[TOVname],11581,11580)
	--SaveAOTCCE(RaidAchiv[TOSname],11790,11874,11875)
	--SaveAOTCCE(RaidAchiv[ABTname],12110,12111)

	local oilvltooltiptexts = {}
	for i = 1, OilvlTooltip:NumLines() do
		if i > 1 and i < 5 then
			oilvltooltiptexts[i] = "|cffffffff".._G["OilvlTooltipTextLeft"..i]:GetText();
		else
			oilvltooltiptexts[i] = _G["OilvlTooltipTextLeft"..i]:GetText();
		end
	end
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	--ClearAchievementComparisonUnit();
	rpsw=false;
	rpunit="";
	Omover2=0;
	-- Show raid progression on tooltip:
	if cfg.MVPvsrpdetails then
		if LibQTip:IsAcquired("Oraidprog") or otooltip2 then
			otooltip2:Clear()
			otooltip2:Hide()
			LibQTip:Release(otooltip2)
			otooltip2 = nil
		end
			otooltip2 = LibQTip:Acquire("Oraidprog", 5, "LEFT", "CENTER", "CENTER", "CENTER", "CENTER")
			otooltip2:SetBackdropColor(0,0,0,1)
			otooltip2:SetHeaderFont(ssHeaderFont)
			otooltip2:SetFont(ssRegFont)
			otooltip2:ClearAllPoints()
			otooltip2:SetClampedToScreen(false)
			--[[if GetScreenWidth() - OilvlTooltip:GetRight() < 500 then
				-- show on left
				otooltip2:SetPoint("TOPRIGHT", OilvlTooltip, "TOPLEFT")
				otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner());
			else
				-- show on right
				otooltip2:SetPoint("TOPLEFT", OilvlTooltip, "TOPRIGHT")
				otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner());
			end]]--
			if GetScreenWidth() - OilvlTooltip:GetRight() < 500 then
				otooltip2:SetPoint("TOPRIGHT", OilvlTooltip:GetOwner(),"BOTTOMLEFT")
			else
				otooltip2:SetPoint("TOPLEFT", OilvlTooltip:GetOwner(),"BOTTOMRIGHT")
			end
			otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner(), function()
				otooltip2:Clear()
				otooltip2:Hide()
				LibQTip:Release(otooltip2)
				otooltip2 = nil
				--ClearAchievementComparisonUnit();
				local oframe = GetMouseFocus();
				if oframe == nil then return -1 end
				if oframe:IsForbidden() then return -1 end
				if oframe:GetName() == nil then return -1 end
				if oframe:GetName():gsub("%d","").."" ~= "OILVLRAIDFRAME" then return -1; end
				OilvlRunMouseoverTooltips(oframe)
			end);
		OilvlTooltip:Hide();
		LoadRPDTooltip:Hide();
	local function DrawOTooltip2()
		--collectgarbage()
		for i = 1, #oilvltooltiptexts do otooltip2:AddLine(oilvltooltiptexts[i]) end

		local line = otooltip2:AddLine("")
		otooltip2:SetCell(1,4,"|cffffffff"..ULDname,"LEFT",2)
		otooltip2:SetCellScript(1,4,"OnMouseUp",function(s)
			Save_orp_vars(ULDname)
			otooltip2:Clear()
			DrawOTooltip2()
		end)
		-- otooltip2:SetCell(2,4,"|cffffffff"..TNname,"LEFT",2)
		-- otooltip2:SetCellScript(2,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(TNname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)
		-- otooltip2:SetCell(3,4,"|cffffffff"..ULDname,"LEFT",2)
		-- otooltip2:SetCellScript(3,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(ULDname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)
		-- otooltip2:SetCell(4,4,"|cffffffff"..TOVname,"LEFT",2)
		-- otooltip2:SetCellScript(4,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(TOVname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)
		-- otooltip2:SetCell(5,4,"|cffffffff"..TOSname,"LEFT",2)
		-- otooltip2:SetCellScript(5,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(TOSname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)

		line = otooltip2:AddLine()
		otooltip2:SetCell(line, 1, "|cffffffff" ..orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"].. "|r", "LEFT", 5)
		otooltip2:SetLineScript(1, "OnMouseUp", function()
			oilvl_link(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"])
		end)
		otooltip2:SetLineScript(line, "OnMouseUp", function()
			oilvl_link(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"])
		end)
		otooltip2:AddSeparator();
		line = otooltip2:AddHeader()
		line = otooltip2:SetCell(line, 1, NAME)
		line = otooltip2:SetCell(line, 2, PLAYER_DIFFICULTY6)--随机团队
		
		otooltip2:SetCellScript(line, 2, "OnMouseUp", function()
			local xprog = 0

			for m = 1, NumRaidBosses do	if orp["LFR"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY3.." "..xprog.."/"..NumRaidBosses.."次)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";

				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].." X "; end

				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)
		line = otooltip2:SetCell(line, 3, "--")--普通
		otooltip2:SetCellScript(line, 3, "OnMouseUp", function()
			local xprog = 0
			for m = 1, NumRaidBosses do	if orp["Normal"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY1.." "..xprog.."/"..NumRaidBosses.."N)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].." X "; end
				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)
		line = otooltip2:SetCell(line, 4, "--")
		otooltip2:SetCellScript(line, 4, "OnMouseUp", function()--英雄
			local xprog = 0
			for m = 1, NumRaidBosses do	if orp["Heroic"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY2.." "..xprog.."/"..NumRaidBosses.."H)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].." X "; end
				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)
		line = otooltip2:SetCell(line, 5, "--")--史诗

		otooltip2:SetCellScript(line, 5, "OnMouseUp", function()
			local xprog = 0
			for m = 1, NumRaidBosses do	if orp["Mythic"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY6.." "..xprog.."/"..NumRaidBosses.."M)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].." X "; end
				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)


		otooltip2:AddSeparator()

		for m = 1, NumRaidBosses do
			line = otooltip2:AddLine()
			line = otooltip2:SetCell(line, 1, OSTAT[m][5])
			line = otooltip2:SetCell(line, 2, orp["LFR"][m])
			
			line = otooltip2:SetCell(line, 3, orp["Normal"][m])
			line = otooltip2:SetCell(line, 4, orp["Heroic"][m])
			line = otooltip2:SetCell(line, 5, orp["Mythic"][m])--史诗那排
			
		end
		otooltip2:AddSeparator()
		line = otooltip2:AddLine()
		line = otooltip2:SetCell(line, 1, "|cffffffff"..SEND_LABEL)
		line = otooltip2:SetCell(line, 2, "|cffffffff"..CHAT_MSG_GUILD)
		line = otooltip2:SetCell(line, 3, "|cffffffff"..CHAT_MSG_RAID)
		line = otooltip2:SetCell(line, 4, "|cffffffff"..GUILD_RANK1_DESC)
		line = otooltip2:SetCell(line, 5, "|cffffffff"..STATUS_TEXT_TARGET)--史诗发送那排
		
		otooltip2:SetCellScript(line, 2, "OnMouseUp", function()

			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "GUILD");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "GUILD"); end
			end
		end)
		otooltip2:SetCellScript(line, 3, "OnMouseUp", function()
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "RAID"); end
			end
		end)
		otooltip2:SetCellScript(line, 4, "OnMouseUp", function()
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "OFFICER");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "OFFICER"); end
			end
		end)
		otooltip2:SetCellScript(line, 5, "OnMouseUp", function()
			if not UnitExists("target") then return -1;	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"], "WHISPER", nil, UnitName("target"));
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].."L".." "; end
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].."N".." "; end
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].."H".." "; end
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].."M".." "; end
				if orpd ~= "" then SendChatMessage(OSTAT[m][5]..":"..orpd, "WHISPER", nil, UnitName("target")); end
			end
		end)
		otooltip2:AddSeparator()
		if RaidAchiv[orp["raidname"]] then
			for i = 1, #RaidAchiv[orp["raidname"]],6 do
				if RaidAchiv[orp["raidname"]][i] and RaidAchiv[orp["raidname"]][i+1] and  RaidAchiv[orp["raidname"]][i+2] and  RaidAchiv[orp["raidname"]][i+3] and RaidAchiv[orp["raidname"]][i+4] and  RaidAchiv[orp["raidname"]][i+5] then
					line = otooltip2:AddLine()
					line = otooltip2:SetCell(line, 1, "|cFFFF8000"..RaidAchiv[orp["raidname"]][i+4].." - |cFFFFFFFF"..RaidAchiv[orp["raidname"]][i+1].."/"..RaidAchiv[orp["raidname"]][i+2].."/"..RaidAchiv[orp["raidname"]][i+3])
					otooltip2:SetLineScript(line, "OnMouseUp", function()
						oilvl_link(RaidAchiv[orp["raidname"]][i+5])
					end)
					otooltip2:AddSeparator()
				end
			end
		end
		otooltip2:Show();--主窗口指向提示
	end
	DrawOTooltip2()
	end
end

-- OiLvL Item Level and Gear List
function OGetRaidProgression3(RaidName, OSTAT, NumRaidBosses)
	--collectgarbage()
	local self = otooltip6rpd;
	local i=0;
	local omatch=false; -- check if some word repeat
	local twohighest=0;
	local progression="";
	local matchi=0; -- line that word repeat + 1
	wipe(orp);
	orp={};
	orp["LFR"]={};
	orp["Normal"]={};
	orp["Heroic"]={};
	orp["Mythic"]={};
	orp["unitname"], orp["unitid"] = OilvlTooltip:GetUnit();
	orp["oframe"] = OilvlTooltip:GetOwner();
	if orp["oframe"] == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		local oframe = GetMouseFocus();
		if oframe == nil then return -1 end
		if oframe:IsForbidden() then return -1 end
		if oframe ~= otooltip6rpd then return -1 end
		if CheckInteractDistance(otooltip6rpdunit, 1) and UnitExists(otooltip6rpdunit) and cfg.MVPvsms then
			Omover2=2;
			ClearAchievementComparisonUnit();
			OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
			rpsw=true;
			rpunit=otooltip6rpdunit;
			SetAchievementComparisonUnit(rpunit);
			if cfg.MVPvsrpdetails then
				LoadRPDTooltip:SetOwner(OilvlTooltip, "ANCHOR_BOTTOM",0,-20);
				LoadRPDTooltip:AddLine(L["Raid Progression Details"]..": |cFFFFFFFF"..LFG_LIST_LOADING);
				LoadRPDTooltip:SetBackdropColor(1, 0, 0,1)
				LoadRPDTooltip:Show();
			end
		end
		return -1;
	end
	if rpunit == "" or rpunit == "target" or not UnitExists(rpunit) or not UnitExists(orp["unitid"]) or not CheckInteractDistance(rpunit, 1) or not CheckInteractDistance(orp["unitid"], 1) then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		otooltip6rpd=nil;
		otooltip6rpdunit=nil;
		otooltip6rpdid=nil;
		return -1;
	end
	if orp["oframe"] ~= otooltip6rpd then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		otooltip6rpd=nil;
		otooltip6rpdunit=nil;
		otooltip6rpdid=nil;
		return -1;
	end
	if orp["unitname"] == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		otooltip6rpd=nil;
		otooltip6rpdunit=nil;
		otooltip6rpdid=nil;
		return -1;
	end
	if orp["unitid"] == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		otooltip6rpd=nil;
		otooltip6rpdunit=nil;
		otooltip6rpdid=nil;
		return -1;
	end
	if UnitGUID(rpunit) ~= UnitGUID(orp["unitid"]) then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		otooltip6rpd=nil;
		otooltip6rpdunit=nil;
		otooltip6rpdid=nil;
		return -1;
	end
	local gcs1197 = GetComparisonStatistic(1197)
	if gcs1197 == nil or tonumber(gcs1197) == nil then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		otooltip6rpd=nil;
		otooltip6rpdunit=nil;
		otooltip6rpdid=nil;
		return -1;
	end
	local nn = oicomp[GetMouseFocus()._line-4].id
	orp["spec"] = ospec[MVPvsframedata.spec[nn]];
	orp["class"], _ =  UnitClass(orp["unitid"]);
	if not orp["spec"] or not orp["class"] then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		rpsw=false;
		rpunit="";
		Omover2=0;
		LoadRPDTooltip:Hide();
		otooltip6rpd=nil;
		otooltip6rpdunit=nil;
		otooltip6rpdid=nil;
		--ClearAchievementComparisonUnit();
		return -1;
	end
	orp["ilvl"] = string.format("%d", MVPvsframedata.ilvl[nn][1]);
	orp["raidname"]=RaidName;
	orp["progression"]="";
	for i = 2, OilvlTooltip:NumLines() do
		local msg = _G["OilvlTooltipTextLeft"..i]:GetText();
		if msg then
			msg = msg:find(RaidName);
		end
		if msg then
			omatch=true;
			matchi=i+1;
			break;
		end
	end
	if not omatch and not cfg.MVPvsrpdetails then
		OilvlTooltip:SetHeight(OilvlTooltip:GetHeight()+15);
		OilvlTooltip:AddLine(RaidName);
	end

	local bigorp = {}
	local function Save_orp(RaidName, OSTAT, NumRaidBosses)
		--collectgarbage()
		local twohighest=0;
		local progression="";
		local orp = {}
		orp["raidname"]=RaidName;
		orp["progression"]="";
		orp["LFR"]={};
		orp["Normal"]={};
		orp["Heroic"]={};
		orp["Mythic"]={};
		local op=0;
		for d = 1, #difficulties do
			op=0
			for i = 1, NumRaidBosses do
				if GetComparisonStatistic(OSTAT[i][difficulties[d][3]]) ~= "--" then
					op = op + 1;
				end
				orp[difficulties[d][1]][i] = GetComparisonStatistic(OSTAT[i][difficulties[d][3]]);
			end
			if op > 0 and twohighest < 2 then
				progression=progression.."|cFF00FF00"..op.."/"..NumRaidBosses.." |r|cFFFFFFFF"..difficulties[d][2];
				orp["progression"]=orp["progression"]..op.."/"..NumRaidBosses..difficulties[d][4];
				twohighest = twohighest + 1
			end
		end
		if twohighest == 0 then
			progression=progression.."|cFF00FF00none";
			orp["progression"]="none";
		end
		local ORP = {OSTAT, NumRaidBosses, twohighest, progression, orp["raidname"], orp["progression"], orp["LFR"], orp["Normal"], orp["Heroic"], orp["Mythic"];}
		return ORP;
	end
	--bigorp[TNname] = Save_orp(TNname, OSTATTN, 10)
	bigorp[ULDname] = Save_orp(ULDname, OSTATULD, 11)
	--bigorp[TOVname] = Save_orp(TOVname, OSTATTOV, 3)
	--bigorp[TOSname] = Save_orp(TOSname, OSTATTOS, 9)
	--bigorp[ABTname] = Save_orp(ABTname, OSTATABT, 11)

	local function Save_orp_vars(raidname3)
		OSTAT, NumRaidBosses, twohighest, progression, orp["raidname"], orp["progression"], orp["LFR"], orp["Normal"], orp["Heroic"], orp["Mythic"] = bigorp[raidname3][1],bigorp[raidname3][2],bigorp[raidname3][3],bigorp[raidname3][4],bigorp[raidname3][5],bigorp[raidname3][6],bigorp[raidname3][7],bigorp[raidname3][8],bigorp[raidname3][9],bigorp[raidname3][10]
	end
	Save_orp_vars(RaidName)
	if not omatch and not cfg.MVPvsrpdetails then
		if progression ~= "" then
			OilvlTooltip:SetHeight(OilvlTooltip:GetHeight()+15);
			OilvlTooltip:AddLine(progression);
		end
	else
		if not cfg.MVPvsrpdetails then
			_G["OilvlTooltipTextLeft"..matchi]:SetText(progression);
		end
	end

	local RaidAchiv = {}
	RaidAchiv[ULDname] ={}
	--SaveAOTCCE(RaidAchiv[TNname],11195,11192)
	SaveAOTCCE(RaidAchiv[ULDname],12536,12535)
	--SaveAOTCCE(RaidAchiv[TOVname],11581,11580)
	--SaveAOTCCE(RaidAchiv[TOSname],11790,11874,11875)
	--SaveAOTCCE(RaidAchiv[ABTname],12110,12111)

	local oilvltooltiptexts = {}
	for i = 1, OilvlTooltip:NumLines() do
		if i > 1 and i < 5 then
			oilvltooltiptexts[i] = "|cffffffff".._G["OilvlTooltipTextLeft"..i]:GetText();
		else
			oilvltooltiptexts[i] = _G["OilvlTooltipTextLeft"..i]:GetText();
		end
	end

	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	--ClearAchievementComparisonUnit();
	rpsw=false;
	rpunit="";
	Omover2=0;
	-- Show raid progression on tooltip:
	if cfg.MVPvsrpdetails and otooltip6 then otooltip6:SetAutoHideDelay() end
	if cfg.MVPvsrpdetails then
		if LibQTip:IsAcquired("Oraidprog") or otooltip2 then
			otooltip2:Clear()
			otooltip2:Hide()
			LibQTip:Release(otooltip2)
			otooltip2 = nil
		end
			otooltip2 = LibQTip:Acquire("Oraidprog", 5, "LEFT", "CENTER", "CENTER", "CENTER", "CENTER")
			otooltip2:SetBackdropColor(0,0,0,1)
			otooltip2:SetHeaderFont(ssHeaderFont)
			otooltip2:SetFont(ssRegFont)
			otooltip2:ClearAllPoints()
			otooltip2:SetClampedToScreen(false)
			--[[if GetScreenWidth() - OilvlTooltip:GetRight() < 500 then
				-- show on left
				otooltip2:SetPoint("TOPRIGHT", OilvlTooltip, "TOPLEFT")
				otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner());
			else
				-- show on right
				otooltip2:SetPoint("TOPLEFT", OilvlTooltip, "TOPRIGHT")
				otooltip2:SetAutoHideDelay(0.25, OilvlTooltip:GetOwner());
			end]]--
			local _, obottom, _, _ = otooltip6rpd:GetRect()
			otooltip2:SmartAnchorTo(self)
			otooltip2:SetAutoHideDelay(0.25, self, function()
				-- reset otooltip6 SetAutoHideDelay
				if not otooltip6sw and otooltip6 then
					otooltip6:SetAutoHideDelay(0.25,self,function()
						--ClearAchievementComparisonUnit();
						if GetMouseFocus() ~= otooltip6 then
							otooltip6:Hide()
							if otooltip6 ~= nil then
								LibQTip:Release(otooltip6)
								otooltip6 = nil
							end
						end
					end)
				end

				otooltip2:Clear()
				otooltip2:Hide()
				LibQTip:Release(otooltip2)
				otooltip2 = nil
				local oframe = GetMouseFocus();
				if oframe == nil then otooltip6rpd=nil; otooltip6rpdunit=nil; otooltip6rpdid=nil; return -1 end
				if oframe ~= otooltip6rpd then otooltip6rpd=nil; otooltip6rpdunit=nil; otooltip6rpdid=nil; return -1 end
				if not rpsw and CheckInteractDistance(otooltip6rpdunit, 1) and UnitExists(otooltip6rpdunit) and cfg.MVPvsms then
					Omover2=2;
					ClearAchievementComparisonUnit();
					OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
					rpsw=true;
					rpunit=otooltip6rpdunit;
					SetAchievementComparisonUnit(rpunit);
					if cfg.MVPvsrpdetails then
						LoadRPDTooltip:SetOwner(OilvlTooltip, "ANCHOR_BOTTOM",0,-20);
						LoadRPDTooltip:AddLine(L["Raid Progression Details"]..": |cFFFFFFFF"..LFG_LIST_LOADING);
						LoadRPDTooltip:SetBackdropColor(1, 0, 0,1)
						LoadRPDTooltip:Show();
					end
				end
				otooltip6rpd=nil; otooltip6rpdunit=nil; otooltip6rpdid=nil;
			end);
			OilvlTooltip:Hide();
			LoadRPDTooltip:Hide();
	local function DrawOTooltip2()
		--collectgarbage()
		for i = 1, #oilvltooltiptexts do otooltip2:AddLine(oilvltooltiptexts[i]) end

		local line = otooltip2:AddLine("")
		otooltip2:SetCell(1,4,"|cffffffff"..ULDname,"LEFT",2)
		otooltip2:SetCellScript(1,4,"OnMouseUp",function(s)
			Save_orp_vars(ULDname)
			otooltip2:Clear()
			DrawOTooltip2()
		end)
		-- otooltip2:SetCell(2,4,"|cffffffff"..TNname,"LEFT",2)
		-- otooltip2:SetCellScript(2,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(TNname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)
		-- otooltip2:SetCell(3,4,"|cffffffff"..ULDname,"LEFT",2)
		-- otooltip2:SetCellScript(3,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(ULDname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)
		-- otooltip2:SetCell(4,4,"|cffffffff"..TOVname,"LEFT",2)
		-- otooltip2:SetCellScript(4,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(TOVname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)
		-- otooltip2:SetCell(5,4,"|cffffffff"..TOSname,"LEFT",2)
		-- otooltip2:SetCellScript(5,4,"OnMouseUp",function(s)
		-- 	Save_orp_vars(TOSname)
		-- 	otooltip2:Clear()
		-- 	DrawOTooltip2()
		-- end)

		line = otooltip2:AddLine()
		otooltip2:SetCell(line, 1, "|cffffffff" ..orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"].. "|r", "LEFT", 5)
		otooltip2:SetLineScript(1, "OnMouseUp", function()
			oilvl_link(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"])
		end)
		otooltip2:SetLineScript(line, "OnMouseUp", function()
			oilvl_link(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["progression"].." "..orp["raidname"])
		end)

		otooltip2:AddSeparator();
		line = otooltip2:AddHeader()
		line = otooltip2:SetCell(line, 1, NAME)
		line = otooltip2:SetCell(line, 2, PLAYER_DIFFICULTY6)
		otooltip2:SetCellScript(line, 2, "OnMouseUp", function()
			local xprog = 0
			for m = 1, NumRaidBosses do	if orp["LFR"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY3.." "..xprog.."/"..NumRaidBosses.."L)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["LFR"][m] ~= "--" then orpd=orpd..orp["LFR"][m].." X "; end
				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)
		line = otooltip2:SetCell(line, 3, "--")
		otooltip2:SetCellScript(line, 3, "OnMouseUp", function()
			local xprog = 0
			for m = 1, NumRaidBosses do	if orp["Normal"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY1.." "..xprog.."/"..NumRaidBosses.."N)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["Normal"][m] ~= "--" then orpd=orpd..orp["Normal"][m].." X "; end
				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)
		line = otooltip2:SetCell(line, 4, "--")
		otooltip2:SetCellScript(line, 4, "OnMouseUp", function()
			local xprog = 0
			for m = 1, NumRaidBosses do	if orp["Heroic"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY2.." "..xprog.."/"..NumRaidBosses.."H)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["Heroic"][m] ~= "--" then orpd=orpd..orp["Heroic"][m].." X "; end
				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)
		line = otooltip2:SetCell(line, 5, "--")
		otooltip2:SetCellScript(line, 5, "OnMouseUp", function()
			local xprog = 0
			for m = 1, NumRaidBosses do	if orp["Mythic"][m] ~= "--" then xprog = xprog + 1 end	end
			SendChatMessage(orp["unitname"].."("..orp["ilvl"].." "..orp["spec"].." "..orp["class"]..") "..orp["raidname"].." ("..PLAYER_DIFFICULTY6.." "..xprog.."/"..NumRaidBosses.."M)", "RAID");
			for m = 1, NumRaidBosses do
				local orpd="";
				if orp["Mythic"][m] ~= "--" then orpd=orpd..orp["Mythic"][m].." X "; end
				if orpd ~= "" then SendChatMessage(orpd..OSTAT[m][5], "RAID"); end
			end
		end)
		otooltip2:AddSeparator()
		for m = 1, NumRaidBosses do
			line = otooltip2:AddLine()
			line = otooltip2:SetCell(line, 1, OSTAT[m][5])
			line = otooltip2:SetCell(line, 2, orp["LFR"][m])
			line = otooltip2:SetCell(line, 3, orp["Normal"][m])
			line = otooltip2:SetCell(line, 4, orp["Heroic"][m])
			line = otooltip2:SetCell(line, 5, orp["Mythic"][m])

		end
		otooltip2:AddSeparator()
		if RaidAchiv[orp["raidname"]] then
			for i = 1, #RaidAchiv[orp["raidname"]],6 do
				if RaidAchiv[orp["raidname"]][i] and RaidAchiv[orp["raidname"]][i+1] and  RaidAchiv[orp["raidname"]][i+2] and  RaidAchiv[orp["raidname"]][i+3] and RaidAchiv[orp["raidname"]][i+4] and  RaidAchiv[orp["raidname"]][i+5] then
					line = otooltip2:AddLine()
					line = otooltip2:SetCell(line, 1, "|cFFFF8000"..RaidAchiv[orp["raidname"]][i+4].." - |cFFFFFFFF"..RaidAchiv[orp["raidname"]][i+1].."/"..RaidAchiv[orp["raidname"]][i+2].."/"..RaidAchiv[orp["raidname"]][i+3])
					otooltip2:AddSeparator()
					otooltip2:SetLineScript(line, "OnMouseUp", function()
						oilvl_link(RaidAchiv[orp["raidname"]][i+5])
					end)
				end
			end
		end
		otooltip2:Show();
	end
	DrawOTooltip2()
	end
end

function otooltip4func()
	if otooltip4 ~= nil then
		if LibQTip:IsAcquired("OiLvLRoll") then otooltip4:Clear() end
		otooltip4:Hide()
		LibQTip:Release(otooltip4)
		otooltip4 = nil
	end
	otooltip4 = LibQTip:Acquire("OiLvLRoll", 5, "LEFT", "CENTER", "LEFT", "LEFT", "RIGHT")
	otooltip4:SetBackdropColor(0,0,0,1)
	otooltip4:SetHeaderFont(ssHeaderFont)
	otooltip4:SetFont(ssRegFont)
	otooltip4:ClearAllPoints()
	otooltip4:SetClampedToScreen(false)
	otooltip4:SetPoint("CENTER",UIParent,0,200)
	local line = otooltip4:AddLine("");
	otooltip4:SetCell(line, 1, oroll[1][1].." "..oroll[1][2].." "..ROLL.." "..oroll[1][3],"LEFT",4)
	otooltip4:SetCellScript(line, 1, "OnEnter", function()
		OilvlRollTooltip:SetOwner(otooltip4, "ANCHOR_NONE");
		OilvlRollTooltip:SetPoint("TOPLEFT",otooltip4,"TOPRIGHT",0,0)
		OilvlRollTooltip:ClearLines()
		OilvlRollTooltip:SetHyperlink(oroll[1][2])
	end)
	otooltip4:SetCellScript(line, 1, "OnLeave", function() OilvlRollTooltip:Hide() end)
	otooltip4:SetCellScript(line, 1, "OnMouseUp", function()
		if IsShiftKeyDown() then
			local chatWindow = ChatEdit_GetActiveWindow()
			if chatWindow then
				chatWindow:Insert(oroll[1][2])
			end
		end
		if IsControlKeyDown() then
			DressUpItemLink(oroll[1][2])
		end
	end)
	otooltip4:AddSeparator();
	line = otooltip4:AddHeader()
	otooltip4:SetCell(line, 1, "|cffffffff"..NAME)
	otooltip4:SetCell(line, 2, "|cffffffff"..ROLL)
	otooltip4:SetCell(line, 3, "|cffffffff"..ENCOUNTER_JOURNAL_ITEM.." 1")
	otooltip4:SetCell(line, 4, "|cffffffff"..ENCOUNTER_JOURNAL_ITEM.." 2")
	otooltip4:AddSeparator()
	local temporoll = {}
	for m = 2, orolln do
		temporoll[m-1] = {
			name = oroll[m][1],
			roll = oroll[m][2],
			ilvl1 = oroll[m][3],
			item1 = oroll[m][4],
			ilvl2 = oroll[m][5],
			item2 = oroll[m][6]
		}
	end
	-- sort roll
	sort(temporoll, function(a,b) return a.roll > b.roll end);
	for m = 1,  orolln - 1 do
		line = otooltip4:AddLine()
		otooltip4:SetCell(line, 1, temporoll[m].name)
		otooltip4:SetCell(line, 2, temporoll[m].roll)
		otooltip4:SetCell(line, 3, temporoll[m].ilvl1.." "..temporoll[m].item1)
		otooltip4:SetCellScript(line, 3, "OnEnter", function()
			if temporoll[m].item1 and temporoll[m].item1 ~= "" then
				OilvlRollTooltip:SetOwner(otooltip4, "ANCHOR_NONE");
				OilvlRollTooltip:SetPoint("TOPLEFT",otooltip4,"TOPRIGHT",0,0)
				OilvlRollTooltip:ClearLines()
				OilvlRollTooltip:SetHyperlink(temporoll[m].item1)
			end
		end)
		otooltip4:SetCellScript(line, 3, "OnLeave", function() OilvlRollTooltip:Hide() end)
		otooltip4:SetCellScript(line, 3, "OnMouseUp", function()
			if IsShiftKeyDown() and temporoll[m].item1 and temporoll[m].item1 ~= "" then
				local chatWindow = ChatEdit_GetActiveWindow()
				if chatWindow then
					chatWindow:Insert(temporoll[m].item1)
				end
			end
			if IsControlKeyDown() and temporoll[m].item1 and temporoll[m].item1 ~= "" then
				DressUpItemLink(temporoll[m].item1)
			end
		end)
		otooltip4:SetCell(line, 4, temporoll[m].ilvl2.." "..temporoll[m].item2)
		otooltip4:SetCellScript(line, 4, "OnEnter", function()
			if temporoll[m].item2 and temporoll[m].item2 ~= "" then
				OilvlRollTooltip:SetOwner(otooltip4, "ANCHOR_NONE");
				OilvlRollTooltip:SetPoint("TOPLEFT",otooltip4,"TOPRIGHT",0,0)
				OilvlRollTooltip:ClearLines()
				OilvlRollTooltip:SetHyperlink(temporoll[m].item2)
			end
		end)
		otooltip4:SetCellScript(line, 4, "OnLeave", function() OilvlRollTooltip:Hide() end)
		otooltip4:SetCellScript(line, 4, "OnMouseUp", function()
			if IsShiftKeyDown() and temporoll[m].item2 and temporoll[m].item2 ~= "" then
				local chatWindow = ChatEdit_GetActiveWindow()
				if chatWindow then
					chatWindow:Insert(temporoll[m].item2)
				end
			end
			if IsControlKeyDown() and temporoll[m].item2 and temporoll[m].item2 ~= "" then
				DressUpItemLink(temporoll[m].item2)
			end
		end)
	end
	otooltip4:AddSeparator()
	line = otooltip4:AddLine()
	otooltip4:SetCell(line, 5, "|cffffffff"..HIDE)
	otooltip4:SetCellScript(line, 5, "OnMouseUp", function()
		otooltip4:Hide()
		if otooltip4 ~= nil then
			LibQTip:Release(otooltip4)
			otooltip4 = nil
		end
		orolln = 0;
		oroll = {};
		orollgear = "";
	end)
	otooltip4:AddSeparator();
	otooltip4:UpdateScrolling();
	otooltip4:Show();
end

function otooltip5func()
	if otooltip5 ~= nil then
		if LibQTip:IsAcquired("OiLvLAlt") then otooltip5:Clear() end
		otooltip5:Hide()
		LibQTip:Release(otooltip5)
		otooltip5 = nil
	end
	otooltip5 = LibQTip:Acquire("OiLvLAlt", 2, "LEFT", "CENTER")
	otooltip5:SetBackdropColor(0,0,0,1)
	otooltip5:SetHeaderFont(ssHeaderFont)
	otooltip5:SetFont(ssRegFont)
	otooltip5:ClearAllPoints()
	otooltip5:SetClampedToScreen(false)
	otooltip5:SetPoint("CENTER")
	otooltip5:AddSeparator();
	local line = otooltip5:AddHeader()
	otooltip5:SetCell(line, 1, "|cffffffff"..NAME)
	otooltip5:SetCell(line, 2, "|cffffffff"..L["Item Level"])
	otooltip5:AddSeparator()
	for m = 1,  #cfg.MVPvsgears do
		line = otooltip5:AddLine()
		otooltip5:SetCell(line, 1, cfg.MVPvsgears[m][1].."-"..cfg.MVPvsgears[m][2])
		otooltip5:SetCellScript(line, 1, "OnMouseUp", function(self)
			if GetMouseButtonClicked() == "LeftButton" then
				local nn = self._line - 3;
				if cfg.MVPvsgears[nn] and  cfg.MVPvsgears[nn][1] and cfg.MVPvsgears[nn][2] then
					OIlvlInspectFrame:Clear();
					for crg = 17,1,-1 do
						if cfg.MVPvsgears[nn][4][crg] ~= nil then
							OIlvlInspectFrame:AddMessage(cfg.MVPvsgears[nn][4][crg][1].." "..cfg.MVPvsgears[nn][4][crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvsgears[nn][4][crg][3]*cfg.MVPvsgears[nn][4][crg][5],1,cfg.MVPvsgears[nn][4][crg][4]*cfg.MVPvsgears[nn][4][crg][6]);
						end
					end
					OIlvlInspectFrame:AddMessage(cfg.MVPvsgears[m][3].." "..cfg.MVPvsgears[m][1].."-"..cfg.MVPvsgears[m][2].."\n")
					OIlvlInspect:Show();
				end
			end
			if GetMouseButtonClicked() == "RightButton" then
				local nn = self._line - 3;
				if cfg.MVPvsgears[nn] and  cfg.MVPvsgears[nn][1] and cfg.MVPvsgears[nn][2] then
					OIlvlInspect2Frame:Clear();
					for crg = 17,1,-1 do
						if cfg.MVPvsgears[nn][4][crg] ~= nil then
							OIlvlInspect2Frame:AddMessage(cfg.MVPvsgears[nn][4][crg][1].." "..cfg.MVPvsgears[nn][4][crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvsgears[nn][4][crg][3]*cfg.MVPvsgears[nn][4][crg][5],1,cfg.MVPvsgears[nn][4][crg][4]*cfg.MVPvsgears[nn][4][crg][6]);
						end
					end
					OIlvlInspect2Frame:AddMessage(cfg.MVPvsgears[m][3].." "..cfg.MVPvsgears[m][1].."-"..cfg.MVPvsgears[m][2].."\n")
					OIlvlInspect2:Show();
				end
			end
		end)
		otooltip5:SetCell(line, 2, cfg.MVPvsgears[m][3])
	end
	otooltip5:AddSeparator()
	line = otooltip5:AddLine()
	otooltip5:SetCell(line, 2, "|cffffffff"..HIDE)
	otooltip5:SetCellScript(line, 2, "OnMouseUp", function()
		otooltip5:Hide()
		if otooltip5 ~= nil then
			LibQTip:Release(otooltip5)
			otooltip5 = nil
		end
	end)
	otooltip5:AddSeparator();
	otooltip5:UpdateScrolling();
	otooltip5:Show();
end

local tiergears = {HELM,SHOULDER,CHEST,HANDS,LEGS,BACK}
local tierslots = {INVTYPE_HEAD,INVTYPE_SHOULDER,INVTYPE_CHEST,INVTYPE_HAND,INVTYPE_LEGS,INVTYPE_CLOAK}
-- The Nighthold Set = 138309 to 138380
-- Tomb of Sargeras Set = 147121 to 147192
-- Antorus Set = 152112 to 152183
local function checktierID(id) if id >= 152112 and id <= 152183 then return true else return false end end

local function checkNtier(slot)
	if slot then if 	(slot[1] == 930
					or	slot[1] == 935
					or	slot[1] == 940)
	and checktierID(slot[8]) then return true else return false end end
end
local function checkHtier(slot)
	if slot then if 	(slot[1] == 945
					or	slot[1] == 950
					or	slot[1] == 955)
	and checktierID(slot[8]) then return true else return false end end
end
local function checkMtier(slot)
	if slot then if 	(slot[1] == 960
					or	slot[1] == 965
					or	slot[1] == 970)
	and checktierID(slot[8]) then return true else return false end end
end

local function otooltip6sort(method)
	otooltip6sortMethod = method;
	if method == "NAME" then
			sort(oicomp, function(a,b) return a.name < b.name end);
	elseif method == "NAME2" then
			sort(oicomp, function(a,b) return a.name > b.name end);
	elseif method == "ROLE" then
			sort(oicomp, function(a,b) return a.role < b.role end);
	elseif method == "ROLE2" then
			sort(oicomp, function(a,b) return a.role > b.role end);
	elseif method == "ILVL" then
			sort(oicomp, function(a,b)
				if not tonumber(a.ilvl) and not tonumber(b.ilvl) then
					return a.id < b.id
				elseif not tonumber(a.ilvl) and tonumber(b.ilvl) then
					return true
				elseif tonumber(a.ilvl) and not tonumber(b.ilvl) then
					return false
				else
					return a.ilvl < b.ilvl
				end
			end);
	elseif method == "ILVL2" then
			sort(oicomp, function(a,b)
				if not tonumber(a.ilvl) and not tonumber(b.ilvl) then
					return a.id > b.id
				elseif not tonumber(a.ilvl) and tonumber(b.ilvl) then
					return false
				elseif tonumber(a.ilvl) and not tonumber(b.ilvl) then
					return true
				else
					return a.ilvl > b.ilvl
				end
			end);
	elseif method == "ID" then
			sort(oicomp, function(a,b) return a.id < b.id end);
	else
			sort(oicomp, function(a,b) return a.id > b.id end);
	end
end

oilvltestvar = {};
function otooltip6func()
	local self = LDB_ANCHOR;
	otooltip6rpd=nil; otooltip6rpdunit=nil; otooltip6rpdid=nil;
	if otooltip6 ~= nil then
		if LibQTip:IsAcquired("OiLvLDB") then otooltip6:Clear() end
		otooltip6:Hide()
		LibQTip:Release(otooltip6)
		otooltip6 = nil
	end
	--collectgarbage()
	if LibQTip:IsAcquired("Oraidprog") or otooltip2 then
		otooltip2:Clear()
		otooltip2:Hide()
		LibQTip:Release(otooltip2)
		otooltip2 = nil
	end
	-- otooltip6gearsw=false;
	if otooltip6gearsw or otooltip6gearsw2 then
		otooltip6 = LibQTip:Acquire("OiLvLDB", 21, "LEFT", "LEFT", "CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER","CENTER")
	else
		otooltip6 = LibQTip:Acquire("OiLvLDB", 5, "LEFT", "LEFT", "CENTER","CENTER","CENTER")
	end
	otooltip6:SetBackdropColor(0,0,0,1)
	otooltip6:SetHeaderFont(ssHeaderFont)
	otooltip6:SetFont(ssRegFont)
	otooltip6:SmartAnchorTo(self)
	if not otooltip6sw then
		otooltip6:SetAutoHideDelay(0.25,self,function()
			if GetMouseFocus() ~= otooltip6 then
				otooltip6:Hide()
				if otooltip6 ~= nil then
					LibQTip:Release(otooltip6)
					otooltip6 = nil
				end
			end
		end)
	end
	local line;
	line = otooltip6:AddLine()
	if otooltip6sw then
		otooltip6:SetCell(line, 1, OPin[1])
		otooltip6:SetCellScript(line,1, "OnMouseUp", function()	otooltip6sw = false	otooltip6func() end)
	else
		otooltip6:SetCell(line, 1, OPin[2])
		otooltip6:SetCellScript(line,1, "OnMouseUp", function()	otooltip6sw = true otooltip6func() end)
	end
	if otooltip6gearsw or otooltip6gearsw2 then
		otooltip6:SetCell(line, 2, "M V P ","CENTER",19)
		otooltip6:SetCell(line, 21, "|cffffffff"..HIDE.." "..ITEMS)
		otooltip6:SetCellScript(line,2, "OnMouseUp", function()
			otooltip6gearsw=false
			otooltip6gearsw2=false
			for gsw = 1, 40 do	MVPvsframedata.ilvl[gsw][2] = false	end
			otooltip6func()
		end)
		otooltip6:SetCellScript(line,21, "OnMouseUp", function()
			otooltip6gearsw=false
			otooltip6gearsw2=false
			for gsw = 1, 40 do	MVPvsframedata.ilvl[gsw][2] = false	end
			otooltip6func()
		end)
	else
		otooltip6:SetCell(line, 2, "M V P ","CENTER",3)
		otooltip6:SetCell(line, 5, "|cffffffff"..SHOW.." "..ITEMS)
		otooltip6:SetCellScript(line,2, "OnMouseUp", function()
			otooltip6gearsw=true
			otooltip6gearsw2=true
			for gsw = 1, 40 do	MVPvsframedata.ilvl[gsw][2] = true	end
			otooltip6func()
		end)
		otooltip6:SetCellScript(line,5, "OnMouseUp", function()
			otooltip6gearsw=true
			otooltip6gearsw2=true
			for gsw = 1, 40 do	MVPvsframedata.ilvl[gsw][2] = true	end
			otooltip6func()
		end)
	end
	otooltip6:AddSeparator();
	line = otooltip6:AddHeader()
	otooltip6:SetCell(line, 1, "|cffffffffID")
	otooltip6:SetCellScript(line, 1, "OnMouseUp", function()
		if otooltip6sortMethod == "ID" then
			otooltip6sortMethod = "ID2"; otooltip6func();
		else
			otooltip6sortMethod = "ID"; otooltip6func();
		end
	end)
	otooltip6:SetCell(line, 2, "|cffffffff"..NAME)
	otooltip6:SetCellScript(line, 2, "OnMouseUp", function()
		if otooltip6sortMethod == "NAME" then
			otooltip6sortMethod = "NAME2"; otooltip6func();
		else
			otooltip6sortMethod = "NAME"; otooltip6func();
		end
	end)
	otooltip6:SetCell(line, 3, "|cffffffff"..ROLE)
	otooltip6:SetCellScript(line, 3, "OnMouseUp", function()
		if otooltip6sortMethod == "ROLE" then
			otooltip6sortMethod = "ROLE2"; otooltip6func();
		else
			otooltip6sortMethod = "ROLE"; otooltip6func();
		end
	end)
	otooltip6:SetCell(line, 4, "|cffffffff"..L["Item Level"])
	otooltip6:SetCellScript(line, 4, "OnMouseUp", function()
		if otooltip6sortMethod == "ILVL" then
			otooltip6sortMethod = "ILVL2"; otooltip6func();
		else
			otooltip6sortMethod = "ILVL"; otooltip6func();
		end
	end)
	otooltip6:SetCell(line,5,"|cffffffff"..SCENARIO_BONUS_LABEL)
	local ot6gear = {HELM,SHOULDER,CHEST,HANDS,LEGS,WRISTS,WAIST,FEET,NECK,BACK,RING1,RING2,TRINK1,TRINK2,WEP,OFFHAND}
	for ot = 6, 21 do
		if otooltip6gearsw or otooltip6gearsw2 then
			otooltip6:SetCell(line, ot, "|cffffffff"..oenchantItem[ot6gear[ot-5]][2])
		end
	end
	otooltip6:AddSeparator()
	wipe(oicomp)
	oicomp = nil
	oicomp = {};
	local compi = 0;
	for m = 1, 40 do
		if MVPvsframedata.name[m] ~= ""  and MVPvsframedata.name[m] and MVPvsframedata.guid[m] ~= "" and MVPvsframedata.guid[m] then
			compi = compi + 1
			local ooname =_G["OILVLRAIDFRAME"..m]:GetText():sub(1,10).. MVPvsframedata.name[m]:gsub("!",""):gsub("~",""):gsub(" ","");
			local function CheckGearAvail(n,slot,pp)
				if MVPvsframedata.gear[n][slot] then
					local eg = "|cFFFFFFFF"
					if MVPvsframedata.gear[n][slot][3] == 0 then eg = "|cFF00FFFF"  -- missing echant
					elseif MVPvsframedata.gear[n][slot][4] == 0 then eg = "|cFF00FFFF"  -- missing gem
					elseif MVPvsframedata.gear[n][slot][5] == 0 then eg = "|cFFFFFF00"  -- low level enchant
					elseif MVPvsframedata.gear[n][slot][6] == 0 then eg = "|cFFFFFF00" end -- low level gem
					if tonumber(MVPvsframedata.gear[n][slot][pp]) == 0 then
						return {MVPvsframedata.gear[n][slot][1],MVPvsframedata.gear[n][slot][2],eg,MVPvsframedata.gear[n][slot][9]}
					else
						return {MVPvsframedata.gear[n][slot][pp],MVPvsframedata.gear[n][slot][2],eg,MVPvsframedata.gear[n][slot][9]}
					end
				else
					return {"","",""}
				end
			end
			if pvpsw then
				oicomp[compi] = {id = m, name = ooname, role = MVPvsframedata.role[m], ilvl = MVPvsframedata.ilvl[m][1], sw = MVPvsframedata.ilvl[m][2], nset = oilvlCheckTierBonusSet(m)}
				for ot = 1, #ot6gear do oicomp[compi][ot6gear[ot]] = CheckGearAvail(m,ot6gear[ot],7) end
			else
				oicomp[compi] = {id = m, name = ooname, role = MVPvsframedata.role[m], ilvl = MVPvsframedata.ilvl[m][1], sw = MVPvsframedata.ilvl[m][2], nset = oilvlCheckTierBonusSet(m)}
				for ot = 1, #ot6gear do oicomp[compi][ot6gear[ot]] = CheckGearAvail(m,ot6gear[ot],1) end
			end
		end
	end
	otooltip6sort(otooltip6sortMethod);
	otooltip6:SetFrameStrata("FULLSCREEN_DIALOG")
	for m = 1, #oicomp do
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, oicomp[m].id)
		if _G["Oilvlmark"..oicomp[m].id]:IsShown() then	otooltip6:SetCellColor(line,1,0,1,0,1) end
		otooltip6:SetCell(line, 2, oicomp[m].name)
		otooltip6:SetCellScript(line, 2, "OnMouseUp", function(f,info,button)
			if button == "LeftButton" then	ORfbIlvl(oicomp[m].id,true) end
			if button == "MiddleButton" then
				if _G["Oilvlmark"..oicomp[m].id]:IsShown() then
					otooltip6:SetCellColor(f._line,1,0,0,0,0)
					_G["Oilvlmark"..oicomp[m].id]:Hide()
				else
					otooltip6:SetCellColor(f._line,1,0,1,0,1)
					_G["Oilvlmark"..oicomp[m].id]:Show()
				end
			end
		end)
		otooltip6:SetCellScript(line, 2, "OnLeave", function(f)
			OilvlTooltip:Hide()
			LoadRPDTooltip:Hide()
			--ClearAchievementComparisonUnit();
			if not otooltip2 then
				OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
				--ClearAchievementComparisonUnit();
				rpsw=false;
				rpunit="";
				Omover2=0;
				otooltip6rpd=nil; otooltip6rpdunit=nil; otooltip6rpdid=nil;
			end
		end)
		otooltip6:SetCellScript(line, 2, "OnEnter", function(f)
			if not otooltip2 then
				local ounit;
				if IsInRaid() then ounit = "raid"..oicomp[m].id
				elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_HOME) then
					if oicomp[m].name:sub(11) == UnitName("player") then
						ounit = "player"
						else
						ounit = "party"..(oicomp[m].id-1)
					end
				else
					ounit = "player"
				end
				OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY"); rpsw=false;
				ClearAchievementComparisonUnit();
				otooltip6rpd = f;
				otooltip6rpdunit = ounit;
				otooltip6rpdid = oicomp[m].id;
				OilvlTooltip:SetOwner(f, "ANCHOR_NONE");
				OilvlTooltip:SetUnit(ounit)
				OilvlTooltip:SetPoint("TOPLEFT",f,"TOPRIGHT",0,f:GetTop())
				local i = oicomp[m].id
				if not ospec[MVPvsframedata.spec[i]] then return end
				if MVPvsframedata.spec[i] ~= "" then
					OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
					OilvlTooltip:AddLine(SPECIALIZATION..": |cFF00FF00"..ospec[MVPvsframedata.spec[i]]);
				end
				if MVPvsframedata.me[i][1] and MVPvsframedata.me[i][1] ~= "" then
					OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
					OilvlTooltip:AddLine(L["Not enchanted"]..":\n|cFF00FF00"..MVPvsframedata.me[i][1]);
				end
				if MVPvsframedata.me[i][1] and MVPvsframedata.mg[i][1] ~= "" then
					OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
					OilvlTooltip:AddLine(L["Not socketed"]..":\n|cFF00FF00"..MVPvsframedata.mg[i][1]);
				end
				if MVPvsframedata.me[i][2] and MVPvsframedata.me[i][2] ~= "" then
					OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
					OilvlTooltip:AddLine(L["Low level enchanted"]..":\n|cFF00FF00"..MVPvsframedata.me[i][2]);
				end
				if MVPvsframedata.me[i][2] and MVPvsframedata.mg[i][2] ~= "" then
					OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
					OilvlTooltip:AddLine(L["Low level socketed"]..":\n|cFF00FF00"..MVPvsframedata.mg[i][2]);
				end
				if not CheckInteractDistance(ounit, 1) then
					OilvlTooltip:SetHeight(GameTooltip:GetHeight()+15);
					OilvlTooltip:AddLine(L["Raid Progression Details"]..":\n|cFF00FF00"..ERR_OUT_OF_RANGE);
				end
				OilvlTooltip:Show()
				if CheckInteractDistance(ounit, 1) and UnitExists(ounit) and cfg.MVPvsms then
					Omover2=2;
					ClearAchievementComparisonUnit();
					OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
					rpsw=true;
					rpunit=ounit;
					SetAchievementComparisonUnit(ounit);
					if cfg.MVPvsrpdetails then
						LoadRPDTooltip:SetOwner(OilvlTooltip, "ANCHOR_BOTTOM",0,-20);
						LoadRPDTooltip:AddLine(L["Raid Progression Details"]..": |cFFFFFFFF"..LFG_LIST_LOADING);
						LoadRPDTooltip:SetBackdropColor(1, 0, 0,1)
						LoadRPDTooltip:Show();
					end
				end
			end
		end
		)
		otooltip6:SetCell(line, 3, ORole2[oicomp[m].role],"CENTER")
		local msg = _G["OILVLRAIDFRAME"..oicomp[m].id]:GetText():find("FFFF8000")
		if msg and tonumber(oicomp[m].ilvl) then
			otooltip6:SetCell(line, 4, "|cFFFF8000"..oicomp[m].ilvl)
			if MVPvsframedata.name[oicomp[m].id]:find("~") then otooltip6:SetCellColor(line,4,1,1,0,0.3) end
			if MVPvsframedata.name[oicomp[m].id]:find("!") then otooltip6:SetCellColor(line,4,0,1,1,0.3) end
		else
			if tonumber(oicomp[m].ilvl) then
				otooltip6:SetCell(line, 4, oicomp[m].ilvl)
				if MVPvsframedata.name[oicomp[m].id]:find("~") then otooltip6:SetCellColor(line,4,1,1,0,0.3) end
				if MVPvsframedata.name[oicomp[m].id]:find("!") then otooltip6:SetCellColor(line,4,0,1,1,0.3) end
			end
		end

		if tonumber(oicomp[m].ilvl) then
			otooltip6:SetCellScript(line, 4, "OnMouseUp", function(f)
				if oicomp[m].sw then oicomp[m].sw = false else oicomp[m].sw = true end
				MVPvsframedata.ilvl[oicomp[m].id][2] = oicomp[m].sw
				otooltip6gearsw2 = true
				otooltip6func()
			end)
		end
		local function checklegendary(itemlink)
			local _,_,quality,_ = GetItemInfo(itemlink)
			if quality == 5 then return true else return false end
		end
		otooltip6:SetCell(line, 5, oicomp[m].nset,"CENTER")
		if (otooltip6gearsw or otooltip6gearsw2) and oicomp[m].sw then
			for ot = 6,21 do
				if tonumber(oicomp[m][ot6gear[ot-5]][1]) and tonumber(MVPvsframedata.gear[oicomp[m].id][ot6gear[ot-5]][1]) and
					tonumber(oicomp[m].ilvl) then
					if checklegendary(oicomp[m][ot6gear[ot-5]][2]) then
						otooltip6:SetCell(line,ot, "|cFFFF8000"..oicomp[m][ot6gear[ot-5]][1].." |cFF00FF00"..(oicomp[m][ot6gear[ot-5]][4] or ""))
					else
						otooltip6:SetCell(line,ot, oicomp[m][ot6gear[ot-5]][3]..oicomp[m][ot6gear[ot-5]][1].." |cFF00FF00"..(oicomp[m][ot6gear[ot-5]][4] or ""))
						if (ot >= 6 and ot <= 10) or ot == 15 then
							if checkMtier(MVPvsframedata.gear[oicomp[m].id][ot6gear[ot-5]]) then
								otooltip6:SetCellColor(line,ot,255/255, 127/255, 243/255,1)
							elseif checkHtier(MVPvsframedata.gear[oicomp[m].id][ot6gear[ot-5]]) then
								otooltip6:SetCellColor(line,ot,25/255, 127.5/255, 255/255,1)
							elseif checkNtier(MVPvsframedata.gear[oicomp[m].id][ot6gear[ot-5]]) then
								otooltip6:SetCellColor(line,ot,0,1,0,1)
							else
								otooltip6:SetCellColor(line,ot,0,0,0,0)
							end
						end
					end
					otooltip6:SetCellScript(line, ot, "OnEnter", function(f)
						if checknil(MVPvsframedata.gear[oicomp[m].id],ot6gear[ot-5],2) then return end
						OilvlInspectTooltip:SetOwner(UIParent, "ANCHOR_NONE");
						OilvlInspectTooltip:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,f:GetTop())
						OilvlInspectTooltip:ClearLines()
						OilvlInspectTooltip:SetMinimumWidth(150)

						local additionalTooltipBackdrop = {bgFile="Interface/Buttons/WHITE8X8",edgeFile="Interface/Tooltips/UI-Tooltip-Border",tile=false,edgeSize=14,insets={left=0.5,right=0.5,top=0.5,bottom=0.5}}
						OilvlInspectTooltip:SetBackdrop(additionalTooltipBackdrop)
						OilvlInspectTooltip:SetBackdropColor(0,0,0,1)
						OilvlInspectTooltip:SetBackdropBorderColor(1,1,1,1)

						if oicomp[m][ot6gear[ot-5]][2] ~= "" and MVPvsframedata.gear[oicomp[m].id][ot6gear[ot-5]] and MVPvsframedata.spec[oicomp[m].id] ~= "" then
							OilvlInspectTooltip:SetHyperlink(
								MVPvsframedata.gear[oicomp[m].id][ot6gear[ot-5]][2],
								CheckClass(MVPvsframedata.spec[oicomp[m].id]),
								MVPvsframedata.spec[oicomp[m].id]
							)

							-- check tier
							do
								local j,sn,ns;
								-- j=line number for tier set (n/n)
								-- sn = name of tier set
								-- ns = total number of gears in the tier set
								for i = 1, OilvlInspectTooltip:NumLines() do
									j = i;
									sn,ns = _G["OilvlInspectTooltipTextLeft"..i]:GetText():match("(.+) %(%d+/(%d+)")
									if ns then
										ns = tonumber(ns)
										break
									end
								end
								if ns then
									local tier = {}
									local tieravail = {}
									local k=1
									for i = j+1,j+ns do
										tier[k]=_G["OilvlInspectTooltipTextLeft"..i]:GetText():sub(3)
										k=k+1
									end
									local gearnames = {}
									for i=1,#ot6gear do
										if not checknil(MVPvsframedata.gear[oicomp[m].id],ot6gear[i],2) then
											gearnames[i]=MVPvsframedata.gear[oicomp[m].id][ot6gear[i]][2]:match("%[(.+)%]")
										end
									end
									local tn=0
									for i = 1, #gearnames do
										if gearnames[i] and gearnames[i] ~= "" then
											for j = 1, ns do
												if gearnames[i] == tier[j] then
													tieravail[j] = true
													tn = tn + 1
													break
												end
											end
										end
									end
									_G["OilvlInspectTooltipTextLeft"..j]:SetText(sn.." ("..tn.."/"..ns..")")
									_G["OilvlInspectTooltipTextLeft"..j]:SetTextColor(1,210/255,0,1)
									for i = j+1, j+ns do
										if tieravail[i-j] then
											_G["OilvlInspectTooltipTextLeft"..i]:SetTextColor(1,1,151/255,1)
										else
											_G["OilvlInspectTooltipTextLeft"..i]:SetTextColor(0.5,0.5,0.5,1)
										end
									end
									if tn >= 2 then
										_G["OilvlInspectTooltipTextLeft"..j+ns+2]:SetTextColor(0,1,0,1)
									end
									if tn >= 4 then
										_G["OilvlInspectTooltipTextLeft"..j+ns+3]:SetTextColor(0,1,0,1)
									end
								end
							end

						end
						OilvlInspectTooltip:Show()
					end)
					otooltip6:SetCellScript(line, ot, "OnLeave", function(f) OilvlInspectTooltip:Hide() end)
				end
			end
		end
	end
	otooltip6:AddSeparator()
	-- average item level for tank, healer and dps
	if IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_HOME) then
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:32:48:0:16:255:255:255|t","CENTER",2)
		otooltip6:SetCell(line, 3, NumRole["TANK"])
		otooltip6:SetCell(line, 4, ailtank)
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:16:32:0:16:255:255:255|t","CENTER",2)
		otooltip6:SetCell(line, 3, NumRole["DAMAGER"])
		otooltip6:SetCell(line, 4, aildps)
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, "|TInterface\\LFGFrame\\LFGRole:0:0:0:0:64:16:48:64:0:16:255:255:255|t","CENTER",2)
		otooltip6:SetCell(line, 3, NumRole["HEALER"])
		otooltip6:SetCell(line, 4, ailheal)
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, L["Average"],"CENTER",2)
		otooltip6:SetCell(line, 3, GetNumGroupMembers())
		otooltip6:SetCell(line, 4, ail)
		otooltip6:AddSeparator()
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, L["Vanquisher"],"CENTER",2)
		otooltip6:SetCell(line, 3, OVanq)
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, L["Protector"],"CENTER",2)
		otooltip6:SetCell(line, 3, OProt)
		line = otooltip6:AddLine()
		otooltip6:SetCell(line, 1, L["Conqueror"],"CENTER",2)
		otooltip6:SetCell(line, 3, OConq)
		otooltip6:AddSeparator()
	end
	line = otooltip6:AddLine()
	otooltip6:SetCell(line, 2, "|cffffffff"..PARTY,"CENTER")
	otooltip6:SetCellScript(line, 2, "OnMouseUp", function() OSendToParty(GetMouseButtonClicked()) end)
	otooltip6:SetCell(line, 3, "|cffffffff"..STATUS_TEXT_TARGET)
	otooltip6:SetCellScript(line, 3, "OnMouseUp", function() OSendToTarget(GetMouseButtonClicked()) end)
	otooltip6:SetCell(line, 4, "|cffffffff"..BATTLEGROUND_INSTANCE)
	otooltip6:SetCellScript(line, 4, "OnMouseUp", function() OSendToInstance(GetMouseButtonClicked()) end)
	line = otooltip6:AddLine()
	otooltip6:SetCell(line, 2, "|cffffffff"..CHAT_MSG_GUILD,"CENTER")
	otooltip6:SetCellScript(line, 2, "OnMouseUp", function() OSendToGuild(GetMouseButtonClicked()) end)
	if GetLocale() == "deDE" then
		otooltip6:SetCell(line, 3, "|cffffffff".."Raid")
	else
		otooltip6:SetCell(line, 3, "|cffffffff"..CHAT_MSG_RAID)
	end
	otooltip6:SetCellScript(line, 3, "OnMouseUp", function() OSendToRaid(GetMouseButtonClicked()) end)
	otooltip6:SetCell(line, 4, "|cffffffff"..GUILD_RANK1_DESC)
	otooltip6:SetCellScript(line, 4, "OnMouseUp", function() OSendToOfficer(GetMouseButtonClicked()) end)
	line = otooltip6:AddLine()
	otooltip6:SetCell(line, 2, "|cffffffff"..PVP,"CENTER")
	if pvpsw then
		otooltip6:SetCellColor(line,2,1,0,0,0.5)
	else
		otooltip6:SetCellColor(line,2,0,0,0,0)
	end
	otooltip6:SetCellScript(line, 2, "OnMouseUp", function()
		if pvpsw then
			OPvPSet:Hide();
			otooltip6:SetCellColor(line,2,0,0,0,0)
			pvpsw = false
		else
			OPvPSet:Show();
			otooltip6:SetCellColor(line,2,1,0,0,0.5)
			pvpsw = true
		end
		for s = 1, 40 do
			if MVPvsframedata.ilvl[s][1] ~= nil and MVPvsframedata.ilvl[s][1] ~= "" then
				MVPvsframedata.ilvl[s][1] = OTgathertilPvP(s);
			end
		end
		OilvlCheckFrame();
	end)
	otooltip6:SetCell(line, 3, "|cffffffff"..L["Export"])
	otooltip6:SetCellScript(line, 3, "OnMouseUp", function(f,i,button) OSendToCopy(button) end)
	otooltip6:SetCell(line, 4, "|cffffffff"..RESET)
	otooltip6:SetCellScript(line, 4, "OnMouseUp", function(f,i,button)
		OResetSendMark()
		otooltip6func()
	end)
	otooltip6:AddSeparator()
	line = otooltip6:AddLine()
	otooltip6:SetCell(line, 1, "|cffffffff"..LFG_LIST_REFRESH,"CENTER",4)
	otooltip6:SetLineScript(line, "OnMouseUp", function() OVILRefresh() end)
	otooltip6:AddSeparator()
	otooltip6:UpdateScrolling();
	otooltip6:Show();
end

function LDB.OnEnter(self)
	LDB_ANCHOR = self;
	otooltip6func();
end

function otooltip7func()
	--collectgarbage()
	if otooltip7 ~= nil then
		if LibQTip:IsAcquired("OiLvLCache") then otooltip7:Clear() end
		otooltip7:Hide()
		LibQTip:Release(otooltip7)
		otooltip7 = nil
	end
	otooltip7 = LibQTip:Acquire("OiLvLCache", 5, "RIGHT","LEFT", "CENTER", "CENTER", "CENTER")
	otooltip7:SetBackdropColor(0,0,0,1)
	otooltip7:SetHeaderFont(ssHeaderFont)
	otooltip7:SetFont(ssRegFont)
	otooltip7:ClearAllPoints()
	otooltip7:SetClampedToScreen(false)
	otooltip7:SetPoint("CENTER")
	otooltip7:AddSeparator();
	local line = otooltip7:AddHeader()
	otooltip7:SetCell(line, 1, "|cffffffff".."ID")
	otooltip7:SetCell(line, 2, "|cffffffff"..NAME)
	otooltip7:SetCellScript(line, 2, "OnMouseUp", function(self)
		if #cfg.MVPvscache > 1 then
			if  cfg.MVPvscache[1].oname > cfg.MVPvscache[#cfg.MVPvscache].oname then
				sort(cfg.MVPvscache, function(a,b) return a.oname < b.oname end)
			else
				sort(cfg.MVPvscache, function(a,b) return a.oname > b.oname end)
			end
		end
		otooltip7func()
	end)
	otooltip7:SetCell(line, 3, "|cffffffff"..FRIENDS_LIST_REALM:gsub(":",""))
	otooltip7:SetCellScript(line, 3, "OnMouseUp", function(self)
		if #cfg.MVPvscache > 1 then
			if  cfg.MVPvscache[1].orealm > cfg.MVPvscache[#cfg.MVPvscache].orealm then
				sort(cfg.MVPvscache, function(a,b) return a.orealm < b.orealm end)
			else
				sort(cfg.MVPvscache, function(a,b) return a.orealm > b.orealm end)
			end
		end
		otooltip7func()
	end)
	otooltip7:SetCell(line, 4, "|cffffffff"..CLASS)
	otooltip7:SetCellScript(line, 4, "OnMouseUp", function(self)
		if #cfg.MVPvscache > 1 then
			if  cfg.MVPvscache[1].oclass > cfg.MVPvscache[#cfg.MVPvscache].oclass then
				sort(cfg.MVPvscache, function(a,b) return a.oclass < b.oclass end)
			else
				sort(cfg.MVPvscache, function(a,b) return a.oclass > b.oclass end)
			end
		end
		otooltip7func()
	end)
	otooltip7:SetCell(line, 5, "|cffffffff"..L["Item Level"])
	otooltip7:SetCellScript(line, 5, "OnMouseUp", function(self)
		if #cfg.MVPvscache > 1 then
			if  cfg.MVPvscache[1].oilvl > cfg.MVPvscache[#cfg.MVPvscache].oilvl then
				sort(cfg.MVPvscache, function(a,b) return a.oilvl < b.oilvl end)
			else
				sort(cfg.MVPvscache, function(a,b) return a.oilvl > b.oilvl end)
			end
		end
		otooltip7func()
	end)
	otooltip7:AddSeparator()
	for m = 1,  #cfg.MVPvscache do
		line = otooltip7:AddLine()
		otooltip7:SetCell(line, 1, m)
		otooltip7:SetCell(line, 2, cfg.MVPvscache[m].oname)
		otooltip7:SetCellScript(line, 2, "OnMouseUp", function(self)
			if GetMouseButtonClicked() == "LeftButton" then
				local nn = self._line - 3;
				if cfg.MVPvscache[nn] and cfg.MVPvscache[nn].oname and cfg.MVPvscache[nn].orealm then
					OIlvlInspectFrame:Clear();
					for crg = 17,1,-1 do
						if cfg.MVPvscache[nn].ogear[crg] ~= nil then
							if pvpsw then
								if cfg.MVPvscache[nn].ogear[crg][7] ~= 0 then
									OIlvlInspectFrame:AddMessage(cfg.MVPvscache[nn].ogear[crg][7].." "..cfg.MVPvscache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvscache[nn].ogear[crg][3]*cfg.MVPvscache[nn].ogear[crg][5],1,cfg.MVPvscache[nn].ogear[crg][4]*cfg.MVPvscache[nn].ogear[crg][6])
								else
									OIlvlInspectFrame:AddMessage(cfg.MVPvscache[nn].ogear[crg][1].." "..cfg.MVPvscache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvscache[nn].ogear[crg][3]*cfg.MVPvscache[nn].ogear[crg][5],1,cfg.MVPvscache[nn].ogear[crg][4]*cfg.MVPvscache[nn].ogear[crg][6])
								end
							else
								OIlvlInspectFrame:AddMessage(cfg.MVPvscache[nn].ogear[crg][1].." "..cfg.MVPvscache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvscache[nn].ogear[crg][3]*cfg.MVPvscache[nn].ogear[crg][5],1,cfg.MVPvscache[nn].ogear[crg][4]*cfg.MVPvscache[nn].ogear[crg][6]);
							end
						end
					end
					OIlvlInspectFrame:AddMessage(cfg.MVPvscache[m].oilvl.." "..cfg.MVPvscache[m].oname.."-"..cfg.MVPvscache[m].orealm.."\n")
					OIlvlInspect:Show();
				end
			end
			if GetMouseButtonClicked() == "RightButton" then
				local nn = self._line - 3;
				if cfg.MVPvscache[nn] and cfg.MVPvscache[nn].oname and cfg.MVPvscache[nn].orealm then
					OIlvlInspect2Frame:Clear();
					for crg = 17,1,-1 do
						if cfg.MVPvscache[nn].ogear[crg] ~= nil then
							if pvpsw then
								if cfg.MVPvscache[nn].ogear[crg][7] ~= 0 then
									OIlvlInspect2Frame:AddMessage(cfg.MVPvscache[nn].ogear[crg][7].." "..cfg.MVPvscache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvscache[nn].ogear[crg][3]*cfg.MVPvscache[nn].ogear[crg][5],1,cfg.MVPvscache[nn].ogear[crg][4]*cfg.MVPvscache[nn].ogear[crg][6])
								else
									OIlvlInspectFrame:AddMessage(cfg.MVPvscache[nn].ogear[crg][1].." "..cfg.MVPvscache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvscache[nn].ogear[crg][3]*cfg.MVPvscache[nn].ogear[crg][5],1,cfg.MVPvscache[nn].ogear[crg][4]*cfg.MVPvscache[nn].ogear[crg][6])
								end
							else
								OIlvlInspect2Frame:AddMessage(cfg.MVPvscache[nn].ogear[crg][1].." "..cfg.MVPvscache[nn].ogear[crg][2].."  ("..oenchantItem[crg][2]..")",cfg.MVPvscache[nn].ogear[crg][3]*cfg.MVPvscache[nn].ogear[crg][5],1,cfg.MVPvscache[nn].ogear[crg][4]*cfg.MVPvscache[nn].ogear[crg][6]);
							end
						end
					end
					OIlvlInspect2Frame:AddMessage(cfg.MVPvscache[m].oilvl.." "..cfg.MVPvscache[m].oname.."-"..cfg.MVPvscache[m].orealm.."\n")
					OIlvlInspect2:Show();
				end
			end
		end)
		otooltip7:SetCell(line, 3, cfg.MVPvscache[m].orealm)
		otooltip7:SetCell(line, 4, cfg.MVPvscache[m].oclass)
		cfg.MVPvscache[m].oilvl = OTgathertilPvPCache(m)
		otooltip7:SetCell(line, 5, cfg.MVPvscache[m].oilvl)
	end
	otooltip7:AddSeparator()
	line = otooltip7:AddLine()
	-- DISABLE
	if cfg.MVPvscachesw then
		otooltip7:SetCell(line, 3, "|cffffffff"..DISABLE)
		otooltip7:SetCellScript(line, 3, "OnMouseUp", function()
			cfg.MVPvscachesw = false
			cfg.MVPvscache = {}
			otooltip7func()
		end)
	else
		otooltip7:SetCell(line, 3, "|cffffffff"..ENABLE)
		otooltip7:SetCellScript(line, 3, "OnMouseUp", function()
			cfg.MVPvscachesw = true
			cfg.MVPvscache = {}
			otooltip7func()
		end)
	end

	-- CLEAR_ALL
	otooltip7:SetCell(line, 4, "|cffffffff"..CLEAR_ALL)
	otooltip7:SetCellScript(line, 4, "OnMouseUp", function()
		cfg.MVPvscache = {}
		otooltip7func()
	end)
	-- HIDE
	otooltip7:SetCell(line, 5, "|cffffffff"..HIDE)
	otooltip7:SetCellScript(line, 5, "OnMouseUp", function()
		otooltip7:Hide()
		if otooltip7 ~= nil then
			LibQTip:Release(otooltip7)
			otooltip7 = nil
		end
	end)
	otooltip7:AddSeparator();
	otooltip7:UpdateScrolling(400);
	if otooltip7exit == nil then
		oilvlminbutton(otooltip7, "otooltip7exit", function()
			otooltip7:Hide()
			otooltip7exit:Hide();
			if otooltip7 ~= nil then
				LibQTip:Release(otooltip7)
				otooltip7 = nil
			end
		end, 10,10)
	else
		otooltip7exit:SetParent(otooltip7)
		otooltip7exit:SetPoint("TOPRIGHT",otooltip7,10,10)
	end
	otooltip7exit:Show();
	otooltip7:Show();
end

local enchantID = {

	[5942]=true,[5943]=true,[5944]=true,[5945]=true, -- ring
	[5946]=true,[5948]=true,[5949]=true,[5950]=true,[5965]=true,[5964]=true,[5963]=true,[5966]=true,[5962]=true -- weapon
}

local gemTexture = {
	[1990986]=true,[1990989]=true,[1990987]=true, [1990984]=true, [1995542]=true
}

local OgemFrame = CreateFrame('GameTooltip', 'OSocketTooltip', nil, 'GameTooltipTemplate');
OgemFrame:SetOwner(UIParent, 'ANCHOR_NONE');

function OItemAnalysis_CountEmptySockets(unitid, slot, itemLink)
	local count = 0; -- missing gem
	local count2 = 0; -- low lever gem
	local temp = OILVLTooltipTexture1:GetTexture();
	if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic" then
		count = count + 1;
	end
	local _, gemlink = GetItemGem(itemLink,1)
	if temp and gemlink and slot ~= 16 and slot ~= 17 and not gemTexture[temp] then count2 = count2 + 1 end
	return count, count2;
end

function OItemAnalysis_CountEmptySockets2(unitid, slot)
	local count = 0; -- missing gem
	OgemFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OgemFrame:ClearLines();
	OgemFrame:SetInventoryItem(unitid, slot)

	local temp = OSocketTooltipTexture1:GetTexture();
	if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic" then
		count = count + 1;
	end
	return count
end

function OItemAnalysisLowGem(unitid, slot)
	local count2 = 0; -- low lever gem

	OgemFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OgemFrame:ClearLines();
	OgemFrame:SetInventoryItem(unitid, slot)

	local temp = OSocketTooltipTexture1:GetTexture();
	if temp and not gemTexture[temp] then count2 = count2 + 1 end
	return count2;
end

function OTCheckartifactwep(itemID)
	local _,_,quality,_ = GetItemInfo(itemID)
	if quality == 6 then return true end
	return false
end

function OTCheckLegendary(itemID)
	local _,_,quality,_ = GetItemInfo(itemID)
	if quality == 5 then return true end
	return false
end

function OGetArtifactRelicPlus5(itemLink)
	local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",itemLink,15)
	local relics = {}
	if ((gem1 and gem1 ~= "") or (gem2 and gem2 ~= "") or (gem1 and gem3 ~= "")) and (numBonusIDs and numBonusIDs ~= "") then
		numBonusIDs = tonumber(numBonusIDs)
		for j=1,numBonusIDs do
			if not restLink then
				break
			end
			local _,newRestLink = strsplit(":",restLink,2)
			restLink = newRestLink
		end
		if restLink then
			restLink = restLink:gsub("|h.-$","")

			if upgradeType and (tonumber(upgradeType) or 0) < 1000 then
				local _,newRestLink = strsplit(":",restLink,2)
				restLink = newRestLink
			else
				local _,_,newRestLink = strsplit(":",restLink,3)
				restLink = newRestLink
			end

			for relic=1,3 do
				if not restLink then
					break
				end
				local numBonusRelic,newRestLink = strsplit(":",restLink,2)
				numBonusRelic = tonumber(numBonusRelic or "?") or 0
				restLink = newRestLink

				if numBonusRelic > 10 then	--Got Error in parsing here
					break
				end

				local relicBonus = numBonusRelic
				for j=1,numBonusRelic do
					if not restLink then
						break
					end
					local bonusID,newRestLink = strsplit(":",restLink,2)
					restLink = newRestLink
					relicBonus = relicBonus .. ":" .. bonusID
				end

				local relicItemID = select(3+relic, strsplit(":",itemLink) )
				if relicItemID and relicItemID ~= "" then
					relics[relic] = "item:"..relicItemID.."::::::::110:0::0:"..relicBonus..":::"
				end
			end
		end
	end
	return relics
end

function OTgathertil(guid, unitid)
	local totalIlvl, avgIlvl = 0
	local iter_min, iter_max = 0
	local itemLevel = 0
	local equipType = 0
	local twoHander = nil
	local mia = 0;
	local count = 0
	local missenchant = "";
	local missgem = "";
	local missHenchant = "";
	local missHgem = "";
	local _,_,_,_,_,armorname,_ = GetItemInfo(124262)
	if OTCurrent3 ~= "" then
		MVPvsframedata.gear[OTCurrent3] = {};
	end
	local cgear = {}
	local legendary = 0
	--local relic = {}
	OILVLFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	OILVLFrame:ClearLines();
	for i = 1,17 do
		local xupgrade = nil
		local xname = nil
		if(i ~= 4) then
			OILVLFrame:SetInventoryItem(unitid, i, nil, true)
			local _,item = OILVLFrame:GetItem()

			if item and (i == 16 or i == 17) and item:find("item::") then
				item = GetInventoryItemLink(unitid, i)
			end

			if(item) then
				_,_,_,itemLevel,_,itemClass,_,_,equipType = GetItemInfo(item)

				if(itemLevel) then
					count = count + 1
					if(i == 16) then
						if(equipType == "INVTYPE_2HWEAPON" or equipType == "INVTYPE_RANGED" or equipType == "INVTYPE_RANGEDRIGHT") then
							twoHander = 1
						end
					end

					-- check miss enchant
					item = item:gsub("::",":0:"):gsub("::",":0:")
					local itemID,enchant,_,_,_,_,_ = item:match("%a+:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)");

					local ogme=1; -- save for gear missing enchant
					if oenchantItem[i][1] == 1 and enchant == "0" then
						if i ~= 17 then
							if missenchant == "" then
								missenchant = missenchant..oenchantItem[i][2];
							else
								missenchant = missenchant..", "..oenchantItem[i][2];
							end
							ogme = 0;
						else
							if i == 17 and itemClass ~= armorname and  twoHander ~= 1 then
								if missenchant == "" then
									missenchant = missenchant..oenchantItem[i][2];
								else
									missenchant = missenchant..", "..oenchantItem[i][2];
								end
								ogme = 0;
							end
						end
					end
					-- check for better enchant
					local ogmHe=1; -- save for gear missing enchant
					if oenchantItem[i][1] == 1 and enchant ~= "0" and not enchantID[tonumber(enchant)] then
						if i ~= 17 then
							if missHenchant == "" then
								missHenchant = missHenchant..oenchantItem[i][2];
							else
								missHenchant = missHenchant..", "..oenchantItem[i][2];
							end
							ogmHe = 0;
						else
							if i == 17 and itemClass ~= armorname and  twoHander ~= 1 and enchant ~= "0" and not enchantID[tonumber(enchant)] then
								if missHenchant == "" then
									missHenchant = missHenchant..oenchantItem[i][2];
								else
									missHenchant = missHenchant..", "..oenchantItem[i][2];
								end
								ogmHe = 0;
							end
						end
					end

					-- check missing gems
					local ogmg=1; -- save for gear missing gem
					local socketstatus, lowgem = OItemAnalysis_CountEmptySockets(unitid,i,item)
					if socketstatus ~= 0 then
						if missgem == "" then
							missgem = missgem..oenchantItem[i][2];
						else
							missgem = missgem..", "..oenchantItem[i][2];
						end
						ogmg = 0;
					end
					-- check for better gems
					local ogmHg=1; -- save for gear missing gem
					if socketstatus == 0 and lowgem ~= 0 then
						if missHgem == "" then
							missHgem = missHgem..oenchantItem[i][2];
						else
							missHgem = missHgem..", "..oenchantItem[i][2];
						end
						ogmHg = 0;
					end

					-- check item level
					if OItemAnalysis_CheckILVLGear(unitid,i) ~= 0 then
						itemLevel, xupgrade = OItemAnalysis_CheckILVLGear(unitid,i)
					end

					-- temp fix for ilvl in nether crucible
					--if (i == 16 or i == 17) and UnitName("player") ~= UnitName(unitid) then
						--local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",item,15)
						--local gemactive = 0
						--if (gem1 and gem1 ~= "") then gemactive = gemactive + 1 end
						--if (gem2 and gem2 ~= "") then gemactive = gemactive + 1 end
						--if (gem3 and gem3 ~= "") then gemactive = gemactive + 1 end
						--itemLevel = itemLevel + gemactive*5
					--end
					--------------------------------

					if cgear[16] and cgear[16][1] and i == 17 and OTCheckartifactwep(tonumber(itemID)) then
						if cgear[16][1] > itemLevel then
							itemLevel, xupgrade = cgear[16][1], cgear[16][9]
						end
						if cgear[16][1] < itemLevel then
							if OTCurrent3 ~= "" and not pvpsw then
								totalIlvl = totalIlvl - cgear[16][1] + itemLevel
								MVPvsframedata.gear[OTCurrent3][16][1], MVPvsframedata.gear[OTCurrent3][16][9] = itemLevel, xupgrade
								cgear[16][1], cgear[16][9] = itemLevel, xupgrade
							end
							if OTCurrent3 == "" then
								totalIlvl = totalIlvl - cgear[16][1] + itemLevel
							end
						end
					end
					--[[if OTCheckartifactwep(tonumber(itemID)) then
						for aw = 1, 3 do
							local reliclink = select(2,GetItemGem(item,aw))
							if reliclink then
								relic[aw] = {reliclink, OItemAnalysis_CheckILVLRelic(reliclink), tonumber(C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic(reliclink))}
							end
						end
					end]]
					if pvpsw then
						if OItemAnalysis_CheckPvPGear(unitid,i) ~= 0 then
							totalIlvl = totalIlvl + OItemAnalysis_CheckPvPGear(unitid,i)
						else
							totalIlvl = totalIlvl + itemLevel
						end
					else
						totalIlvl = totalIlvl + itemLevel
					end
					if itemLevel == nil then itemLevel = "" end
					if item == nil then item = "" end

					-- check legendary
					if OTCheckLegendary(tonumber(itemID)) then legendary = legendary + 1 end

					if OTCurrent3 ~= "" then
						MVPvsframedata.gear[OTCurrent3][i] = {itemLevel, item, ogme, ogmg, ogmHe, ogmHg, OItemAnalysis_CheckPvPGear(unitid,i),tonumber(itemID),xupgrade}
					end
					cgear[i] = {itemLevel, item, ogme, ogmg, ogmHe, ogmHg, OItemAnalysis_CheckPvPGear(unitid,i),tonumber(itemID),xupgrade}
				end
			end
		end
	end
	if count < 15 and twoHander then
		mia = 15-count;
	end
	if count < 16 and not twoHander then
		mia = 16-count;
	end

	if totalIlvl > 0 and count > 0 then
		if cgear[16] and cgear[16][1] and not cgear[17] then
			avgIlvl = round((totalIlvl+cgear[16][1]) / 16, cfg.MVPvsdp)
		else
			avgIlvl = round(totalIlvl / 16, cfg.MVPvsdp)
		end
	else
		avgIlvl = 0
	end
	-- save player gear to cfg.MVPvsgears
	if cfg.MVPvsgear ~= nil then cfg.MVPvsgear = nil end
	local oname, orealm = UnitFullName("player")
	local oname2 = GetUnitName(unitid, true)
	local oname3, orealm3 = UnitFullName(unitid)
	local altsw = false
	if oname and oname2 and avgIlvl and oname == oname2 and avgIlvl > 0 then
		for i = 1, #cfg.MVPvsgears do
			if cfg.MVPvsgears[i][1] == oname and cfg.MVPvsgears[i][2] == orealm then
				cfg.MVPvsgears[i] = {oname,orealm,avgIlvl,MVPvsframedata.gear[OTCurrent3]}
				altsw = true
				break;
			end
		end
		if not altsw then
			local i = #cfg.MVPvsgears + 1;
			cfg.MVPvsgears[i] = {oname,orealm,avgIlvl,MVPvsframedata.gear[OTCurrent3]}
		end
	end
	-- cache
	if cfg.MVPvscachesw and cfg.MVPvscache and orealm and oname3 and avgIlvl then
		local cachesw = false
		if oname3 and not orealm3 then orealm3 = orealm end
		for i = 1, #cfg.MVPvscache do
			if cfg.MVPvscache[i] and cfg.MVPvscache[i].oname and cfg.MVPvscache[i].oname == oname3 and cfg.MVPvscache[i].orealm and cfg.MVPvscache[i].orealm == orealm3 and avgIlvl > 0 then
				cfg.MVPvscache[i] = {
					oname = oname3,
					orealm = orealm3,
					oilvl = avgIlvl,
					ogear = MVPvsframedata.gear[OTCurrent3],
					oclass = oClassColor(unitid)..UnitClass(unitid),
					otime = time()
				}
				sort(cfg.MVPvscache, function(a,b) return a.otime > b.otime end)
				if #cfg.MVPvscache > 100 then cfg.MVPvscache[#cfg.MVPvscache] = nil; end
				cachesw = true;
				break;
			end
		end
		if not cachesw and oname3 and orealm3 and avgIlvl > 0 then
			local i = #cfg.MVPvscache + 1;
			cfg.MVPvscache[i] = {
				oname = oname3,
				orealm = orealm3,
				oilvl = avgIlvl,
				ogear = MVPvsframedata.gear[OTCurrent3],
				oclass = oClassColor(unitid)..UnitClass(unitid),
				otime = time()
			}
			sort(cfg.MVPvscache, function(a,b) return a.otime > b.otime end)
		end
		if #cfg.MVPvscache > 100 then cfg.MVPvscache[#cfg.MVPvscache] = nil; end
	end
	if OTCurrent3 and OTCurrent3 ~= "" and mia == 0 then
		MVPvsframedata.ilvl[OTCurrent3] = {avgIlvl,otooltip6gearsw,count,legendary};
		MVPvsframedata.me[OTCurrent3] = {missenchant,missHenchant};
		MVPvsframedata.mg[OTCurrent3] = {missgem,missHgem};
		MVPvsframedata.spec[OTCurrent3] = GetInspectSpecialization(unitid);
	end
	return avgIlvl, mia, missenchant, missgem, missHenchant, missHgem, count, legendary, GetInspectSpecialization(unitid);
end

function OTgathertilPvP(r)
	if MVPvsframedata.gear[r] == nil or MVPvsframedata.gear[r] == "" or MVPvsframedata.ilvl[r][1] == nil or MVPvsframedata.ilvl[r][1] == "" then return nil end
	local totalIlvl, avgIlvl = 0
	local itemLevel = 0
	local twoHander = nil
	local count = 0;
	for i = 1,17 do
		if(i ~= SHIRT) and MVPvsframedata.gear[r][i] and MVPvsframedata.gear[r][i][1] then
			if pvpsw then
				if MVPvsframedata.gear[r][i][7] == 0 then
					itemLevel = MVPvsframedata.gear[r][i][1];
				else
					itemLevel = MVPvsframedata.gear[r][i][7];
				end
			else
				itemLevel = MVPvsframedata.gear[r][i][1];
			end
			totalIlvl = totalIlvl + itemLevel
			count = count + 1
		end
	end
	avgIlvl = round(totalIlvl / count, 1)
	return avgIlvl;
end

function OTgathertilPvPCache(r)
	if cfg.MVPvscache[r].ogear == nil or cfg.MVPvscache[r].ogear == "" or cfg.MVPvscache[r].oilvl == nil or cfg.MVPvscache[r].oilvl == "" then return nil end
	local totalIlvl, avgIlvl = 0
	local itemLevel = 0
	local twoHander = nil
	local count = 0;
	for i = 1,17 do
		if(i ~= SHIRT) and cfg.MVPvscache[r].ogear[i] and cfg.MVPvscache[r].ogear[i][1] then
			if pvpsw then
				if cfg.MVPvscache[r].ogear[i][7] == 0 then
					itemLevel = cfg.MVPvscache[r].ogear[i][1];
				else
					itemLevel = cfg.MVPvscache[r].ogear[i][7];
				end
			else
				itemLevel = cfg.MVPvscache[r].ogear[i][1];
			end
			totalIlvl = totalIlvl + itemLevel
			count = count + 1
		end
	end
	avgIlvl = round(totalIlvl / count, 1)
	return avgIlvl;
end

function oilvlUpdateLDBTooltip()
	if otooltip6 ~= nil then
		if otooltip6:IsShown() then
			if LibQTip:IsAcquired("OiLvLDB") then otooltip6:Clear() end
			otooltip6:Hide()
			LibQTip:Release(otooltip6)
			otooltip6 = nil
			otooltip6func();
		end
	end
end

function MVPvsSetABCD(i)
	if not MVPvsframedata.ilvl[i] then MVPvsframedata.ilvl[i] = {"",otooltip6gearsw,0,0}; end
	MVPvsframedata.ilvl[i][1] = ""
end

local function GetUnitIDbyGuid(guid)
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		for i = 1, rnum do
			if UnitGUID("raid"..i) == guid then return "OILVLRAIDFRAME"..i, "raid"..i, i end
		end
	end
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) - 1
		for i = 1, rnum do
			if UnitGUID("party"..i) == guid then return "OILVLRAIDFRAME"..(i+1), "party"..i, i+1 end
		end
	end
	if IsInGroup(LE_PARTY_CATEGORY_HOME) then
		rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) - 1
		for i = 1, rnum do
			if UnitGUID("party"..i) == guid then return "OILVLRAIDFRAME"..(i+1), "party"..i, i+1 end
		end
	end
	if UnitGUID("player") == guid then return "OILVLRAIDFRAME1", "player", 1 end
	return false,false,false
end

function oilvlSaveItemLevel(n)
	if OILVL_Unit ~= "" then
		local OTilvl, OTmia, missenchant, missgem,  missenchant2, missgem2, count2, legendary2, gspec = OTgathertil(UnitGUID("OILVL_Unit"),OILVL_Unit)
		if (OTmia == 0 and n > 0) then
			miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
			_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..GetUnitName(OTCurrent2,""):gsub("%-.+", ""));
			MVPvsframedata.name[OTCurrent3] = GetUnitName(OTCurrent2,""):gsub("%-.+", "");
			if missenchant ~= "" or missgem ~= "" then
				MVPvsframedata.name[OTCurrent3] = "! "..MVPvsframedata.name[OTCurrent3]
			elseif missenchant2 ~= "" or missgem2 ~= "" then
				MVPvsframedata.name[OTCurrent3] = "~ "..MVPvsframedata.name[OTCurrent3]
			end
			if MVPvsframedata.name[OTCurrent3] ~= "" then
			-- check legendary
				if legendary2 > 0 then
					_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..MVPvsframedata.name[OTCurrent3].."\n|r|cFFFF8000"..OTilvl);
				else
					_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..MVPvsframedata.name[OTCurrent3].."\n|r|cFF00FF00"..OTilvl);
				end
			end
			_G["Oilvltier"..OTCurrent3]:SetText(oilvlCheckTierBonusSet(OTCurrent3))
			_G["OilvlUpgrade"..OTCurrent3]:SetText(oilvlCheckUpgrade(OTCurrent3))
			oilvlUpdateLDBTooltip();
			OTCurrent = "";
			OTCurrent2 = "";
			OTCurrent3 = "";
			OILVL_Unit="";
		else
			if OTmia < 3 and OTmia > 0 then
				miacount = miacount + 1
				miaunit[miacount] = UnitGUID("OILVL_Unit");
				if miaunit[1] == miaunit[2] and miaunit[2] == miaunit[3] and miaunit[3] == miaunit[4] and miaunit[4] == miaunit[5] and miaunit[5] == miaunit[6] then
					miacount=0;	miaunit[1]="";miaunit[2]="";miaunit[3]="";miaunit[4]="";miaunit[5]="";miaunit[6]="";
					OILVL_Unit="";
					if MVPvsframedata.name[OTCurrent3] ~= "" then
						_G[OTCurrent]:SetText(oClassColor(OTCurrent2)..MVPvsframedata.name[OTCurrent3].."\n|r|cFFFF0000"..OTilvl);
						MVPvsframedata.ilvl[OTCurrent3][1] = OTilvl;
					end
					OTCurrent = "";
					OTCurrent2 = "";
					OTCurrent3 = "";
				end
			end
		end
	end
	if n > 0 then OILVL:UnregisterEvent("INSPECT_READY") end
end

local events = {}
local LastInspectTime = GetTime()

function events:INSPECT_READY(guid)
	local tempoc, tempoc2, tempoc3 = GetUnitIDbyGuid(guid)
	if GetTime() - LastInspectTime > 2.5 and tempoc then
		OILVL_Unit = tempoc2
		OTCurrent=tempoc; -- current raid frame
		OTCurrent2=tempoc2; -- current unit id
		OTCurrent3=tempoc3; -- current raid frame number
		oilvlSaveItemLevel(0)
		C_Timer.After(1,function() oilvlSaveItemLevel(0) end)
		C_Timer.After(2,function() oilvlSaveItemLevel(1) end)
	end
	--print(guid,GetTime() - LastInspectTime)
	LastInspectTime = GetTime()
	-- GameTooltip
	if (Omover ==1) and cfg.MVPvsms then
		Omover=0;
		if not UnitAffectingCombat("player")  and cfg.MVPvsms and UnitExists("target") and CheckInteractDistance("target", 1) then
			local oname, _ = GameTooltip:GetUnit();
			if oname ~= nil then oname = oname:gsub("%-.+", ""); else return -1; end
			if oname ~= GetUnitName("target",""):gsub("%-.+", "") then return -1; end
			local OTilvl2, OTmia2, missenchant, missgem = OTgathertil(UnitGUID("target"),"target")
			if (OTmia2 == 0) then
				local i=0;
				local omatch=false;
				local oospec = ospec[GetInspectSpecialization("target")];
				if oospec then
					-- spec
					for i = 2, GameTooltip:NumLines() do
						local msg = _G["GameTooltipTextLeft"..i]:GetText();
						if msg then
							msg = msg:find(SPECIALIZATION..":");
						end
						if msg then
							_G["GameTooltipTextLeft"..i]:SetText(SPECIALIZATION..": |r|cFF00FF00"..oospec);
							omatch=true;
							break;
						end
					end
					if not omatch then
						GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
						GameTooltip:AddLine(SPECIALIZATION..": |r|cFF00FF00"..oospec);
					end
					-- item level
					omatch=false;
					for i = 2, GameTooltip:NumLines() do
						local msg = _G["GameTooltipTextLeft"..i]:GetText();
						if msg then
							msg = msg:find(L["Item Level"]..":");
						end
						if msg then
							_G["GameTooltipTextLeft"..i]:SetText(L["Item Level"]..": |r|cFF00FF00"..OTilvl2);
							omatch=true;
							break;
						end
					end
					if not omatch then
						GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
						GameTooltip:AddLine(L["Item Level"]..": |r|cFF00FF00"..OTilvl2);
					end
				end
			else
				local i=0;
				local omatch=false;
				local oospec = ospec[GetInspectSpecialization("target")];
				-- spec
				for i = 2, GameTooltip:NumLines() do
					local msg = _G["GameTooltipTextLeft"..i]:GetText();
					if msg then
						msg = msg:find("Spec:");
					end
					if msg and oospec ~= nil then
						_G["GameTooltipTextLeft"..i]:SetText(L["Item Level"]..": |r|cFF00FF00"..oospec);
						omatch=true;
						break;
					end
				end
				if not omatch and oospec ~= nil then
					GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
					GameTooltip:AddLine(L["Item Level"]..":".."|r|cFF00FF00"..oospec);
				end
				-- item level
				omatch=false;
				for i = 2, GameTooltip:NumLines() do
					local msg = _G["GameTooltipTextLeft"..i]:GetText();
					if msg then
						msg = msg:find(L["Item Level"]..":");
					end
					if msg and OTilvl2 then
						_G["GameTooltipTextLeft"..i]:SetText(L["Item Level"]..": |r|cFFFF0000"..OTilvl2);
						omatch=true;
						break;
					end
				end
				if not omatch and OTilvl2 then
					GameTooltip:SetHeight(GameTooltip:GetHeight()+15);
					GameTooltip:AddLine(L["Item Level"]..": |r|cFFFF0000"..OTilvl2);
				end
				Oilvltimer:ScheduleTimer(OMouseover,1);
			end
		end
		OILVL:UnregisterEvent("INSPECT_READY")
	end
end

local LastInspectATime = GetTime()
function events:INSPECT_ACHIEVEMENT_READY(...)
	if not UnitAffectingCombat("player")  and GetTime() - LastInspectATime > 2.5 then
		if cfg.MVPvsms then
			if Omover2 == 1 then
				if UnitExists(rpunit) and CheckInteractDistance(rpunit, 1) and rpsw then
					if cfg.raidmenuid == 1 then OGetRaidProgression2(ULDname, OSTATULD, 11); end
					-- if cfg.raidmenuid == 4 then OGetRaidProgression2(TOVname, OSTATTOV, 3); end
					-- if cfg.raidmenuid == 3 then OGetRaidProgression2(TNname, OSTATTN, 10); end
					-- if cfg.raidmenuid == 2 then OGetRaidProgression2(TOSname, OSTATTOS, 9); end
					-- if cfg.raidmenuid == 1 then OGetRaidProgression2(ABTname, OSTATABT, 11); end
				else
					--ClearAchievementComparisonUnit();
					rpsw=false;
					rpunit="";
					Omover2=0;
				end
			elseif Omover2 == 2 then
				if UnitExists(rpunit) and CheckInteractDistance(rpunit, 1) and rpsw then
					if cfg.raidmenuid == 1 then OGetRaidProgression3(ULDname, OSTATULD, 11); end
					-- if cfg.raidmenuid == 4 then OGetRaidProgression3(TOVname, OSTATTOV, 3); end
					-- if cfg.raidmenuid == 3 then OGetRaidProgression3(TNname, OSTATTN, 10); end
					-- if cfg.raidmenuid == 2 then OGetRaidProgression3(TOSname, OSTATTOS, 9); end
					-- if cfg.raidmenuid == 1 then OGetRaidProgression3(ABTname, OSTATABT, 11); end
				else
					--ClearAchievementComparisonUnit();
					rpsw=false;
					rpunit="";
					Omover2=0;
				end
			else
				if UnitExists("target") and CheckInteractDistance("target", 1)  and rpsw then
					if cfg.raidmenuid == 1 then OGetRaidProgression(ULDname, OSTATULD, 11); end
					-- if cfg.raidmenuid == 4 then OGetRaidProgression(TOVname, OSTATTOV, 3); end
					-- if cfg.raidmenuid == 3 then OGetRaidProgression(TNname, OSTATTN, 10); end
					-- if cfg.raidmenuid == 2 then OGetRaidProgression(TOSname, OSTATTOS, 9); end
					-- if cfg.raidmenuid == 1 then OGetRaidProgression(ABTname, OSTATABT, 11); end
				else
					--ClearAchievementComparisonUnit();
					rpsw=false;
					rpunit="";
					Omover2=0;
				end
			end
		end
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		LastInspectATime = GetTime()
	end
	C_Timer.After(2, function()
		if AchievementFrame and AchievementFrameComparison and AchievementFrame:IsShown() and AchievementFrameComparison:IsShown() then
			if tonumber(AchievementFrameComparisonHeaderPoints:GetText()) == 0 then
				--print(AchievementFrameComparisonHeaderName:GetText())
				InspectAchievements("target")
				--C_Timer.After(2, function() print(AchievementFrameComparisonHeaderPoints:GetText()) end)
			end
		end
	end)
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

function events:GROUP_ROSTER_UPDATE(...)
	if not UnitAffectingCombat("player")  then
		if oilvlframesw then OResetSendMark(); OilvlCheckFrame(); end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		oilvlUpdateLDBTooltip()
	end
end

function events:RAID_ROSTER_UPDATE(...)
	if not UnitAffectingCombat("player")  then
		if oilvlframesw then OResetSendMark(); OilvlCheckFrame(); end
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2=0;
		oilvlUpdateLDBTooltip()
	end
end

function events:PLAYER_SPECIALIZATION_CHANGED(...)
	if not UnitAffectingCombat("player")  then
		C_Timer.After(0.8,function()
			if IsInRaid() then
				for i=1,40 do
					if GetRaidRosterInfo(i) == UnitName("player") then
						MVPvsSetABCD(i)
						break
					end
				end
			else
				MVPvsSetABCD(1)
			end
		end)
	end
end

local repeatsw = false;
local bagupdatesw=false;

function events:ADDON_LOADED(...)
	OILVL:UnregisterEvent("BAG_UPDATE")
	bagupdatesw=false
end

function events:PLAYER_LOGIN(...)
	cfg = MVP_Settings;
	if cfg.MVPvsframeP == nil then cfg.MVPvsframeP = "TOPLEFT"; end
	if cfg.MVPvsframeX == nil then cfg.MVPvsframeX = 15; end
	if cfg.MVPvsframeY == nil then cfg.MVPvsframeY = -60; end
	if cfg.MVPvsscale  == nil then cfg.MVPvsscale = 0.8; end
	if cfg.MVPvsalpha  == nil then cfg.MVPvsalpha = 1; end
	if cfg.raidmenuid  == nil then cfg.raidmenuid = 1; end
	if cfg.MVPvsms == nil then cfg.MVPvsms = true; end
	if cfg.MVPvsme == nil then cfg.MVPvsme = true; end
	if cfg.MVPvsme2 == nil then cfg.MVPvsme2 = false; end
	if cfg.MVPvscharilvl == nil then cfg.MVPvscharilvl = true; end
	if cfg.MVPvsrpdetails == nil then cfg.MVPvsrpdetails = true; end
	if cfg.MVPvsgears == nil then cfg.MVPvsgears = {}; end
	if cfg.MVPvscache == nil then cfg.MVPvscache = {}; end
	if cfg.MVPvscachesw == nil then cfg.MVPvscachesw = true; end
	if cfg.MVPvsminimapicon == nil then cfg.MVPvsminimapicon = true; end
	if cfg.MVPvsprintloaded == nil then cfg.MVPvsprintloaded = false; end
	if cfg.MVPvsdp == nil then cfg.MVPvsdp = 1 end
	if cfg.MVPvsun == nil then cfg.MVPvsun = true end
	if cfg.MVPvsge == nil then cfg.MVPvsge = true end
	if cfg.MVPvsaltclickroll == nil then cfg.MVPvsaltclickroll = true end
	if cfg.MVPvsautoscan == nil then cfg.MVPvsautoscan = true end
	if cfg.MVPvssamefaction == nil then cfg.MVPvssamefaction = false end
	if cfg.MVPvsbagilvl == nil then cfg.MVPvsbagilvl = true end
	if cfg.MVPvscolormatchitemrarity == nil then cfg.MVPvscolormatchitemrarity = true end
	OilvlConfigFrame();
	oilvlframe();
	OVILRefresh();
	if cfg.MVPvsprintloaded then
		print("M V P  (|cFFFFFF00OiLvL|r|cFFFFFFFF) |r|cFF00FF00v"..GetAddOnMetadata("Oilvl","Version").." |r|cFFFFFFFF is loaded.")
	end
	if minimapicon then
		minimapicon:Register("M V P ",LDB, cfg)
		if cfg.MVPvsminimapicon then
			C_Timer.After(1, function() minimapicon:Show("M V P ") end)
		else
			C_Timer.After(1, function() minimapicon:Hide("M V P ") end)
		end
	end
	if cfg.MVPvsaltclickroll then
		if not lootslotSW then C_Timer.After(5,function() oilvlaltc() end); end
		if not oilvlOnHyperlinkClickSW then C_Timer.After(5,function() oilvlOnHyperlinkClick() end); end
	end
	oilvlSetOSTATULD()
	-- oilvlSetOSTATTN()
	-- oilvlSetOSTATTOV()
	-- oilvlSetOSTATTOS()
	-- oilvlSetOSTATABT()
	--[[Fix for Lua errors with Blizzard_AchievementUI below]]--
	local unregistered,reregistered
	local function reregisterBlizz()
		if not reregistered then
			AchievementFrameComparison:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
			reregistered=true
		end
	end
	local function unregisterBlizz(name)
		if not unregistered then
			if not name or name=="Blizzard_AchievementUI" then
				AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
				hooksecurefunc("InspectAchievements",reregisterBlizz)
				unregistered=true
			end
		end
	end
	if IsAddOnLoaded("Blizzard_AchievementUI") then
		unregisterBlizz()
	else
		hooksecurefunc("LoadAddOn",unregisterBlizz)
	end
	----------------------------------
	GameTooltip:HookScript("OnTooltipSetUnit", function()
		if not UnitAffectingCombat("player")  and cfg.MVPvsms and UnitExists("target") and not IsInRaid() and not IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and not IsInGroup(LE_PARTY_CATEGORY_HOME) then
			local oname, _ = GameTooltip:GetUnit()
			if oname ~= nil then oname = oname:gsub("%-.+", ""); else return -1; end
			if  oname == GetUnitName("target",""):gsub("%-.+", "") then
				OMouseover();
			end
		end
	end);
end

function events:PLAYER_ENTERING_WORLD(...)
	OILVL:UnregisterEvent("BAG_UPDATE")
	bagupdatesw=false
	collectgarbage()
	if not repeatsw then
		repeatsw = true
		OilvlCheckFrame();
		ShowUIPanel(InterfaceOptionsFrame);
		InterfaceOptionsFrame.lastFrame = GameMenuFrame;
		InterfaceOptionsFrameTab2:Click();
		InterfaceOptionsFrameOkay:Click()
		HideUIPanel(GameMenuFrame);
		C_Timer.After(2, function() Oilvltimer:ScheduleRepeatingTimer(oilvlcheckrange,3) end);
		C_Timer.After(3, function() Oilvltimer:ScheduleRepeatingTimer(OilvlRPDTimeCheck,1) end);
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2 = 0;
		hooksecurefunc("OpenAllBags",function() oilvlShowBagItemLevel() C_Timer.After(0.3, oilvlShowBagItemLevel) end)
		hooksecurefunc("ToggleAllBags",function() oilvlShowBagItemLevel() C_Timer.After(0.3, oilvlShowBagItemLevel) end)
		hooksecurefunc("ToggleBag",function() oilvlShowBagItemLevel() C_Timer.After(0.3, oilvlShowBagItemLevel) end)
		hooksecurefunc("OpenBag",function() oilvlShowBagItemLevel() C_Timer.After(0.3, oilvlShowBagItemLevel) end)
		if Bagnon and BagnonFrameinventory then
			BagnonFrameinventory:HookScript('onShow', function()
				oilvlShowBagItemLevel()
				C_Timer.After(0.3, oilvlShowBagItemLevel)
			end)
		end
	end
end

function events:PLAYER_LEAVING_WORLD(...)
	OILVL:UnregisterEvent("BAG_UPDATE")
	bagupdatesw=false
end

function events:PLAYER_REGEN_DISABLED(...)
	if oilvlframesw then
		local nn=1;
		for nn=1, 40 do
			_G["OILVLRAIDFRAME"..nn]:Disable();
		end
		OILVLREFRESH:Hide();
	end
	rescanilvl = 0
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	--ClearAchievementComparisonUnit();
	rpsw=false;
	rpunit="";
	Omover2 = 0;
	orollgear = ""
	oilvlUpdateLDBTooltip()
	otooltip6sw = false

	OILVL_Unit="";
	OTCurrent = "";
	OTCurrent2 = "";
	OTCurrent3 = "";
end

function events:PLAYER_REGEN_ENABLED(...)
	if oilvlframesw then
		local nn=1;
		for nn=1, 40 do
			if not _G["OILVLRAIDFRAME"..nn]  then break; end
			_G["OILVLRAIDFRAME"..nn]:Disable();
			_G["OILVLRAIDFRAME"..nn]:Enable();
		end
		OILVLREFRESH:Show();
		OilvlCheckFrame();
	end
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	--ClearAchievementComparisonUnit();
	rpsw=false;
	rpunit="";
	Omover2 = 0;
	orollgear = ""
	oilvlUpdateLDBTooltip()

	OILVL_Unit="";
	OTCurrent = "";
	OTCurrent2 = "";
	OTCurrent3 = "";
end

function events:ROLE_CHANGED_INFORM(...)
	if oilvlframesw then OilvlCheckFrame() end
	local changedPlayer, _, oldrole, role = ...;
	if oilvlframesw then
		if IsInRaid() then
			local rnum = GetNumGroupMembers();
			local i = 1;
			for i = 1, rnum do
				if GetUnitName("raid"..i,true) == changedPlayer then
					OilvlSetRole(i, role);
					if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
				end
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			local rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
			if GetUnitName("player",true) == changedPlayer then
				OilvlSetRole(1, role);
				if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
			end
			local i = 2;
			for i = 2, rnum do
				if GetUnitName("party"..(i-1),true) == changedPlayer then
					OilvlSetRole(i, role);
					if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
				end
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			local rnum = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
			if GetUnitName("player",true) == changedPlayer then
				OilvlSetRole(1, role);
				if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
			end
			local i = 2;
			for i = 2, rnum do
				if GetUnitName("party"..(i-1),true) == changedPlayer then
					OilvlSetRole(i, role);
					if oldrole ~= "NONE" then NumRole[oldrole] = NumRole[oldrole] - 1; end
				end
			end
		end
	end
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	--ClearAchievementComparisonUnit();
	rpsw=false;
	rpunit="";
	Omover2=0;
	oilvlUpdateLDBTooltip()
end

function events:LFG_ROLE_UPDATE(...)
	if oilvlframesw then OilvlCheckFrame() end
	OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	--ClearAchievementComparisonUnit();
	rpsw=false;
	rpunit="";
	Omover2=0;
	oilvlUpdateLDBTooltip()
end

function events:BAG_UPDATE(n)
	if bagilvltime == 0 then oilvlShowBagItemLevel() end
	if GetTime() - bagilvltime > 0.3 then
		oilvlShowBagItemLevel()
	end
	bagilvltime = GetTime()
end

OILVL:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...); -- call one of the functions above
end);

for k, v in pairs(events) do
 OILVL:RegisterEvent(k); -- Register all events for which handlers have been defined
end

-- Set GameTooltip
function OMouseover()
	if InspectFrame and (InspectFrame.unit or InspectFrame:IsShown()) then return -1 end
	if not UnitExists("target") or not CheckInteractDistance("target", 1) then
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover2 = 0;
		return -1;
	end
	if InspectFrame and InspectFrame.unit then return -1 end
	if not UnitAffectingCombat("player")  and cfg.MVPvsms and oilvlframesw then
		if CheckInteractDistance("target", 1) and CanInspect("target") then
			-- if (cfg.MVPvssamefaction and UnitFactionGroup("player") == UnitFactionGroup("target")) then
			if not cfg.MVPvssamefaction then
				OILVL:RegisterEvent("INSPECT_READY");
				NotifyInspect("target");
				Omover=1;
				if not rpsw then
					ClearAchievementComparisonUnit();
					OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
					SetAchievementComparisonUnit("target");
					rpunit = "target";
					rpsw=true;
				end
			else
				if UnitFactionGroup("player") == UnitFactionGroup("target") then
					OILVL:RegisterEvent("INSPECT_READY");
					NotifyInspect("target");
					Omover=1;
					if not rpsw then
						ClearAchievementComparisonUnit();
						OILVL:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
						SetAchievementComparisonUnit("target");
						rpunit = "target";
						rpsw=true;
					end
				end
			end
		end
	end
end

function OilvlRaidMenu()
	if not ORaidDropDownMenu then
	   CreateFrame("frame", "ORaidDropDownMenu", cfg.frame, "L_UIDropDownMenuTemplate")
	end

	ORaidDropDownMenu:ClearAllPoints()
	ORaidDropDownMenu:SetPoint("TOPLEFT", cfg.frame, "TOPLEFT", 16+25, -230)
	ORaidDropDownMenu:Show()

	local items = {
		-- ABTname,
		-- TOSname,
		-- TNname,
		-- TOVname,
		ULDname,
	}

	local function OnClick(self)
		L_UIDropDownMenu_SetSelectedID(ORaidDropDownMenu, self:GetID())
		cfg.raidmenuid = self:GetID()
	end

	local function initialize(self, level)
	   local info = L_UIDropDownMenu_CreateInfo()

	   for k,v in pairs(items) do
		  info = L_UIDropDownMenu_CreateInfo()
		  info.text = v
		  info.value = v
		  info.func = OnClick
		  L_UIDropDownMenu_AddButton(info)
	   end
	end

	L_UIDropDownMenu_SetWidth(ORaidDropDownMenu, 150);
	L_UIDropDownMenu_Initialize(ORaidDropDownMenu, initialize)
	L_UIDropDownMenu_SetButtonWidth(ORaidDropDownMenu, 124)
	L_UIDropDownMenu_SetSelectedID(ORaidDropDownMenu, cfg.raidmenuid)
	L_UIDropDownMenu_JustifyText(ORaidDropDownMenu, "LEFT")
end

function OilvlConfigFrame()
	cfg.frame = CreateFrame("Frame", "OiLvLConfig",InterfaceOptionsFramePanelContainer)
	cfg.frame.name = "M V P  (Jany)"
	InterfaceOptions_AddCategory(cfg.frame)

	local title = cfg.frame:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
	title:SetPoint("TOPLEFT",16,-16)
	title:SetText("M V P  (Jany) v"..GetAddOnMetadata("MostValuablePlayer","Version")) -- can get version from GetAddOnMetadata

--  oilvl scale
	local oscale = CreateFrame("Slider", "Oilvlscale", cfg.frame, "OptionsSliderTemplate")
	oscale:SetWidth(200)
	oscale:SetHeight(20)
	oscale:SetOrientation('HORIZONTAL');
	oscale:SetPoint("TOPLEFT",16,-70);

	local scaletitle = oscale:CreateFontString(nil,"ARTWORK","GameFontNormal")
	scaletitle:SetPoint("LEFT",oscale,"LEFT",0,35)
	scaletitle:SetText("M V P  Frame");

	getglobal(oscale:GetName() .. 'Low'):SetText('1'); --Sets the left-side slider text (default is "Low").
	getglobal(oscale:GetName() .. 'High'):SetText('100'); --Sets the right-side slider text (default is "High").
	getglobal(oscale:GetName() .. 'Text'):SetText(L["Scale"]); --Sets the "title" text (top-centre of slider).

	oscale:SetMinMaxValues(0, 2);
	oscale:SetValue(cfg.MVPvsscale);
	oscale:RegisterForDrag("LeftButton");
	oscale:SetScript("OnDragStop", function(self, button)
	local n=oscale:GetValue();
		if n > 0 then
			OIVLFRAME:SetScale(n)
			cfg.MVPvsscale = n;
		end
	end);
	oscale:SetScript("OnMouseDown", function(self, button)
	local n=oscale:GetValue();
		if n > 0 then
			OIVLFRAME:SetScale(n)
			cfg.MVPvsscale = n;
		end
	end);

--  oilvl opacity
	local oalpha = CreateFrame("Slider", "Oilvlalpha", cfg.frame, "OptionsSliderTemplate")
	oalpha:SetWidth(200)
	oalpha:SetHeight(20)
	oalpha:SetOrientation('HORIZONTAL');
	oalpha:SetPoint("TOPLEFT",16,-120);

	getglobal(oalpha:GetName() .. 'Low'):SetText('0'); --Sets the left-side slider text (default is "Low").
	getglobal(oalpha:GetName() .. 'High'):SetText('1'); --Sets the right-side slider text (default is "High").
	getglobal(oalpha:GetName() .. 'Text'):SetText(OPACITY); --Sets the "title" text (top-centre of slider).

	oalpha:SetMinMaxValues(0, 1);
	oalpha:SetValue(cfg.MVPvsalpha);
	oalpha:RegisterForDrag("LeftButton");
	oalpha:SetScript("OnMouseDown", function(self, button)
	local n=oalpha:GetValue();
		OIVLFRAME:SetAlpha(n)
		cfg.MVPvsalpha = n;
	end);
	oalpha:SetScript("OnDragStop", function(self)
	local n=oalpha:GetValue();
		OIVLFRAME:SetAlpha(n)
		cfg.MVPvsalpha = n;
	end);

	-- Raid Progression Checkbutton
	function createCheckbutton(parent, x_loc, y_loc, varname, displayname)
		local checkbutton = CreateFrame("CheckButton", varname, parent, "ChatConfigCheckButtonTemplate");
		checkbutton:SetPoint("TOPLEFT", parent, "TOPLEFT", x_loc, y_loc);
		_G[varname..'Text']:SetText(displayname);
		checkbutton:SetHitRectInsets(0,0,0,0);
		return checkbutton;
	end

	-- Tooltips option
	local mscb = createCheckbutton(cfg.frame, 16, -170, "oilvlsilvl"," "..L["Enable Showing item level / raid progression on tooltips"]);
	mscb:SetSize(30,30);
	mscb:SetScript("PostClick", function()
		cfg.MVPvsms = oilvlsilvl:GetChecked()
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover=0
		Omover2 = 0;
		if oilvlsilvl:GetChecked() then
			L_UIDropDownMenu_EnableDropDown(ORaidDropDownMenu)
		else
			L_UIDropDownMenu_DisableDropDown(ORaidDropDownMenu)
		end
	end);
	if cfg.MVPvsms then mscb:SetChecked(true) end

	-- Raid Progression Details
	local rpdcb = createCheckbutton(cfg.frame, 16+25, -200, "oilvlsrpd", " "..L["Enable Showing Raid Progression Details on tooltips"]);
	rpdcb:SetSize(30,30);
	rpdcb:SetScript("PostClick", function()
		cfg.MVPvsrpdetails = oilvlsrpd:GetChecked()
		OILVL:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
		--ClearAchievementComparisonUnit();
		rpsw=false;
		rpunit="";
		Omover=0
		Omover2 = 0;
	end);
	if cfg.MVPvsrpdetails then rpdcb:SetChecked(true) end

	OilvlRaidMenu()

	-- miss enchant option
	local eercb = createCheckbutton(cfg.frame, 16, -260, "oilvleer"," "..L["Enable Sending Enchantment Reminder"]);
	eercb:SetSize(30,30);
	eercb:SetScript("PostClick", function()
		cfg.MVPvsme = oilvleer:GetChecked()
		oilvlercb:SetChecked(cfg.MVPvsme)
		if oilvleer:GetChecked() then oilvlbestenchant:Enable(); else	oilvlbestenchant:Disable(); end
	end);
	eercb:SetChecked(cfg.MVPvsme);

	-- 通报MVP
	local cfilvlcb1 = createCheckbutton(cfg.frame, 16, -500, "oilvlcfilvl1"," ".."开启大秘境通关MVP通报");
	cfilvlcb1:SetSize(30,30);
	cfilvlcb1:SetScript("PostClick", function() 
		if cfg.MVPvsnoti == false then
			cfg.MVPvsnoti = true
			print("通报已经打开")
		else
			cfg.MVPvsnoti = false
			print("通报已经关闭")
		end
		
		end);
	if cfg.MVPvsnoti then cfilvlcb1:SetChecked(true) end

		-- 鼠标提示MVP 
	local cfilvlcb2= createCheckbutton(cfg.frame, 16, -530, "oilvlcfilvl2"," ".."开启鼠标锚点提示MVP信息");
	cfilvlcb2:SetSize(30,30);
	cfilvlcb2:SetScript("PostClick", function() 
		if cfg.MVPvsline == false then
			cfg.MVPvsline = true
			print("鼠标提示MVP已经打开")
		else
			cfg.MVPvsline = false
			print("鼠标提示MVP已经关闭")
		end
		
		end);
	if cfg.MVPvsline then cfilvlcb2:SetChecked(true) end


	-- character frame item level option
	local cfilvlcb = createCheckbutton(cfg.frame, 16, -320, "oilvlcfilvl"," "..L["Enable Showing Gear Item Level on Character Frame"]);
	cfilvlcb:SetSize(30,30);
	cfilvlcb:SetScript("PostClick", function() cfg.MVPvscharilvl = oilvlcfilvl:GetChecked() OiLvlPlayer_Update() end);
	if cfg.MVPvscharilvl then cfilvlcb:SetChecked(true) end

	-- best enchant option
	local eercb2 = createCheckbutton(cfg.frame, 16+25, -290, "oilvlbestenchant", " "..BEST.." "..ENSCRIBE);
	eercb2:SetSize(30,30);
	eercb2:SetScript("PostClick", function()
		cfg.MVPvsme2 = oilvlbestenchant:GetChecked()
		if CharacterFrame and CharacterFrame:IsShown() and OiLvlPlayer_Update then
			OiLvlPlayer_Update()
		end
		if InspectFrame and InspectFrame:IsShown() and OiLvLInspect_Update then
			OiLvLInspect_Update()
		end
	end);
	eercb2:SetChecked(cfg.MVPvsme2);
	if oilvleer:GetChecked() then oilvlbestenchant:Enable(); else oilvlbestenchant:Disable(); end

	-- minimap icon option
	local micon = createCheckbutton(cfg.frame, 16, -410, "oilvlshowminimap", L["Show minimap button"]);
	micon:SetSize(30,30);
	micon:SetScript("PostClick", function()
		cfg.MVPvsminimapicon = oilvlshowminimap:GetChecked()
		if cfg.MVPvsminimapicon then
			minimapicon:Show("M V P ")
		else
			minimapicon:Hide("M V P ")
		end
	end);
	micon:SetChecked(cfg.MVPvsminimapicon);

	-- print loaded message
	local printload = createCheckbutton(cfg.frame, 16, -470, "oilvlprintloaded", L["Print Loaded Message"]);
	printload:SetSize(30,30);
	printload:SetScript("PostClick", function()
		cfg.MVPvsprintloaded = oilvlprintloaded:GetChecked()
	end);
	printload:SetChecked(cfg.MVPvsprintloaded);

	-- print loaded message
	local summaryshow = createCheckbutton(cfg.frame, 16+25, -380, "oilvlLevelSummary", L["Show overall iLevel at the top of the CharacterFrame"]);
	summaryshow:SetSize(30,30);
	summaryshow:SetScript("PostClick", function()
		cfg.MVPvssummaryshow = summaryshow:GetChecked()
	end);
	summaryshow:SetChecked(cfg.MVPvssummaryshow);

	-- item level decimal places
	local dptitle = cfg.frame:CreateFontString(nil,"ARTWORK","GameFontNormal")
	dptitle:SetTextColor(1,1,1)
	dptitle:SetPoint("TOPLEFT",16,-450)
	dptitle:SetText(L["Set the amount of numbers past the decimal place to show"].."(0-2): ")
	local dp = CreateFrame("EditBox", "ODP",cfg.frame,"InputBoxTemplate")
	dp:SetWidth(15)
	dp:SetHeight(20)
	dp:SetPoint("TOPLEFT",20+dptitle:GetStringWidth(),-447)
	dp:SetFontObject("GameFontNormal")
	dp:SetTextColor(1,1,1)
	dp:SetMaxLetters(1)
	dp:SetNumber(cfg.MVPvsdp)
	dp:SetNumeric(true)
	dp:SetAutoFocus(false)
	dp:ClearFocus()
	dp:SetScript("OnChar",function(self, key)
		if dp:GetText() == nil or dp:GetText() == "" then dp:SetNumber(cfg.MVPvsdp) end
		if tonumber(key) > 2 then dp:SetNumber(2) end
		if tonumber(key) < 0 then dp:SetNumber(0) end
		if not tonumber(dp:GetText()) then dp:SetNumber(cfg.MVPvsdp) end
		dp:HighlightText(0)
	end)
	dp:SetScript("OnEnterPressed",function(self) cfg.MVPvsdp = tonumber(dp:GetText()) dp:ClearFocus() OVILRefresh() end)
	dp:SetScript("OnEscapePressed",function(self) dp:SetNumber(cfg.MVPvsdp) dp:ClearFocus() end)

	-- upgrade number
	local upgradenumbercb = createCheckbutton(cfg.frame, 16+25, -350, "oilvlupgradeno",ITEM_UPGRADE_TOOLTIP_FORMAT:gsub(": %%d/%%d",""):gsub("：",""):gsub("%%d/%%d",""));
	upgradenumbercb:SetSize(30,30);
	upgradenumbercb:SetScript("PostClick", function() cfg.MVPvsun = oilvlupgradeno:GetChecked() OiLvlPlayer_Update() end);
	if cfg.MVPvsun then upgradenumbercb:SetChecked(true) end
end

function LDB:OnClick(button)
	if button == "LeftButton" then
		if not UnitAffectingCombat("player") then
			if OIVLFRAME:IsShown() then
				OIVLFRAME:Hide();
			else
				OIVLFRAME:ClearAllPoints();
				OIVLFRAME:SetPoint(cfg.MVPvsframeP, cfg.MVPvsframeX, cfg.MVPvsframeY);
				OIVLFRAME:SetScale(cfg.MVPvsscale);
				OIVLFRAME:SetAlpha(cfg.MVPvsalpha);
				OIVLFRAME:Show();
			end
		else
			print(ERR_NOT_IN_COMBAT)
		end
	end
	if button == "RightButton" then
		--PlaySound("igMainMenuOption");
		InterfaceOptionsFrameTab2:Click();
		InterfaceOptionsFrame_OpenToCategory("M V P  (Jany)")
	end
	if button == "MiddleButton" or button == "MiddleButtonDown" then
		if otooltip5 ~= nil then
			if LibQTip:IsAcquired("OiLvLAlt") then otooltip5:Clear() end
			otooltip5:Hide()
			LibQTip:Release(otooltip5)
			otooltip5 = nil
		else
			otooltip5func()
		end
	end
end

BINDING_HEADER_OiLvL = "M V P "
BINDING_NAME_OILVL_RAID_PROGRESSION = L["Raid Progression"]

function OMouseover2()
	if not UnitAffectingCombat("player")  and cfg.MVPvsms and UnitExists("target") then
		local oname, _ = GameTooltip:GetUnit()
		if oname ~= nil then oname = oname:gsub("%-.+", ""); else return -1; end
		if  oname == GetUnitName("target",""):gsub("%-.+", "") then
			OMouseover();
		end
	end
end

function oilvlaltc()
	lootslotSW = true;
	for i = 1, LOOTFRAME_NUMBUTTONS do
		_G["LootButton"..i]:HookScript("OnClick", function(self, button)
			if IsAltKeyDown() then
				local link = GetLootSlotLink(i);
				local scantip = CreateFrame("GameTooltip", "OiLvlRoll_Tooltip", nil, "GameTooltipTemplate")
				local silvl="";
				orollgear = link;
				scantip:SetOwner(UIParent, "ANCHOR_NONE")
				scantip:SetHyperlink(orollgear)
				for i = 2, scantip:NumLines() do
					local text = _G["OiLvlRoll_TooltipTextLeft"..i]:GetText()
					if text and text ~= "" then	silvl = text:match(ITEM_LEVEL:gsub("%%d","(%%d+)")) end
					if silvl ~= nil then break end
				end
				if silvl == nil then silvl = "" end
				if UnitIsGroupLeader("player") then
					ChatFrame_OpenChat("/rw "..silvl.." "..link.." "..ROLL.." ")
				end
				if otooltip4 ~= nil then
					otooltip4:Hide()
					LibQTip:Release(otooltip4)
					otooltip4 = nil
				end
				orolln = 0;
				oroll = {};
				orolln = orolln + 1;
				oroll[1] = {silvl,link,""}
				otooltip4func();
			else
				orollgear = "";
			end
		end)
	end
end

GameTooltip:HookScript("OnHide", function(self)
	if otooltip ~= nil then
		LibQTip:Release(otooltip)
		otooltip = nil
	end
end)

SLASH_OILVL_OILVL1 = "/oilvl"
SLASH_OILVL_OILVL2 = "/oi"

SlashCmdList["OILVL_OILVL"] = function()
	if not UnitAffectingCombat("player") then
		OIVLFRAME:ClearAllPoints();
		OIVLFRAME:SetPoint(cfg.MVPvsframeP, cfg.MVPvsframeX, cfg.MVPvsframeY);
		OIVLFRAME:SetScale(cfg.MVPvsscale);
		OIVLFRAME:SetAlpha(cfg.MVPvsalpha);
		OIVLFRAME:Show();
	else
		print(ERR_NOT_IN_COMBAT)
	end
end

SLASH_OILVL_OICFG1 = "/oicfg"

SlashCmdList["OILVL_OICFG"] = function()
	InterfaceOptionsFrameTab2:Click();
	InterfaceOptionsFrame_OpenToCategory("M V P  (Jany)")
end

SLASH_OILVL_OIROLL1 = "/oiroll"
SLASH_OILVL_OIROLL2 = "/oir"

SlashCmdList["OILVL_OIROLL"] = function(msg)
	if msg:match("|c.*|r") ~= nil then
		local scantip = CreateFrame("GameTooltip", "OiLvlRoll_Tooltip", nil, "GameTooltipTemplate")
		local silvl="";
		orollgear = msg:match("|c.*|r");
		scantip:SetOwner(UIParent, "ANCHOR_NONE")
		scantip:SetHyperlink(orollgear)
		for i = 2, scantip:NumLines() do
			local text = _G["OiLvlRoll_TooltipTextLeft"..i]:GetText()
			if text and text ~= "" then	silvl = text:match(ITEM_LEVEL:gsub("%%d","(%%d+)")) end
			if silvl ~= nil then break end
		end
		if silvl == nil then silvl = "" end
		if UnitIsGroupLeader("player") then
			SendChatMessage(ROLL.." "..silvl.." "..msg:match("|c.*|r").." "..msg:gsub("|c.*|r","").."", "RAID_WARNING")
		end
		if otooltip4 ~= nil then
			otooltip4:Hide()
			LibQTip:Release(otooltip4)
			otooltip4 = nil
		end
		orolln = 0;
		oroll = {};
		orolln = orolln + 1;
		oroll[1] = {silvl,msg:match("|c.*|r"),msg:gsub("|c.*|r","")}
		otooltip4func();
	else
		orollgear = "";
	end
end

StaticPopupDialogs["RELOAD"] = {
	text = SLASH_RELOAD1.."?",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}

SLASH_OILVL_OIRALTC1 = "/oiraltc"
SlashCmdList["OILVL_OIRALTC"] = function(msg)
	local token = {msg}
	if string.upper(token[1]) == "OFF" then
		cfg.MVPvsaltclickroll = false
		print("OiLvL: Lootframe Alt-click feature is disabled")
		StaticPopup_Show ("RELOAD")
	end
	if  string.upper(token[1]) == "ON" then
		cfg.MVPvsaltclickroll = true
		print("OiLvL: Lootframe Alt-click feature is enabled")
		StaticPopup_Show ("RELOAD")
	end
end

SLASH_OILVL_OIALT1 = "/oialt"
SLASH_OILVL_OIALT2 = "/oia"
SlashCmdList["OILVL_OIALT"] = function(msg)  otooltip5func() end

SLASH_OILVL_OICACHE1 = "/oicache"
SLASH_OILVL_OICACHE2 = "/oic"
SlashCmdList["OILVL_OICACHE"] = function(msg)  otooltip7func() end

function oilvlOnHyperlinkClick()
	oilvlOnHyperlinkClickSW = true
	DEFAULT_CHAT_FRAME:HookScript("OnHyperlinkClick", function(self, linkData, link, button)
		if IsAltKeyDown() then
			local scantip = CreateFrame("GameTooltip", "OiLvlRoll_Tooltip", nil, "GameTooltipTemplate")
			local silvl="";
			orollgear = link;
			scantip:SetOwner(UIParent, "ANCHOR_NONE")
			scantip:SetHyperlink(orollgear)
			for i = 2, scantip:NumLines() do
				local text = _G["OiLvlRoll_TooltipTextLeft"..i]:GetText()
				if text and text ~= "" then	silvl = text:match(ITEM_LEVEL:gsub("%%d","(%%d+)")) end
				if silvl ~= nil then break end
			end
			if silvl == nil then silvl = "" end
			if UnitIsGroupLeader("player") then
				SendChatMessage(ROLL.." "..silvl.." "..link, "RAID_WARNING")
			end
			if otooltip4 ~= nil then
				otooltip4:Hide()
				LibQTip:Release(otooltip4)
				otooltip4 = nil
			end
			orolln = 0;
			oroll = {};
			orolln = orolln + 1;
			oroll[1] = {silvl,link,""}
			otooltip4func();
		else
			orollgear = "";
		end
	end)
end

function oilvlchecktiers()
	local vanquisher, protector, conqueror = 0,0,0
	if IsInRaid() then
		rnum = GetNumGroupMembers();
		for i = 1, rnum do
			local _, _, cclass = UnitClass("raid"..i);
			--           DK             DRUID           MAGE          ROGUE
			if cclass == 6 or cclass == 11 or cclass == 8 or cclass == 4 then vanquisher = vanquisher + 1 end
			--           HUNTER         MONK           SHAMAN         WARRIOR
			if cclass == 3 or cclass == 10 or cclass == 7 or cclass == 1 then protector = protector + 1 end
			--           PALADIN       PRIEST         WARLOCK
			if cclass == 2 or cclass == 5 or cclass == 9 then conqueror = conqueror + 1 end
		end
	end
	return vanquisher, protector, conqueror;
end

function oilvlCheckTierBonusSet(i)
	local set=0;
	for j = 1, #tiergears do
		if MVPvsframedata.gear[i] and tiergears[j] and MVPvsframedata.gear[i][tiergears[j]] then
			if checktierID(MVPvsframedata.gear[i][tiergears[j]][8]) then set = set + 1 end
		end
	end
	if set >=4 then return 4 elseif set >= 2 then return 2 else	return "" end
end

function oilvlCheckUpgrade(i)
	local upgrade=0;
	local n = 0;
	for j = 1, 17 do
		if MVPvsframedata.gear[i] and MVPvsframedata.gear[i][j] and MVPvsframedata.gear[i][j][9] then
			upgrade = upgrade +  MVPvsframedata.gear[i][j][9] / 2;
			n = n + 1;
		end
	end
	if n == 0 then return "" end
	return upgrade.."/"..n;
end

function oilvlShowBagItemLevel()
	local quality_color = {
		[0] = {127.5/255, 127.5/255, 127.5/255}, -- Poor (Gray)
		[1] = { 255/255, 255/255, 255/255}, -- Common (White)
		[2] = { 0/255, 255/255, 0/255}, -- Uncommon (Green)
		[3] = { 25/255, 127.5/255, 255/255}, -- Rare (Blue)
		[4] = { 255/255, 127/255, 243/255}, -- Epic (Purple)
		[5] = { 255/255, 165.75/255, 0/255}, -- Legendary (Orange)
		[6] = { 255/255, 204/255, 0/255}, -- Artifact (Light Gold)
		[7] = { 255/255, 255/255, 0/255}, -- Heirloom (Light Gold)
	}

	if GetTime() - bagilvltime > 0.3 then
		if not bagupdatesw then
			bagupdatesw = true;
			OILVL:RegisterEvent("BAG_UPDATE")
		end
		local _,_,_,_,_,it1,_ = GetItemInfo(7521) -- armor
		local _,_,_,_,_,it2,_ = GetItemInfo(23347) -- weapon
		local _,_,_,_,_,_,it3 = GetItemInfo(141521) -- relic
		if not it1 then it1 = "Armor" end
		if not it2 then it2 = "Weapon" end
		if not it3 then it3 = "Artifact Relic" end
		for i=1,NUM_CONTAINER_FRAMES do
			for j=1,MAX_CONTAINER_ITEMS do
				local frame = _G["ContainerFrame"..i.."Item"..j]
				if frame and frame:GetParent() and frame:GetParent():GetID() then
					if not frame.iLvl then
						frame.iLvl = frame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
						frame.iLvl:SetPoint("BOTTOM", 0, 0)
						frame.iLvl:SetTextColor(1,1,0)
						frame.iLvl:SetText("")
					end
					local container = frame:GetParent():GetID()
					local slot = frame:GetID()
					local itemLink = GetContainerItemLink(container, slot)
					if itemLink then
						local name, _, quality, _, _,itemType,itemType2, _, _, _, _ = GetItemInfo(itemLink)
						if (itemType == it1 or itemType == it2 or itemType == it3 or itemType2 == it3) and ((UnitLevel("player") >= 20 and quality > 1) or UnitLevel("player") < 20) and cfg.MVPvsbagilvl then
							if cfg.MVPvscolormatchitemrarity then
								frame.iLvl:SetTextColor(quality_color[quality][1],quality_color[quality][2],quality_color[quality][3])
							else
								frame.iLvl:SetTextColor(1,1,0)
							end
							frame.iLvl:SetShadowColor(1,1,1,1)
							frame.iLvl:SetText(OItemAnalysis_CheckILVLGear3(container, slot))
						else
							frame.iLvl:SetText("")
						end
					else
						frame.iLvl:SetText("")
					end
				end
			end
		end
		bagilvltime = GetTime()
	end
end

SLASH_OILVL_OIT1 = "/oit"
SlashCmdList["OILVL_OIT"] = function(msg)
	local vanquisher, protector, conqueror = oilvlchecktiers()
	print("Vanquisher (Death Knight, Druid, Mage, Rogue): "..vanquisher)
	print("Protector (Hunter, Monk, Shaman, Warrior): "..protector)
	print("Conqueror (Paladin, Priest, Warlock): "..conqueror)
end

SLASH_OILVL_OISF1 = "/oisf"
SlashCmdList["OILVL_OISF"] = function(msg)
	local token = {msg}
	if string.upper(token[1]) == "OFF" then
		cfg.MVPvssamefaction = false
		print("OiLvL: Show both faction item level")
		StaticPopup_Show ("RELOAD")
	end
	if  string.upper(token[1]) == "ON" then
		cfg.MVPvssamefaction = true
		print("OiLvL: Show only same faction item level")
		StaticPopup_Show ("RELOAD")
	end
end

SLASH_OILVL_OIBI1 = "/oibi"
SlashCmdList["OILVL_OIBI"] = function(msg)
	if cfg.MVPvsbagilvl then
		cfg.MVPvsbagilvl = false
		print("OiLvL: Item level of items in bags are hidden")
		oilvlShowBagItemLevel();
	else
		cfg.MVPvsbagilvl = true
		print("OiLvL: Item level of items in bags are shown")
		oilvlShowBagItemLevel();
	end
end

--cfg.MVPvscolormatchitemrarity
SLASH_OILVL_OIMATCHCOLOR1 = "/oimatchcolor"
SlashCmdList["OILVL_OIMATCHCOLOR"] = function(msg)
	if cfg.MVPvscolormatchitemrarity then
		cfg.MVPvscolormatchitemrarity = false
		print("OiLvL: Color matching is disabled")
	else
		cfg.MVPvscolormatchitemrarity = true
		print("OiLvL: Color matching is enabled")
	end
end

-- check who roll the gear
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(frame, event, message)
	-- Thank for eglohpri's help.
	if GetLocale() == 'deDE' then RANDOM_ROLL_RESULT = "%s w\195\188rfelt. Ergebnis: %d (%d-%d)" end
	local name, proll = message:match(RANDOM_ROLL_RESULT:gsub( "%%s", "(.+)" ):gsub( "%%d %(%%d%-%%d%)", "(%%d+).*" ))
	proll = tonumber(proll)
	local ochecksamename = false;
	for m = 1, #oroll do
		if oroll[m][1] == name then ochecksamename = true break end
	end
	if name and orollgear ~= "" and not ochecksamename then
		local _, _, _, _, _, _, _, _, equipSlot, _, _ = GetItemInfo(orollgear)
		for i = 1, 40 do
			if MVPvsframedata.name[i] == nil then break end
			if MVPvsframedata.name[i] == name or MVPvsframedata.name[i] == "! "..name or MVPvsframedata.name[i] == "~ "..name then
				if gslot[equipSlot] ~= nil then
					if MVPvsframedata.gear[i][gslot[equipSlot]] == nil then
						orolln = orolln + 1; oroll[orolln] = {name,proll,"","","",""} otooltip4func();
						break
					end
					if MVPvsframedata.gear[i][gslot[equipSlot]][1] == nil then
						orolln = orolln + 1; oroll[orolln] = {name,proll,"","","",""} otooltip4func();
						break
					end
					if MVPvsframedata.gear[i][gslot[equipSlot]][1] ~= nil then
						if gslot[equipSlot] == 11 then
							orolln = orolln + 1;
							oroll[orolln] = {
								name,
								proll,
								MVPvsframedata.gear[i][11][1],
								MVPvsframedata.gear[i][11][2],
								MVPvsframedata.gear[i][12][1],
								MVPvsframedata.gear[i][12][2]
							}
							otooltip4func();
							break;
						elseif gslot[equipSlot] == 13 then
							orolln = orolln + 1;
							oroll[orolln] = {
								name,
								proll,
								MVPvsframedata.gear[i][13][1],
								MVPvsframedata.gear[i][13][2],
								MVPvsframedata.gear[i][14][1],
								MVPvsframedata.gear[i][14][2]
							}
							otooltip4func();
							break;
						else
							orolln = orolln + 1;
							oroll[orolln] = {
								name,
								proll,
								MVPvsframedata.gear[i][gslot[equipSlot]][1],
								MVPvsframedata.gear[i][gslot[equipSlot]][2],
								"",
								""
							}
							otooltip4func();
							break;
						end
					end
					break;
				else
					orolln = orolln + 1; oroll[orolln] = {name,proll,"","","",""} otooltip4func();break;
				end
			end
		end
	end
end)

-- fix No player named XYZ is currently playing error.
local function SystemSpamFilter(frame, event, message)
	if message:match(string.format(ERR_CHAT_PLAYER_NOT_FOUND_S, "(.+)")) then
		return true
	end
    return false
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", SystemSpamFilter)

function oilvlfakeaotc(id,month,day,year)
	print(GetAchievementLink(id):gsub("0:0:0:%-1","1:"..month..":"..day..":"..year).."")
end
