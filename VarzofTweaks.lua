local curAddonName = "VarzofTweaks";
local curAddonTitle = "Varzof's UI Tweaks";
local messagePrefix = WrapTextInColorCode(curAddonName, "FF69CCF0") .. ":";
local ACHIEVEMENT_FLAG_ACCOUNT_WIDE = 0x20000;

local defaults = {
    untrackCompletedAchievements = false,
}

local function getTrackedAchievementIDs()
    local atype = Enum.ContentTrackingType.Achievement;
    return C_ContentTracking.GetTrackedIDs(atype);
end

local function isAchievementComplete(id)
    local _, _, _, completedByAnyCharacter, _, _, _, _, flags, _, _, _, wasEarnedByMe, _, _ = GetAchievementInfo(id);
    local accountWide = bit.band(flags, ACHIEVEMENT_FLAG_ACCOUNT_WIDE) > 0;
    return wasEarnedByMe or (accountWide and completedByAnyCharacter);
end

local function untrackCompletedAchievement(id)
    local atype = Enum.ContentTrackingType.Achievement;
    local stype = Enum.ContentTrackingStopType.Collected;
    C_ContentTracking.StopTracking(atype, id, stype);
end

local f = CreateFrame("Frame");

function f:OnEvent(event, addOnName)
    if addOnName == curAddonName then
        if event == "ADDON_LOADED" then
            self:OnLoad();
        end
    end
end

function f:OnLoad()
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

    local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", 20, -20)
    cb.Text:SetText("Un-track completed achievements");
    cb:HookScript("OnClick", function()
        self.db.untrackCompletedAchievements = cb:GetChecked();
        self:CheckForTrackedCompletedAchievements();
    end)
    cb:SetChecked(self.db.untrackCompletedAchievements);

    InterfaceOptions_AddCategory(self.panel);
end

function f:CheckForTrackedCompletedAchievements()
    local trackedIds = getTrackedAchievementIDs();
    local fix = self.db.untrackCompletedAchievements;
    local completedIds = {};
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
    InterfaceOptionsFrame_OpenToCategory(f.panel)
end
