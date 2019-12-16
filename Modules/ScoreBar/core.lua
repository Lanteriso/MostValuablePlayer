
local _, nPower = ...
local config = nPower.Config


local strsplit, format = strsplit, format

local function GetRealMpFive()
    local _, activeRegen = GetPowerRegen()
    local realRegen = activeRegen * 5
    local _, powerType = UnitPowerType("player")

    if (powerType == "MANA" or UnitHasVehicleUI("player")) then
        return math.floor(realRegen)
    else
        return ""
    end
end

local function GetHPPercentage()
    local currentHP = UnitHealth("player")
    local maxHP = UnitHealthMax("player")
    return math.floor(100*currentHP/maxHP)
end

local function CalcRuneCooldown(num)
    local start, duration, runeReady = GetRuneCooldown(num)
    local time = floor(GetTime() - start)
    local cooldown = ceil(duration - time)

    if (runeReady or UnitIsDeadOrGhost("player")) then
        return "#"
    elseif (not UnitIsDeadOrGhost("player") and cooldown) then
        return cooldown
    end
end

local function HolyPowerCheck(num)
    local curPower = UnitPower("player", Enum.PowerType.HolyPower)
    return num <= curPower and "|cffFFFF00#|r" or "|cffC0C0C0-|r"
end

local function SetPowerColor(self)
    local powerType
    if (self.class == "ROGUE" or self.class == "DRUID") then
        powerType = Enum.PowerType.ComboPoints
    elseif (self.class == "MONK") then
        powerType = Enum.PowerType.Chi
    elseif (self.class == "MAGE") then
        powerType = Enum.PowerType.ArcaneCharges
    elseif (self.class == "PALADIN") then
        powerType = Enum.PowerType.HolyPower
    elseif (self.class == "WARLOCK") then
        powerType = Enum.PowerType.SoulShards
    end

    local currentPower = UnitPower("player", powerType)
    local maxPower = UnitPowerMax("player", powerType)

    if (UnitIsDeadOrGhost("target")) then
        return 1, 1, 1
    elseif (currentPower == maxPower-1) then
        return 0.9, 0.7, 0.0
    elseif (currentPower == maxPower) then
        return 1, 0, 0
    else
        return 1, 1, 1
    end
end

local function UpdateArrow(self)
    if (UnitPower("player") == 0) then
        self.Power.Below:SetAlpha(0.3)
        self.Power.Above:SetAlpha(0.3)
    else
        self.Power.Below:SetAlpha(1)
        self.Power.Above:SetAlpha(1)
    end

    --local newPosition = UnitPower("player") / UnitPowerMax("player") * self.Power:GetWidth()
    --self.Power.Below:SetPoint("TOP", self.Power, "BOTTOMLEFT", newPosition, 0)
    self.Power.Below:SetPoint("TOP", self.Power, "BOTTOMLEFT", GetHPPercentage()*2, 0)
end


local function UpdateBarValue(self,Junit)
    --[[
    local min = UnitPower("player")
    self.Power:SetMinMaxValues(0, UnitPowerMax("player"))
    self.Power:SetValue(min)
    if (config.valueAbbrev) then
        self.Power.Value:SetText(min > 0 and nPower:FormatValue(min) or "")
    else
        self.Power.Value:SetText(min > 0 and min or "")
    end
    
    local currentHP = UnitHealth("player")
    local maxHP = UnitHealthMax("player")
    self.Power:SetMinMaxValues(0, maxHP)
    self.Power:SetValue(currentHP)
    if (config.valueAbbrev) then
        self.Power.Value:SetText(currentHP > 0 and nPower:FormatValue(currentHP) or "")
        
    else
        self.Power.Value:SetText(currentHP > 0 and currentHP or "")
        
    end
    ]]
    local name = GetUnitName(Junit,true)
    if not name then return end
    local sco,maxscore = GetScoreData()
    
    --JANY名称
    self.Power.sname:SetText(strsplit("-",name))

    --JANY分数
    local currentHP = sco[name] or 0
    local maxHP = maxscore or 100
    self.Power:SetMinMaxValues(0, maxHP)
    self.Power:SetValue(currentHP)
    if (config.valueAbbrev) then
        self.Power.Value:SetText(currentHP > 0 and nPower:FormatValue(currentHP) or "")
        
    else
        self.Power.Value:SetText(currentHP > 0 and currentHP or "")          
    end 
