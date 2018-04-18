if not godspeed_bend_time then godspeed_bend_time = class({}) end
function godspeed_bend_time:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
LinkLuaModifier ("modifier_godspeed_bend_time", "abilities/godspeed_bend_time.lua", LUA_MODIFIER_MOTION_NONE)


function godspeed_bend_time:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        local info = {
    			EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_base_attack.vpcf",
    			Ability = self,
    			iMoveSpeed = 1200,
    			Source = self:GetCaster(),
    			Target = self:GetCursorTarget(),
    			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    		}
	      ProjectileManager:CreateTrackingProjectile( info )
        EmitSoundOn("Hero_Oracle.FatesEdict", self:GetCaster())
    end
end

function godspeed_bend_time:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		ApplyDamage( damage )
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_godspeed_bend_time", {duration = self:GetSpecialValueFor("duration")})
	end

	return true
end

if not modifier_godspeed_bend_time then modifier_godspeed_bend_time = class({}) end

function modifier_godspeed_bend_time:IsPurgeException()
    return true
end

function modifier_godspeed_bend_time:GetStatusEffectName()
	return "particles/status_fx/status_effect_siren_song.vpcf"
end

function modifier_godspeed_bend_time:StatusEffectPriority()
	return 1000
end


function modifier_godspeed_bend_time:GetHeroEffectName()
	return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
end


function modifier_godspeed_bend_time:HeroEffectPriority()
	return 100
end


function modifier_godspeed_bend_time:OnCreated( kv )
    if IsServer() then
       EmitSoundOn("Hero_ArcWarden.Flux.Target", self:GetParent())
    end
end

function modifier_godspeed_bend_time:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_godspeed_bend_time:GetModifierMoveSpeed_Max()
	return 50
end

function modifier_godspeed_bend_time:GetModifierMoveSpeed_Limit()
	return 50
end

function modifier_godspeed_bend_time:GetModifierTurnRate_Percentage()
	return -500
end

function modifier_godspeed_bend_time:GetModifierMoveSpeedBonus_Constant()
	return 50
end

function modifier_godspeed_bend_time:GetModifierIncomingDamage_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("damage_incoming")
end

function modifier_godspeed_bend_time:IsHidden()
	return false
end

function modifier_godspeed_bend_time:OnDestroy()
    if IsServer() then
        EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse", self:GetParent())
        EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.Cast", self:GetParent())
    end
end

function modifier_godspeed_bend_time:OnTakeDamage( params )
   local parent = params.unit
   local attacker = params.attacker
   local damage = params.damage
   local damage_type = params.damage_type

   if parent == self:GetParent() then
   		self:Destroy()
   end
end
