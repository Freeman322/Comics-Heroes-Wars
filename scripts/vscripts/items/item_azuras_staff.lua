if item_azuras_staff == nil then item_azuras_staff = class({}) end
LinkLuaModifier( "modifier_item_azuras_staff", "items/item_azuras_staff.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_azuras_staff", "items/item_azuras_staff.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function item_azuras_staff:GetIntrinsicModifierName()
	return "modifier_item_azuras_staff"
end

function item_azuras_staff:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        local info = {
            EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf",
            Ability = self,
            iMoveSpeed = 2500,
            Source = self:GetCaster (),
            Target = self:GetCursorTarget (),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }

        ProjectileManager:CreateTrackingProjectile (info)
        EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster () )
    end
end

function item_azuras_staff:OnProjectileHit (hTarget, vLocation)
    if IsServer() then
	    local duration = self:GetSpecialValueFor ("silence_duration")
	    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_azuras_staff", { duration = duration } )
	    EmitSoundOn ("DOTA_Item.Bloodthorn.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)
	end
    return true
end

if modifier_azuras_staff == nil then modifier_azuras_staff = class({}) end

function modifier_azuras_staff:IsPurgable()
    return false
end


function modifier_azuras_staff:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end


function modifier_azuras_staff:StatusEffectPriority()
    return 1
end


function modifier_azuras_staff:GetEffectName()
    return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
end


function modifier_azuras_staff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_azuras_staff:OnCreated( kv )
    self.bonus_damage = 0
end

function modifier_azuras_staff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE

    }

    return funcs
end

function modifier_azuras_staff:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    }

    return state
end

function modifier_azuras_staff:GetModifierIncomingDamage_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("silence_damage_percent")
end

function modifier_azuras_staff:OnTakeDamage( params )
	if self:GetParent() == params.unit then
		self.bonus_damage = self.bonus_damage + params.damage
	end
	return 0
end

function modifier_azuras_staff:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("silence_slowing")
end

function modifier_azuras_staff:OnDestroy()
	if IsServer() then
		local hTarget = self:GetParent()
		EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)

        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetAbility():GetCaster())
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetAbility():GetCaster())

    	ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = hTarget, ability = self:GetAbility(), damage = self.bonus_damage*0.3, damage_type = DAMAGE_TYPE_MAGICAL})

		local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
		ParticleManager:SetParticleControl(pop_pfx, 0, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
		ParticleManager:ReleaseParticleIndex(pop_pfx)

    	self.bonus_damage = 0
	end
end

if modifier_item_azuras_staff == nil then
    modifier_item_azuras_staff = class ( {})
end

function modifier_item_azuras_staff:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_azuras_staff:IsPurgable()
    return false
end

function modifier_item_azuras_staff:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_azuras_staff:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_azuras_staff:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_azuras_staff:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_azuras_staff:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_azuras_staff:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end
function modifier_item_azuras_staff:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function modifier_item_azuras_staff:GetModifierConstantManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen" )
end
function modifier_item_azuras_staff:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_azuras_staff:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end

function modifier_item_azuras_staff:GetModifierPreAttack_CriticalStrike(params)
	if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
		return self:GetAbility():GetSpecialValueFor("crit_multiplier")
	end
	return
end

function item_azuras_staff:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

