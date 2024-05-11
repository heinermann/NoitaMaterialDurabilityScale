-- This file makes patches and changes to the game before anything else is called

-- #########################################################
-- ## Patch all spells to disable staining
-- #########################################################
dofile_once("data/scripts/gun/gun_actions.lua")

local EXTRA_STAIN_XMLS = {
  "data/entities/base_projectile_physics.xml",
  "data/entities/base_prop_crystal.xml",
}

local function remove_stains_from_file(filename)
  if filename == nil then return end

  local xml = ModTextFileGetContent(filename)
  if xml == nil then return end

  xml = string.gsub(xml, 'stains_enabled="%d+"', 'stains_enabled="0"')
  xml = string.gsub(xml, 'stains_radius="%d+"', 'stains_radius="0"')
  ModTextFileSetContent(filename, xml)
end

local function remove_stains_from_array(arr)
  if arr == nil then return end

  for _, related in ipairs(arr) do
    remove_stains_from_file(related)
  end
end

-- Register all stain XMLs
for _, spell in ipairs(actions) do
  remove_stains_from_array(spell.related_projectiles)
  remove_stains_from_array(spell.related_extra_entities)
  remove_stains_from_file(spell.custom_xml_file)
end

for _, xml in ipairs(EXTRA_STAIN_XMLS) do
  remove_stains_from_file(xml)
end

-- #########################################################
-- ## Other tweaks
-- #########################################################

-- Change magic numbers (global tweaks)
ModMagicNumbersFileAdd("data/magic_numbers_wiki.xml")
