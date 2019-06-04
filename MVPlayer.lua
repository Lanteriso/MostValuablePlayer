local cfg;
local L = MVP_L

local MVPlayer = {
  frame = CreateFrame("Frame"),
  set = 0
}

local Items = {
  "CharacterHeadSlot",
  "CharacterNeckSlot",
  "CharacterShoulderSlot",
  "",
  "CharacterChestSlot",
  "CharacterWaistSlot",
  "CharacterLegsSlot",
  "CharacterFeetSlot",
  "CharacterWristSlot",
  "CharacterHandsSlot",
  "CharacterFinger0Slot",
  "CharacterFinger1Slot",
  "CharacterTrinket0Slot",
  "CharacterTrinket1Slot",
  "CharacterBackSlot",
  "CharacterMainHandSlot",
  "CharacterSecondaryHandSlot",
}

local InspectItems = {
  "InspectHeadSlot",
  "InspectNeckSlot",
  "InspectShoulderSlot",
  "",
  "InspectChestSlot",
  "InspectWaistSlot",
  "InspectLegsSlot",
  "InspectFeetSlot",
  "InspectWristSlot",
  "InspectHandsSlot",
  "InspectFinger0Slot",
  "InspectFinger1Slot",
  "InspectTrinket0Slot",
  "InspectTrinket1Slot",
  "InspectBackSlot",
  "InspectMainHandSlot",
  "InspectSecondaryHandSlot",
}

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

local GarroshBoA = {
	[3] = {105679,105673,105677,105672,105678,105671,105675,105670,105674,105680},
	[2] = {104405,104403,104406,104404,104401,104400,104402,104399,104409,104407},
	[1] = {105692,105686,105690,105685,105691,105684,105688,105683,105687,105693},
}

local GarroshBoAScaling = {
		  -- M,  H,  N
	[90] = {582,569,556},
	[91] = {586,574,562},
	[92] = {590,579,569},
	[93] = {593,584,575},
	[94] = {597,589,582},
	[95] = {601,595,588},
	[96] = {605,600,594},
	[97] = {609,605,601},
	[98] = {612,610,607},
	[99] = {616,615,614},
	[100] = {620,620,620},
}

local function RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end

local GemEnchant = CreateFrame('GameTooltip', 'MVPvsgetooltip', UIParent, 'GameTooltipTemplate');
local GemEnchant2 = CreateFrame('GameTooltip', 'MVPvsgetooltip2', UIParent, 'GameTooltipTemplate');
local enchantID = {
	5942,5943,5944,5945 -- ring
}

local relictooltip = {}
relictooltip[1] = CreateFrame('GameTooltip', 'MVPvsrelictooltip1', UIParent, 'GameTooltipTemplate');
relictooltip[2] = CreateFrame('GameTooltip', 'MVPvsrelictooltip2', UIParent, 'GameTooltipTemplate');
relictooltip[3] = CreateFrame('GameTooltip', 'MVPvsrelictooltip3', UIParent, 'GameTooltipTemplate');

function MVPlayer_buttonsw(sw)
	if sw then
		if CharacterFrameAverageItemLevel then
			CharacterFrameAverageItemLevel:Show()
		end
		if MVPvsGemEnchantButton then MVPvsGemEnchantButton:Show() end
	else
		if CharacterFrameAverageItemLevel then
			CharacterFrameAverageItemLevel:Hide()
		end
		if MVPvsGemEnchantButton then MVPvsGemEnchantButton:Hide() end
	end
end

local xname = {}

