local cfg;
--API

local CreateFrame = CreateFrame
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local backdrop = { --
bgFile = "Interface/AddOns/MostValuablePlayer/Custom/mvp2.tga", tile = false, tileSize = 512,
insets = {left = -1, right = -1, top = -1, bottom = -1},
                }



local Users = {}
local Timers = {}
local TimerData = {}
local CombinedFails = {} -- 额外受伤
local DeathData = {}--JANY用来记录一次副本里的死亡次数
local DamdgeData = {}--JANY用来记录一次副本里的总伤害量
local InterruptData = {}--打断次数
local DispelData = {}--驱散
local score = {}--评分
local Battletime= {}--战斗时长
local HealData = {} -- 治疗
local deftime = {}
local dps = {}
local activeUser = nil
local playerUser = GetUnitName("player",true).."-"..GetRealmName():gsub(" ", "")
local hardMinPct = 20

local select,UnitGUID,tonumber
    = select, UnitGUID, tonumber--鼠标提示相关
local challengeMapID

local tonumber, band = tonumber, bit.band
local isValidEvent = {
  SWING_DAMAGE = true,
  SWING_MISSED = true,
  RANGE_DAMAGE = true,
  RANGE_MISSED = true,
  SPELL_ABSORBED = true,
  SPELL_DAMAGE = true,
  SPELL_HEAL = true,
  SPELL_MISSED = true,
  SPELL_SUMMON = true,
  SPELL_PERIODIC_DAMAGE = true,
  SPELL_PERIODIC_HEAL = true,
  SPELL_PERIODIC_MISSED = true,
  SPELL_EXTRA_ATTACKS = true,
  DAMAGE_SHIELD = true,
  DAMAGE_SHIELD_MISSED = true,
  DAMAGE_SPLIT = true,
}
local isHeal = {
  SPELL_ABSORBED = true,
  SPELL_HEAL = true,
  SPELL_PERIODIC_HEAL = true,
}
local isDamage = {
  SWING_DAMAGE = true,
  RANGE_DAMAGE = true,
  SPELL_DAMAGE = true,
  SPELL_PERIODIC_DAMAGE = true,
  DAMAGE_SHIELD = true,
  DAMAGE_SPLIT = true,
}
local Spells = {
	-- Affixes
	[209862] = 20,    -- Volcanic Plume (Environment)
	[226512] = 20,    -- Sanguine Ichor (Environment)
	[288694] = 20,    -- Shadow Smash (Season 2)
	[288858] = 20,    -- Expel Soul (Season 2)

	-- Freehold
	[272046] = 20,    --- Dive Bomb (Sharkbait)
	[257426] = 20,    --- Brutal Backhand (Irontide Enforcer)
	[258352] = 20,    --- Grapeshot (Captain Eudora)
	[256594] = 20,    --- Barrel Smash (Captain Raoul)
	[267523] = 20,    --- Cutting Surge (Captain Jolly)
	[272374] = 20,    --- Whirlpool of Blades (Captain Jolly)
	[272397] = 20,    --- Whirlpool of Blades (Captain Jolly)
	[256546] = 20,    --- Shark Tornado
	[257310] = 20,    --- Cannon Barrage
	[257757] = 20,    --- Goin' Bananas (Bilge Rat Buccaneer)
	[274389] = 20,    --- Rat Traps (Vermin Trapper)
	[257902] = 20,    --- Shell Bounce (Ludwig Von Tortollan)
	[258199] = 20,    --- Ground Shatter (Irontide Crusher)
	[276061] = 20,    --- Boulder Throw (Irontide Crusher)
	[258779] = 20,    --- Sea Spout (Irontide Oarsman)
	[274400] = 20,    --- Duelist Dash (Cutwater Duelist)
	[257274] = 20,    --- Vile Coating (Environment)

	-- Shrine of the Storm
	[264560] = 20,    --- Choking Brine (Aqualing)
	[267899] = 20,    --- Hindering Cleave (Brother Ironhull)
	[268280] = 20,    --- Tidal Pod (Tidesage Enforcer)
	[276286] = 20,    --- Slicing Hurricane (Environment)
	[276292] = 20,    --- Whirlign Slam (Ironhull Apprentice)
	[267385] = 20,    --- Tentacle Slam (Vol'zith the Whisperer)

	-- Siege of Boralus
	[256627] = 20,    --- Slobber Knocker (Scrimshaw Enforcer)
	[256663] = 20,    --- Burning Tar (Blacktar Bomber)
	[257431] = 20,    --- Meat Hook (Chopper Redhook)
	[275775] = 20,    --- Savage Tempest (Irontide Raider)
	[269029] = 20,    --- Clear the Deck (Dread Captain Lockwood)
	[272874] = 20,    --- Trample (Ashvane Commander)
	[272426] = 20,    --- Sighted Artillery
	[272140] = 20,    --- Iron Volley
	[257292] = 20,    --- Heavy Slash (Irontide Cleaver)
	[273681] = 20,    --- Heavy Hitter (Chopper Redhook)
	[257886] = 20,    --- Brine Pool (Hadal Darkfathom)

	-- Tol Dagor
	[257785] = 20,    --- Flashing Daggers
	[256976] = 20,    --- Ignition (Knight Captain Valyri)
	[256955] = 20,    --- Cinderflame (Knight Captain Valyri)
	[256083] = 20,    --- Cross Ignition (Overseer Korgus)
	[263345] = 20,    --- Massive Blast (Overseer Korgus)
	[258864] = 20,    --- Suppression Fire (Ashvane Marine/Spotter)
	[258364] = 20,    --- Fuselighter (Ashvane Flamecaster)
	[259711] = 20,    --- Lockdown (Ashvane Warden)

	-- Waycrest Manor
	[260569] = 20,    --- Wildfire (Soulbound Goliath)
	[265407] = 20,    --- Dinner Bell (Banquet Steward)
	[264923] = 20,    --- Tenderize (Raal the Gluttonous)
	[264150] = 20,    --- Shatter (Thornguard)
	[271174] = 20,    --- Retch (Pallid Gorger)
	[268387] = 20,    --- Contagious Remnants (Lord Waycrest)
	[268308] = 20,    --- Discordant Cadenza (Lady Waycrest

	-- Atal'Dazar
	[253666] = 20,    --- Fiery Bolt (Dazar'ai Juggernaught)
	[257692] = 20,    --- Tiki Blaze (Environment)
	[255620] = 20,    --- Festering Eruption (Reanimated Honor Guard)
	[256959] = 20,    --- Rotting Decay (Renaimated Honor Guard)
	[250259] = 20,    --- Toxic Leap
	[250022] = 20,    --- Echoes of Shadra (Echoes of Shadra)
	[250585] = 20,    --- Toxic Pool
	[250036] = 20,    --- Shadowy Remains

	-- King's Rest
	[265914] = 20,    --- Molten Gold (The Golden Serpent)
	[266191] = 20,    --- Whirling Axe (Council of Tribes)
	[270289] = 20,    --- Purification Beam
	[270503] = 20,    --- Hunting Leap (Honored Raptor)
	[271564] = 20,    --- Embalming Fluid (Embalming Fluid)
	[270485] = 20,    --- Blooded Leap (Spectral Berserker)
	[267639] = 20,    --- Burn Corruption (Mchimba the Embalmer)
	[270931] = 20,    --- Darkshot

	-- The MOTHERLODE!!
	[257371] = 20,    --- Gas Can (Mechanized Peace Keeper)
	[262287] = 20,    --- Concussion Charge (Mech Jockey / Venture Co. Skyscorcher)
	[268365] = 20,    --- Mining Charge (Wanton Sapper)
	[269313] = 20,    --- Final Blast (Wanton Sapper)
	[275907] = 20,    --- Tectonic Smash
	[259533] = 20,    --- Azerite Catalyst (Rixxa Fluxflame)
	[260103] = 20,    --- Propellant Blast
	[260279] = 20,    --- Gattling Gun (Mogul Razdunk)
	[276234] = 20,    --- Micro Missiles
	[270277] = 20,    --- Big Red Rocket (Mogul Razdunk)
	[271432] = 20,    --- Test Missile (Venture Co. War Machine)
	[262348] = 20,    --- Mine Blast
	[257337] = 20,    --- Shocking Claw
	[269092] = 20,    --- Artillery Barrage (Ordnance Specialist)

	-- Temple of Sethraliss
	[268851] = 20,    --- Lightning Shield (Adderis)
	[273225] = 20,    --- Volley (Sandswept Marksman)
	[264574] = 20,    --- Power Shot (Sandswept Marksman)
	[273995] = 20,    --- Pyrrhic Blast (Crazed Incubator)
	[264206] = 20,    --- Burrow (Merektha)
	[272657] = 20,    --- Noxious Breath
	[272658] = 20,    --- Electrified Scales
	[272821] = 20,    --- Call Lightning (Stormcaller)

	-- Underrot
	[264757] = 20,    --- Sanguine Feast (Elder Leaxa)
	[265542] = 20,    --- Rotten Bile (Fetid Maggot)
	[265019] = 20,    --- Savage Cleave (Chosen Blood Matron)
	[261498] = 20,    --- Creeping Rot (Elder Leaxa)
	[265665] = 20,    --- Foul Sludge (Living Rot)
	[265511] = 20,    --- Spirit Drain (Spirit Drain Totem)
	[272469] = 20,    --- Abyssal Slam (Abyssal Reach)
	[272609] = 20,    --- Maddening Gaze (Faceless Corruptor)
}
local SpellsNoTank = {
	-- Freehold

	-- Shrine of the Storm
	[267899] = 20,      --- Hindering Cleave

	-- Siege of Boralus

	-- Tol Dagor

	-- Waycrest Manor

	-- Atal'Dazar

	-- King's Rest

	-- The MOTHERLODE!!

	-- Temple of Sethraliss
	[255741] = 20,    	--- Cleave (Scaled Krolusk Rider)

	-- Underrot
	[265019] = 20,    	--- Savage Cleave (Chosen Blood Matron)
}
local Auras = {
	-- Freehold
	[274516] = true,    -- Slippery Suds
	[274389] = true,        -- Rat Traps (Vermin Trapper)

	-- Shrine of the Storm
	[268391] = true,    -- Mental Assault (Abyssal Cultist)
	[276268] = true,    -- Heaving Blow (Shrine Templar)

	-- Siege of Boralus
	[257292] = true,    -- Heavy Slash (Kul Tiran Vanguard)
	[272874] = true,    -- Trample (Ashvane Commander)

	-- Tol Dagor
	[257119] = true,    -- Sand Trap (The Sand Queen)
	[256474] = true,    -- Heartstopper Venom (Overseer Korgus)

	-- Waycrest Manor
	[265352] = true,    -- Toad Blight (Toad)

	-- Atal'Dazar

	-- King's Rest
	[270003] = true,    -- Suppression Slam (Animated Guardian)
	[270931] = true,    -- Darkshot
	[268796] = true,    -- (Kind Dazar)

	-- The MOTHERLODE!!

	-- Temple of Sethraliss
	[263914] = true,    -- Blinding Sand (Merektha)
	[269970] = true,    -- Blinding Sand (Merektha)

	-- Underrot
	[272609] = true,    -- Maddening Gaze (Faceless Corrupter)

}

local AurasNoTank = {
}

function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end






local MVPvsFrame = CreateFrame("Frame", "MVPvsFrame")
MVPvsFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local MSG_PREFIX = "MVPvs"
local success = C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)
MVPvsFrame:RegisterEvent("CHAT_MSG_ADDON")
MVPvsFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
MVPvsFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MVPvsFrame:RegisterEvent("CHALLENGE_MODE_START")
MVPvsFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
MVPvsFrame:RegisterEvent("ADDON_LOADED")

MVPvsFrame:ClearAllPoints()
MVPvsFrame:SetHeight(100)
MVPvsFrame:SetWidth(100)
MVPvsFrame.text = MVPvsFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont")
MVPvsFrame.text:SetAllPoints()
MVPvsFrame.text:SetTextHeight(13)
MVPvsFrame:SetAlpha(1)



local modelHolder2 = CreateFrame("Frame", nil,UIParent)
modelHolder2:SetSize(512,512)
modelHolder2:SetPoint("CENTER",UIParent,"CENTER", -500, 0)

playerModel2 = CreateFrame("PlayerModel", nil, modelHolder2)
playerModel2:SetPoint("CENTER", modelHolder2, "CENTER")







modelHolder2:SetScript("OnMouseDown", function(self)

	modelHolder2:EnableMouse(false)
    modelHolder2:SetMovable(false)
	playerModel2:SetUnit("none")
	modelHolder2:SetBackdropColor(0, 0, 0, 0)

end);
playerModel2.isIdle = nil
playerModel2:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) --YES, double screen size. This prevents clipping of models.
playerModel2:Show()



function table.pack(...)
  return { n = select("#", ...), ... }
end
MVPvsFrame:SetScript("OnEvent", function(self, event_name, ...)
	if self[event_name] then
		return self[event_name](self, event_name, ...)
	end
end)




function generateMaybeOutput(user)
	local func = function()
			local msg = "<走位提醒> "..user.." 被 "
			local amount = 0
			local minPct = math.huge
			for k,v in pairs(TimerData[user]) do

				msg = msg..GetSpellLink(k).." "
				local spellMinPct = nil
				if Spells[k] then
					spellMinPct = Spells[k]
				elseif SpellsNoTank[k] then
					spellMinPct = SpellsNoTank[k]
				end
				if spellMinPct ~= nil and spellMinPct < minPct then
					minPct = spellMinPct
				end
				amount = amount + v
				--print("损失血量为 " .. amount)
			end
			if minPct == math.huge then
				local spellNames = " "
				for k,v in pairs(TimerData[user]) do
					spellNames = spellNames..GetSpellLink(k).." "
				end
				--print("<友情提示> Error: Could not find spells"..spellNames.."in Spells or SpellsNoTank but got Timer for them. wtf")
			end
			TimerData[user] = nil
			Timers[user] = nil
			local userMaxHealth = UnitHealthMax(user)
			local msgAmount = round(amount/10000 ,1)
			local pct = Round(amount / userMaxHealth * 100)
			--print(user,msg,amount)
			msg = msg.."命中,减 "..msgAmount.."万血 (-"..pct.."%)."
			--print(msg)

			if pct >= hardMinPct and pct >= minPct and MVPDB then--这个判断
				--msg = msg.."损失血量为 "..msgAmount.."万 (-"..pct.."%)."
				--print(msg)
			end
		end
	return func
end
--[[
local function UnitFullName2(unit)
    if not unit then return UNKNOWNOBJECT end
    local name, realm = UnitName(unit)
    if not realm or realm=="" then
        if not PLAYER_REALM or PLAYER_REALM=="" then
            PLAYER_REALM = GetRealmName()
        end
        realm = PLAYER_REALM
    end
    return name.."-"..realm
end
]]
----------------------鼠标提示相关------------------
local function addLine(tooltip, id, kind,guname)

if cfg.MVPvsline == false and cfg.MVPvsline == true then	
	playerModel2:ClearModel()
	playerModel2:SetUnit(guname)
	playerModel2:SetFacing(6.5)
	playerModel2:SetPortraitZoom(0.05)
	playerModel2:SetCamDistanceScale(4.8)
	playerModel2:SetAlpha(1)
	playerModel2:SetAnimation(random(1,225))
	UIFrameFadeIn(playerModel2, 1, playerModel2:GetAlpha(), 1)
	modelHolder2:SetBackdrop(backdrop)
	modelHolder2:EnableMouse(true)
    modelHolder2:SetMovable(true)
   end
  if not id or id == "" then return end
  if type(id) == "table" and #id == 1 then id = id[1] end

  -- 检查我们是否已添加到此工具提示中。发生在人才框架上
  local frame, text
  for i = 1,15 do
    frame = _G[tooltip:GetName() .. "TextLeft" .. i]
    if frame then text = frame:GetText() end
    if text and string.find(text, kind .. ":") then return end
  end




  if MVPLilst[guname] and cfg.MVPvsline == true then


	  tooltip:AddDoubleLine(MVPLilst[guname])
	  tooltip:Show()
	end
end
-- NPCs
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
  if C_PetBattles.IsInBattle() then return end
  local unit = select(2, self:GetUnit())
  if unit then
    local guid = UnitGUID(unit) or ""
    local guna = UnitName(unit) or ""
    local guplayerUser = GetUnitName(unit,true)

    local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
    if id and guid:match("%a+") ~= "abc" then 
      addLine(GameTooltip, id, "ID",guplayerUser)
    end
  end
end)
----------------------鼠标提示相关------------------
--[[
SLASH_MostValuablePlayers1 = "/MostValuablePlayers"

SlashCmdList["MostValuablePlayers"] = function(msg,editBox)
	if msg == "activeuser" then
		if activeUser == playerUser then
			print("You are the activeUser")
		end
		
	elseif msg == "resync" then
		MVPvsFrame:RebuildTable()
		
	elseif msg == "table" then
		for k,v in pairs(Users) do
			print(k.." ;;; "..v)
		end
		
	elseif msg == "eod" then
		MVPvsFrame:CHALLENGE_MODE_COMPLETED()
		
	elseif msg == "on" or msg == "enable" then
		if MVPDB then
			print("Damage notifications are already enabled.")
		else
			MVPDB = true
			print("All damage notifications enabled.")
		end
		
	elseif msg == "off" or msg == "disable" then
		if not MVPDB then
			print("Damage notifications are already disabled.")
		else
			MVPDB = false
			print("Will only announce at the end of the dungeon.")
		end
	end
end
]]
function maybeSendAddonMessage(prefix, message)
	if IsInGroup() and not IsInGroup(2) and not IsInRaid() then
		C_ChatInfo.SendAddonMessage(prefix,message,"PARTY")
	elseif IsInGroup() and not IsInGroup(2) and IsInRaid() then
		C_ChatInfo.SendAddonMessage(prefix,message,"RAID")
	end
