if item_void_gem == nil then item_void_gem = class({}) end
LinkLuaModifier ("modifier_item_void_gem_active", "items/item_void_gem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_void_gem", "items/item_void_gem.lua", LUA_MODIFIER_MOTION_NONE)

function item_void_gem:GetIntrinsicModifierName ()
    return "modifier_item_void_gem"
end

--------------------------------------------------------------------------------

function item_void_gem:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("active_duration")
    local caster = self:GetCaster ()

    caster:AddNewModifier(caster, self, "modifier_item_void_gem_active", {duration = duration})
end


if modifier_item_void_gem_active == nil then
    modifier_item_void_gem_active = class({})
end

function modifier_item_void_gem_active:IsPurgable()
    return false
end

function modifier_item_void_gem_active:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/items/item_void_gem.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(100, 100, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())
    end
end


function modifier_item_void_gem_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL
    }

    return funcs
end

function modifier_item_void_gem_active:GetAbsorbSpell(keys)
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
    hAbility:RemoveSelf()
    ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())    
    ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())      
    return 1
end


--[[function modifier_item_void_gem_active:GetAbsorbSpell( params )
	ParticleManager:CreateParticle("particles/items3_fx/lotus_orb_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())         
    EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
    EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())
    return 1
end]]

if modifier_item_void_gem == nil then
    modifier_item_void_gem = class({})
end

function modifier_item_void_gem:IsHidden()
    return true 
end

function modifier_item_void_gem:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ABSORB_SPELL
    }

    return funcs
end

function modifier_item_void_gem:GetAbsorbSpell(keys)
	if self:GetAbility():IsCooldownReady() or self:GetParent():HasModifier("modifier_item_void_gem_active") == true then
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
    	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel())/2)
        return 1
	end
	return false
end

--[[function modifier_item_void_gem:GetReflectSpell(kv)
    if self:GetAbility():IsCooldownReady() or self:GetParent():HasModifier("modifier_item_void_gem_active") == true then
        if self.stored ~= nil then
            self.stored:RemoveSelf() --we make sure to remove previous spell.
        end
        local hCaster = self:GetParent()
        EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
        EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
        EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())
        if kv.ability:GetAbilityName() == "loki_spell_steal" then
            return nil
        end
        local hAbility = hCaster:AddAbility(kv.ability:GetAbilityName())

        hAbility:SetStolen(true) --just to be safe with some interactions.
        hAbility:SetHidden(true) --hide the ability.
        hAbility:SetLevel(kv.ability:GetLevel()) --same level of ability as the origin.
        hCaster:SetCursorCastTarget(kv.ability:GetCaster()) --lets send this spell back.
        hAbility:OnSpellStart() --cast the spell.
        self.stored = hAbility --store the spell reference for future use.

        ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())    
        ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())      
        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
    end
end]]

function modifier_item_void_gem:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function modifier_item_void_gem:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_void_gem:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_void_gem:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_void_gem:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function modifier_item_void_gem:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end

function modifier_item_void_gem:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end




function item_void_gem:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