end


local function UpdateBarColor(self,Junit)
    local _, powerToken, altR, altG, altB = UnitPowerType("player")
    local unitPower = PowerBarColor[powerToken]

    local _,classMatch = UnitClass(Junit)
    if classMatch then
        local classColorTable = _G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[classMatch] or _G.RAID_CLASS_COLORS[classMatch];
        self.Power:SetStatusBarColor(classColorTable.r, classColorTable.g, classColorTable.b)
    elseif (unitPower) then
        if (powerToken == "MANA") then
            self.Power:SetStatusBarColor(0.0, 0.55, 1.0)
        else
            self.Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
        end
    else
        self.Power:SetStatusBarColor(altR, altG, altB)
    end

end

local function UpdateBarVisibility(self,Junit)
    
    local _, powerToken = UnitPowerType(Junit)
    local newAlpha = nil
    if not powerToken then self.Power:SetAlpha(0) end
    if (not config.showPowerType[powerToken] or UnitIsDeadOrGhost(Junit) or UnitHasVehicleUI(Junit)) then
        self.Power:SetAlpha(0)
    elseif (InCombatLockdown()) then
        newAlpha = config.activeAlpha
    elseif (not InCombatLockdown() and UnitPower(Junit) > 0) then
        newAlpha = config.inactiveAlpha
    else
        newAlpha = config.emptyAlpha
    end

    if (newAlpha) then
        nPower:Fade(self.Power, 0.3, self.Power:GetAlpha(), newAlpha)
    end
end

local function RuneUpdate(self, elapsed)
    self.updateTimer = self.updateTimer + elapsed

    if (self.updateTimer > 0.1) then
        for i = 1, 6 do
            if (UnitHasVehicleUI("player")) then
                if (self.Rune[i]:IsShown()) then
                    self.Rune[i]:Hide()
                end
            else
                if (not self.Rune[i]:IsShown()) then
                    self.Rune[i]:Show()
                end
            end

            self.Rune[i]:SetText(CalcRuneCooldown(i))
            self.Rune[i]:SetTextColor(0.0, 0.6, 0.8)
        end

        self.updateTimer = 0
    end
end

local function HolyPowerUpdate(self, elapsed)
    if self.spec ~= SPEC_PALADIN_RETRIBUTION then
        for i = 1, 5 do
            self.Rune[i]:Hide()
        end
        return
    end

    self.updateTimer = self.updateTimer + elapsed

    if (self.updateTimer > 0.1) then
        for i = 1, 5 do
            if (UnitHasVehicleUI("player")) then
                if (self.Rune[i]:IsShown()) then
                    self.Rune[i]:Hide()
                end
            else
                if (not self.Rune[i]:IsShown()) then
                    self.Rune[i]:Show()
                end
            end

            self.Rune[i]:SetText(HolyPowerCheck(i))
        end

        self.updateTimer = 0
    end
end





function P2Score_OnLoad(self,Xaxis,Yaxis)
    self.updateTimer = 0
    self.class = select(2, UnitClass("player"))
    self.spec = GetSpecialization()

    self:SetScale(config.scale)
    self:SetSize(18, 18)

    self:SetPoint(unpack({"CENTER", ScoreFrame, Xaxis,Yaxis}))
    self:EnableMouse(false)

    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("PLAYER_TALENT_UPDATE")
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    self:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
    self:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
    self:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
    self:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")
    self:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
    self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
    self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")

    if (config.showCombatRegen) then
        self:RegisterUnitEvent("UNIT_AURA", "player")
    end

    if (config.hp.show) then
        self:RegisterUnitEvent("UNIT_HEALTH", "player")
        self:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
        self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
        --nPower:SetupHealth(self)
    end

    nPower:SetupPower(self)

    if nPower:HasExtraPoints(self.class) then
        --nPower:SetupExtraPoints(self)
    end

    if (self.class == "DEATHKNIGHT" and config.showRunes) then
        --nPower:SetupRunes(self)
    end

    if (self.class == "PALADIN" and config.holyPower.showRunes) then
        --nPower:SetupHolyPower(self)
    end