end
function MVPprint(messages)
	if activeUser ~= playerUser then
		print(messages)
		return
	end
	if cfg.MVPvsnoti == true then
		SendChatMessage(messages,"PARTY")
	else
		print(messages)
	end
end
function maybeSendChatMessage(message)
	if activeUser ~= playerUser then
		return
	end
	if IsInGroup() and not IsInGroup(2) and not IsInRaid() then
		print(message)
		--SendChatMessage(message,"PARTY")
	elseif IsInGroup() and not IsInGroup(2) and IsInRaid() then
		--SendChatMessage(message,"RAID")
		print(message)
	else
		--SendChatMessage(message,"YELL")
		print(message)
	end
end

function MVPvsFrame:RebuildTable()--权重
	Users = {}
	activeUser = nil
	
	if IsInGroup() then
		
		maybeSendAddonMessage(MSG_PREFIX,"VREQ")
	else
		
		name = GetUnitName("player",true)
		activeUser = name.."-"..GetRealmName()

	end

end

function MVPvsFrame:ADDON_LOADED(event,addon)

	if addon == "MostValuablePlayer" then
		MVPvsFrame:RebuildTable()
	end

	if not MVPDB then
		MVPDB = true
	end
	if not MVPLilst then MVPLilst = {} end
	cfg = MVP_Settings;
	if cfg.MVPvsnoti == nil then cfg.MVPvsnoti = true; end


