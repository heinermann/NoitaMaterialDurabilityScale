dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

-- Apply our own patches
dofile_once("data/wiki/patches.lua")

-- Stains will be in XML files as:
--   stains_enabled="\d+"
--   stains_radius="\d+"


-- Give perk, taken from
-- https://github.com/DaftBrit/NoitaArchipelago/blob/master/data/archipelago/scripts/ap_utils.lua#L36
function give_perk(perk_name)
	for i, p in ipairs(get_players()) do
		local x, y = EntityGetTransform(p)
		local perk = perk_spawn(x, y, perk_name)
		perk_pickup(perk, p, EntityGetName(perk), false, false)
	end
end

-- Called when the player character is spawned
function OnPlayerSpawned(player_entity)
  give_perk("REMOVE_FOG_OF_WAR") -- All-seeing eye
end
