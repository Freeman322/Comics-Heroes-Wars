LinkLuaModifier( "modifier_arc_shard", "items/item_absolute_staff.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_shard_overfloat", "items/item_absolute_staff.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_absolute_staff_freeze", "items/item_absolute_staff.lua", LUA_MODIFIER_MOTION_NONE )

if item_absolute_staff == nil then
    item_absolute_staff = class({})
end

function item_absolute_staff:GetIntrinsicModifierName(  )
  return "modifier_arc_shard"
end

function item_absolute_staff:OnSpellStart(  )
    if IsServer() then
        local hero = self:GetCaster()

        local overfloat_duration = self:GetSpecialValueFor( "overfloat_duration" )
        EmitSoundOn( "Hero_ArcWarden.TempestDouble.FP", hero )
        hero:AddNewModifier( hero, self, "modifier_arc_shard_overfloat", {duration = overfloat_duration} )
        -- Add a modifier to this unit.
        local nFXIndex = ParticleManager:CreateParticle ("particles/items3_fx/iron_talon_active.vpcf", PATTACH_CUSTOMORIGIN, nil);
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "attach_attack1", hero:GetOrigin (), true);
        ParticleManager:SetParticleControl(nFXIndex, 1, hero:GetOrigin ());
        ParticleManager:SetParticleControl(nFXIndex, 3, hero:GetOrigin ());
        ParticleManager:SetParticleControl(nFXIndex, 4, hero:GetOrigin ());
        ParticleManager:ReleaseParticleIndex (nFXIndex);
    end
end

if modifier_arc_shard_overfloat == nil then
    modifier_arc_shard_overfloat = class({})
end

function modifier_arc_shard_overfloat:IsPurgable(  )
    return  false
end

function modifier_arc_shard_overfloat:OnCreated( table )
    if IsServer() then
        local hero = self:GetParent()
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_arc_shard_overfloat:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end
function modifier_arc_shard_overfloat:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end

function modifier_arc_shard_overfloat:StatusEffectPriority()
	return 1000
end

function modifier_arc_shard_overfloat:GetModifierEvasion_Constant( params )
	return self:GetAbility(  ):GetSpecialValueFor( "overfloat_evasion" )
end

--------------------------------------------------------------------------------

function modifier_arc_shard_overfloat:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility(  ):GetSpecialValueFor( "overfloat_speed" )
end

if modifier_arc_shard == nil then
    modifier_arc_shard = class({})
end

function modifier_arc_shard:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_arc_shard:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end
function modifier_arc_shard:OnAttackLanded(params)
    if self:GetParent() == params.attacker then
        if not self:GetParent():IsRangedAttacker() then
            if RollPercentage(self:GetAbility():GetSpecialValueFor("time_lock_chance")) then
                params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_absolute_staff_freeze", {duration = self:GetAbility():GetSpecialValueFor("time_lock_duration")})
            end
        end
    end

    return
end

function modifier_arc_shard:GetModifierEvasion_Constant( params )
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_evasion")
end

function modifier_arc_shard:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_arc_shard:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_arc_shard:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_arc_shard:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_arc_shard:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_speed")
end

if modifier_absolute_staff_freeze == nil then modifier_absolute_staff_freeze = class({}) end

function modifier_absolute_staff_freeze:IsPurgable(  )
    return true
end

function modifier_absolute_staff_freeze:IsHidden()
    return true
end

function modifier_absolute_staff_freeze:OnCreated( table )
    if IsServer() then
        local hero = self:GetParent()
        EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", hero)
    end
end

function modifier_absolute_staff_freeze:GetStatusEffectName()
    return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end

function modifier_absolute_staff_freeze:StatusEffectPriority()
    return 1000
end

function modifier_absolute_staff_freeze:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_absolute_staff_freeze:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_absolute_staff_freeze:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_FROZEN] = true,
    }

    return state
end

function item_absolute_staff:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