end

function MVPvsFrame:GROUP_ROSTER_UPDATE(event,...)
	MVPvsFrame:RebuildTable()
end

function MVPvsFrame:ZONE_CHANGED_NEW_AREA(event,...)
	MVPvsFrame:RebuildTable()
end

function compareDamage(a,b)
	return a["value"] < b["value"]
end
function compareMVP(a,b)
	return a["value"] > b["value"]
end
local function timeFormatMS(timeAmount)
	local seconds = floor(timeAmount / 1000)
	local ms = timeAmount - seconds * 1000
	local hours = floor(seconds / 3600)
	local minutes = floor((seconds / 60) - (hours * 60))
	seconds = seconds - hours * 3600 - minutes * 60

	if hours == 0 then
		return format("%d:%.2d.%.3d", minutes, seconds, ms)--分 秒
	else
		return format("%d:%.2d:%.2d.%.3d", hours, minutes, seconds, ms)
	end
end
local function timeFormats(timeAmount)
	local seconds = floor(timeAmount / 1000)
	local hours = floor(seconds / 3600)
	local minutes = floor((seconds / 60) - (hours * 60))
	seconds = seconds - hours * 3600 - minutes * 60

	if hours == 0 then
		return minutes
	else
		return hours * 60 + minutes
	end
end
function MVPvsFrame:CHALLENGE_MODE_COMPLETED(event, ...)--挑战模式完成时

    local TIME_FOR_3 = 0.6
    local TIME_FOR_2 = 0.8

    if not challengeMapID then print("challengeMapID") end
    
    local mapID, level, time, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
    local name, _, timeLimit = C_ChallengeMode.GetMapUIInfo(challengeMapID)
    
    timeLimit = timeLimit * 1000
    local timeLimit2 = timeLimit * TIME_FOR_2
    local timeLimit3 = timeLimit * TIME_FOR_3
    local RemainingTime
    print("CHALLENGE_MODE_COMPLETED", mapID, level, time, onTime, keystoneUpgradeLevels, name, timeLimit, timeLimit2, timeLimit3)
    if time <= timeLimit3 then
        print(format("|cff33ff99<%s>|r |cffffd700%s|r", "MVP", format("恭喜你在规定时间内获得了 %s 的3箱奖励！共耗时 %s，3箱奖励剩余时间 %s。", name, timeFormatMS(time), timeFormatMS(timeLimit3 - time))))
        RemainingTime = timeFormats(timeLimit3 - time)
    elseif time <= timeLimit2 then
        print(format("|cff33ff99<%s>|r |cffc7c7cf%s|r", "MVP", format("恭喜你在规定时间内获得了 %s 的2箱奖励！共耗时 %s，2箱奖励剩余时间 %s，3箱奖励超时 %s。", name, timeFormatMS(time), timeFormatMS(timeLimit2 - time), timeFormatMS(time - timeLimit3))))
        RemainingTime = timeFormats(timeLimit2 - time)
    elseif onTime then
        print(format("|cff33ff99<%s>|r |cffeda55f%s|r", "MVP", format("恭喜你在规定时间内完成了 %s 的战斗！共耗时 %s，剩余时间 %s，2箱奖励超时 %s。", name, timeFormatMS(time), timeFormatMS(timeLimit - time), timeFormatMS(time - timeLimit2))))
        RemainingTime = timeFormats(timeLimit - time)
    else
        print(format("|cff33ff99<%s>|r |cffff2020%s|r", "MVP", format("很遗憾你超时完成了 %s 的战斗。共耗时 %s，超出规定时间 %s。", name, timeFormatMS(time), timeFormatMS(time - timeLimit))))
        RemainingTime = timeFormats(time - timeLimit) * -1
    end
    
    MVPprint(name .. level .. "层    玩家         伤害           额外受伤        治疗     打断   驱散   阵亡      评分")
    
    if IsAddOnLoaded("details") then
	    local ticker = C_Timer.NewTicker(3, function(ticker)
	        if not InCombatLockdown() then
	                local allscore = 0
	                for k, v in pairs(DamdgeData) do
	                    if not v then v = 0 end
	                    if not CombinedFails[k] then CombinedFails[k] = 0 end
	                    if not InterruptData[k] then InterruptData[k] = 0 end
	                    if not DispelData[k] then DispelData[k] = 0 end
	                    if not DeathData[k] then DeathData[k] = 0 end
	                    if not HealData[k] then HealData[k] = 0 end
	                    if not score[k] then score[k] = 0 end
	                    if not dps[k] then dps[k] = 0 end
	                    if IsAddOnLoaded("details") then
	                        v = Details.UnitDamage(k)
	                        Battletime[k] = Details.SegmentElapsedTime()
	                        HealData[k] = Details.UnitHealing(k)                       
	                    end
	                    dps[k] = (("%%.%df"):format(2)):format((v / Battletime[k]) / 10000)
	                    score[k] = round((v + HealData[k] - CombinedFails[k] * 3) / 100000, 1) + InterruptData[k] + DispelData[k] - DeathData[k] * 3 + (level + keystoneUpgradeLevels) * 10 + RemainingTime
	                    allscore = allscore + score[k]
	                end
	                
	                for k, v in pairs(DamdgeData) do
	                    --评分公式    (总伤害量 + 治疗 - 额外受伤 * 3) / 100000 + 打断 + 驱散 - 死亡 * 3 + (层数 + 几箱) *10 + 剩余时间  \n|r
	                    -- print(v, "伤害--【这是测试数据】--时间", Battletime[k])
	                    MVPLilst[k] = name .. level .. "层 " .. "【+" .. keystoneUpgradeLevels .. "】" .. allscore .. "团队得分 " .. score[k] .. "个人分 " .. (allscore / 5) .. "平均分\n|r " .. dps[k] .. "万秒伤 " .. round(v / 10000, 1) .. "万伤害 " .. round(CombinedFails[k] / 10000, 1) .. "万受伤 " .. round(HealData[k] / 10000, 1) .. "万疗 " .. InterruptData[k] .. "断 " .. DispelData[k] .. "驱 " .. DeathData[k] .. "亡 "
	                    MVPprint(k .." ".. round(v / 10000, 1) .. "万伤害 " .. round(CombinedFails[k] / 10000, 1) .. "万受伤 " .. round(HealData[k] / 10000, 1) .. "万疗 " .. InterruptData[k] .. "断 " .. DispelData[k] .. "驱 " .. DeathData[k] .. "亡 " .. score[k] .. "分")--总伤害量 额外受伤 死亡次数  打断次数
	                --print("【sovijo】说：","伤害-额外受伤-打断-死亡-评分-MVP",round((30000000 - 2000000 * 3) / 100000 ,1) + 30 - 5*3)      层数*10 + 限时箱 *10 + 剩余时间   (level+keystoneUpgradeLevels)*10 + RemainingTime
	                end
	                
	                local fs = {}
	                for k, v in pairs(score) do table.insert(fs, {key = k, value = v}) end
	                
	                table.sort(fs, compareMVP)
	                
	                for k, v in pairs(fs) do
						playerModel2:ClearModel()
						playerModel2:SetUnit(guname)
						playerModel2:SetFacing(6.5)
						playerModel2:SetPortraitZoom(0.05)
						playerModel2:SetCamDistanceScale(4.8)
						playerModel2:SetAlpha(1)
						playerModel2:SetAnimation(random(1,225))
						UIFrameFadeIn(playerModel2, 1, playerModel2:GetAlpha(), 1)
						modelHolder2:SetBackdrop(backdrop)
						modelHolder2:EnableMouse(true)
					    modelHolder2:SetMovable(true)
	                    MVPprint("恭喜 " .. v["key"] .. " " .. v["value"] .. " 分   【MVP】" .. "团队得分 " .. allscore)
	                    break
	                
	                end
	                CombinedFails = {}-- 不躲技能受到的伤害
	                DeathData = {}--挑战模式完成时 重置死亡次数为nil  ----jany
	                DamdgeData = {}--挑战模式完成时 重置总伤害为nil---jany
	                InterruptData = {}--打断次数
	                DispelData = {}--驱散次数
	                HealData = {}--治疗
	                deftime = {}
	                score = {}--评分
	                Battletime = {}--战斗时长
	            
	        ticker:Cancel()   
	        end
	    
	    end)
	else     
        local allscore = 0
        for k, v in pairs(DamdgeData) do
            if not v then v = 0 end
            if not CombinedFails[k] then CombinedFails[k] = 0 end
            if not InterruptData[k] then InterruptData[k] = 0 end
            if not DispelData[k] then DispelData[k] = 0 end
            if not DeathData[k] then DeathData[k] = 0 end
            if not HealData[k] then HealData[k] = 0 end
            if not score[k] then score[k] = 0 end
            if not dps[k] then dps[k] = 0 end
            dps[k] = (("%%.%df"):format(2)):format((v / Battletime[k]) / 10000)
            score[k] = round((v + HealData[k] - CombinedFails[k] * 3) / 100000, 1) + InterruptData[k] + DispelData[k] - DeathData[k] * 3 + (level + keystoneUpgradeLevels) * 10 + RemainingTime
            allscore = allscore + score[k]
        end
        
        for k, v in pairs(DamdgeData) do
            --评分公式    (总伤害量 + 治疗 - 额外受伤 * 3) / 100000 + 打断 + 驱散 - 死亡 * 3 + (层数 + 几箱) *10 + 剩余时间  \n|r
            -- print(v, "伤害--【这是测试数据】--时间", Battletime[k])
            MVPLilst[k] = name .. level .. "层 " .. "【+" .. keystoneUpgradeLevels .. "】" .. allscore .. "团队得分 " .. score[k] .. "个人分 " .. (allscore / 5) .. "平均分\n|r " .. dps[k] .. "万秒伤 " .. round(v / 10000, 1) .. "万伤害 " .. round(CombinedFails[k] / 10000, 1) .. "万受伤 " .. round(HealData[k] / 10000, 1) .. "万疗 " .. InterruptData[k] .. "断 " .. DispelData[k] .. "驱 " .. DeathData[k] .. "亡 "
            MVPprint(k .." ".. round(v / 10000, 1) .. "万伤害 " .. round(CombinedFails[k] / 10000, 1) .. "万受伤 " .. round(HealData[k] / 10000, 1) .. "万疗 " .. InterruptData[k] .. "断 " .. DispelData[k] .. "驱 " .. DeathData[k] .. "亡 " .. score[k] .. "分")--总伤害量 额外受伤 死亡次数  打断次数
        --print("【sovijo】说：","伤害-额外受伤-打断-死亡-评分-MVP",round((30000000 - 2000000 * 3) / 100000 ,1) + 30 - 5*3)      层数*10 + 限时箱 *10 + 剩余时间   (level+keystoneUpgradeLevels)*10 + RemainingTime
        end
        local fs = {}
        for k, v in pairs(score) do table.insert(fs, {key = k, value = v}) end
        table.sort(fs, compareMVP)
        for k, v in pairs(fs) do
			playerModel2:ClearModel()
			playerModel2:SetUnit(guname)
			playerModel2:SetFacing(6.5)
			playerModel2:SetPortraitZoom(0.05)
			playerModel2:SetCamDistanceScale(4.8)
			playerModel2:SetAlpha(1)
			playerModel2:SetAnimation(random(1,225))
			UIFrameFadeIn(playerModel2, 1, playerModel2:GetAlpha(), 1)
			modelHolder2:SetBackdrop(backdrop)
			modelHolder2:EnableMouse(true)
		    modelHolder2:SetMovable(true)
            MVPprint("恭喜 " .. v["key"] .. " " .. v["value"] .. " 分   【MVP】" .. "团队得分 " .. allscore)
            break
        end
        CombinedFails = {}-- 不躲技能受到的伤害
        DeathData = {}--挑战模式完成时 重置死亡次数为nil  ----jany
        DamdgeData = {}--挑战模式完成时 重置总伤害为nil---jany
        InterruptData = {}--打断次数
        DispelData = {}--驱散次数
        HealData = {}--治疗
        deftime = {}
        score = {}--评分
        Battletime = {}--战斗时长
	   
	end

