aqua_man_sea_lord = class ( {})

function aqua_man_sea_lord:Spawn() if IsServer() then self:SetLevel(1) end end
function aqua_man_sea_lord:GetIntrinsicModifierName () return "modifier_slardar_sprint_river" end
function aqua_man_sea_lord:GetBehavior () return DOTA_ABILITY_BEHAVIOR_PASSIVE end
