LinkLuaModifier ("modifier_ostarion_reincarnation", 				"abilities/ostarion_reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ostarion_reincarnation_passive", "abilities/ostarion_reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ostarion_reincarnation_aura", 				"abilities/ostarion_reincarnation.lua", LUA_MODIFIER_MOTION_NONE)

if ostarion_reincarnation == nil then ostarion_reincarnation = class({}) end

function ostarion_reincarnation:GetIntrinsicModifierName()
	return "modifier_ostarion_reincarnation"
end

if modifier_ostarion_reincarnation == nil then modifier_ostarion_reincarnation = class({}) end

function modifier_ostarion_reincarnation:IsAura()
	return true
end

function modifier_ostarion_reincarnation:IsHidden()
	return true
end

function modifier_ostarion_reincarnation:IsPurgable()
	return false
end

function modifier_ostarion_reincarnation:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_ostarion_reincarnation:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_ostarion_reincarnation:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_ostarion_reincarnation:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_ostarion_reincarnation:GetModifierAura()
	return "modifier_ostarion_reincarnation_aura"
end

if not modifier_ostarion_reincarnation_aura then modifier_ostarion_reincarnation_aura = class({}) end 

function modifier_ostarion_reincarnation_aura:IsHidden()
	return true
end

function modifier_ostarion_reincarnation_aura:IsPurgable()
	return false
end

function modifier_ostarion_reincarnation_aura:RemoveOnDeath()
	return false
end

function modifier_ostarion_reincarnation_aura:OnCreated(params)
    if IsServer() then
        if self:GetParent():IsDominated() or self:GetParent():IsHero() or self:GetParent():IsAncient() or self:GetParent():IsBuilding() then self:Destroy() end 
    end
end

function modifier_ostarion_reincarnation_aura:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_ostarion_reincarnation_aura:OnDeath( params )
    if IsServer() then 
        if params.unit == self:GetParent() then
            if not self:GetParent():IsDominated() and not self:GetParent():IsHero() and not self:GetParent():IsAncient() and not self:GetParent():IsBuilding() then
                local unit = CreateUnitByName("npc_night_king_zombie", self:GetParent():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetPlayerOwner(), self:GetCaster():GetTeamNumber())

                unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ostarion_reincarnation_passive", {duration = self:GetAbility():GetSpecialValueFor("creep_duration")})
            else
                self:Destroy() 
            end 
        end
    end 
end

if modifier_ostarion_reincarnation_passive == nil then modifier_ostarion_reincarnation_passive = class({}) end

function modifier_ostarion_reincarnation_passive:IsPurgable()
    return false
end

function modifier_ostarion_reincarnation_passive:RemoveOnDeath()
	return false
end

function modifier_ostarion_reincarnation_passive:OnCreated(params)
    if IsServer() then
        self:GetParent():SetTeam(self:GetCaster():GetTeamNumber())
        self:GetParent():SetOwner(self:GetCaster())
        self:GetParent():Heal(self:GetParent():GetMaxHealth(), self:GetAbility())
        self:GetParent():SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), false)

        self:GetParent():Hold()
        self:GetParent():Interrupt()
        self:GetParent():Stop()

        self:GetParent():SetDeathXP (0)
        self:GetParent():SetMinimumGoldBounty (1)
        self:GetParent():SetMaximumGoldBounty (10)

        local target = self:GetParent():GetTarget()

        if target then self:GetParent():MoveToTargetToAttack(target) end 
    end 
end

function modifier_ostarion_reincarnation_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_LIFETIME_FRACTION 
    }

    return funcs
end

function modifier_ostarion_reincarnation_passive:IsHidden()
	return true
end

function modifier_ostarion_reincarnation_passive:IsPurgable()
	return false
end

function modifier_ostarion_reincarnation_passive:OnDestroy()
    if IsServer() then 
        self:GetParent():ForceKill(false)
    end 
end

function modifier_ostarion_reincarnation_passive:GetModifierExtraHealthBonus( params )
    return self:GetAbility():GetSpecialValueFor("creep_bonus_health")
end

function modifier_ostarion_reincarnation_passive:GetModifierBaseAttack_BonusDamage( params )
    return self:GetAbility():GetSpecialValueFor("creep_bonus_damage")
end

function modifier_ostarion_reincarnation_passive:GetUnitLifetimeFraction( params )
    return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

function modifier_ostarion_reincarnation_passive:CheckState()
	local state = {
		[MODIFIER_STATE_DOMINATED] = true
	}

	return state
end