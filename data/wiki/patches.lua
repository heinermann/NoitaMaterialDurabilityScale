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
  local xml = ModTextFileGetContent(filename)
  xml = xml:gsub('stains_enabled="%d+"', 'stains_enabled="0"')
  xml = xml:gsub('stains_radius="%d+"', 'stains_radius="0"')
  ModTextFileSetContent(filename, xml)
end


-- Register all stain XMLs
for _, spell in ipairs(actions) do
  if spell.related_extra_entities ~= nil then
    for _, related in ipairs(spell.related_extra_entities) do
      remove_stains_from_file(related)
    end
  end
end

for _, xml in ipairs(EXTRA_STAIN_XMLS) do
  remove_stains_from_file(xml)
end

-- #########################################################
-- ## Other tweaks
-- #########################################################

-- Change magic numbers (global tweaks)
ModMagicNumbersFileAdd("data/magic_numbers_wiki.xml")
