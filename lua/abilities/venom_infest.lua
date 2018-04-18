venom_infest = class({})
LinkLuaModifier( "modifier_infest_hide", "abilities/venom_infest.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_infest_buff", "abilities/venom_infest.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function venom_infest:CastFilterResultTarget( hTarget )
   if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function venom_infest:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function venom_infest:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function venom_infest:IsStealable()
	return false
end
--------------------------------------------------------------------------------

function venom_infest:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_infest_buff", nil )
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_infest_hide", nil )

        EmitSoundOn( "Hero_LifeStealer.Infest", hTarget )
	end
end

if modifier_infest_hide == nil then modifier_infest_hide = class({}) end

--------------------------------------------------------------------------------

function modifier_infest_hide:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_infest_hide:RemoveOnDeath()
	return true
end

function modifier_infest_hide:OnCreated(table)
	if IsServer() then
        self.scale = self:GetParent():GetModelScale()
        self:GetParent():SetModelScale(0.004)
        self.target = self:GetAbility():GetCursorTarget()
        self:StartIntervalThink(0.03)

        self:GetAbility():SetActivated(false)
    end
end

function modifier_infest_hide:OnDestroy()
	if IsServer() then
        self:GetParent():SetModelScale(self.scale)
        self:GetAbility():SetActivated(true)
        self.target = nil
    end
end

function modifier_infest_hide:OnIntervalThink()
	if IsServer() then
        if self.target:IsAlive() == false then
            self:Destroy()
        end
        for i = 0, 5, 1 do
      		local current_item = self:GetCaster():GetItemInSlot(i)
      		if current_item ~= nil then
      			if current_item:GetName() == "item_heart" or current_item:GetName() == "item_heart_2" or current_item:GetName() == "item_boots_of_protection" then  --Refresher Orb does not refresh itself.
      				current_item:StartCooldown(5)
      			end
      		end
      	end
       self:GetParent():SetAbsOrigin(self.target:GetAbsOrigin())
    end
end

--------------------------------------------------------------------------------

function modifier_infest_hide:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_DISARMED]	= true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
    [MODIFIER_STATE_UNSELECTABLE]	= true,
    [MODIFIER_STATE_OUT_OF_GAME]	= true,
    [MODIFIER_STATE_NO_HEALTH_BAR]	= true,
    [MODIFIER_STATE_INVULNERABLE]	= true
	}

	return state
end

if modifier_infest_buff == nil then modifier_infest_buff = class({}) end

function modifier_infest_buff:IsPurgable(  )
    return false
end

function modifier_infest_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_infest_buff:StatusEffectPriority()
	return 1000
end

function modifier_infest_buff:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

function modifier_infest_buff:HeroEffectPriority()
	return 100
end

function modifier_infest_buff:IsHidden()
    return false
end

function modifier_infest_buff:OnCreated(params)
    if IsServer() then
        self.agi = self:GetCaster():GetAgility()*(self:GetAbility():GetSpecialValueFor("stats")/100)
        self.str = self:GetCaster():GetStrength()*(self:GetAbility():GetSpecialValueFor("stats")/100)
        self.int = self:GetCaster():GetIntellect()*(self:GetAbility():GetSpecialValueFor("stats")/100)

        self:StartIntervalThink(0.05)
        self:GetParent():CalculateStatBonus()
        self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
        self:GetParent():SetMana(self:GetParent():GetMaxMana())

        self.regen = 0
        self.regen_mana = 0
        --[[if self:GetCaster():HasScepter() then
            self.regen = self:GetCaster():GetHealthRegen()*2
            self.regen_mana = self:GetCaster():GetManaRegen()*2
        end]]--
    end
end

function modifier_infest_buff:OnDestroy()
    if IsServer() then
       self:GetParent():CalculateStatBonus()
    end
end

function modifier_infest_buff:OnIntervalThink()
    if IsServer() then
       if self:GetCaster():HasModifier("modifier_infest_hide") == false then
            self:Destroy()
       end
       --[[if self:GetCaster():HasScepter() then
           self.regen = self:GetCaster():GetHealthRegen()*2
           self.regen_mana = self:GetCaster():GetManaRegen()*2
       end]]--
    end
end

function modifier_infest_buff:RemoveOnDeath()
    return true
end

function modifier_infest_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_infest_buff:GetModifierConstantHealthRegen( params )
    return self.regen
end

function modifier_infest_buff:GetModifierConstantManaRegen(args)
    return self.regen_mana
end

function modifier_infest_buff:GetModifierBonusStats_Agility( params )
    return self.agi
end

function modifier_infest_buff:GetModifierBonusStats_Strength( params )
    return self.str
end

function modifier_infest_buff:GetModifierBonusStats_Intellect( params )
    return self.int
end

function venom_infest:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
