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
  local player = get_players()[1]
  local x, y = EntityGetTransform(player)
  local perk = perk_spawn(x, y, perk_name)
  perk_pickup(perk, player, EntityGetName(perk), false, false)
end

-- Gives a spell
local function give_spell(spell_name)
  local player = get_players()[1]
  local spell = CreateItemActionEntity(spell_name)
  GamePickUpInventoryItem(player, spell, false)
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

local SPELLS_TO_TEST = {
  "BOMB",
  "LIGHT_BULLET",
  "BULLET",
  "HEAVY_BULLET",
  "AIR_BULLET",
  "SLOW_BULLET",
  "HOOK",
  "BLACK_HOLE",
  "WHITE_HOLE",
  "TENTACLE_PORTAL",
  "SPITTER",
  "SPITTER_TIMER",
  "SPITTER_TIER_2",
  "SPITTER_TIER_3",
  "BUBBLESHOT",
  "DISC_BULLET",
  "DISC_BULLET_BIG",
  "BOUNCY_ORB",
  "RUBBER_BALL",
  "ARROW",
  "POLLEN",
  "LANCE",
  "LANCE_HOLY",
  "ROCKET",
  "ROCKET_TIER_2",
  "ROCKET_TIER_3",
  "GRENADE",
  "GRENADE_TIER_2",
  "GRENADE_TIER_3",
  "GRENADE_ANTI",
  "GRENADE_LARGE",
  "MINE",
  "PIPE_BOMB",
  "FISH",
  "EXPLODING_DEER",
  "EXPLODING_DUCKS",
  "WORM_SHOT",
  "LASER",
  "MEGALASER",
  "LIGHTNING",
  "BALL_LIGHTNING",
  "LASER_EMITTER",
  "LASER_EMITTER_FOUR",
  "LASER_EMITTER_CUTTER",
  "DIGGER",
  "POWERDIGGER",
  "CHAINSAW",
  "LUMINOUS_DRILL",
  "LASER_LUMINOUS_DRILL",
  "TENTACLE",
  "TENTACLE_TIMER",
  "HEAL_BULLET",
  "ANTIHEAL",
  "SPIRAL_SHOT",
  "MAGIC_SHIELD",
  "BIG_MAGIC_SHIELD",
  "CHAIN_BOLT",
  "FIREBALL",
  "METEOR",
  "FLAMETHROWER",
  "ICEBALL",
  "SLIMEBALL",
  "DARKFLAME",
  "MISSILE",
  "FUNKY_SPELL",
  "PEBBLE",
  "DYNAMITE",
  "GLITTER_BOMB",
  "BUCKSHOT",
  "FREEZING_GAZE",
  "GLOWING_BOLT",
  "SPORE_POD",
  "GLUE_SHOT",
  "BOMB_HOLY",
  "BOMB_HOLY_GIGA",
  "PROPANE_TANK",
  "BOMB_CART",
  "CURSED_ORB",
  "EXPANDING_ORB",
  "CRUMBLING_EARTH",
  "SUMMON_ROCK",
  "SUMMON_EGG",
  "SUMMON_HOLLOW_EGG",
  "TNTBOX",
  "TNTBOX_BIG",
  "ACIDSHOT",
  "THUNDERBALL",
  "FIREBOMB",
  "DEATH_CROSS",
  "DEATH_CROSS_BIG",
  "INFESTATION",
  "MIST_RADIOACTIVE",
  "MIST_ALCOHOL",
  "MIST_SLIME",
  "MIST_BLOOD",
  "TELEPORT_PROJECTILE",
  "TELEPORT_PROJECTILE_SHORT",
  "TELEPORT_PROJECTILE_STATIC",
  "SWAPPER_PROJECTILE",
  "TELEPORT_PROJECTILE_CLOSER",
  "NUKE",
  "NUKE_GIGA",
  "FIREWORK",
}

local function add_spell_to_wand(spell_name)
  local spell = CreateItemActionEntity(spell_name)
  local wand = EntityGetWithTag("first_wand")[1]
  EntityAddChild(wand, spell)
end

-- Called when the player character is spawned
function OnPlayerSpawned(player_entity)
  -- Give perks
  give_perk("REMOVE_FOG_OF_WAR") -- All-seeing eye
  give_perk("EDIT_WANDS_EVERYWHERE")

  -- Give spells
  give_spell("CHAINSAW")
  give_spell("CHAINSAW")
  give_spell("CHAINSAW")
  give_spell("CHAINSAW")
  give_spell("BURST_2")
  give_spell("BURST_2")
  give_spell("RECOIL_DAMPER")
  give_spell("RECOIL_DAMPER")
  give_spell("SPREAD_REDUCE")
  give_spell("SPEED")

  -- Set up the scene
  LoadPixelScene("data/wiki/scene.png", "", -100, -1100, "", true)
  EntityApplyTransform(player_entity, -65, -1000)

  -- Choose the spell to spawn
  local index = tonumber(ModSettingGet("wiki_durability.wiki_iter")) or 1
  if index < 1 then index = 1 end

  if index <= #SPELLS_TO_TEST then
    add_spell_to_wand(SPELLS_TO_TEST[index])
    ModSettingSetNextValue("wiki_durability.wiki_iter", tostring(index + 1), false)
  end
end

-- Called after the world has been loaded
function OnWorldInitialized()
  clear_weather()
  SwitchDebugLogForReal()
end
