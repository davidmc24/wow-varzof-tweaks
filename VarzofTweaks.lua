local curAddonName, NS = ...;
local curAddonTitle = "Varzof's UI Tweaks";
local messagePrefix = WrapTextInColorCode(curAddonName, "FF69CCF0") .. ":";
local ACHIEVEMENT_FLAG_ACCOUNT_WIDE = 0x20000;
local debug = false;

local defaults = {
    untrackCompletedAchievements = false,
}

local function getTrackedAchievementIDs()
    local atype = Enum.ContentTrackingType.Achievement;
    return C_ContentTracking.GetTrackedIDs(atype);
end

local function isAchievementComplete(id)
    local _, name, _, completedByAnyCharacter, _, _, _, _, flags, _, _, _, wasEarnedByMe, _, _ = GetAchievementInfo(id);
    local accountWide = bit.band(flags, ACHIEVEMENT_FLAG_ACCOUNT_WIDE) > 0;
    local complete = wasEarnedByMe or (accountWide and completedByAnyCharacter);
    if debug then
        if complete then
            print("Tracking " .. name .. ": complete");
        else
            print("Tracking " .. name .. ": incomplete");
        end
    end

    return complete;
end

local function untrackCompletedAchievement(id)
    local atype = Enum.ContentTrackingType.Achievement;
    local stype = Enum.ContentTrackingStopType.Manual;
    C_ContentTracking.StopTracking(atype, id, stype);
end

local f = CreateFrame("Frame");

local function updateUntrackCompletedAchievements()
    f:CheckForTrackedCompletedAchievements();
end

function f:OnEvent(event, addOnName)
    if addOnName == curAddonName then
        if event == "ADDON_LOADED" then
            self:OnLoad();
        end
    end
end

function f:OnLoad()
    if debug then
        print("VT loaded");
    end
    self:InitializeDB();
    self:InitializeOptions();
    self:CheckForTrackedCompletedAchievements();
end

function f:InitializeDB()
    VarzofTweaksDB = VarzofTweaksDB or CopyTable(defaults);
    self.db = VarzofTweaksDB;
end

function f:InitializeOptions()
    self.panel = CreateFrame("Frame");
    self.panel.name = curAddonTitle;

    local category = Settings.RegisterVerticalLayoutCategory(curAddonTitle);
    do
        local variable = "untrackCompletedAchievements";
        local name = "Cleanup achievements";
        local tooltip = "Un-track completed achievements";
        local variableKey = "untrackCompletedAchievements";
        local variableTbl = self.db;
        local defaultValue = false;

        local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue);
        setting:SetValueChangedCallback(updateUntrackCompletedAchievements);
        Settings.CreateCheckbox(category, setting, tooltip);
    end

    Settings.RegisterAddOnCategory(category);
    NS.settingsCategoryID = category:GetID();
end

function f:CheckForTrackedCompletedAchievements()
    local trackedIds = getTrackedAchievementIDs();
    local fix = self.db.untrackCompletedAchievements;
    local completedIds = {};
    if debug then
        print(#trackedIds .. " tracked IDs");
    end
    for i = 1, #trackedIds do
        local id = trackedIds[i];
        if isAchievementComplete(id) then
            table.insert(completedIds, id);
        end
    end
    if #completedIds > 0 then
        if fix then
            for i = 1, #completedIds do
                local id = completedIds[i];
                local achievementLink = GetAchievementLink(id);
                untrackCompletedAchievement(id);
                print(messagePrefix, "Untracked completed achievement", achievementLink);
            end
        else
            print(messagePrefix, #completedIds, "completed achievements currently tracked");
        end
    end
end

f:RegisterEvent("ADDON_LOADED");
f:SetScript("OnEvent", f.OnEvent);

SLASH_VARZOFTWEAKS1 = "/vt"
SLASH_VARZOFTWEAKS2 = "/varzoftweaks"

SlashCmdList.VARZOFTWEAKS = function()
    Settings.OpenToCategory(NS.settingsCategoryID)
end

function VarzofTweak_OnAddonCompartmentClick()
    Settings.OpenToCategory(NS.settingsCategoryID)
end
