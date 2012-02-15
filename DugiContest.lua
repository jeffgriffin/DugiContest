DugiContest = {}
local DC = DugiContest
local frame = CreateFrame("Frame", "DugiContestFrame", UIParent)
local L = DugiContestLocals
frame:Hide()
local contestItemId = 67539

local ScreenshotTimer = LibStub("AceAddon-3.0"):NewAddon("ContestTimer", "AceTimer-3.0")

local function GetItemIdFromLink(link)
	--|cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0:80:0|h[Broken Fang]|h|r
	return tonumber(link:match(".+|Hitem:([^:]+):.+"))
end

local requestMade = false
local function Local_WhoList_Update()
	DC:DebugFormat("Local_WhoList_Update")
	if not requestMade then return end
	requestMade = false
	HideUIPanel(FriendsFrame)
	if not DCWhoBlacklist then DCWhoBlacklist={} end
	local i
	local name, race, class
	for i=1,GetNumWhoResults() do
		name, _, _, race, class = GetWhoInfo(i)
		if not tContains(DCWhoBlacklist, name) then
			break
		end
	end
	if tContains(DCWhoBlacklist, name) then
		name, _, _, race, class  = GetWhoInfo(math.random(1,(GetNumWhoResults())))
	else
		tinsert(DCWhoBlacklist, name)
	end

	print(string.format("|cff11ff11 %s|r %s %s %s", "Dugi Contest", name, race, class))
end


local function PostRandom85()
	SetWhoToUI(1)
	requestMade = true
	SendWho("80-85")
end

local LOOT_SELF_REGEX = gsub(LOOT_ITEM_SELF, "%%s", "(.+)") --"You receive item: %s."
local LOOT_PUSHED_REGEX = gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)") --"You receive loot: %s."
frame:RegisterEvent("CHAT_MSG_LOOT")
frame:RegisterEvent("WHO_LIST_UPDATE")
frame:SetScript("OnEvent", function(self, event, message)
	if event=="CHAT_MSG_LOOT" then
		local itemlink = string.match(message, LOOT_SELF_REGEX) or string.match(message, LOOT_PUSHED_REGEX)
		if itemlink then
			local itemid = GetItemIdFromLink(itemlink)
			DC:DebugFormat("CHAT_MSG_LOOT", "itemid", itemid)
			if itemid==contestItemId then
				PostRandom85()
				local raidMessage = string.format(L["Dugi Contest: Looted %s"], itemlink)
				RaidNotice_AddMessage( RaidWarningFrame, raidMessage, ChatTypeInfo["RAID_WARNING"] )
				raidMessage = string.format(L["Saving Screenshot %d:%d"], GetGameTime())
				RaidNotice_AddMessage( RaidWarningFrame, raidMessage, ChatTypeInfo["RAID_WARNING"] )
				PlaySound("RaidWarning")
				OpenAllBags()
				ScreenshotTimer:ScheduleTimer("ScreenshotTimer", 2)
			end
		end
	elseif event=="WHO_LIST_UPDATE" then
		Local_WhoList_Update()
	end
end)

function ScreenshotTimer:ScreenshotTimer()
	Screenshot()
end