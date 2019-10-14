local name, SpeedyMount = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("SpeedyMount");

local debug = false;

--------------------------------------------------
---  Addon Specific Options
--------------------------------------------------
local normal, riding = "normal", "riding";

local function PerformItemChanges(input)
  local count = 0;
  local items;
  local gloves = { nil, 10 };
  local boots = { nil, 8 };
  local trinket = { nil, 14 };

  if (GetInventoryItemID("player", 10) ~= nil) then
    gloves[1] = GetItemInfo(GetInventoryItemID("player", 10));

    if debug then
      print(gloves[1]);
    end
  end

  if (GetInventoryItemID("player", 8) ~= nil) then
    boots[1] = GetItemInfo(GetInventoryItemID("player", 8));

    if debug then
      print(boots[1]);
    end
  end

  if (GetInventoryItemID("player", 14) ~= nil) then
    trinket[1] = GetItemInfo(GetInventoryItemID("player", 14));

    if debug then
      print(trinket[1]);
    end
  end

  if input == normal then
    items = Addon.db.profile.normal;
  elseif input == riding then
    items = Addon.db.profile.riding;
  end
  
  if (input == normal and Addon.db.profile.inRidingGear) or (input == riding and not Addon.db.profile.inRidingGear) then
    for i, item in pairs(items) do
      
      if not IsEquippedItem(item[1]) then
        EquipItemByName(item[1], item[2]);
      end

      count = count + 1;
    end
  end
  
  if input == riding and not Addon.db.profile.inRidingGear then
    if (gloves[1] ~= nil) and (gloves[1] ~= Addon.db.profile.riding.gloves[1]) and (gloves[1] ~= Addon.db.profile.normal.gloves[1]) then
      if debug then
        print("Normal gloves changed to: ", gloves[1]);
      end

      Addon.db.profile.normal.gloves[1] = gloves[1];
    end

    if (boots[1] ~= nil) and (boots[1] ~= Addon.db.profile.riding.boots[1]) and (boots[1] ~= Addon.db.profile.normal.boots[1]) then
      if debug then
        print("Normal boots changed to: ", boots[1]);
      end

      Addon.db.profile.normal.boots[1] = boots[1];
    end

    if (trinket[1] ~= nil) and (trinket[1] ~= Addon.db.profile.riding.trinket[1]) and (trinket[1] ~= Addon.db.profile.normal.tinket[1]) then
      if debug then
        print("Normal trinket changed to: ", trinket[1]);
      end

      Addon.db.profile.normal.tinket[1] = trinket[1];
    end
  end

  if count == 3 then
    if input == normal then
      Addon.db.profile.inRidingGear = false;
    elseif input == riding then
      Addon.db.profile.inRidingGear = true;
    end
  end
end

function HasMount()
  if UnitLevel("player") < 40 then 
    return;
  end

  local hasMount = false;
  local mounts = SpeedyMount.GetMounts();

  for i=1, 40 do
    local name = UnitBuff("player", i);

    if name == nil then
      break;
    end

    for j, mount in ipairs(mounts) do
      if name == mount then
        hasMount = true;
        if not Addon.db.profile.inRidingGear then
          if debug then
            print("I have a steed");
          end

          PerformItemChanges(riding);
        end
        
        return;
      else
        hasMount = false;
      end
    end
  end

  if not hasMount then
    if Addon.db.profile.inRidingGear then
      if debug then
        print("walking sim 9000");
      end

      PerformItemChanges(normal);
    end
  end
end

SpeedyMount.HasMount = HasMount;

--------------------------------------------------
---  Getters and Setters
--------------------------------------------------
function SetGloves(value)
  local id = GetItemInfoInstant(value);
  local name = select(1, GetItemInfo(id));

  if name ~= nil then
    Addon.db.profile.riding.gloves = { name, 10 };
    SpeedyMount:DisplayMessage("Gloves", name);
  end
end

SpeedyMount.SetGloves = SetGloves;

function SetBoots(value)
  local id = GetItemInfoInstant(value);
  local name = select(1, GetItemInfo(id));

  if name ~= nil then
    Addon.db.profile.riding.boots = { name, 8 };
    SpeedyMount:DisplayMessage("Boots", name);
  end
end

SpeedyMount.SetBoots = SetBoots;

function SetTrinket(value)
  local id = GetItemInfoInstant(value);
  local name = select(1, GetItemInfo(id));

  if name ~= nil then
    Addon.db.profile.riding.trinket = { name, 14 };
    SpeedyMount:DisplayMessage("Trinket", name);
  end
end

SpeedyMount.SetTrinket = SetTrinket;

function Reset()
  PerformItemChanges(normal);
end

SpeedyMount.Reset = Reset;