end



function MVPvsFrame:CHALLENGE_MODE_START(event,...)--挑战模式启动 时重置伤害为nil,死亡次数为nil
	CombinedFails = {} -- 不躲技能受到的伤害
	DeathData = {}--挑战模式启动时 重置伤害为nil,死亡次数为nil   ----jany
	DamdgeData = {}--挑战模式启动时 重置总伤害为nil---jany
	InterruptData ={}--打断次数
	DispelData ={} --驱散次数
	HealData ={}--治疗
	deftime={}
	score={}
	Battletime= {}--战斗时长
	challengeMapID = C_ChallengeMode.GetActiveChallengeMapID()
	print("欢迎使用MVP通报 "..activeUser)
end

function MVPvsFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	

	if prefix ~= MSG_PREFIX then
		return
	end
	if message == "VREQ" then
		maybeSendAddonMessage(MSG_PREFIX,"VANS;1.1")
	elseif message:match("^VANS") then
		if tonumber(message:match("(%d+.%d+)")) > 1.1 then 
			print('MVP有新版本,你可以在NGA下载到最新的版本.')
		end
		Users[sender] = message
		for k,v in pairs(Users) do
			if activeUser == nil then
				activeUser = k
			end
			if k < activeUser then
				activeUser = k
			end
		end
	else

	end
