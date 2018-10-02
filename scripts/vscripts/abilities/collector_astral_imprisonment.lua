collector_astral_imprisonment = class({})
LinkLuaModifier ("modifier_collector_astral_imprisonment", "abilities/collector_astral_imprisonment.lua" , LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function collector_astral_imprisonment:IsStealable()
    return false
  end
  

function collector_astral_imprisonment:OnSpellStart()
    if IsServer() then 
        local info = {
                EffectName = "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_crimson_nasal_goo_proj.vpcf",
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

function collector_astral_imprisonment:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_ObsidianDestroyer.AstralImprisonment.Cast", hTarget )
        
        local duration = self:GetOrbSpecialValueFor( "prison_duration", "q" )

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_collector_astral_imprisonment", { duration = duration } )
	end

	return true
end

modifier_collector_astral_imprisonment = class({})

function modifier_collector_astral_imprisonment:IsHidden()
	return true
end

function modifier_collector_astral_imprisonment:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_collector_astral_imprisonment:StatusEffectPriority()
	return 900
end

function modifier_collector_astral_imprisonment:GetHeroEffectName()
	return "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger_hero_effect.vpcf"
end

function modifier_collector_astral_imprisonment:GetEffectName()
	return "particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn_debuff.vpcf"
end

function modifier_collector_astral_imprisonment:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_collector_astral_imprisonment:IsPurgable()
	return false
end

function modifier_collector_astral_imprisonment:OnCreated( kv )
    if IsServer() then 
        self.damage = self:GetAbility():GetSpecialValueFor("damage")
	end
end

function modifier_collector_astral_imprisonment:OnDestroy( kv )
	if IsServer() then
		local damageTable = {
            attacker = self:GetCaster(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            damage =  self.damage,
            victim = self:GetParent()
        }

        ApplyDamage(damageTable)

        iNtdx = ParticleManager:CreateParticle( "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
        ParticleManager:ReleaseParticleIndex( iNtdx )

        EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.End", self:GetParent())
	end
end


function modifier_collector_astral_imprisonment:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_collector_astral_imprisonment:GetFixedNightVision( params )
    return 0
end

function modifier_collector_astral_imprisonment:GetModifierMoveSpeedBonus_Percentage( params )
    return -1000
end

function modifier_collector_astral_imprisonment:GetFixedDayVision( params )
    return 0
end

function modifier_collector_astral_imprisonment:IsDebuff()
    return true
end

function modifier_collector_astral_imprisonment:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
        [MODIFIER_STATE_STUNNED] = true
	}

	return state
end