std = "lua51"
max_line_length = false
codes = true
files["**/VarzofTweaks.lua"].ignore = {
	"11[13]/VarzofTweaksDB", -- set/access saved variables
	"111/VarzofTweak_OnAddonCompartmentClick", -- handler for addon compartment frame registered in TOC

	-- Slash handling
	"111/SLASH_VARZOFTWEAKS1",
	"111/SLASH_VARZOFTWEAKS2",
	"11[23]/SlashCmdList",
}
not_globals = {
	"arg", -- arg is a standard global, so without this it won't error when we typo "args" in a module
}
globals = {
	-- wow std api
	"abs",
	"bit",
	"ceil",
	"cos",
	"date",
	"debugstack",
	"deg",
	"exp",
	"floor",
	"format",
	"frexp",
	"getn",
	"gmatch",
	"gsub",
	"hooksecurefunc",
	"ldexp",
	"max",
	"min",
	"mod",
	"rad",
	"random",
	"scrub",
	"sin",
	"sort",
	"sqrt",
	"strbyte",
	"strchar",
	"strcmputf8i",
	"strconcat",
	"strfind",
	"string.join",
	"strjoin",
	"strlen",
	"strlenutf8",
	"strlower",
	"strmatch",
	"strrep",
	"strrev",
	"strsplit",
	"strsub",
	"strtrim",
	"strupper",
	"table.wipe",
	"tan",
	"time",
	"tinsert",
	"tremove",

    -- Lua APIs
    "CopyTable",

    -- WoW Enums
    "Enum.ContentTrackingType.Achievement", -- https://wowpedia.fandom.com/wiki/Enum.ContentTrackingType
    "Enum.ContentTrackingStopType.Collected",

    -- WoW APIs
	"C_ContentTracking.GetTrackedIDs", -- https://wowpedia.fandom.com/wiki/API_C_ContentTracking.GetTrackedIDs
	"C_ContentTracking.StopTracking",
	"CreateFrame",
	"GetAchievementInfo", -- https://wowpedia.fandom.com/wiki/API_GetAchievementInfo
	"GetAchievementLink",
	"InterfaceOptions_AddCategory",
	"InterfaceOptionsFrame_OpenToCategory",
	"WrapTextInColorCode", -- https://wowpedia.fandom.com/wiki/API_ColorMixin_WrapTextInColorCode
}