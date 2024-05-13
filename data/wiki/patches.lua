-- This file makes patches and changes to the game before anything else is called

-- #########################################################
-- ## Spell stain removal functions
-- #########################################################
dofile_once("data/scripts/gun/gun_actions.lua")

local EXTRA_STAIN_XMLS = {
  "data/entities/base_projectile_physics.xml",
  "data/entities/base_prop_crystal.xml",
}

local NONEXISTENT_XMLS = {
  ["data/entities/projectiles/deck/caster_cast.xml"] = true,
}

-- Early start logging gets overwritten making it impossible to debug, so lets save log items here then print it later
local logger_text = {}
local real_log = false

local function log_debug(msg)
  if real_log then
    print_error(msg)
  else
    table.insert(logger_text, msg)
  end
end

local function print_debug_log()
  for _, msg in ipairs(logger_text) do
    print_error(msg)
  end
end

function SwitchDebugLogForReal(msg)
  real_log = true
  print_debug_log()
end

local function remove_stains_from_file_protected(filename)
  local xml = ModTextFileGetContent(filename)

  xml = string.gsub(xml, 'stains_enabled="%d+"', 'stains_enabled="0"')
  xml = string.gsub(xml, 'stains_radius="%d+"', 'stains_radius="0"')
  ModTextFileSetContent(filename, xml)
end

local function remove_stains_from_file(filename)
  if type(filename) ~= "string" or NONEXISTENT_XMLS[filename] then return end

  local success = pcall(remove_stains_from_file_protected, filename)
  if not success then
    log_debug("Failed to remove stains from file: " .. tostring(filename))
  end
end

local function remove_stains_from_array(arr)
  if arr == nil then return end

  for _, related in ipairs(arr) do
    remove_stains_from_file(related)
  end
end

-- #########################################################
-- ## Patch all spells to disable staining
-- #########################################################

-- Iterate all stain XMLs
for _, spell in ipairs(actions) do
  remove_stains_from_array(spell.related_projectiles)
  remove_stains_from_array(spell.related_extra_entities)
  remove_stains_from_file(spell.custom_xml_file)
end

for _, xml in ipairs(EXTRA_STAIN_XMLS) do
  remove_stains_from_file(xml)
end

-- #########################################################
-- ## Turn off max uses for spells
-- #########################################################
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "data/wiki/patch_gun_actions.lua")

-- #########################################################
-- ## Other tweaks
-- #########################################################

-- Change magic numbers (global tweaks)
ModMagicNumbersFileAdd("data/magic_numbers_wiki.xml")
