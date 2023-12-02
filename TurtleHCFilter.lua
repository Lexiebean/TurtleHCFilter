function Error(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cffbe5effHCF|cffff0000 "..message)
end

local turtle = (TargetHPText or TargetHPPercText)
if turtle then
		Error("This addon will only function correctly for Turtle WoW.")
    return
end

function Message(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cffbe5effHCF|r "..message)
end

function Debug(message)
	if HCFDebug then
		DEFAULT_CHAT_FRAME:AddMessage("|cffbe5effHCF|cffffff00 "..message)
	end
end

function Trace(message)
	if HCFTrace then
		DEFAULT_CHAT_FRAME:AddMessage("|cffbe5effHCF|cffffff00 "..message)
	end
end

if HCFFrame == nil then HCFFrame = 1 end
if HCFPrefix == nil then HCFPrefix = "HC" end
if HCFColour == nil then HCFColour = "e6cd80" end
if HCFLevelFilter == nil then HCFLevelFilter = true end
if HCFDebug == nil then HCFDebug = false end
if HCFTrace == nil then HCFTrace = false end

local gfind = string.gmatch or string.gfind
local HC_LEVEL_RANGE = 5

TurtleHCFilter_ChatFrame_OnEvent = ChatFrame_OnEvent
HCFSpam = ''
local addonNotes = GetAddOnMetadata("TurtleHCFilter", "Notes")
local addonVersion = GetAddOnMetadata("TurtleHCFilter", "Version")
local addonAuthor = GetAddOnMetadata("TurtleHCFilter", "Author")
local me = UnitName("player")

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
		local marker = FindAny(string.lower(arg1), "wts", "wtb", "wtt", "lf%d*m", "lfg", "^lf +", " +lf +")
		if marker ~= nil then
			local bottomRangeLevel, topRangeLevel
			-- Check for ##+
			local levelStart, levelEnd = string.find(arg1, "%d+ *+")
			if levelStart ~= nil then
				local plusLevel = tonumber(string.sub(arg1, levelStart, levelEnd-1))
				bottomRangeLevel = plusLevel - HC_LEVEL_RANGE
				topRangeLevel = plusLevel + HC_LEVEL_RANGE
			else
				-- Check for ##-## range
				local levelRangeStart, levelRangeEnd = string.find(arg1, "%d+ *- *%d+")
				if levelRangeStart ~= nil then
					local rangeString = string.sub(arg1, levelRangeStart, levelRangeEnd)
					local dashIdx, _ = string.find(rangeString, "-")
					bottomRangeLevel = tonumber(string.sub(rangeString, 0, dashIdx-1))
					topRangeLevel = tonumber(string.sub(rangeString, dashIdx+1, levelRangeEnd))
				end
			end
			-- Check player level and compare to the HC trading range
			if not (bottomRangeLevel == nil or topRangeLevel == nil) then
				local myLevel = UnitLevel("player")
				if myLevel < bottomRangeLevel or myLevel > topRangeLevel then
					Debug("[" .. bottomRangeLevel .. "-" .. topRangeLevel .."] - " .. arg1)
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

function SetFrame(frameString)
	local frame = tonumber(frameString)
	if frame == nil then
		Error("Not a number: "..(frameString or "nil"))
	else
		HCFFrame = frame
		Message("Frame set to: "..HCFFrame)
	end
end

function ShowHelp()
	Message("/hcf # or /hcf frame # - Modify the chat frame for HC Chat")
	Message("/hcf [PREFIX] - Set the channel prefix to PREFIX (default: HC)")
	Message("/hcf colour [HEX ##] - Set the colour of text (default: e6cd80)")
	Message("/hcf levelfilter - Turn the level filter on or off (default: on)")
	Message("/hcf info - Show the current settings of HCF")
	Message("/hcf debug - Turn debug mode on or off (default: off)")
	Message("/hcf help - Show this message!")
	Message(addonNotes .. " for bugs and suggestions")
	Message("Written by " .. addonAuthor)
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
			ShowHelp()
			return
		end
		if commandlist[1] == "frame" then
			if commandlist[2] == nil then 
				Error("No argument provided for command: "..message)
				return
			end
			SetFrame(commandlist[2])
		elseif commandlist[1] == "help" then
			ShowHelp()
			return
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
		elseif commandlist[1] == "trace" then
			HCFTrace = not HCFTrace
			Message("Trace logging " .. (HCFTrace and "enabled" or "disabled"))
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


local alreadyshown = false
local loginchannels = { "BATTLEGROUND", "RAID", "GUILD" }
local groupchannels = { "BATTLEGROUND", "RAID" }
  
hcfupdater = CreateFrame("Frame")
hcfupdater:RegisterEvent("CHAT_MSG_ADDON")
hcfupdater:RegisterEvent("PLAYER_ENTERING_WORLD")
hcfupdater:RegisterEvent("PARTY_MEMBERS_CHANGED")
hcfupdater:SetScript("OnEvent", function()
	if event == "CHAT_MSG_ADDON" and arg1 == "hcf" then
		Trace("Received: " .. arg2)
		local message = ParseMessage(arg2)
		if(SemverCompare(message["version"], addonVersion) >= 0) then
			Trace(message["sender"] .. " has version " .. addonVersion)
			return
		end
		Trace("I have version " .. addonVersion .. " and " .. message["sender"] .. " has version " .. message["version"])
		if not alreadyshown then
			Message("New version available (" .. arg2 .. ")! " .. addonNotes)
			alreadyshown = true
		end
	end

	if event == "PARTY_MEMBERS_CHANGED" then
		local groupsize = GetNumRaidMembers() > 0 and GetNumRaidMembers() or GetNumPartyMembers() > 0 and GetNumPartyMembers() or 0
		if (this.currentGroupSize or 0) < groupsize then
			for _, chan in pairs(groupchannels) do
				SendVersionMessage(chan)
			end
		end
		this.currentGroupSize = groupSize
	end

	if event == "PLAYER_ENTERING_WORLD" then
		for _, chan in pairs(loginchannels) do
			SendVersionMessage(chan)
		end
	end
end)

function SendVersionMessage(chan)
	local msg = "sender=" .. me .. ",version=" .. addonVersion
	Trace("Sent: " .. msg)
	SendAddonMessage("hcf", msg, chan)
end

--pfUI.api.strsplit
function strsplit(delimiter, subject)
  if not subject then return nil end
  local delimiter, fields = delimiter or ":", {}
  local pattern = string.format("([^%s]+)", delimiter)
  string.gsub(subject, pattern, function(c) fields[table.getn(fields)+1] = c end)
  return unpack(fields)
end

function SemverCompare(ver1, ver2)
	local major, minor, fix = strsplit(".", ver1)
	local ver1Num = tonumber(major*10000 + minor*100 + fix)
	major, minor, fix = strsplit(".", ver2)
	local ver2Num = tonumber(major*10000 + minor*100 + fix)
	return ver1Num - ver2Num
end

function ParseMessage(message)
	local t={}
	for kvp in gfind(message, "([^,]+)") do
		local key = nil
		for entry in gfind(kvp, "([^=]+)") do
			if key == nil then
				key = entry
			else
				t[key] = entry
			end
	  end
	end
	return t
end
