--Localization.enUS.lua

DugiContestLocals = {
	PART_TEXT = "Part",
	PART_MATCH = "%s%(Part (%d+)%)",
}

setmetatable(DugiContestLocals, {__index=function(t,k) rawset(t, k, k); return k; end})
