local friends = {}

local function Event(event, handler)
    if _G.event == nil then
        _G.event = CreateFrame("Frame")
        _G.event.handler = {}
        _G.event.OnEvent = function(frame, event, ...)
            for key, handler in pairs(_G.event.handler[event]) do
                handler(...)
            end
        end
        _G.event:SetScript("OnEvent", _G.event.OnEvent)
    end
    if _G.event.handler[event] == nil then
        _G.event.handler[event] = {}
        _G.event:RegisterEvent(event)
    end
    table.insert(_G.event.handler[event], handler)
end


local function colortxt(name)
    if name then
        if UnitInRaid(name) or UnitInParty(name) then
            local rsccodeclass = 0
            local _, rsctekclass = UnitClass(name)
            if rsctekclass then
                rsctekclass = string.lower(rsctekclass)
                if rsctekclass == "warrior" then rsccodeclass = 1
                elseif rsctekclass == "deathknight" then rsccodeclass = 2
                elseif rsctekclass == "paladin" then rsccodeclass = 3
                elseif rsctekclass == "priest" then rsccodeclass = 4
                elseif rsctekclass == "shaman" then rsccodeclass = 5
                elseif rsctekclass == "druid" then rsccodeclass = 6
                elseif rsctekclass == "rogue" then rsccodeclass = 7
                elseif rsctekclass == "mage" then rsccodeclass = 8
                elseif rsctekclass == "warlock" then rsccodeclass = 9
                elseif rsctekclass == "hunter" then rsccodeclass = 10
                elseif rsctekclass == "monk" then rsccodeclass = 11
                elseif rsctekclass == "demonhunter" then rsccodeclass = 12
                end
                local tablecolor = {
                    "|cFFC79C6E", --1
                    "|CFFC41F3B", --2
                    "|cFFF58CBA", --3
                    "|CFFFFFFFF", --4
                    "|cFF0070DE", --5
                    "|CFFFF7C0A", --6
                    "|CFFFFF569", --7
                    "|CFF69CCF0", --8
                    "|CFF9382C9", --9
                    "|CFFABD473", --10
                    "|CFF00FF96", --11
                    "|CFFA330C9", --12
                    "|cff999999"}
                if rsccodeclass == 0 then
                    return "|cff999999" --для цвет петов
                else
                    return tablecolor[rsccodeclass]
                end
            end
        else
            return "" --цвет петов
        end
    end

end


local function GetColor(nr, name)
    if name then
        if nr == 2 then
            return "|r"
        end
        if nr == 1 then
            local realm = nil
            local _, localrealm = UnitFullName("player", true)
            
            if string.find(name, "%-") then
                realm = string.sub(name, string.find(name, "%-") + 1, -1)
            end
            
            if string.find(name, "%%") then
                name = string.sub(name, 1, string.find(name, "%%") - 1)
            end
            
            local color = colortxt(name)
            
            if color ~= "" then
                return color
            end
            
            for i in pairs(MVP_Settings["MVPvscache"]) do
                if (name == MVP_Settings["MVPvscache"][i]["oname"] and (realm == "" or realm == nil) and localrealm == MVP_Settings["MVPvscache"][i]["orealm"]) then
                    return string.sub(MVP_Settings["MVPvscache"][i]["oclass"], 1, 10)
                end
            end
            
            for i in pairs(MVP_Settings["MVPvscache"]) do
                if (name == MVP_Settings["MVPvscache"][i]["oname"] and (realm == MVP_Settings["MVPvscache"][i]["orealm"] or realm == "" or realm == nil)) then
                    return string.sub(MVP_Settings["MVPvscache"][i]["oclass"], 1, 10)
                end
            end
            return "|cFF000000"
        end
    end
end

local function addcolor(str1, tag, str2)
    local strmid = string.gsub(tag, "%%%-", "-")
    local a, b = string.find(str2, tag)
    if string.lower(string.sub(str1, -10, -1)) ~= string.lower(GetColor(1, tag)) then
        strmid = GetColor(1, tag) .. strmid .. "|r"
        if string.lower(string.sub(str1, -10, -7)) == "|cff" then
            strmid = strmid .. string.lower(string.sub(str1, -10, -1))
        end
    end
    if a then
        str2 = addcolor(string.sub(str2, 1, a - 1), tag, string.sub(str2, b + 1, -1))
    end
    return str1 .. strmid .. tostring(str2)
end

local psfilter = function(_, event, msg, player, ...)
    if friends == {} then
        return false
    else
        for i = 1, #(friends) do
            tag = friends[i]
            a, b = string.find(msg, tag)
            if a then
                msg = addcolor(string.sub(msg, 1, a - 1), tag, string.sub(msg, b + 1, -1))
            end
            if string.find(msg,"|Hplayer:.+"..tag.."|r|h%[.+"..tag.."|r%]|h") then
                msg=string.gsub(msg,"|Hplayer:.+" .. tag .. "|r|h%[.+" .. tag .. "|r%]|h", "[" .. GetColor(1, tag) .. "|Hplayer:" .. tag .. "|h" .. tag .. "|h|r]")
            end
        end
        return false, msg, player, ...
    end
end

local function ADDfilter()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BG_SYSTEM_ALLIANCE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BG_SYSTEM_HORDE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BG_SYSTEM_NEUTRAL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_ALERT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_CONVERSATION", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_PLAYER_OFFLINE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LIST", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE_USER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_HONOR_GAIN", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_MISC_INFO", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_XP_GAIN", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMMUNITIES_CHANNEL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CURRENCY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_FILTERED", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ITEM_LOOTED", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_IGNORED", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONEY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_PARTY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_OPENING", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PET_BATTLE_COMBAT_LOG", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PET_BATTLE_INFO", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PET_INFO", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_BOSS_EMOTE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_BOSS_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RESTRICTED", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SKILL", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_TARGETICONS", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_TRADESKILLS", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", psfilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", psfilter)
end

local function addfriends()
    local name, realm = UnitFullName("player")
    for i in pairs(MVP_Settings["MVPvscache"]) do
        table.insert(friends, MVP_Settings["MVPvscache"][i]["oname"] .. "%-" .. MVP_Settings["MVPvscache"][i]["orealm"])
        table.insert(friends, MVP_Settings["MVPvscache"][i]["oname"])
    end
    local aa = {}
    for k, v in pairs(friends) do
        aa[v] = true
    end
    friends = {}
    for k, v in pairs(aa) do
        table.insert(friends, k)
    end
    table.sort(friends, function(a, b) return tostring(a) > tostring(b) end)
end

Event("PLAYER_LOGIN", function()
    ADDfilter()
end)

Event("PLAYER_ENTERING_WORLD", function()
    addfriends()
end)

Event("PLAYER_REGEN_DISABLED", function()
    addfriends()
end)