end

function P2Score_OnEvent(self, event,Junit, ...)
    if (self.extraPoints) then
        if (UnitHasVehicleUI("player")) then
            if (self.extraPoints:IsShown()) then
                self.extraPoints:Hide()
            end
        else
            local nump
            if (self.class == "WARLOCK") then
                nump = WarlockPowerBar_UnitPower("player")
            elseif (self.class == "PALADIN") then
                nump = UnitPower("player", Enum.PowerType.HolyPower)
            elseif (self.class == "ROGUE" or self.class == "DRUID") then
                nump = UnitPower("player", Enum.PowerType.ComboPoints)
            elseif (self.class == "MONK") then
                nump = UnitPower("player", Enum.PowerType.Chi)
            elseif (self.class == "MAGE") then
                nump = UnitPower("player", Enum.PowerType.ArcaneCharges)
            end

            self.extraPoints:SetTextColor(SetPowerColor(self))
            self.extraPoints:SetText(nump == 0 and "" or nump)

            if (not self.extraPoints:IsShown()) then
                self.extraPoints:Show()
            end

            nPower:UpdateHealthTextLocation(self, nump)
        end
    end

    if (self.mpreg and (event == "UNIT_AURA" or event == "PLAYER_ENTERING_WORLD")) then
        self.mpreg:SetText(GetRealMpFive())
    end

    if (self.HPText) then
        if (UnitHasVehicleUI("player")) then
            if (self.HPText:IsShown()) then
                self.HPText:Hide()
            end
        else
            self.HPText:SetTextColor(unpack(config.hp.hpFontColor))
            self.HPText:SetText(GetHPPercentage())

            if (not self.HPText:IsShown()) then
                self.HPText:Show()
            end
        end
    end

    --UpdateArrow(self)
    UpdateBarValue(self,Junit)
    UpdateBarColor(self,Junit)
    UpdateBarVisibility(self,Junit)

    if (event == "PLAYER_ENTERING_WORLD") then
        if (InCombatLockdown()) then
            securecall("UIFrameFadeIn", self, 0.35, self:GetAlpha(), 1)
        else
            securecall("UIFrameFadeOut", self, 0.35, self:GetAlpha(), config.inactiveAlpha)
        end
    elseif (event == "PLAYER_REGEN_DISABLED") then
        securecall("UIFrameFadeIn", self, 0.35, self:GetAlpha(), 1)
    elseif (event == "PLAYER_REGEN_ENABLED") then
        securecall("UIFrameFadeOut", self, 0.35, self:GetAlpha(), config.inactiveAlpha)
    elseif (event == "PLAYER_LEVEL_UP") then
        local level = ...
        if level >= PALADINPOWERBAR_SHOW_LEVEL then
            self:UnregisterEvent("PLAYER_LEVEL_UP")
            nPower:SetupHolyPower(self)
        end
    elseif (event == "PLAYER_TALENT_UPDATE") then
        self.spec = GetSpecialization()
        nPower:UpdateHealthTextLocation(self)
    end
end



function nPower:SetupHealth(self)
    self.HPText = self:CreateFontString(nil, "ARTWORK")
    if (config.hp.hpFontOutline) then
        self.HPText:SetFont(config.hp.hpFont, config.hp.hpFontSize, "THINOUTLINE")
        self.HPText:SetShadowOffset(0, 0)
    else
        self.HPText:SetFont(config.hp.hpFont, config.hp.hpFontSize)
        self.HPText:SetShadowOffset(1, -1)
    end
    self.HPText:SetParent(self)
    nPower:UpdateHealthTextLocation(self)
end

