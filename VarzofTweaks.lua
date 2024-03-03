local curAddonName = "VarzofTweaks";
local curAddonTitle = "Varzof's UI Tweaks";
local messagePrefix = WrapTextInColorCode(curAddonName, "FF69CCF0") .. ": ";

local defaults = {
    untrackCompletedAchievements = false,
}

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
    -- there already is an existing OnClick script that plays a sound, hook it
    cb:HookScript("OnClick", function(_, btn, down)
        print("Clicked");
        self.db.untrackCompletedAchievements = cb:GetChecked();
        if self.db.untrackCompletedAchievements then
            print("Enabled");
        else
            print("Disabled");
        end
    end)
    cb:SetChecked(self.db.untrackCompletedAchievements);

    InterfaceOptions_AddCategory(self.panel);
end

function f:CheckForTrackedCompletedAchievements()
    local atype = Enum.ContentTrackingType.Achievement;
    local stype = Enum.ContentTrackingStopType.Collected;
    local ids = C_ContentTracking.GetTrackedIDs(atype);
    for index = 1, #ids do
        local id = ids[index];
        local _, achievementName, points, completed, month, day, year, description, flags, iconpath = GetAchievementInfo(id);
        local achievementLink = GetAchievementLink(id);
        if (completed) then
            if self.db.untrackCompletedAchievements then
                print(messagePrefix .. "Untracked completed achievement " .. achievementLink);
                --C_ContentTracking.StopTracking(atype, id, stype);
            else
                print(messagePrefix .. "Achievement " .. achievementLink .. " is complete but still tracked");
            end
        end
    end
end

f:RegisterEvent("ADDON_LOADED");
f:SetScript("OnEvent", f.OnEvent);

--local atype = Enum.ContentTrackingType.Achievement;
--local stype = Enum.ContentTrackingStopType.Collected;
--local index;
--local ids = C_ContentTracking.GetTrackedIDs(atype);
--for index = 1, #ids do
--    local id = ids[index];
--    local _, achievementName, points, completed, month, day, year, description, flags, iconpath = GetAchievementInfo(id);
--    if (completed) then
--        print(achievementName .. " is complete but still tracked");
--        C_ContentTracking.StopTracking(atype, id, stype);
--        print("Fixed");
--    end
--end
--local max = Constants.ContentTrackingConsts.MaxTrackedAchievements;
--ids = C_ContentTracking.GetTrackedIDs(atype);
--print(#ids .. "/" .. max);
