local Cframe = CreateFrame("Frame") 
Cframe:RegisterEvent("ADDON_LOADED") 
Cframe:SetScript("OnEvent", function(self, event, ...) 
	if self[event] then
		return self[event](self, event, ...)
	end
end )

local psfilter2 = function(_, event, message, player, ...)
	local isFirstmes = true
	for words in gmatch(message, "%s-%S+%s*") do
		tempWords = gsub(words,"^[%s%p]-([^%s%p]+)([%-]?[^%s%p]-)[%s%p]*$","%1%2")
		local _,classMatch = UnitClass(tempWords)
		if classMatch then
			local classColorTable = _G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[classMatch] or _G.RAID_CLASS_COLORS[classMatch];
			words = gsub(words, gsub(tempWords, "%-","%%-"), format("\124cff%.2x%.2x%.2x%s\124r", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255, tempWords))
		end
		if isFirstmes then
			rebuiltString = words
			isFirstmes = false
		else
			rebuiltString = rebuiltString..words
		end
	end
	return false, rebuiltString, player, ...
end


function Cframe:ADDON_LOADED(event,...)
	
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", psfilter2)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", psfilter2	)
end