function nPower:SetupPower(self)
    self.Power = CreateFrame("StatusBar", nil, UIParent)
    self.Power:SetScale(self:GetScale())
    self.Power:SetSize(config.sizeWidth, 9)
    self.Power:SetPoint("CENTER", self, 0, -23)
    self.Power:SetStatusBarTexture([[Interface\AddOns\MostValuablePlayer\Modules\ScoreBar\media\statusbarTexture]])
    self.Power:SetAlpha(0)

    self.Power.Value = self.Power:CreateFontString(nil, "ARTWORK")

    if (config.valueFontOutline) then
        self.Power.Value:SetFont(config.valueFont, config.valueFontSize, "THINOUTLINE")
        self.Power.Value:SetShadowOffset(0, 0)
    else
        self.Power.Value:SetFont(config.valueFont, config.valueFontSize)
        self.Power.Value:SetShadowOffset(1, -1)
    end

    self.Power.Value:SetPoint("RIGHT", self.Power, 0, config.valueFontAdjustmentX)
    self.Power.Value:SetVertexColor(1, 1, 1)

    self.Power.sname = self.Power:CreateFontString(nil, "ARTWORK")

    self.Power.sname:SetFont(config.valueFont, 12, "THINOUTLINE")
    self.Power.sname:SetShadowOffset(0, 0)
    self.Power.sname:SetPoint("LEFT", self.Power, "LEFT", 0, 0)



    self.Power.Background = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.Background:SetAllPoints(self.Power)
    self.Power.Background:SetTexture([[Interface\AddOns\MostValuablePlayer\Modules\ScoreBar\media\statusbarTexture]])
    self.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

    self.Power.BackgroundShadow = CreateFrame("Frame", nil, self.Power)
    self.Power.BackgroundShadow:SetFrameStrata("BACKGROUND")
    self.Power.BackgroundShadow:SetPoint("TOPLEFT", -4, 4)
    self.Power.BackgroundShadow:SetPoint("BOTTOMRIGHT", 4, -4)
    self.Power.BackgroundShadow:SetBackdrop({
        BgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        edgeFile = [[Interface\Addons\MostValuablePlayer\Modules\ScoreBar\\media\textureGlow]], edgeSize = 4,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    })
    self.Power.BackgroundShadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
    self.Power.BackgroundShadow:SetBackdropBorderColor(0, 0, 0)




    if (config.showCombatRegen) then
        self.mpreg = self.Power:CreateFontString(nil, "ARTWORK")
        self.mpreg:SetFont(config.valueFont, 12, "THINOUTLINE")
        self.mpreg:SetShadowOffset(0, 0)
        self.mpreg:SetPoint("TOP", self.Power.Below, "BOTTOM", 0, 4)
        self.mpreg:SetParent(self.Power)
        self.mpreg:Show()
    end



end

function nPower:SetupExtraPoints(self)
    self.extraPoints = self:CreateFontString(nil, "ARTWORK")

    if (config.extraFontOutline) then
        self.extraPoints:SetFont(config.extraFont, config.extraFontSize, "THINOUTLINE")
        self.extraPoints:SetShadowOffset(0, 0)
    else
        self.extraPoints:SetFont(config.extraFont, config.extraFontSize)
        self.extraPoints:SetShadowOffset(1, -1)
    end

    self.extraPoints:SetParent(self)
    self.extraPoints:SetPoint("CENTER", 0, 0)
end

function nPower:SetupRunes(self)
    self.Rune = {}

    for i = 1, 6 do
        self.Rune[i] = self:CreateFontString(nil, "ARTWORK")
        self.Rune[i]:SetParent(self)

        if (config.rune.runeFontOutline) then
            self.Rune[i]:SetFont(config.rune.runeFont, config.rune.runeFontSize, "THINOUTLINE")
            self.Rune[i]:SetShadowOffset(0, 0)
        else
            self.Rune[i]:SetFont(config.rune.runeFont, config.rune.runeFontSize)
            self.Rune[i]:SetShadowOffset(1, -1)
        end

        self.Rune[i]:SetJustifyV("MIDDLE")
        self.Rune[i]:SetJustifyH("CENTER")
        self.Rune[i]:SetWidth(config.rune.runeFontSize*1.2)
    end

    -- Left Side
    self.Rune[3]:SetPoint("RIGHT", self, "CENTER", -2, 2)
    self.Rune[2]:SetPoint("RIGHT", self.Rune[3], "LEFT", -2, 0)
    self.Rune[1]:SetPoint("RIGHT", self.Rune[2], "LEFT", -2, 0)

    --Right Side
    self.Rune[4]:SetPoint("LEFT", self, "CENTER", 2, 2)
    self.Rune[5]:SetPoint("LEFT", self.Rune[4], "RIGHT", 2, 0)
    self.Rune[6]:SetPoint("LEFT", self.Rune[5], "RIGHT", 2, 0)

    self:SetScript("OnUpdate", RuneUpdate)

    if (self.HPText) then
        nPower:UpdateHealthTextLocation(self)
    end
