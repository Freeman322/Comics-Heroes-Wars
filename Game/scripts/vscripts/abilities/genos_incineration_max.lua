-- 2 ульт (рука-ядро)

LinkLuaModifier("modifier_genos_incineration_max", "abilities/genos/genos_incineration_max.lua", LUA_MODIFIER_MOTION_NONE)

genos_incineration_max = class ({})


function genos_incineration_max:OnUpgrade()
    if self:GetCaster():HasAbility("genos_spiral_incineration") then
        self:GetCaster():RemoveAbility("genos_spiral_incineration")
    end
end

function genos_incineration_max:GetChannelTime()
	return self:GetSpecialValueFor("channel_time")
end

function genos_incineration_max:OnAbilityPhaseStart()
	if IsServer() then
		self.Target = self:GetCursorTarget()
	end
	return true
end

function genos_incineration_max:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_genos_incineration_max", { duration = self:GetChannelTime() } )
    end
end

function genos_incineration_max:OnChannelFinish( bInterrupted )
    if bInterrupted == false then
        local info = {
            EffectName = "particles/econ/items/sniper/sniper_charlie/sniper_assassinate_charlie.vpcf",
            Ability = self,
            iMoveSpeed = 2500,
            Source = self:GetCaster(),
            Target = self.Target,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }
        ProjectileManager:CreateTrackingProjectile(info)
        EmitSoundOn("Ability.Assassinate", self:GetCaster())
        EmitSoundOn("Hero_Sniper.AssassinateProjectile", self:GetCaster())

    else
        if self:GetCaster():HasModifier("modifier_genos_incineration_max") then
            self:GetCaster():RemoveModifierByName("modifier_genos_incineration_max")
        end
    end
end

function genos_incineration_max:OnProjectileHit(hTarget, vLocation)
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
    for _,target in pairs(enemies) do
      local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self:GetSpecialValueFor("damage"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
      }
      ApplyDamage(damage)
      unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") } )
    end
  end
  local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_cluckles/courier_cluckles_ambient_rocket_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(particle, 0, hTarget)
  ParticleManager:SetParticleControl(particle, 3, hTarget)
  ParticleManager:ReleaseParticleIndex(particle)
  EmitSoundOn("Hero_Techies.Suicide", hTarget)
end


modifier_genos_incineration_max = class ({})

function genos_incineration_max:IsPurgable()
	return false
end

function genos_incineration_max:IsHidden()
	return true
end