end

local function getPetOwnerName(petGUID) --返回宠物的主人名字
  local n, s
  if petGUID == UnitGUID("pet") then
    n, s = UnitName("player")
    if s then
      return n.."-"..s
    else
      return n
    end
  else
    for i = 1, GetNumGroupMembers() do
      if IsInRaid() then
        if petGUID == UnitGUID(format("raidpet%i", i)) then
          n, s = UnitName(format("raid%i", i))
          if s then
            return n.."-"..s
          else
            return n
          end
        end
      else
        if petGUID == UnitGUID(format("partypet%i", i)) then
          n, s = UnitName(format("party%i", i))
          if s then
            return n.."-"..s
          else
            return n
          end
        end
      end
    end
  end
end

local function getPetOwnerGUID(petGUID)--返回宠物的主人的GUID
  if petGUID == UnitGUID("pet") then
    return UnitGUID("player")
  else
    for i = 1, GetNumGroupMembers() do
      if IsInRaid() then
        if petGUID == UnitGUID(format("raidpet%i", i)) then
          return UnitGUID(format("raid%i", i))
        end
      else
        if petGUID == UnitGUID(format("partypet%i", i)) then
          return UnitGUID(format("party%i", i))
        end
      end
    end
  end
end

local function isPartyPet(petGUID)--判断是否是队伍里
  if petGUID == UnitGUID("pet") then
    return true
  else
    for i = 1, GetNumGroupMembers() do
      if IsInRaid() then
        if petGUID == UnitGUID(format("raidpet%i", i)) then
          return true
        end
      else
        if petGUID == UnitGUID(format("partypet%i", i)) then
          return true
        end
      end
    end
  end
