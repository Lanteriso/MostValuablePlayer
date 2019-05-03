local Users = {}
local Timers = {}
local TimerData = {}
local CombinedFails = {} -- 额外受伤
local DeathData = {}--JANY用来记录一次副本里的死亡次数
local DamdgeData = {}--JANY用来记录一次副本里的总伤害量
local InterruptData = {}--打断次数
local score = {}--评分
local HealData = {} -- 治疗
local activeUser = nil
local playerUser = GetUnitName("player",true).."-"..GetRealmName():gsub(" ", "")
local hardMinPct = 20


local Spells = {
	-- Debug
	--[252144] = 1,
	--[252150] = 1,
	[260320] = 20,
	-- Affixes
	[209862] = 20,		-- Volcanic Plume (Environment)
	[226512] = 20,		-- Sanguine Ichor (Environment)

	-- Freehold
	[272046] = 20,		--- Dive Bomb (Sharkbait)
	[257426] = 20,		--- Brutal Backhand (Irontide Enforcer)
	[258352] = 20,		--- Grapeshot (Captain Eudora)
	[272374] = 20,		--- Whirlpool of Blades
	[256546] = 20,		--- Shark Tornado
	[257310] = 20,		--- Cannon Barrage
	[257902] = 20,		--- Shell Bounce (Ludwig Von Tortollan)
	[258199] = 20,		--- Ground Shatter (Irontide Crusher)
	[276061] = 20,		--- Boulder Throw (Irontide Crusher)
	[258779] = 20,		--- Sea Spout (Irontide Oarsman)
	[274400] = 20,		--- Duelist Dash (Cutwater Duelist)
	[257274] = 20,		--- Vile Coating (Environment)
	
	-- Shrine of the Storm
	[264560] = 20,		--- Choking Brine (Aqualing)
	[267899] = 20,		--- Hindering Cleave (Brother Ironhull)
	[268280] = 20,		--- Tidal Pod (Tidesage Enforcer)
	[276286] = 20,		--- Slicing Hurricane (Environment)
	[276292] = 20,		--- Whirlign Slam (Ironhull Apprentice)
	[269104] = 20,		--- Explosive Void (Lord Stormsong)
	[267385] = 20,		--- Tentacle Slam (Vol'zith the Whisperer)
	
	-- Siege of Boralus
	[256663] = 20,		--- Burning Tar (Blacktar Bomber)
	[275775] = 20,		--- Savage Tempest (Irontide Raider)
	[272426] = 20,		--- Sighted Artillery
	[272140] = 20,		--- Iron Volley
	[273681] = 20,		--- Heavy Hitter (Chopper Redhook)
	
	
	-- Tol Dagor
	[257785] = 20,		--- Flashing Daggers
	[256976] = 20,		--- Ignition (Knight Captain Valyri)
	[256955] = 20,		--- Cinderflame (Knight Captain Valyri)
	[256083] = 20,		--- Cross Ignition (Overseer Korgus)
	[263345] = 20,		--- Massive Blast (Overseer Korgus)
	[258864] = 20,		--- Suppression Fire (Ashvane Marine/Spotter)
	[258364] = 20,		--- Fuselighter (Ashvane Flamecaster)
	[259711] = 20,		--- Lockdown (Ashvane Warden)
	
	-- Waycrest Manor
	[260569] = 20,		--- Wildfire (Soulbound Goliath)
	[265407] = 20,		--- Dinner Bell (Banquet Steward)
	[264923] = 20,		--- Tenderize (Raal the Gluttonous)
	[264150] = 20,		--- Shatter (Thornguard)
	[271174] = 20,		--- Retch (Pallid Gorger)
	[268387] = 20,		--- Contagious Remnants (Lord Waycrest)
	[268308] = 20,		--- Discordant Cadenza (Lady Waycrest

	-- Atal'Dazar
	[253666] = 20,		--- Fiery Bolt (Dazar'ai Juggernaught)
	[257692] = 20,		--- Tiki Blaze (Environment)
	[255620] = 20,		--- Festering Eruption (Reanimated Honor Guard)
	[256959] = 20,		--- Rotting Decay (Renaimated Honor Guard)
	[250259] = 20,		--- Toxic Leap
	[250022] = 20,		--- Echoes of Shadra (Echoes of Shadra)
	[250585] = 20, 		--- Toxic Pool
	[250036] = 20,		--- Shadowy Remains

	-- King's Rest
	[265914] = 20,		--- Molten Gold (The Golden Serpent)
	[266191] = 20,		--- Whirling Axe (Council of Tribes)
	[270289] = 20,		--- Purification Beam
	[270503] = 20,		--- Hunting Leap (Honored Raptor)
	[271564] = 20,		--- Embalming Fluid (Embalming Fluid)
	[270485] = 20,		--- Blooded Leap (Spectral Berserker)
	[267639] = 20,		--- Burn Corruption (Mchimba the Embalmer)
	[270931] = 20,		-- Darkshot
	
	-- The MOTHERLODE!!
	[257371] = 20,		--- Gas Can (Mechanized Peace Keeper)
	[262287] = 20,		-- Concussion Charge (Mech Jockey / Venture Co. Skyscorcher)
	[268365] = 20,		--- Mining Charge (Wanton Sapper)
	[269313] = 20,		--- Final Blast (Wanton Sapper)
	[275907] = 20,		--- Tectonic Smash
	[259533] = 20,		--- Azerite Catalyst (Rixxa Fluxflame)
	[260103] = 20,		--- Propellant Blast
	[260279] = 20,		--- Gattling Gun (Mogul Razdunk)
	[276234] = 20, 		--- Micro Missiles
	[270277] = 20,		--- Big Red Rocket (Mogul Razdunk)
	[271432] = 20,		--- Test Missile (Venture Co. War Machine)
	[262348] = 20,		--- Mine Blast
	[257337] = 20,		--- Shocking Claw
	[269092] = 20,		--- Artillery Barrage (Ordnance Specialist)

	-- Temple of Sethraliss
	[273225] = 20,		--- Volley (Sandswept Marksman)
	[273995] = 20,		--- Pyrrhic Blast (Crazed Incubator)
	[264206] = 20,		--- Burrow (Merektha)
	[272657] = 20,		--- Noxious Breath
	

	-- Underrot
	[265542] = 20,		--- Rotten Bile (Fetid Maggot)
	[265019] = 20,		--- Savage Cleave (Chosen Blood Matron)
	[261498] = 20,		--- Creeping Rot (Elder Leaxa)
	[265665] = 20,		--- Foul Sludge (Living Rot)
}

local SpellsNoTank = {
	-- Freehold

	-- Shrine of the Storm
	[267899] = 20,  		--- Hindering Cleave

	-- Siege of Boralus

	-- Tol Dagor

	-- Waycrest Manor

	-- Atal'Dazar

	-- King's Rest

	-- The MOTHERLODE!!

	-- Temple of Sethraliss
	[255741] = 20,			--- Cleave (Scaled Krolusk Rider)

	-- Underrot
	[265019] = 20,			--- Savage Cleave (Chosen Blood Matron)
}

local Auras = {
	-- Freehold
	[274389] = true,		-- Rat Traps (Vermin Trapper)
	[274516] = true,		-- Slippery Suds
	
	-- Shrine of the Storm
	[268391] = true,		-- Mental Assault (Abyssal Cultist)
	[276268] = true,		-- Heaving Blow (Shrine Templar)

	-- Siege of Boralus
	[257292] = true,		-- Heavy Slash (Kul Tiran Vanguard)
	[272874] = true,		-- Trample (Ashvane Commander)

	-- Tol Dagor
	[257119] = true,		-- Sand Trap (The Sand Queen)
	[256474] = true,		-- Heartstopper Venom (Overseer Korgus)

	-- Waycrest Manor
	[265352] = true,		-- Toad Blight (Toad)
	
	-- Atal'Dazar

	-- King's Rest
	[270003] = true,		-- Suppression Slam (Animated Guardian)
	[270931] = true,		-- Darkshot
	[268796] = true,		-- (Kind Dazar)

	-- The MOTHERLODE!!
	
	-- Temple of Sethraliss
	[263914] = true,		-- Blinding Sand (Merektha)
	[269970] = true,		-- Blinding Sand (Merektha)

	-- Underrot
	[272609] = true,		-- Maddening Gaze (Faceless Corrupter)

}

local AurasNoTank = {
}

function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

local MVPFrame = CreateFrame("Frame", "MVPFrame")
MVPFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local MSG_PREFIX = "MostValuablePlayer"
local success = C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)
MVPFrame:RegisterEvent("CHAT_MSG_ADDON")
MVPFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
MVPFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MVPFrame:RegisterEvent("CHALLENGE_MODE_START")
MVPFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
MVPFrame:RegisterEvent("ADDON_LOADED")

MVPFrame:ClearAllPoints()
MVPFrame:SetHeight(100)
MVPFrame:SetWidth(100)
MVPFrame.text = MVPFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont")
MVPFrame.text:SetAllPoints()
MVPFrame.text:SetTextHeight(13)
MVPFrame:SetAlpha(1)

function table.pack(...)
  return { n = select("#", ...), ... }
end

MVPFrame:SetScript("OnEvent", function(self, event_name, ...)
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
				print("损失血量为 " .. amount)
			end
			if minPct == math.huge then
				local spellNames = " "
				for k,v in pairs(TimerData[user]) do
					spellNames = spellNames..GetSpellLink(k).." "
				end
				print("<友情提示> Error: Could not find spells"..spellNames.."in Spells or SpellsNoTank but got Timer for them. wtf")
			end
			TimerData[user] = nil
			Timers[user] = nil
			local userMaxHealth = UnitHealthMax(user)
			local msgAmount = round(amount/10000 ,1)
			local pct = Round(amount / userMaxHealth * 100)
			print(user,msg,amount)
			msg = msg.."命中,减 "..msgAmount.."万血 (-"..pct.."%)."
			print(msg)

			if pct >= hardMinPct and pct >= minPct and MVPDB then--这个判断未知
				msg = msg.."损失血量为 "..msgAmount.."万 (-"..pct.."%)."
				maybeSendChatMessage(msg)
				print(msg)
			end
		end
	return func
end

SLASH_ELITISMHELPER1 = "/eh"

SlashCmdList["MostValuablePlayer"] = function(msg,editBox)
	if msg == "activeuser" then
		if activeUser == playerUser then
			print("You are the activeUser")
		end
		
	elseif msg == "resync" then
		MVPFrame:RebuildTable()
		
	elseif msg == "table" then
		for k,v in pairs(Users) do
			print(k.." ;;; "..v)
		end
		
	elseif msg == "eod" then
		MVPFrame:CHALLENGE_MODE_COMPLETED()
		
	elseif msg == "on" or msg == "enable" then
		if MVPDB then
			print("ElitismHelper: Damage notifications are already enabled.")
		else
			MVPDB = true
			print("ElitismHelper: All damage notifications enabled.")
		end
		
	elseif msg == "off" or msg == "disable" then
		if not MVPDB then
			print("ElitismHelper: Damage notifications are already disabled.")
		else
			MVPDB = false
			print("ElitismHelper: Will only announce at the end of the dungeon.")
		end
	end
end

function maybeSendAddonMessage(prefix, message)
	if IsInGroup() and not IsInGroup(2) and not IsInRaid() then
		C_ChatInfo.SendAddonMessage(prefix,message,"PARTY")
	elseif IsInGroup() and not IsInGroup(2) and IsInRaid() then
		C_ChatInfo.SendAddonMessage(prefix,message,"RAID")
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

function MVPFrame:RebuildTable()
	Users = {}
	activeUser = nil
	if IsInGroup() then
		maybeSendAddonMessage(MSG_PREFIX,"VREQ")
	else
		name = GetUnitName("player",true)
		activeUser = name.."-"..GetRealmName()--名字-服务器名
		--print("【MVP插件】: "..activeUser)
	end
end

function MVPFrame:ADDON_LOADED(event,addon)
	if addon == "MostValuablePlayer" then
		MVPFrame:RebuildTable()
	end
	
	if not MVPDB then
		MVPDB = true
	end
end

function MVPFrame:GROUP_ROSTER_UPDATE(event,...)
	MVPFrame:RebuildTable()
end

function MVPFrame:ZONE_CHANGED_NEW_AREA(event,...)
	MVPFrame:RebuildTable()
end

function compareDamage(a,b)
	return a["value"] < b["value"]
end
function compareMVP(a,b)
	return a["value"] > b["value"]
end
function MVPFrame:CHALLENGE_MODE_COMPLETED(event,...)--挑战模式完成时
	--[[
	C_ChallengeMode.GetActiveChallengeMapID()
	C_ChallengeMode.GetActiveKeystoneInfo()
	C_ChallengeMode.GetAffixInfo(affixID)
	C_ChallengeMode.GetCompletionInfo()
	C_ChallengeMode.GetDeathCount()
	C_ChallengeMode.GetGuildLeaders()
	C_ChallengeMode.GetMapTable()
	C_ChallengeMode.GetMapUIInfo(mapChallengeModeID)
	C_ChallengeMode.GetPowerLevelDamageHealthMod(powerLevel)
	C_ChallengeMode.GetSlottedKeystoneInfo()
	activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo()
	mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
	mapChallengeModeID = C_ChallengeMode.GetActiveChallengeMapID()
	name, description, filedataid = C_ChallengeMode.GetAffixInfo(affixID)
	numDeaths, timeLost = C_ChallengeMode.GetDeathCount()
	topAttempt = C_ChallengeMode.GetGuildLeaders()
	mapChallengeModeIDs = C_ChallengeMode.GetMapTable()
	name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(mapChallengeModeID)
	damageMod, healthMod = C_ChallengeMode.GetPowerLevelDamageHealthMod(powerLevel)
	mapChallengeModeID, affixIDs, keystoneLevel = C_ChallengeMode.GetSlottedKeystoneInfo()
	
	local activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo()
	print("1 ",activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged )
	local mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
	print("2 ",mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels)--地图ID 钥匙等级 用时 是否限时 +几
	local mapChallengeModeID = C_ChallengeMode.GetActiveChallengeMapID()
	print("3 ",mapChallengeModeID)
	local numDeaths, timeLost = C_ChallengeMode.GetDeathCount()
	print("4 ",numDeaths, timeLost)
	local topAttempt = C_ChallengeMode.GetGuildLeaders()
	print("5 ",topAttempt)
	local mapChallengeModeIDs = C_ChallengeMode.GetMapTable()
	print("6 ",mapChallengeModeIDs)
	local mapChallengeModeID, affixIDs, keystoneLevel = C_ChallengeMode.GetSlottedKeystoneInfo()
	print("7 ",mapChallengeModeID, affixIDs, keystoneLevel)
	]]
	SendChatMessage("玩家         伤害           额外受伤        治疗     打断      阵亡      评分","PARTY")
	for k, v in pairs(DamdgeData) do 
		if not v then v=0 end
		if not CombinedFails[k] then CombinedFails[k] = 0 end
		if not InterruptData[k] then InterruptData[k] = 0 end
		if not DeathData[k] then DeathData[k] = 0 end
		if not HealData[k] then HealData[k] = 0 end
		if not score[k] then score[k] = 0 end
		
		score[k] = round((v + HealData[k] - CombinedFails[k] * 3) / 100000 ,1)+InterruptData[k]-DeathData[k]*3
		SendChatMessage(k..round(v / 10000 ,1).." 万--"..round(CombinedFails[k] / 10000 ,1).." 万--"..round(HealData[k] / 10000 ,1).." 万--"..InterruptData[k].." 断--"..DeathData[k].." 亡--"..score[k].." 分","PARTY") --总伤害量 额外受伤 死亡次数  打断次数
		--print("【sovijo】说：","伤害-额外受伤-打断-死亡-评分-MVP",round((30000000 - 2000000 * 3) / 100000 ,1) + 30 - 5*3)
	end
	local fs = { }
	for k, v in pairs(score) do table.insert(fs, { key = k, value = v }) end
	table.sort(fs, compareMVP)
	for k,v in pairs(fs) do
		SendChatMessage("恭喜 "..v["key"].." "..v["value"].." 分   【MVP】","PARTY")
		break
	end

	local count = 0
	for _ in pairs(CombinedFails) do count = count + 1 end
	if count == 0 then
		--maybeSendChatMessage("Thank you for travelling with ElitismHelper. No failure damage was taken this run.")
		return
	else
		print("--------------------:")
		--maybeSendChatMessage("----------排行榜:")
	end
	local u = { }
	for k, v in pairs(CombinedFails) do table.insert(u, { key = k, value = v }) end
	table.sort(u, compareDamage)
	for k,v in pairs(u) do
		--print(k..". "..v["key"].." "..round(v["value"] / 10000 ,1).." 万")
			--maybeSendChatMessage(k..". "..v["key"].." "..round(v["value"] / 10000 ,1).." 万")
	end
	CombinedFails = {} -- 不躲技能受到的伤害
	DeathData = {}--挑战模式完成时 重置死亡次数为nil  ----jany
	DamdgeData = {}--挑战模式完成时 重置总伤害为nil---jany
	InterruptData ={} --打断次数
	HealData ={}--治疗
	score={}--评分
end

function MVPFrame:CHALLENGE_MODE_START(event,...)--挑战模式启动 时重置伤害为nil,死亡次数为nil
	CombinedFails = {} -- 不躲技能受到的伤害
	DeathData = {}--挑战模式启动时 重置伤害为nil,死亡次数为nil   ----jany
	DamdgeData = {}--挑战模式启动时 重置总伤害为nil---jany
	InterruptData ={}--打断次数
	HealData ={}--治疗
	score={}
end

function MVPFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	if prefix ~= MSG_PREFIX then
		return
	end
	if message == "VREQ" then
		maybeSendAddonMessage(MSG_PREFIX,"VANS;0.1")
	elseif message:match("^VANS") then
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
		print("Unknown message: "..message)
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

function MVPFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, aAmount)
	--print("发生了攻击事件Spells[spellId]"..timestamp, eventType,srcName,aAmount)
	if (Spells[spellId] or (SpellsNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName) then
		-- Initialize TimerData and CombinedFails for Timer shot 为计时器快照初始化,
		if TimerData[dstName] == nil then
			TimerData[dstName] = {}
		end
		if CombinedFails[dstName] == nil then
			CombinedFails[dstName] = 0
		end

		
		-- Add this event to TimerData / CombinedFails
		CombinedFails[dstName] = CombinedFails[dstName] + aAmount
		if TimerData[dstName][spellId] == nil then
			TimerData[dstName][spellId] = aAmount
		else
			TimerData[dstName][spellId] = TimerData[dstName][spellId] + aAmount
		end


		
		-- 如果还没有计时器，请使用此事件启动计时器。在2秒内受到的伤害，防刷屏吧？猜的，可以改成别的时间，比如10秒
		if Timers[dstName] == nil then
			Timers[dstName] = true
			C_Timer.After(2,generateMaybeOutput(dstName))
		end--玩害受到伤害统计
	end

	if UnitIsPlayer(srcName) then--玩害技能伤害统计
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
function MVPFrame:DeathDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool,destName)
	if UnitIsPlayer(dstName) then--如果死亡的是队友和我   srcName是甲方    dstName是乙方     这是 怪物 击败了 玩家

		if DeathData[dstName] == nil then
			DeathData[dstName] = 0
		end
		DeathData[dstName] = DeathData[dstName] + 1
		if destName then
		print(destName .. " 失去 " .. DeathData[dstName] .. " 血！")
		else
		print("发生了死亡事件")	
		end
	end
end
--打断事件JANY
function MVPFrame:InterruptDamage(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,a12,a15)
	local inInstance = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	local inParty = IsInGroup()--是否在小队
	local inRaid = IsInRaid()
	if UnitIsPlayer(srcName) and inParty then--如果打断的人是队友和我  srcName是甲方    dstName是乙方     这是 玩家 打断了 怪物
		if InterruptData[srcName] == nil then
			InterruptData[srcName] = 0
		end
		InterruptData[srcName] = InterruptData[srcName] + 1
		if srcName then
		print(srcName .. " 打断 " .. InterruptData[srcName] .. " 次！")
		--SendChatMessage(srcName .. " 打断 " .. InterruptData[srcName] .. " 次！人品+1","PARTY")
		else
		print("发生了打断事件")	
		end
	end
end
--发生治疗事件
function MVPFrame:SpellHeal(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,amount)
	if UnitIsPlayer(srcName) then
		if HealData[srcName] == nil then
			HealData[srcName] = 0
		end
		HealData[srcName] = HealData[srcName] + amount
	end	
end

function MVPFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)--玩害普通攻击伤害统计

	--print(timestamp, eventType, srcGUID, srcName,aAmount)


	
	if UnitIsPlayer(srcName) then--玩害普通攻击伤害统计
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

function MVPFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	if (Auras[spellId] or (AurasNoTank[spellId] and UnitGroupRolesAssigned(dstName) ~= "TANK")) and UnitIsPlayer(dstName)  then
		if auraAmount and MVPDB then
			maybeSendChatMessage("<友情提示> "..dstName.." 受到伤害 "..GetSpellLink(spellId)..". "..auraAmount.." Stacks.")
		elseif MVPDB then
			maybeSendChatMessage("<友情提示> "..dstName.." 受到伤害 "..GetSpellLink(spellId)..".")
		end
	end
end

function MVPFrame:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	local timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,a12,a13,a14,a15,a16,a17,a18,a19,a20 = CombatLogGetCurrentEventInfo(); -- Those arguments appear for all combat event variants.
	local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");

	if (eventPrefix:match("^SPELL") or eventPrefix:match("^RANGE")) and eventSuffix == "DAMAGE" then
		local spellId, spellName, spellSchool, sAmount, aOverkill, sSchool, sResisted, sBlocked, sAbsorbed, sCritical, sGlancing, sCrushing, sOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		MVPFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, sAmount)
	elseif eventPrefix:match("^SWING") and eventSuffix == "DAMAGE" then
		local aAmount, aOverkill, aSchool, aResisted, aBlocked, aAbsorbed, aCritical, aGlancing, aCrushing, aOffhand, _ = select(12,CombatLogGetCurrentEventInfo())
		MVPFrame:SwingDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, aAmount)
	elseif eventPrefix:match("^SPELL") and eventSuffix == "MISSED" then
		local spellId, spellName, spellSchool, missType, isOffHand, mAmount  = select(12,CombatLogGetCurrentEventInfo())
		if mAmount then
			MVPFrame:SpellDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, mAmount)
		end
	elseif eventType == "SPELL_AURA_APPLIED" then
		local spellId, spellName, spellSchool, auraType = select(12,CombatLogGetCurrentEventInfo())
		MVPFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType)
	elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
		local spellId, spellName, spellSchool, auraType, auraAmount = select(12,CombatLogGetCurrentEventInfo())
		MVPFrame:AuraApply(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, auraType, auraAmount)
	elseif eventType == "UNIT_DIED" then --死亡事件JANY
		local destName = select(9,CombatLogGetCurrentEventInfo())
		MVPFrame:DeathDamage(timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool,destName)
	elseif eventType == "SPELL_INTERRUPT" then--打断成功
		local a12 = select(12,CombatLogGetCurrentEventInfo())
		local a15 = select(15,CombatLogGetCurrentEventInfo())
		MVPFrame:InterruptDamage(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,a12,a15)
	elseif eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" and eventType ~= "SPELL_ABSORBED" then--治疗
		local amount = select(15,CombatLogGetCurrentEventInfo()) - select(16,CombatLogGetCurrentEventInfo())
		amount = floor(amount + .5)
		if amount < 1 then
		    -- stop on complete overheal or out of combat; heals will never start a new fight
		    return
		end
		MVPFrame:SpellHeal(timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2,amount)
		


	end
end
