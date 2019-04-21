if ebonymaw_nether_shield == nil then ebonymaw_nether_shield = class({}) end
LinkLuaModifier ("modifier_ebonymaw_nether_shield", "abilities/ebonymaw_nether_shield.lua", LUA_MODIFIER_MOTION_NONE)

function ebonymaw_nether_shield:GetIntrinsicModifierName ()
    return "modifier_ebonymaw_nether_shield"
end


if modifier_ebonymaw_nether_shield == nil then
    modifier_ebonymaw_nether_shield = class({})
end

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
        if self.stored ~= nil then
            self.stored:RemoveSelf() --we make sure to remove previous spell.
        end

        local hCaster = self:GetParent()

        EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
        EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())

        if keys.ability:GetAbilityName() == "loki_spell_steal" then
            return nil
        end

        local hAbility = hCaster:AddAbility(keys.ability:GetAbilityName())

        hAbility:SetStolen(true) --just to be safe with some interactions.
        hAbility:SetHidden(true) --hide the ability.
        hAbility:SetLevel(keys.ability:GetLevel()) --same level of ability as the origin.
        hCaster:SetCursorCastTarget(keys.ability:GetCaster()) --lets send this spell back.
        hAbility:OnSpellStart() --cast the spell.
        self.stored = hAbility --store the spell reference for future use.

        ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
        ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
        
        Timers:CreateTimer(0.10, function()
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        end)
        return 1
    end
    return false
end