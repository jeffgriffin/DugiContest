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

local LOOT_SELF_REGEX = gsub(LOOT_ITEM_SELF, "%%s", "(.+)") --"You receive item: %s."
local LOOT_PUSHED_REGEX = gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)") --"You receive loot: %s."
frame:RegisterEvent("CHAT_MSG_LOOT")
frame:SetScript("OnEvent", function(self, event, message)
	DC:DebugFormat("CHAT_MSG_LOOT")
	local itemlink = string.match(message, LOOT_SELF_REGEX) or string.match(message, LOOT_PUSHED_REGEX)
	if itemlink then
		local itemid = GetItemIdFromLink(itemlink)
		DC:DebugFormat("CHAT_MSG_LOOT", "itemid", itemid)
		if itemid==contestItemId then
			local raidMessage = string.format(L["Dugi Contest: Looted %s"], itemlink)
			RaidNotice_AddMessage( RaidWarningFrame, raidMessage, ChatTypeInfo["RAID_WARNING"] )
			raidMessage = string.format(L["Saving Screenshot %d:%d"], GetGameTime())
			RaidNotice_AddMessage( RaidWarningFrame, raidMessage, ChatTypeInfo["RAID_WARNING"] )
			PlaySound("RaidWarning")
			ScreenshotTimer:ScheduleTimer("ScreenshotTimer", 1)
		end
	end
end)

function ScreenshotTimer:ScreenshotTimer()
	Screenshot()
end