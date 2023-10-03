if HCFFrame == nil then HCFFrame = 1 end
TurtleHCFilter_ChatFrame_OnEvent = ChatFrame_OnEvent
HCFSpam = ''

function ChatFrame_OnEvent(event)
	if (event == "CHAT_MSG_HARDCORE") then
		if HCFSpam == arg1 then
			return false
		end
		local output = "|cffe6cd80[Hardcore] \|cffe6cd80\124Hplayer:"..arg2.."\124h["..arg2.."]:\124h\124r|cffe6cd80 "..arg1
		if HCFFrame == 1 then
			ChatFrame1:AddMessage(output)
		elseif HCFFrame == 2 then
			ChatFrame2:AddMessage(output)
		elseif HCFFrame == 3 then
			ChatFrame3:AddMessage(output)
		elseif HCFFrame == 4 then
			ChatFrame4:AddMessage(output)
		elseif HCFFrame == 5 then
			ChatFrame5:AddMessage(output)
		elseif HCFFrame == 6 then
			ChatFrame6:AddMessage(output)
		elseif HCFFrame == 7 then
			ChatFrame7:AddMessage(output)
		elseif HCFFrame == 8 then
			ChatFrame8:AddMessage(output)
		elseif HCFFrame == 9 then
			ChatFrame9:AddMessage(output)
		end
		HCFSpam = arg1
		return false
	end
	TurtleHCFilter_ChatFrame_OnEvent(event);
end

SLASH_TurtleHCFilter1, SLASH_TurtleHCFilter2 = "/HCF", "/HCFilter"
SlashCmdList["TurtleHCFilter"] = function(message)
	HCFFrame = tonumber(message)
	DEFAULT_CHAT_FRAME:AddMessage("Frame set to: "..HCFFrame)
end
