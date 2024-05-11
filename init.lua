dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

-- Apply our pre-game patches and modifications to existing content
dofile("data/wiki/patches.lua")

-- Add new materials and change spawn location
ModMaterialsFileAdd("data/wiki/materials.xml")

-- Stains will be in XML files as:
--   stains_enabled="\d+"
--   stains_radius="\d+"

-- Give perk, taken from
-- https://github.com/DaftBrit/NoitaArchipelago/blob/master/data/archipelago/scripts/ap_utils.lua#L36
local function give_perk(perk_name)
	for _, p in ipairs(get_players()) do
		local x, y = EntityGetTransform(p)
		local perk = perk_spawn(x, y, perk_name)
		perk_pickup(perk, p, EntityGetName(perk), false, false)
	end
end

-- Clear the weather of any rain/fog/wind, set the time of day and pause it
local function clear_weather()
  local world_state_entity = GameGetWorldStateEntity()
	edit_component( world_state_entity, "WorldStateComponent", function(comp,vars)
		vars.time = 0
		vars.time_dt = 0
    vars.rain = 0
    vars.fog = 0
    vars.wind = 0
    vars.wind_speed = 0
	end)
end

-- Called when the player character is spawned
function OnPlayerSpawned(player_entity)
  give_perk("REMOVE_FOG_OF_WAR") -- All-seeing eye
  LoadPixelScene("data/wiki/scene.png", "", -100, -1100, "", true)
  EntityApplyTransform(player_entity, 0, -1000)
end

-- Called after the world has been loaded
function OnWorldInitialized()
  clear_weather()
end
