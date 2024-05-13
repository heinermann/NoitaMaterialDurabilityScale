
-- Remove max uses on all spells
for _,spell in ipairs(actions) do
  spell.max_uses = nil
end
