if HCFFrame == nil then HCFFrame = 1 end
if HCFPrefix == nil then HCFPrefix = "HC" end
if HCFColour == nil then HCFColour = "e6cd80" end
if HCFLevelFilter == nil then HCFLevelFilter = true end
if HCFDebug == nil then HCFDebug = false end

local gfind = string.gmatch or string.gfind
local HC_LEVEL_RANGE = 5

TurtleHCFilter_ChatFrame_OnEvent = ChatFrame_OnEvent
HCFSpam = ''

function FindAny(str, ...)
	for _,v in ipairs(arg) do
		local _start, _end = string.find(str, v)
		if _start ~= nil then
			return _start
		end
	end
	return nil
end

function FilterOut(chat)
	if HCFLevelFilter then
		local marker = FindAny(string.lower(arg1), "wts", "wtb", "wtt", "lf%d*m", "lfg")
		if marker ~= nil then
			local levelStart, levelEnd = string.find(arg1, "%d+ *+")
			if levelStart ~= nil then
				local plusLevel = tonumber(string.sub(arg1, levelStart, levelEnd-1))
				local myLevel = UnitLevel("player")
				if plusLevel < myLevel - HC_LEVEL_RANGE or plusLevel > myLevel + HC_LEVEL_RANGE then
					Debug("- " .. arg1)
					HCFSpam = arg1
					return true
				end
			end
		end
	end
	return false
end

function ChatFrame_OnEvent(event)
	if (event == "CHAT_MSG_HARDCORE") then
		if HCFSpam == arg1 or FilterOut(arg1) then
			return false
		end
		local prefix
		if HCFPrefix == nil then
			prefix = ""
		else
			prefix = "["..HCFPrefix.."] "
		end
		local msg = string.gsub(arg1, "|r", "|r|cff"..HCFColour)
		local output = "|cff"..HCFColour..prefix.."|cff"..HCFColour.."\124Hplayer:"..arg2.."\124h["..arg2.."]\124h\124r|cff"..HCFColour.." "..msg
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

function Debug(message)
	if HCFDebug then
		DEFAULT_CHAT_FRAME:AddMessage("|cffbe5effHCF|cffffff00 "..message)
	end
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
		elseif commandlist[1] == "info" then
			Message("Debug mode " .. (HCFDebug and "enabled" or "disabled"))
			Message("Level filtering " .. (HCFLevelFilter and "enabled" or "disabled"))
			Message("Channel prefix set to " .. (HCFPrefix and HCFPrefix or "nothing"))
			Message("Channel frame set to " .. HCFFrame)
		elseif commandlist[1] == "debug" then
			HCFDebug = not HCFDebug
			Message("Debug mode " .. (HCFDebug and "enabled" or "disabled"))
		elseif commandlist[1] == "levelfilter" then
			HCFLevelFilter = not HCFLevelFilter
			Message("Level filtering " .. (HCFLevelFilter and "enabled" or "disabled"))
		elseif commandlist[1] == "colour" or commandlist[1] == "color" then
			if commandlist[2] == nil then
				Message("Channel prefix set to the default: |cffe6cd80e6cd80")
				HCFColour = "e6cd80"
			else
				HCFColour = commandlist[2]
				Message("Channel prefix set to: "..HCFColour)
			end
		else
			Error("Invalid command: "..message)
			return
		end
	else
		SetFrame(frame)
	end
end
