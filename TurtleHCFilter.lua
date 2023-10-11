if HCFFrame == nil then HCFFrame = 1 end
if HCFPrefix == nil then HCFPrefix = "H" end

TurtleHCFilter_ChatFrame_OnEvent = ChatFrame_OnEvent
HCFSpam = ''

function ChatFrame_OnEvent(event)
	if (event == "CHAT_MSG_HARDCORE") then
		if HCFSpam == arg1 then
			return false
		end
		local prefix
		if HCFPrefix == nil then
			prefix = ""
		else
			prefix = "["..HCFPrefix.."] "
		end
		local output = "|cffe6cd80"..prefix.."|cffe6cd80\124Hplayer:"..arg2.."\124h["..arg2.."]\124h\124r|cffe6cd80 "..arg1
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

function Error(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cffbe5effHCF|cffff0000 "..message)
end

function Message(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cffbe5effHCF|r "..message)
end

function SetFrame(frameString)
	local frame = tonumber(frameString)
	if frame == nil then
		Error("Not a number: "..(frameString or "nil"))
	else
		HCFFrame = frame
		Message("Frame set to: "..HCFFrame)
	end
end

SLASH_TurtleHCFilter1, SLASH_TurtleHCFilter2 = "/HCF", "/HCFilter"
SlashCmdList["TurtleHCFilter"] = function(message)
	local gfind = string.gmatch or string.gfind
	local frame = tonumber(message)
	if frame == nil then
		local commandlist = { }
		local command
		for command in gfind(message, "[^ ]+") do
			table.insert(commandlist, command)
		end
		if commandlist[1] == nil then 
			Error("No command provided: "..message)
			return
		end
		if commandlist[1] == "frame" then
			if commandlist[2] == nil then 
				Error("No argument provided for command: "..message)
				return
			end
			SetFrame(commandlist[2])
		elseif commandlist[1] == "prefix" then
			HCFPrefix = commandlist[2]
			if commandlist[2] == nil then
				Message("Channel prefix set to nothing")
			else
				Message("Channel prefix set to: "..HCFPrefix)
			end
		else
			Error("Invalid command: "..message)
			return
		end
	else
		SetFrame(frame)
	end
end