function MVPlayer_Update(sw)
	if CharacterFrame:GetWidth() > 500 then
		MVPlayer.frame:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
		if cfg ~= nil and cfg.MVPvscharilvl and cfg.MVPvscharilvl ~= nil then
			local n = 0 -- total equipped gear
			local ailvl = 0 -- average item level
			local n2 = 0 -- total upgradable gear
			local aun = 0 -- total fully upgraded gear
			local totalilvl = {};
			local xupgrade = {};
			for Value = 1,17 do
			--for Key, Value in pairs(Items) do
				local Key = Items[Value]
				local ItemLink = GetInventoryItemLink("player", Value)
				local Slot = getglobal(Key.."Stock");

				if Slot and Value ~= 4 then
					Slot:Hide();
					-- add upgrade level fontstring
					if not _G[Key.."un" ] then
						local un = _G[Key]:CreateFontString(Key.."un","ARTWORK")
						un:SetFontObject(Slot:GetFontObject())
						un:SetTextColor(1,1,0)
						if IsAddOnLoaded("ElvUI") then
							un:SetPoint("TOPRIGHT",2,-2)
						else
							un:SetPoint("TOPRIGHT",0,-2)
						end
					else
						_G[Key.."un" ]:SetText("")
					end
					-- add gem and enchant fontstring
					if not _G[Key.."ge" ] then
						local ge = _G[Key]:CreateFontString(Key.."ge","OVERLAY")
						ge:SetFontObject("GameFontNormalSmall")
						ge:SetTextColor(1,1,0)
						if Value == 1 or Value == 2 or Value == 3 or Value == 5 or Value == 9 or Value == 15 or Value == 17 then
							ge:SetPoint("BOTTOMLEFT",Key,"BOTTOMRIGHT",7,0)
							ge:SetJustifyH("LEFT")
						else
							ge:SetPoint("BOTTOMRIGHT",Key,"BOTTOMLEFT",-7,0)
							ge:SetJustifyH("RIGHT")
						end
						ge:SetWidth(100)
						ge:SetWordWrap(true)
						ge:SetNonSpaceWrap(false)
						if cfg.MVPvsge then
							ge:Show()
						else
							ge:Hide()
						end
						if Value == 16 or Value == 17 then
							CreateFrame("Frame", "MVPvsrelic"..Value, _G[Key]);
							local w,h = _G[Key]:GetSize()
							_G["MVPvsrelic"..Value]:SetSize(w,h)
							if Value == 16 then
								_G["MVPvsrelic"..Value]:SetPoint("TOPRIGHT",_G[Key],"TOPLEFT")
							end
							if Value == 17 then
								_G["MVPvsrelic"..Value]:SetPoint("TOPLEFT",_G[Key],"TOPRIGHT")
							end
							_G["MVPvsrelic"..Value]:SetScript("OnEnter", function(self)
								local n = tonumber(self:GetName():gsub("MVPvsrelic","").."")
								if xname[n] and OTCheckartifactwep(tonumber(xname[n])) and GetInventoryItemLink("player", n) then
									for aw = 1, 3 do
										local reliclink = select(2,GetItemGem(GetInventoryItemLink("player", n),aw))
										if reliclink then
											relictooltip[aw]:SetOwner(_G[Key],"ANCHOR_NONE")
											relictooltip[aw]:ClearLines();
											if aw == 1 then
												relictooltip[aw]:SetPoint("BOTTOMLEFT",_G[Key],"TOPRIGHT")
											end
											if aw == 2 then
												if relictooltip[1]:IsShown() then
													relictooltip[aw]:SetPoint("BOTTOMLEFT",relictooltip[1],"BOTTOMRIGHT")
												else
													relictooltip[aw]:SetPoint("BOTTOMLEFT",_G[Key],"TOPRIGHT")
												end
											end
											if aw == 3 then
												if relictooltip[2]:IsShown() then
													relictooltip[aw]:SetPoint("BOTTOMLEFT",relictooltip[2],"BOTTOMRIGHT")
												elseif relictooltip[1]:IsShown() then
													relictooltip[aw]:SetPoint("BOTTOMLEFT",relictooltip[1],"BOTTOMRIGHT")
												else
													relictooltip[aw]:SetPoint("BOTTOMLEFT",_G[Key],"TOPRIGHT")
												end
											end
											relictooltip[aw]:SetHyperlink(reliclink)
											relictooltip[aw]:Show()
										end
									end
								end
							end)
							_G["MVPvsrelic"..Value]:SetScript("OnLeave", function(self)
								for aw = 1, 3 do
									relictooltip[aw]:Hide()
								end
							end)
						end
					else
						_G[Key.."ge" ]:SetText("")
					end

					if ItemLink then
						n = n + 1
						Slot:ClearAllPoints();
						Slot:SetPoint("CENTER",0,-10);


						-- check item level
						ItemLink = ItemLink:gsub("::",":0:"):gsub("::",":0:")
						local itemID,enchant,_,_,_,_,_ = ItemLink:match("%a+:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)");
						local _, _, quality, _, _,_,_, _, _, _, _ = GetItemInfo(ItemLink)
						if OItemAnalysis_CheckILVLGear4("player",Value) ~= 0 then
							totalilvl[Value], xupgrade[Value] = OItemAnalysis_CheckILVLGear4("player",Value)
							xname[Value] = itemID
							if Value == 17 and OTCheckartifactwep(tonumber(itemID)) then
								if totalilvl[Value] and totalilvl[16] and totalilvl[Value] < totalilvl[16] then
									totalilvl[Value], xupgrade[Value] = totalilvl[16], xupgrade[16]
								end
								if totalilvl[Value] and totalilvl[16] and totalilvl[Value] > totalilvl[16] then
									_G[Items[16].."Stock"]:SetText(totalilvl[Value]);
									_G[Items[16].."Stock"]:SetShadowColor(1,1,1,1);
									ailvl = ailvl -  totalilvl[16] + totalilvl[Value]
								end
							end
							if xupgrade[Value] and cfg.MVPvsun then
								_G[Key.."un"]:SetText(xupgrade[Value]);
								_G[Key.."un"]:SetShadowColor(1,1,1,1);
								n2 = n2 + 1
								aun = aun + xupgrade[Value]/2
							else
								_G[Key.."un" ]:SetText("");
							end
							if cfg.MVPvscolormatchitemrarity then
								Slot:SetTextColor(quality_color[quality][1],quality_color[quality][2],quality_color[quality][3])
							else
								Slot:SetTextColor(1,1,0)
							end

              -- added to make sure HOA neck ilevel is visible, changed text color as well
              if Value == 2 then
                local ArtifactNeckLevel = _G[Key]:CreateFontString(Key.."ArtifactNeckLevel","OVERLAY")
                ArtifactNeckLevel:SetFontObject("GameFontNormal");
                ArtifactNeckLevel:SetTextColor(237, 238, 239);
                ArtifactNeckLevel:SetPoint("CENTER",0,1);
                ArtifactNeckLevel:SetText(totalilvl[Value]);
              else
							  Slot:SetText(totalilvl[Value]);
							  Slot:SetShadowColor(1,1,1,1);
							  Slot:Show();
              end
              ailvl = ailvl + (totalilvl[Value] or 0)

							-- check gem and enchant
							if Value < 17 then
								GemEnchant:SetOwner(UIParent, 'ANCHOR_NONE');
								GemEnchant:ClearLines();
								GemEnchant:SetHyperlink(ItemLink);
								for m = 1, GemEnchant:NumLines() do
									local enchant = _G["MVPvsgetooltipTextLeft"..m]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)"))
									if enchant then
										_G[Key.."ge"]:SetText("|cff00ff00"..enchant);
									end
								end
							end
							-- check low enchant
							if (Value == 11 or Value == 12) and enchant ~= "0" and MVPvsbestenchant and MVPvsbestenchant:GetChecked() then
								local function CheckLowEnchant(eID)
									for mm = 1, #enchantID do
										if tonumber(eID) == enchantID[mm] then return false end
									end
									return true
								end
								if CheckLowEnchant(enchant) and _G[Key.."ge"]:GetText() then
									_G[Key.."ge"]:SetText(_G[Key.."ge"]:GetText()..(" (|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Low level enchanted"]..")");
								end
							end
							-- check no enchant
							if (Value == 11 or Value == 12 or Value == 16) and enchant == "0" then
								_G[Key.."ge"]:SetText(("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Not enchanted"]);
							end
							-- check no gem
							if OItemAnalysis_CountEmptySockets2("player", Value) > 0 and _G[Key.."ge"] then
								_G[Key.."ge"]:SetText((_G[Key.."ge"]:GetText() or "").."\n"..("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Not socketed"]);
							end
							-- check gem
							local _, gemlink = GetItemGem(ItemLink,1)
							if gemlink then
								GemEnchant2:SetOwner(UIParent, 'ANCHOR_NONE');
								GemEnchant2:ClearLines();
								GemEnchant2:SetHyperlink(gemlink);
								for i = 2, GemEnchant2:NumLines() do
									if _G["MVPvsgetooltip2TextLeft"..i]:GetText():find("+") then
										_G[Key.."ge"]:SetText((_G[Key.."ge"]:GetText() or "").."\n|cffffffff".._G["MVPvsgetooltip2TextLeft"..i]:GetText());
										break
									end
								end
							end
							-- check low gem
							if gemlink and OItemAnalysisLowGem("player", Value) > 0 and _G[Key.."ge"]:GetText() and MVPvsbestenchant and MVPvsbestenchant:GetChecked() then
								_G[Key.."ge"]:SetText((_G[Key.."ge"]:GetText() or "")..("(|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Low level socketed"]..")");
							end
							-- check relic
							if (Value == 16 or Value == 17) and OTCheckartifactwep(tonumber(itemID)) then
								_G[Key.."ge"]:SetText("")
								for aw = 1, 3 do
									local reliclink = select(2,GetItemGem(ItemLink,aw))
									if reliclink then
										_G[Key.."ge"]:SetText((_G[Key.."ge"]:GetText() or "").."\n"..OItemAnalysis_CheckILVLRelic(reliclink))
									end
								end
								_G[Key.."ge"]:Show()
							end
							if cfg.MVPvsge then _G[Key.."ge"]:Show() end
						end
					end
				end
			end
			if not CharacterFrameAverageItemLevel then
				local ifal = CharacterFrame:CreateFontString("CharacterFrameAverageItemLevel","ARTWORK")
				ifal:SetFontObject(CharacterLevelText:GetFontObject())
				ifal:SetTextColor(1,1,0)
			end
			CharacterFrameAverageItemLevel:SetText("")
			if n ~= 0 then
				if totalilvl[16] and not totalilvl[17] then
					ailvl = ailvl + totalilvl[16]
					n = n + 1
				end
				ailvl = tonumber(string.format("%." .. (cfg.MVPvsdp or 0) .. "f", ailvl/n))
				local ilt = ailvl
				if n2 ~= 0 then
					ilt = ilt.." ("..aun.."/"..n2..")"
				end
        --local showAverage = true;
        if cfg.MVPvssummaryshow then
				  CharacterFrameAverageItemLevel:SetText(ilt)
				  CharacterFrameAverageItemLevel:ClearAllPoints()
				  CharacterFrameAverageItemLevel:SetPoint("CENTER",CharacterLevelText,"TOP",0,0)
        end
			end
			-- add Show Gem / Enchant button
			if not MVPvsGemEnchantButton then
				local button = CreateFrame("Button", "MVPvsGemEnchantButton", CharacterFrame, "ActionButtonTemplate")
				button:SetPoint("BOTTOMLEFT", CharacterHeadSlot, "TOPLEFT",50,3)
				button:SetSize(16,16)
				button:SetText("\\")
				button:SetNormalFontObject("GameFontNormal")

				local ntex = button:CreateTexture()
				ntex:SetTexture("Interface\\Icons\\Trade_Engraving")
				ntex:SetAllPoints()
				button:SetNormalTexture(ntex)

				button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
				button:SetScript("PostClick", function(self, button, down)
					for Value = 1,17 do
						local Key = Items[Value]
					--for Key, Value in pairs(Items) do
						if _G[Key.."ge"] and Value ~= 4 and Value ~= 16 and Value ~= 17 then
							if _G[Key.."ge"]:IsShown() then
								_G[Key.."ge"]:Hide()
								cfg.MVPvsge = false
							else
								_G[Key.."ge"]:Show()
								cfg.MVPvsge = true
							end
						end
					end
					for Value = 1,17 do
						local Key = InspectItems[Value]
					--for Key, Value in pairs(InspectItems) do
						if _G[Key.."ge2"] and Value ~= 4 and Value ~= 16 and Value ~= 17 then
							if _G[Key.."ge2"]:IsShown() then
								_G[Key.."ge2"]:Hide()
								cfg.MVPvsge = false
							else
								_G[Key.."ge2"]:Show()
								cfg.MVPvsge = true
							end
						end
					end
				end)
			else
				MVPvsGemEnchantButton:Show()
			end
		else
			for Value = 1, 17 do
			--for Key, Value in pairs(Items) do
				-- hide item level for gears
				local Key = Items[Value]
				local ItemLink = GetInventoryItemLink("player", Value)
				local Slot = getglobal(Key.."Stock");

				if Slot and Value ~= 4 then
					Slot:Hide();
				end

				if _G[Key.."ge"] then
					_G[Key.."ge"]:Hide()
				end

				if  _G[Key.."un"] then
					_G[Key.."un"]:SetText("");
				end

			end
			if CharacterFrameAverageItemLevel then
				CharacterFrameAverageItemLevel:SetText("")
			end
			if MVPvsGemEnchantButton then
				MVPvsGemEnchantButton:Hide()
			end
			cfg.MVPvsge = true
		end
		MVPlayer.frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		-- Update MVPvsframedata
		if sw then
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
		end
	else
		MVPlayer_buttonsw(false)
	end
