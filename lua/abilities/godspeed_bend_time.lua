if not godspeed_bend_time then godspeed_bend_time = class({}) end
LinkLuaModifier ("modifier_godspeed_bend_time", "abilities/godspeed_bend_time.lua", LUA_MODIFIER_MOTION_NONE)


function godspeed_bend_time:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        local info = {
    			EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
    			Ability = self,
    			iMoveSpeed = 1200,
    			Source = self:GetCaster(),
    			Target = self:GetCursorTarget(),
    			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
	    ProjectileManager:CreateTrackingProjectile( info )
	   
		EmitSoundOn("Hero_PhantomLancer.SpiritLance.Throw", self:GetCaster())
    end
end

function godspeed_bend_time:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn("Hero_PhantomLancer.SpiritLance.Impact", self:GetCaster())

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


function modifier_godspeed_bend_time:GetEffectName()
	return "particles/godspeed/godspeed_bend_time.vpcf"
end


function modifier_godspeed_bend_time:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_godspeed_bend_time:OnCreated( kv )
	if IsServer() then
		self._tAbilities = {}

		for i = 0, 5 do
			table.insert( self._tAbilities,  self:GetParent():GetAbilityByIndex(i))
		end

		for k, ability in pairs(self._tAbilities) do
			ability:SetFrozenCooldown(true)
		end

		self._iPtc = self:GetAbility():GetSpecialValueFor("damage")
		if self:GetParent():HasTalent("special_bonus_godspeed_1") then self._iPtc = self._iPtc + self:GetParent():FindTalentValue("special_bonus_godspeed_1") end 

		self._vPosition = self:GetParent():GetAbsOrigin()
    end
end

function modifier_godspeed_bend_time:OnDestroy()
	if IsServer() then
		for k, ability in pairs(self._tAbilities) do
			ability:SetFrozenCooldown(false)
		end
	end
end

function modifier_godspeed_bend_time:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED
    }

    return funcs
end

function modifier_godspeed_bend_time:OnUnitMoved(params)
	if IsServer() then 
		if params.unit == self:GetParent() then 
			if self._vPosition ~= self:GetParent():GetAbsOrigin() then 
				local distance = (self:GetParent():GetAbsOrigin() - self._vPosition):Length2D()

				self._vPosition = self:GetParent():GetAbsOrigin()

				self:OnPositionChanged(distance)
			end 			
		end
	end 
end

function modifier_godspeed_bend_time:OnPositionChanged( distance )
	if IsServer() then 
		local damage_table = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = distance,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
			ability = self:GetAbility()
		}

		ApplyDamage( damage_table )
	end
end
