chaos_king_hellfire = class({})
LinkLuaModifier ("modifier_chaos_king_hellfire", "abilities/chaos_king_hellfire.lua" , LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function chaos_king_hellfire:IsStealable()
    return false
end

function chaos_king_hellfire:OnSpellStart()
    if IsServer() then 
        local info = {
                EffectName = "particles/stygian/celebrimbor_base_attack.vpcf",
                Ability = self,
                iMoveSpeed = 1800,
                Source = self:GetCaster(),
                Target = self:GetCursorTarget(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "Hero_ObsidianDestroyer.ArcaneOrb.Impact", self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function chaos_king_hellfire:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_ObsidianDestroyer.AstralImprisonment.Cast", hTarget )
        
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        local damageTable = {
            attacker = self:GetCaster(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
            damage =  self:GetAbilityDamage(),
            victim = hTarget
        }

        ApplyDamage(damageTable)

        local duration = self:GetSpecialValueFor( "blast_dot_duration" )
        local stun_duration = self:GetSpecialValueFor( "blast_stun_duration" )
        
        if self:GetCaster():HasTalent("special_bonus_unique_chaos_king_6") then stun_duration = stun_duration + self:GetCaster():FindTalentValue("special_bonus_unique_chaos_king_6") end 

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_chaos_king_hellfire", { duration = duration } )
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )
	end

	return true
end

modifier_chaos_king_hellfire = class({})

function modifier_chaos_king_hellfire:IsHidden()
	return true
end

function modifier_chaos_king_hellfire:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_chaos_king_hellfire:StatusEffectPriority()
	return 900
end

function modifier_chaos_king_hellfire:GetHeroEffectName()
	return "particles/econ/modifier_chaos_king_hellfire/juggernaut/jugg_arcana/juggernaut_arcana_trigger_hero_effect.vpcf"
end

function modifier_chaos_king_hellfire:GetEffectName()
	return "particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn_debuff.vpcf"
end

function modifier_chaos_king_hellfire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_chaos_king_hellfire:IsPurgable()
	return false
end

function modifier_chaos_king_hellfire:OnCreated( kv )
    if IsServer() then 
        self.damage = self:GetAbility():GetSpecialValueFor("blast_dot_damage")

        if self:GetCaster():HasTalent("special_bonus_unique_chaos_king_5") then self.damage = self.damage + self:GetCaster():FindTalentValue("special_bonus_unique_chaos_king_5") end 

        self:StartIntervalThink(1)
        self:OnIntervalThink()
	end
end

function modifier_chaos_king_hellfire:OnIntervalThink()
	if IsServer() then
		local damageTable = {
            attacker = self:GetCaster(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            damage =  self.damage,
            victim = self:GetParent()
        }

        ApplyDamage(damageTable)
	end
end


function modifier_chaos_king_hellfire:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_chaos_king_hellfire:GetFixedNightVision( params )
    return 0
end

function modifier_chaos_king_hellfire:GetModifierTotalDamageOutgoing_Percentage( params )
    return (-1) * self:GetAbility():GetSpecialValueFor("blast_outgoing_damage_reduction")
end

function modifier_chaos_king_hellfire:GetFixedDayVision( params )
    return 0
end

function modifier_chaos_king_hellfire:IsDebuff()
    return true
end

function modifier_chaos_king_hellfire:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}

	return state
end