end

local xname2 = {}

function MVPvsInspect_Update()
	if InspectFrame and not InspectFrame:IsShown() then return -1 end
	if cfg ~= nil and cfg.MVPvscharilvl and cfg.MVPvscharilvl ~= nil and InspectFrame and InspectFrame.unit then
		local n = 0 -- total equipped gear
		local ailvl = 0 -- average item level
		local n2 = 0 -- total upgradable gear
		local aun = 0 -- total fully upgraded gear
		local totalilvl = {}
		local xupgrade = {}
		for Value = 1,17 do
		--for Key, Value in pairs(InspectItems) do
			local Key = InspectItems[Value]
			local ItemLink = GetInventoryItemLink(InspectFrame.unit, Value)

			if ItemLink and (Value == 16 or Value == 17) and ItemLink:find("item::") then
				ItemLink = GetInventoryItemLink(InspectFrame.unit, Value)
			end


			local Slot = getglobal(Key.."Stock");

			if Slot and Value ~= 4 then
				Slot:Hide();
				-- add upgrade level fontstring
				if not _G[Key.."un2" ] then
					local un2 = _G[Key]:CreateFontString(Key.."un2","ARTWORK")
					un2:SetFontObject(Slot:GetFontObject())
					un2:SetTextColor(1,1,0)
					if IsAddOnLoaded("ElvUI") then
						un2:SetPoint("TOPRIGHT",2,-2)
					else
						un2:SetPoint("TOPRIGHT",0,-2)
					end
				else
					_G[Key.."un2" ]:SetText("")
				end
				-- add gem and enchant fontstring
				if not _G[Key.."ge2" ] then
					local ge = _G[Key]:CreateFontString(Key.."ge2","OVERLAY")
					if Value == 16 or Value == 17 then
						CreateFrame("Frame", "MVPvsrelici"..Value, _G[Key]);
						local w,h = _G[Key]:GetSize()
						_G["MVPvsrelici"..Value]:SetSize(w,h)
						if Value == 16 then
							_G["MVPvsrelici"..Value]:SetPoint("TOPRIGHT",_G[Key],"TOPLEFT")
						end
						if Value == 17 then
							_G["MVPvsrelici"..Value]:SetPoint("TOPLEFT",_G[Key],"TOPRIGHT")
						end
						_G["MVPvsrelici"..Value]:SetScript("OnEnter", function(self)
							local n = tonumber(self:GetName():gsub("MVPvsrelici","").."")
							if xname2[n] and OTCheckartifactwep(tonumber(xname2[n])) and InspectFrame.unit and GetInventoryItemLink(InspectFrame.unit, n) then
								for aw = 1, 3 do
									local reliclink = select(2,GetItemGem(GetInventoryItemLink(InspectFrame.unit, n),aw))
									if reliclink then
										relictooltip[aw]:SetOwner(_G[Key],"ANCHOR_NONE")
										relictooltip[aw]:ClearLines();
										if aw == 1 then
											relictooltip[aw]:SetPoint("BOTTOMLEFT",_G[Key],"TOPRIGHT")
										end
										if aw == 2 then
											if relictooltip[1]:IsShown() then
												relictooltip[aw]:SetPoint("BOTTOMLEFT",relictooltip[1],"BOTTOMRIGHT")
											else
												relictooltip[aw]:SetPoint("BOTTOMLEFT",_G[Key],"TOPRIGHT")
											end
										end
										if aw == 3 then
											if relictooltip[2]:IsShown() then
												relictooltip[aw]:SetPoint("BOTTOMLEFT",relictooltip[2],"BOTTOMRIGHT")
											elseif relictooltip[1]:IsShown() then
												relictooltip[aw]:SetPoint("BOTTOMLEFT",relictooltip[1],"BOTTOMRIGHT")
											else
												relictooltip[aw]:SetPoint("BOTTOMLEFT",_G[Key],"TOPRIGHT")
											end
										end
										relictooltip[aw]:SetHyperlink(reliclink)
										relictooltip[aw]:Show()
									end
								end
							end
						end)
						_G["MVPvsrelici"..Value]:SetScript("OnLeave", function(self)
							for aw = 1, 3 do
								relictooltip[aw]:Hide()
							end
						end)
					end
					ge:SetFontObject("GameFontNormalSmall")
					ge:SetTextColor(1,1,0)
					if Value == 1 or Value == 2 or Value == 3 or Value == 5 or Value == 9 or Value == 15 or Value == 17 then
						ge:SetPoint("BOTTOMLEFT",Key,"BOTTOMRIGHT",7,0)
						ge:SetJustifyH("LEFT")
					else
						ge:SetPoint("BOTTOMRIGHT",Key,"BOTTOMLEFT",-7,0)
						ge:SetJustifyH("RIGHT")
					end
					ge:SetWidth(100)
					ge:SetWordWrap(true)
					ge:SetNonSpaceWrap(false)
					if cfg.MVPvsge then
						ge:Show()
					else
						ge:Hide()
					end
				else
					_G[Key.."ge2" ]:SetText("")
				end
				if ItemLink then
					n = n + 1
					Slot:ClearAllPoints();
					Slot:SetPoint("CENTER",0,-10);

					-- check item level
					ItemLink = ItemLink:gsub("::",":0:"):gsub("::",":0:")
					local itemID,enchant,_,_,_,_,_ = ItemLink:match("%a+:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)");
					local _, _, quality, _, _,_,_, _, _, _, _ = GetItemInfo(ItemLink)
					if OItemAnalysis_CheckILVLGear4("target",Value) ~= 0 then
						totalilvl[Value], xupgrade[Value] = OItemAnalysis_CheckILVLGear4("target",Value)
						-- temp fix for ilvl in nether crucible
						-- if Value == 16 or Value == 17 then
						-- 	local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",ItemLink,15)
						-- 	local gemactive = 0
						-- 	if (gem1 and gem1 ~= "") then gemactive = gemactive + 1 end
						-- 	if (gem2 and gem2 ~= "") then gemactive = gemactive + 1 end
						-- 	if (gem3 and gem3 ~= "") then gemactive = gemactive + 1 end
						-- 	totalilvl[Value] = totalilvl[Value] + gemactive*5
						-- end
						---------------------------------------------------------------------

						xname2[Value] = itemID
						if Value == 17 and OTCheckartifactwep(tonumber(itemID)) then
							if totalilvl[Value] < totalilvl[16] then
								totalilvl[Value], xupgrade[Value] = totalilvl[16], xupgrade[16]
							else
								Slot:SetTextColor(1,1,0)
							end
							if totalilvl[Value] > totalilvl[16] then
								_G[InspectItems[16].."Stock"]:SetText(totalilvl[Value]);
								_G[InspectItems[16].."Stock"]:SetShadowColor(1,1,1,1);
								ailvl = ailvl -  totalilvl[16] + totalilvl[Value]
							end
						end
						if xupgrade[Value] and cfg.MVPvsun then
							_G[Key.."un2"]:SetText(xupgrade[Value]);
							_G[Key.."un2"]:SetShadowColor(1,1,1,1);
							n2 = n2 + 1
							aun = aun + xupgrade[Value]/2
						else
							_G[Key.."un2" ]:SetText("");
						end
						if cfg.MVPvscolormatchitemrarity then
							Slot:SetTextColor(quality_color[quality][1],quality_color[quality][2],quality_color[quality][3])
						else
							Slot:SetTextColor(1,1,0)
						end
						Slot:SetText(totalilvl[Value]);
						Slot:SetShadowColor(1,1,1,1);
						Slot:Show();
						ailvl = ailvl + (totalilvl[Value] or 0)

						-- check gem and enchant
						GemEnchant:SetOwner(UIParent, 'ANCHOR_NONE');
						GemEnchant:ClearLines();
						GemEnchant:SetHyperlink(ItemLink);
						for m = 1, GemEnchant:NumLines() do
							local enchant = _G["MVPvsgetooltipTextLeft"..m]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)"))
							if enchant then
								_G[Key.."ge2"]:SetText("|cff00ff00"..enchant);
							end
						end
						-- check low enchant
						if (Value == 11 or Value == 12) and enchant ~= "0" and MVPvsbestenchant and MVPvsbestenchant:GetChecked() then
							local function CheckLowEnchant(eID)
								for mm = 1, #enchantID do
									if tonumber(eID) == enchantID[mm] then return false end
								end
								return true
							end
							if CheckLowEnchant(enchant) and _G[Key.."ge2"]:GetText() then
								_G[Key.."ge2"]:SetText(_G[Key.."ge2"]:GetText()..("(|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Low level enchanted"]..")");
							end
						end
						-- check no enchant
						if (Value == 11 or Value == 12 or Value == 16) and enchant == "0" then
							_G[Key.."ge2"]:SetText(("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:43:53:34:61|t" or "")..L["Not enchanted"]);
						end
						-- check no gem
						if OItemAnalysis_CountEmptySockets2("target",Value) > 0 and _G[Key.."ge2"] then
							_G[Key.."ge2"]:SetText((_G[Key.."ge2"]:GetText() or "").."\n"..("|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Not socketed"]);
						end
						-- check gem
						local _, gemlink = GetItemGem(ItemLink,1)
						if gemlink then
							GemEnchant2:SetOwner(UIParent, 'ANCHOR_NONE');
							GemEnchant2:ClearLines();
							GemEnchant2:SetHyperlink(gemlink);
							for i = 2, GemEnchant2:NumLines() do
								if _G["MVPvsgetooltip2TextLeft"..i]:GetText():find("+") then
									_G[Key.."ge2"]:SetText((_G[Key.."ge2"]:GetText() or "").."\n|cffffffff".._G["MVPvsgetooltip2TextLeft"..i]:GetText());
									break
								end
							end
						end
						-- check low gem
						if gemlink and OItemAnalysisLowGem("target",Value) > 0 and _G[Key.."ge2"]:GetText() and MVPvsbestenchant and MVPvsbestenchant:GetChecked() then
							_G[Key.."ge2"]:SetText((_G[Key.."ge2"]:GetText() or "")..("(|TInterface\\MINIMAP\\TRACKING\\OBJECTICONS:0:0:0:0:256:64:107:117:34:61|t" or "")..L["Low level socketed"]..")");
						end
						-- check relic
						if (Value == 16 or Value == 17) and OTCheckartifactwep(tonumber(itemID)) then
							_G[Key.."ge2"]:SetText("")
							for aw = 1, 3 do
								local reliclink = select(2,GetItemGem(ItemLink,aw))
								if reliclink then
									_G[Key.."ge2"]:SetText((_G[Key.."ge2"]:GetText() or "").."\n"..OItemAnalysis_CheckILVLRelic(reliclink))
								end
							end
							_G[Key.."ge2"]:Show()
						else
							_G[Key.."ge2"]:Hide()
						end
						if cfg.MVPvsge then _G[Key.."ge2"]:Show() end
					end
				end
			end
		end
		if not InspectFrameAverageItemLevel then
			local ifal = InspectFrame:CreateFontString("InspectFrameAverageItemLevel","ARTWORK")
			ifal:SetFontObject(InspectLevelText:GetFontObject())
			ifal:SetTextColor(1,1,0)
		end
		InspectFrameAverageItemLevel:SetText("")
		if n ~= 0 then
			if totalilvl[16] and not totalilvl[17] then
				ailvl = ailvl + totalilvl[16]
				n = n + 1
			end
			ailvl = tonumber(string.format("%." .. (cfg.MVPvsdp or 0) .. "f", ailvl/n))
			local ilt = ailvl
			if n2 ~= 0 then
				ilt = ilt.." ("..aun.."/"..n2..")"
			end
			InspectFrameAverageItemLevel:SetText(ilt)
			InspectFrameAverageItemLevel:ClearAllPoints()
			InspectFrameAverageItemLevel:SetPoint("CENTER",InspectPaperDollFrame.ViewButton,"RIGHT",50,0)
		end
		-- add Show Gem / Enchant button
		if not MVPvsGemEnchantButton2 then
			local button = CreateFrame("Button", "MVPvsGemEnchantButton2", InspectFrame, "SecureActionButtonTemplate")
			button:SetPoint("BOTTOMLEFT", InspectHeadSlot, "TOPLEFT",50,3)
			button:SetSize(16,16)
			button:SetText("\\")
			button:SetNormalFontObject("GameFontNormal")

			local ntex = button:CreateTexture()
			ntex:SetTexture("Interface\\Icons\\Trade_Engraving")
			ntex:SetAllPoints()
			button:SetNormalTexture(ntex)

			button:RegisterForClicks("LeftButtonDown", "RightButtonDown");
			button:SetScript("PostClick", function(self, button, down)
				for Value = 1,17 do
					local Key = Items[Value]
				--for Key, Value in pairs(Items) do
					if _G[Key.."ge"] and Value ~= 4 and Value ~= 16 and Value ~= 17 then
						if _G[Key.."ge"]:IsShown() then
							_G[Key.."ge"]:Hide()
							cfg.MVPvsge = false
						else
							_G[Key.."ge"]:Show()
							cfg.MVPvsge = true
						end
					end
				end
				for Value = 1,17 do
					local Key = InspectItems[Value]
				--for Key, Value in pairs(InspectItems) do
					if _G[Key.."ge2"] and Value ~= 4 and Value ~= 16 and Value ~= 17 then
						if _G[Key.."ge2"]:IsShown() then
							_G[Key.."ge2"]:Hide()
							cfg.MVPvsge = false
						else
							_G[Key.."ge2"]:Show()
							cfg.MVPvsge = true
						end
					end
				end
			end)
		end
	else
		for Value = 1, 17 do
		--for Key, Value in pairs(InspectItems) do
			if InspectFrame.unit and Value then
				local Key = InspectItems[Value]
				local ItemLink = GetInventoryItemLink(InspectFrame.unit, Value)
				local Slot = getglobal(Key.."Stock");

				if Slot and Value ~= 4 then
					Slot:Hide();
				end
			end
		end
	end
