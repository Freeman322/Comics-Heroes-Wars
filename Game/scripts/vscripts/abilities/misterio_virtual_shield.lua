---@class misterio_virtual_shield
LinkLuaModifier ("modifier_misterio_virtual_shield", "abilities/misterio_virtual_shield.lua", LUA_MODIFIER_MOTION_NONE)

misterio_virtual_shield = class({})

function misterio_virtual_shield:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_misterio_virtual_shield", {
                duration = self:GetSpecialValueFor("duration")
            })

            EmitSoundOn("Hero_Rubick.SpellSteal.Complete", self:GetCaster())
        end
    end 
end


---@class modifier_misterio_virtual_shield
modifier_misterio_virtual_shield = class({})

modifier_misterio_virtual_shield.m_hLastAbility = nil

function modifier_misterio_virtual_shield:IsPurgable() return false end
function modifier_misterio_virtual_shield:IsHidden() return true end

function modifier_misterio_virtual_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_REFLECT_SPELL,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }

    return funcs
end

function modifier_misterio_virtual_shield:GetEffectName()
	return "particles/misterio/misterio_shield.vpcf"
end

function modifier_misterio_virtual_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_misterio_virtual_shield:GetModifierSpellAmplify_Percentage()
    if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_misterio_5") then
        return self:GetAbility():GetSpecialValueFor("spell_amp") + IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_misterio_5")
    end 

    return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_misterio_virtual_shield:GetAbsorbSpell(keys)
	return 1
end

function modifier_misterio_virtual_shield:GetReflectSpell(keys)
    local hCaster = self:GetParent()

    EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
    EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())

    if keys.ability:GetAbilityName() == "loki_spell_steal" or not keys.ability:IsStealable() then
        return nil
    end

    if self.m_hLastAbility and not self.m_hLastAbility:IsNull() then self.m_hLastAbility:RemoveSelf() end 

    pcall(function()
        self.m_hLastAbility = hCaster:AddAbility(keys.ability:GetAbilityName())

        if not self.m_hLastAbility:IsNull() and self.m_hLastAbility then
            self.m_hLastAbility:SetStolen(true) --just to be safe with some interactions.
            self.m_hLastAbility:SetHidden(true) --hide the ability.
            self.m_hLastAbility:SetLevel(keys.ability:GetLevel()) --same level of ability as the origin.
            
            hCaster:SetCursorCastTarget(keys.ability:GetCaster()) --lets send this spell back.
            
            self.m_hLastAbility:OnSpellStart() --cast the spell.

            ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
            ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
        end
    end)

    return 1
end