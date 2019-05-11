---@class misterio_virtual_shield
LinkLuaModifier ("modifier_misterio_virtual_shield", "abilities/misterio_virtual_shield.lua", LUA_MODIFIER_MOTION_NONE)

misterio_virtual_shield = class({})

function misterio_virtual_shield:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_misterio_virtual_shield", {
                duration = self:GetAbility():GetSpecialValueFor("duration")
            })
        end
    end 
end


---@class modifier_misterio_virtual_shield
modifier_misterio_virtual_shield = class({})


function modifier_misterio_virtual_shield:IsPurgable() return false end
function modifier_misterio_virtual_shield:IsHidden() return true end

function modifier_misterio_virtual_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_REFLECT_SPELL,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE
    }

    return funcs
end

function misterio_virtual_shield:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("spell_amplify")
end

function misterio_virtual_shield:GetAbsorbSpell(keys)
	return 1
end

function misterio_virtual_shield:GetReflectSpell(keys)
    if self.stored ~= nil then
        self.stored:RemoveSelf() 
    end

    local hCaster = self:GetParent()

    EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
    EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())

    if keys.ability:GetAbilityName() == "loki_spell_steal" or not keys.ability:IsStealable() then
        return nil
    end

    local hAbility = hCaster:AddAbility(keys.ability:GetAbilityName())

    hAbility:SetStolen(true) 
    hAbility:SetHidden(true) 
    hAbility:SetLevel(keys.ability:GetLevel()) 
    hCaster:SetCursorCastTarget(keys.ability:GetCaster()) 
    hAbility:OnSpellStart() 

    self.stored = hAbility 

    ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
   
    return 1
end