end

function nPower:SetupHolyPower(self)
    if UnitLevel("player") < PALADINPOWERBAR_SHOW_LEVEL then
        self:RegisterEvent("PLAYER_LEVEL_UP")
        return
    end

    self.Rune = {}

    for i = 1, 5 do
        self.Rune[i] = self:CreateFontString(nil, "ARTWORK")
        self.Rune[i]:SetParent(self)

        if (config.holyPower.holyFontOutline) then
            self.Rune[i]:SetFont(config.holyPower.holyFont, config.holyPower.holyFontSize, "THINOUTLINE")
            self.Rune[i]:SetShadowOffset(0, 0)
        else
            self.Rune[i]:SetFont(config.holyPower.holyFont, config.holyPower.holyFontSize)
            self.Rune[i]:SetShadowOffset(1, -1)
        end

        self.Rune[i]:SetJustifyV("MIDDLE")
        self.Rune[i]:SetJustifyH("CENTER")
        self.Rune[i]:SetWidth(config.holyPower.holyFontSize)
    end

    -- Center Point
    self.Rune[3]:SetPoint("CENTER", 0, 2)
    -- Left Side
    self.Rune[2]:SetPoint("RIGHT", self.Rune[3], "LEFT", -2, 0)
    self.Rune[1]:SetPoint("RIGHT", self.Rune[2], "LEFT", -2, 0)
    -- Right Side
    self.Rune[4]:SetPoint("LEFT", self.Rune[3], "RIGHT", 2, 0)
    self.Rune[5]:SetPoint("LEFT", self.Rune[4], "RIGHT", 2, 0)

    self:SetScript("OnUpdate", HolyPowerUpdate)

    if (self.HPText) then
        nPower:UpdateHealthTextLocation(self)
    end
end

local function Jtime()
    local Ti = Ti or 0
    local Fi = Fi or CreateFrame("frame")
    local t=GetTime()
    if t-Ti>5000 then
        StaticPopup1Button1:Click()
        Ti = t
        print("点击了")
    end 
end


function ScoreFrame_OnLoad(self)
    self:RegisterForDrag("LeftButton");

    self.Fname = self:CreateFontString(nil, "ARTWORK")
    self.Fname:SetFont(config.valueFont, 12, "THINOUTLINE")
    self.Fname:SetShadowOffset(0, 0)
    self.Fname:SetPoint("CENTER", self, "CENTER", 0, 0)
    self.Fname:SetText("M V P")
end
local Jtime = 0
function ScoreFrame_OnUpdate(self, elapsed)
    --[[
LFDMicroButton:Click()
HonorFrameQueueButton:Click()
LFDRoleCh:Click()
StaticPopup1Button2:Click()
LFDRoleCheckPopupAcceptButton:Click()
PVPReadyDialogEnterBattleButton:Click()
PVPMatchResults["leaveButton"]:Click()
PVEFrameTab2:Click()

    T, F = T or 0, F or CreateFrame("frame")
    if X then 
        X=nil 
    else 
        X=function()
            local t=GetTime()
            if t-T>1 then 
                StaticPopup1Button1:Click()
                T=t 
            end 
        end 
    end 
    F:SetScript("OnUpdate",X)

    Jtime = Jtime +elapsed
    if Jtime > 5 then
        print("点击了")
        Jtime =0

            LFDMicroButton:Click()

        

            --HonorFrameQueueButton:Click()


            --LFDRoleCh:Click()

            StaticPopup1Button2:Click()

            LFDRoleCheckPopupAcceptButton:Click()

           -- PVPReadyDialogEnterBattleButton:Click()

            PVPMatchResults["leaveButton"]:Click()

            PVEFrameTab2:Click()

   
    end
    ]]
end

