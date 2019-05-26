LinkLuaModifier("modifier_oblivion_astral", "abilities/oblivion_astral.lua", 0)

oblivion_astral = class({})

function oblivion_astral:GetCastPoint() return self:GetSpecialValueFor("cast_point") end
function oblivion_astral:OnSpellStart() if IsServer() then self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_oblivion_astral", {duration = self:GetSpecialValueFor("duration")}) EmitSoundOn("DOTA_Item.GhostScepter.Activate", self:GetCaster()) end end

modifier_oblivion_astral = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    IsDebuff = function() return false end,
    GetEffectName = function() return "particles/items_fx/ghost.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    CheckState = function() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_SILENCED] = true} end
})