end

function MVPvsFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
	--print("发生了攻击事件Spells[spellId]"..timestamp, eventType,srcName,aAmount)
	if (Spells[spellId] or (SpellsNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
		-- Initialize TimerData and CombinedFails for Timer shot 为计时器快照初始化,
		if TimerData[dstName] == nil then
			TimerData[dstName] = {}
		end
		if CombinedFails[dstName] == nil then
			CombinedFails[dstName] = 0
		end
		CombinedFails[dstName] = CombinedFails[dstName] + aAmount


		if TimerData[dstName][spellId] == nil then
			TimerData[dstName][spellId] = aAmount
		else
			TimerData[dstName][spellId] = TimerData[dstName][spellId] + aAmount
		end


		
		-- 如果还没有计时器，请使用此事件启动计时器。在2秒内受到的伤害，防刷屏，可以改成别的时间，比如10秒
		if Timers[dstName] == nil then
			Timers[dstName] = true
			C_Timer.After(2,generateMaybeOutput(dstName))
		end--玩害受到伤害统计
	end

	if UnitIsPlayer(srcName) then--玩家技能伤害统计
		if DamdgeData[srcName] == nil then
			DamdgeData[srcName] = 0
		end
		DamdgeData[srcName] = DamdgeData[srcName] + aAmount	
		--print(srcName,DamdgeData[srcName])
    
	
  	elseif isPartyPet(srcGUID) then--宠物是否是在队伍里的----宠物伤害统计
    -- get owner
    	local ownerGUID, ownerName = getPetOwnerGUID(srcGUID), getPetOwnerName(srcGUID)
    	if DamdgeData[ownerName] == nil then
			DamdgeData[ownerName] = 0
		end
		DamdgeData[ownerName] = DamdgeData[ownerName] + aAmount	
    end
end

--死亡事件JANY
function MVPvsFrame:DeathDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool,destName)
	if UnitIsPlayer(dstName) then--如果死亡的是队友和我   srcName是甲方    dstName是乙方     这是 怪物 击败了 玩家

		if DeathData[dstName] == nil then
			DeathData[dstName] = 0
		end
		
		if destName and UnitHealth(dstName)==0 then--/run SendChatMessage((UnitHealth("卢瑟希"),"PARTY"))
		DeathData[dstName] = DeathData[dstName] + 1--/run print(DeathData["卢瑟希"])
		print(destName .. " 失去 " .. DeathData[dstName] .. " 血！")
		end
	end
end
--打断事件JANY
function MVPvsFrame:InterruptDamage(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,a12,a15)
	local inInstance = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	local inParty = IsInGroup()--是否在小队
	local inRaid = IsInRaid()
	if UnitIsPlayer(srcName) and inParty then--如果打断的人是队友和我  srcName是甲方    dstName是乙方     这是 玩家 打断了 怪物
		if InterruptData[srcName] == nil then
			InterruptData[srcName] = 0
		end
		InterruptData[srcName] = InterruptData[srcName] + 1
		if srcName then
		--print(srcName .. " 打断 " .. InterruptData[srcName] .. " 次！人品+1")
		else
		print("发生了打断事件")	
		end
	end
end
--驱散事件
function MVPvsFrame:DISPELDamage(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2)
	local inParty = IsInGroup()--是否在小队
	if UnitIsPlayer(srcName) and inParty then
		if DispelData[srcName] == nil then
			DispelData[srcName] = 0
		end
		DispelData[srcName] = DispelData[srcName] + 1
		if srcName then
		--print(srcName .. " 驱散 " .. DispelData[srcName] .. " 次！人品+1")
		else
		print("发生了驱散事件")	
		end

	end
end
--发生治疗事件
function MVPvsFrame:SpellHeal(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,amount)
	if UnitIsPlayer(srcName) then
		if HealData[srcName] == nil then
			HealData[srcName] = 0
		end
		HealData[srcName] = HealData[srcName] + amount
	end	
end




local amounts = 0
function MVPvsFrame:Batime(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2)
	
    local inParty = IsInGroup()--是否在小队
    if UnitIsPlayer(srcName) and inParty then
	  -- add combat time增加战斗时间
	  
		if Battletime[srcName] == nil then

			Battletime[srcName] = 0
      
		end
		if deftime[srcName] == nil then

			deftime[srcName] = 0
      
		end		
		
		amounts = timestamp - deftime[srcName]
	  if amounts < 3.5 then

	    Battletime[srcName] = Battletime[srcName] + amounts

	  else

	  	Battletime[srcName] = Battletime[srcName] + 3.5
	  end

  	  deftime[srcName] = timestamp

    end





end

function MVPvsFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)--玩害普通攻击伤害统计

	--print(timestamp, eventType, srcGUID, srcName,aAmount)


	
	if UnitIsPlayer(srcName) then--玩家普通攻击伤害统计
		if DamdgeData[srcName] == nil then
			DamdgeData[srcName] = 0
		end

		DamdgeData[srcName] = DamdgeData[srcName] + aAmount

	elseif isPartyPet(srcGUID) then--宠物是否是在队伍里的   --宠物伤害统计
    -- get owner
    	local ownerGUID, ownerName = getPetOwnerGUID(srcGUID), getPetOwnerName(srcGUID)
    	if DamdgeData[ownerName] == nil then
			DamdgeData[ownerName] = 0
		end
		DamdgeData[ownerName] = DamdgeData[ownerName] + aAmount			
	end

	
