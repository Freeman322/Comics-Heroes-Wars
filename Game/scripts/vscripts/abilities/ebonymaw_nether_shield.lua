if ebonymaw_nether_shield == nil then ebonymaw_nether_shield = class({}) end
LinkLuaModifier ("modifier_ebonymaw_nether_shield", "abilities/ebonymaw_nether_shield.lua", LUA_MODIFIER_MOTION_NONE)

function ebonymaw_nether_shield:GetIntrinsicModifierName ()
    return "modifier_ebonymaw_nether_shield"
end


if modifier_ebonymaw_nether_shield == nil then
    modifier_ebonymaw_nether_shield = class({})
end

modifier_ebonymaw_nether_shield.m_hLastAbility = nil

function modifier_ebonymaw_nether_shield:IsPurgable()
    return false
end

function modifier_ebonymaw_nether_shield:IsHidden()
    return true
end

function modifier_ebonymaw_nether_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_REFLECT_SPELL
    }

    return funcs
end

function modifier_ebonymaw_nether_shield:GetAbsorbSpell(keys)
	if self:GetAbility():IsCooldownReady() then 
        return 1
	end
	return false
end

function modifier_ebonymaw_nether_shield:GetReflectSpell(keys)
    if self:GetAbility():IsCooldownReady() then 
        local hCaster = self:GetParent()

        EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
        EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())

        if keys.ability:GetAbilityName() == "loki_spell_steal" or keys.ability:GetAbilityName() == "zoom_charge_of_darkness" or keys.ability:GetAbilityName() == "raiden_storm_flight" or not keys.ability:IsStealable() then
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
                
                Timers:CreateTimer(0.10, function()
                    self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
                end)

                return 1
            end
        end)
    end
    return false
end