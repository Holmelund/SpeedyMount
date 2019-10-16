Addon = LibStub("AceAddon-3.0"):NewAddon("SpeedyMount", "AceConsole-3.0", "AceEvent-3.0");

local name, SpeedyMount = ...;
local options  = {
    name = "SpeedyMount",
    handler = SpeedyMount,
    type = "group",
    args = {
        gloves = {
            type = "input",
            name = "Gloves",
            desc = "Name of your speed increasing gloves",
            usage = "<item name>",
            set = "SetGloves",
        },
        boots = {
            type = "input",
            name = "Boots",
            desc = "Name of your speed increasing boots",
            usage = "<item name>",
            set = "SetBoots"
        },
        trinket = {
            type = "input",
            name = "Trinket",
            desc = "Name of your speed increasing trinket",
            usage = "<item name>",
            set = "SetTrinket",
        },
        reset = {
          type = "input",
          name = "Reset",
          desc = "Reset outfit to non-riging gear",
          usage = "",
          set = "Reset",
        }
    }
};

do
	local locale = GetLocale();
	local convert = { enGB = "enUS", esES = "esMX", itIT = "enUS" };
	local gameLocale = convert[locale] or locale or "enUS";

	function Addon:GetLocale()
		return gameLocale;
	end
end

function Addon:OnEnable()
    -- Events
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("UNIT_AURA");
    self:RegisterEvent("PLAYER_REGEN_ENABLED");
    self:RegisterEvent("PLAYER_UNGHOST");
    self:RegisterEvent("PLAYER_ALIVE");
  
    -- Addon Loaded
    self:Print("Type /sm for Options");
    SpeedyMount.HasMount();
end

function Addon:OnInitialize()
    -- Register the Database
    self.db = LibStub("AceDB-3.0"):New("SpeedyMountDB", defaults, true);

    if Addon.db.profile.riding == nil then
        Addon.db.profile.riding = {};
    end

    if Addon.db.profile.normal == nil then
        Addon.db.profile.normal = {};
    end

    if Addon.db.profile.inRidingGear == nil then
        Addon.db.profile.inRidingGear = false;
    end

    if Addon.db.profile.swapGearAfterCombat == nil then
        Addon.db.profile.swapGearAfterCombat = false;
    end

    LibStub("AceConfig-3.0"):RegisterOptionsTable("SpeedyMount", options);
    self:RegisterChatCommand("sm", "ChatCommand");
end

function Addon:DisplayMessage(item, name)
  return print("|cff1683d1SpeedyMount|r: ", item, " was updated to ", name);
end

function Addon:ChatCommand(input)
  if not input or input:trim() == "" then
    print("|cff1683d1SpeedyMount|r Options:");
    print("    /sm (gloves | boots | trinket) (item link | item name | item id)");
  else
    LibStub("AceConfigCmd-3.0"):HandleCommand("sm", "SpeedyMount", input);
  end
end

function Addon:PLAYER_ENTERING_WORLD()
  SpeedyMount.HasMount();
end

function Addon:UNIT_AURA()
  local inLockdown = InCombatLockdown();

  if inLockdown then
    if Addon.db.profile.inRidingGear then
      Addon.db.profile.swapGearAfterCombat = true;
    end
  else
    SpeedyMount.HasMount();
  end
end

function Addon:PLAYER_REGEN_ENABLED()
  if Addon.db.profile.swapGearAfterCombat then
    SpeedyMount.HasMount();
    Addon.db.profile.swapGearAfterCombat = false;
  end
end

function Addon:PLAYER_UNGHOST()
  SpeedyMount.HasMount();
end

function Addon:PLAYER_ALIVE()
  SpeedyMount.HasMount();
end

--------------------------------------------------
---  Getters and Setters
--------------------------------------------------
function Addon:SetGloves(_, value)
  SpeedyMount.SetGloves(value);
end

function Addon:SetBoots(_, value)
  SpeedyMount.SetBoots(value);
end

function Addon:SetTrinket(_, value)
  SpeedyMount.SetTrinket(value);
end

function Addon:Reset()
  SpeedyMount.Reset();
end