end

function MVPvsFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	if (Auras[spellId] or (AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName)  then
		if auraAmount and MVPDB then
			--MVPprint("<友情提示> "..dstName.." 受到伤害 "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.")
		elseif MVPDB then
			--MVPprint("<友情提示> "..dstName.." 受到伤害 "..GetSpellLink(spellId)..".")
		end
	end
end

function MVPvsFrame:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,a12,a13,a14,a15,a16,a17,a18,a19,a20 = CombatLogGetCurrentEventInfo(); -- Those arguments appear for all combat event variants.
	local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");

	

	if (eventPrefix:match("^SPELL") or eventPrefix:match("^RANGE")) and eventSuffix == "DAMAGE" then
		local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		MVPvsFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
	elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
		local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		MVPvsFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	elseif eventPrefix:match("^SPELL") and eventSuffix == "MISSED" then
		local spellId, spellName, spellSchool, missType, isOffHand, mAmount  = select(12,CombatLogGetCurrentEventInfo())
		if mAmount then
			MVPvsFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
		end
	elseif eventType == "SPELL_AURA_APPLIED" then
		local spellId, spellName, spellSchool, auraType = select(12,CombatLogGetCurrentEventInfo())
		MVPvsFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
	elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
		local spellId, spellName, spellSchool, auraType, auraAmount = select(12,CombatLogGetCurrentEventInfo())
		MVPvsFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	elseif eventType == "UNIT_DIED" then --死亡事件JANY
		local destName = select(9,CombatLogGetCurrentEventInfo())
		MVPvsFrame:DeathDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool,destName)
	elseif eventType == "SPELL_INTERRUPT" then--打断成功
		local a12 = select(12,CombatLogGetCurrentEventInfo())
		local a15 = select(15,CombatLogGetCurrentEventInfo())
		MVPvsFrame:InterruptDamage(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,a12,a15)
	elseif eventType == "SPELL_DISPEL" then--驱散
		MVPvsFrame:DISPELDamage(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2)
	elseif eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" and eventType ~= "SPELL_ABSORBED" then--治疗
		local amount = select(15,CombatLogGetCurrentEventInfo()) - select(16,CombatLogGetCurrentEventInfo())
		amount = floor(amount + .5)
		if amount < 1 then
		    -- stop on complete overheal or out of combat; heals will never start a new fight
		    return
		end
		MVPvsFrame:SpellHeal(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,amount)

	end
		
	  -- return on invalid event, vehicle, friendly fire, hostile healing, evaded返回无效事件，车辆，友军火力，敌对治疗，躲避
	  if not isValidEvent[eventType] or strsplit("-", srcGUID) == "Vehicle" or (band(dstFlags, 16) > 0 and isDamage[eventType])
	  or (band(dstFlags, 16) == 0 and isHeal[eventType]) or a15 == "EVADE" then
	    return
	  else

  	  MVPvsFrame:Batime(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags)
  	  end
end



SLASH_MostValuablePlayer1, SLASH_MostValuablePlayer1 = "/mvp", "/MostValuablePlayer";
SlashCmdList["MostValuablePlayer"] = function(msgs)
	if cfg.MVPvsnoti==true then
		print("MVP关")

		cfg.MVPvsnoti = false

	else
		print("MVP开")
		cfg.MVPvsnoti = true
	end
end



