if item_timepiece == nil then item_timepiece = class({}) end 

LinkLuaModifier( "modifier_item_timepiece", "items/item_timepiece.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_time_gem_active", "items/item_time.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_timepiece_stats", "items/item_timepiece.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function item_timepiece:GetIntrinsicModifierName()
	return "modifier_item_timepiece_stats"
end

function item_timepiece:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local duration = self:GetSpecialValueFor ("time_freeze_duration")
		    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_timepiece", { duration = duration } )
            self:GetCaster():AddNewModifier (self:GetCaster (), self, "item_time_gem_active", { duration = 10 } )

		    EmitSoundOn ("Hero_DarkWillow.Fear.Target", hTarget)
	    	EmitSoundOn ("Hero_DarkWillow.Fear.Location", hTarget)
            EmitSoundOn ("Hero_DarkWillow.Fear.Wisp", self:GetCaster () )

            local particle = ParticleManager:CreateParticle ("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf", PATTACH_POINT_FOLLOW, hTarget)	
            ParticleManager:ReleaseParticleIndex(particle)
        end
    end
end


if modifier_item_timepiece == nil then modifier_item_timepiece = class({}) end

function modifier_item_timepiece:IsPurgable()
    return false
end

function modifier_item_timepiece:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_item_timepiece:GetStatusEffectName()
    return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end

function modifier_item_timepiece:StatusEffectPriority()
    return 1
end

function modifier_item_timepiece:GetEffectName()
    return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
end

function modifier_item_timepiece:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_timepiece:OnCreated( kv )
	if IsServer() then 
	    self.bonus_damage = 0	
	    self.mana = self:GetParent():GetMana()
	    self.health = self:GetParent():GetHealth()

	    for i=0, 15, 1 do  
	        local current_ability = self:GetParent():GetAbilityByIndex(i)
	        if current_ability ~= nil then
	            current_ability:SetFrozenCooldown(true)
	        end
	    end

	    self:StartIntervalThink(0.03)
	end
end

function modifier_item_timepiece:OnIntervalThink()
    if IsServer() then 
    	if self.mana and self.health then 
    		self:GetParent():SetMana(self.mana)
    		self:GetParent():SetHealth(self.health)
    	end
    end 
end

function modifier_item_timepiece:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }
    return funcs
end

function modifier_item_timepiece:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true
    }

    return state
end

function modifier_item_timepiece:GetModifierIncomingDamage_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("silence_damage_percent")
end

function modifier_item_timepiece:GetDisableHealing(params)
    return 1
end

function modifier_item_timepiece:GetModifierMoveSpeed_Absolute(params)
    return 200
end

function modifier_item_timepiece:OnTakeDamage( params )
	if IsServer() then 
		if self:GetParent() == params.unit then
			self.bonus_damage = self.bonus_damage + params.damage
			self.health = self.health - params.damage
		end
	end
	return 0
end


function modifier_item_timepiece:OnManaGained( params )
	if IsServer() then 
		for i,v in ipairs(params) do
			print(i,v)
		end			
	end
	return 0
end


function modifier_item_timepiece:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("time_freeze_dmg")
end

function modifier_item_timepiece:OnDestroy()
	if IsServer() then
		local hTarget = self:GetParent()
		EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)

        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetAbility():GetCaster())
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetAbility():GetCaster())

    	ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = hTarget, ability = self:GetAbility(), damage = self.bonus_damage*0.3, damage_type = DAMAGE_TYPE_PURE})

		local pop_pfx = ParticleManager:CreateParticle("particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControl(pop_pfx, 0, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(pop_pfx, 1, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(pop_pfx, 9, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(pop_pfx, 4, hTarget:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pop_pfx)

		for i=0, 15, 1 do  
	        local current_ability = self:GetParent():GetAbilityByIndex(i)
	        if current_ability ~= nil then
	            current_ability:SetFrozenCooldown(false)
	        end
	    end

    	self.bonus_damage = 0
	end
end

function modifier_item_timepiece:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if modifier_item_timepiece_stats == nil then
    modifier_item_timepiece_stats = class ( {})
end

function modifier_item_timepiece_stats:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_timepiece_stats:IsPurgable()
    return false
end

function modifier_item_timepiece_stats:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_timepiece_stats:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_timepiece_stats:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_timepiece_stats:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_timepiece_stats:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen_pct" )
end
function modifier_item_timepiece_stats:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_timepiece_stats:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end


function modifier_item_timepiece_stats:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