end

local S_UPGRADE_LEVEL = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")

-- Create the tooltip:
local scantip = CreateFrame("GameTooltip", "MVPlayer_Tooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local MVPvsInspect_Updatehooksw = false
local MVPvsCharFrame_Updatehooksw = false

MVPlayer.frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" and MVPlayer.set == 0 then
		MVPlayer.set = 1;
		MVPlayer.frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
		MVPlayer.frame:RegisterEvent("EQUIPMENT_SWAP_PENDING");
		MVPlayer.frame:RegisterEvent("EQUIPMENT_SWAP_FINISHED");

		if not MVPvsCharFrame_Updatehooksw then
			PaperDollFrame:HookScript("OnShow", function() MVPlayer_buttonsw(true) MVPlayer_Update(false) end)
			ReputationFrame:HookScript("OnShow", function() MVPlayer_buttonsw(false) end)
			TokenFrame:HookScript("OnShow", function() MVPlayer_buttonsw(false) end)
			MVPvsCharFrame_Updatehooksw = true
		end
	end

	if event == "VARIABLES_LOADED" then
		cfg = MVP_Settings;
		if cfg.MVPvscharilvl == nil then cfg.MVPvscharilvl = true; end
		if cfg.MVPvsun == nil then cfg.MVPvsun = true end
		if cfg.MVPvsge == nil then cfg.MVPvsge = true end
	end

	if event == "EQUIPMENT_SWAP_PENDING" then
		MVPlayer.frame:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	end

	if event == "EQUIPMENT_SWAP_FINISHED" then
		C_Timer.After(1, function() MVPlayer_Update(true) end);
	end

	if event == "PLAYER_EQUIPMENT_CHANGED" then
		MVPlayer_Update(true);
	end

	if event == "INSPECT_READY"  and InspectFrame then
		if not MVPvsInspect_Updatehooksw then
			InspectFrame:HookScript("OnShow", function()
				MVPvsInspect_Update()
				C_Timer.After(1,MVPvsInspect_Update)
				C_Timer.After(2,MVPvsInspect_Update)
				C_Timer.After(3,MVPvsInspect_Update)
			end)
			InspectFrame:HookScript("OnHide",
				function()
					for i = 1, 17 do
						local Slot = getglobal(InspectItems[i].."Stock");
						if Slot and i ~= 4 then
							Slot:Hide();
						end
					end
				end
			)
			MVPvsInspect_Updatehooksw = true
		end
		MVPlayer.frame:UnregisterEvent("INSPECT_READY");
	end
end)

MVPlayer.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
MVPlayer.frame:RegisterEvent("VARIABLES_LOADED");
MVPlayer.frame:RegisterEvent("INSPECT_READY");
