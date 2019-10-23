if jons_sea_terror == nil then jons_sea_terror = class({}) end

LinkLuaModifier( "modifier_jons_sea_terror", "abilities/jons_sea_terror", LUA_MODIFIER_MOTION_NONE )

function jons_sea_terror:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	
    if self:GetCaster():HasTalent("special_bonus_unique_jons_1") then
        local value = self:GetCaster():FindTalentValue("special_bonus_unique_jons_1")
        duration = duration + value
	end
	
    local kracken = CreateUnitByName( "npc_dota_kracken", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
    kracken:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

    kracken:AddNewModifier( self:GetCaster(), self, "modifier_jons_sea_terror", { duration = duration })
    kracken:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = duration })

    EmitSoundOn( "Hero_LoneDruid.SpiritBear.Cast", kracken )
    EmitSoundOn( "Hero_EarthShaker.Totem", self:GetCaster() )
end

if modifier_jons_sea_terror == nil then modifier_jons_sea_terror = class({}) end

function modifier_jons_sea_terror:IsHidden()
    return true
end

function modifier_jons_sea_terror:IsPurgable()
    return true
end

function modifier_jons_sea_terror:OnCreated(params)
    if IsServer() then
        self.bonus = self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("damage_per_stg")
        self.hp = self:GetCaster():GetStrength() * 20
    end
end

function modifier_jons_sea_terror:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
    }

    return funcs
end

function modifier_jons_sea_terror:GetModifierBaseAttack_BonusDamage( params )
    return self.bonus
end

function modifier_jons_sea_terror:GetModifierExtraHealthBonus( params )
    return self.hp
end

function modifier_jons_sea_terror:CheckState()
    local state = {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }

    return state
end

function jons_sea_terror:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

