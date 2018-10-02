medivh_fade_aura = class({})

LinkLuaModifier( "modifier_medivh_fade_aura",       "abilities/medivh_fade_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medivh_fade_aura_leak",  "abilities/medivh_fade_aura.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function medivh_fade_aura:GetIntrinsicModifierName()
	return "modifier_medivh_fade_aura"
end

modifier_medivh_fade_aura = class({})

function modifier_medivh_fade_aura:IsAura()
	return true
end

function modifier_medivh_fade_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

function modifier_medivh_fade_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_medivh_fade_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_medivh_fade_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_medivh_fade_aura:GetModifierAura()
	return "modifier_medivh_fade_aura_leak"
end

modifier_medivh_fade_aura_leak = class({})

function modifier_medivh_fade_aura_leak:IsPurgable(  )
    return false
end

function modifier_medivh_fade_aura_leak:OnCreated( table )
    if IsServer(  ) then
        self:StartIntervalThink(0.1)
    end
end

function modifier_medivh_fade_aura_leak:OnIntervalThink()
    if IsServer(  ) then
        local mana = (self:GetAbility():GetSpecialValueFor( "aura_mana_leak" )/100)/10

        self:GetParent():SetMana(self:GetParent():GetMana() - (self:GetParent():GetMaxMana() * mana))
        local gain = self:GetParent():GetMaxMana() * mana
        self:GetAbility():GetCaster():SetMana(self:GetCaster():GetMana() + gain)
    end
end

function medivh_fade_aura:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

