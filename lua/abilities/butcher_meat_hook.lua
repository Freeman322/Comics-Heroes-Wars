butcher_meat_hook = class({})
LinkLuaModifier( "modifier_butcher_meat_hook", "abilities/butcher_meat_hook.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_butcher_meat_hook_followthrough", "abilities/butcher_meat_hook.lua", LUA_MODIFIER_MOTION_NONE )

function butcher_meat_hook:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	return true
end

function butcher_meat_hook:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
end

--------------------------------------------------------------------------------

function butcher_meat_hook:OnSpellStart()
	self.bChainAttached = false
	self.hook_damage = self:GetSpecialValueFor( "damage" )  
	self.hook_speed = self:GetSpecialValueFor( "hook_speed" )
	self.hook_width = self:GetSpecialValueFor( "hook_width" )
	self.hook_distance = self:GetSpecialValueFor( "hook_distance" )

	self.vision_radius = self:GetSpecialValueFor( "vision_radius" )  
	self.vision_duration = self:GetSpecialValueFor( "vision_duration" )  
	self.hook_followthrough_constant = 0.65
	
	if self:GetCaster() and self:GetCaster():IsHero() then
		local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if hHook ~= nil then
			hHook:AddEffects( EF_NODRAW )
		end
	end

	self.vStartPosition = self:GetCaster():GetOrigin()
	self.vProjectileLocation = vStartPosition

	local vDirection = self:GetCursorPosition() - self.vStartPosition
	vDirection.z = 0.0

	local vDirection = ( vDirection:Normalized() ) * self.hook_distance
	self.vTargetPosition = self.vStartPosition + vDirection

	local flFollowthroughDuration = ( self.hook_distance / self.hook_speed * self.hook_followthrough_constant )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_butcher_meat_hook_followthrough", { duration = flFollowthroughDuration } )

	self.vHookOffset = Vector( 0, 0, 96 )
	local vHookTarget = self.vTargetPosition + self.vHookOffset
	local vKillswitch = Vector( ( ( self.hook_distance / self.hook_speed ) * 2 ), 0, 0 )

	self.nChainParticleFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleAlwaysSimulate( self.nChainParticleFXIndex )
	ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 1, vHookTarget )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 2, Vector( self.hook_speed, self.hook_distance, self.hook_width ) )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, vKillswitch )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 1, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetOrigin(), true )

	EmitSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster() )

	local info = {
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		vVelocity = vDirection:Normalized() * self.hook_speed,
		fDistance = self.hook_distance,
		fStartRadius = self.hook_width ,
		fEndRadius = self.hook_width ,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
	}

	ProjectileManager:CreateLinearProjectile( info )

	self.bRetracting = false
	self.hVictim = nil
	self.bDiedInHook = false

	if self:GetCaster():HasTalent("special_bonus_unique_pudge_2") then 
		self:EndCooldown()
		self:StartCooldown(4)
	end
	if self:GetCaster():HasTalent("special_bonus_unique_pudge_1") then 
		self.hook_damage = self.hook_damage + self:GetCaster():FindTalentValue("special_bonus_unique_pudge_1")
	end
end

--------------------------------------------------------------------------------

function butcher_meat_hook:OnProjectileHit( hTarget, vLocation )
	if hTarget == self:GetCaster() then
		return false
	end
	if self.bRetracting == false then
		if hTarget ~= nil and ( not ( hTarget:IsCreep() or hTarget:IsConsideredHero() ) ) then
			return false
		end

		local bTargetPulled = false
		if hTarget ~= nil then
			if hTarget:IsInvulnerable() or hTarget:IsOutOfGame() or hTarget:IsCommandRestricted() then 
				return false
			end

			EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_butcher_meat_hook", nil )

			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				local damage = {
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = self.hook_damage,
						damage_type = DAMAGE_TYPE_PURE,		
						ability = this
					}

				ApplyDamage( damage )

				if not hTarget:IsAlive() then
					self.bDiedInHook = true
					ParticleManager:DestroyParticle(self.nChainParticleFXIndex, true)
				end

				if not hTarget:IsMagicImmune() then
					hTarget:Interrupt()
				end
		
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end

			

			AddFOWViewer( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self.vision_radius, self.vision_duration, false )
			self.hVictim = hTarget
			bTargetPulled = true
		end

		local vHookPos = self.vTargetPosition
		local flPad = self:GetCaster():GetPaddedCollisionRadius()
		if hTarget ~= nil then
			vHookPos = hTarget:GetOrigin()
			flPad = flPad + hTarget:GetPaddedCollisionRadius()
		end

		--Missing: Setting target facing angle
		local vVelocity = self.vStartPosition - vHookPos
		vVelocity.z = 0.0

		local flDistance = vVelocity:Length2D() - flPad
		vVelocity = vVelocity:Normalized() * self.hook_speed

		if hTarget then 
			local info = 
			{
				Target = self:GetCaster(),
				Source = hTarget,
				Ability = self,	
				iMoveSpeed = vVelocity,
				vSourceLoc= hTarget:GetAbsOrigin(),                -- Optional (HOW)
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = false,                                -- Optional
				bIsAttack = false,                                -- Optional
				bVisibleToEnemies = false,                         -- Optional
				bReplaceExisting = false,                         -- Optional
				bProvidesVision = true,                           -- Optional
				iVisionRadius = 400,                              -- Optional
				iVisionTeamNumber = self:GetCaster():GetTeamNumber()        -- Optional
			}
			ProjectileManager:CreateTrackingProjectile(info)
		else
			local info = {
				Ability = self,
				vSpawnOrigin = vHookPos,
				vVelocity = vVelocity,
				fDistance = flDistance,
				Source = self:GetCaster(),
			}

			ProjectileManager:CreateLinearProjectile( info )
		end
		--[[local info = {
			Ability = self,
			vSpawnOrigin = vHookPos,
			vVelocity = vVelocity,
			fDistance = flDistance,
			Source = self:GetCaster(),
		}

		ProjectileManager:CreateLinearProjectile( info )]]

		self.vProjectileLocation = vHookPos

		if hTarget ~= nil and ( not hTarget:IsInvisible() ) and bTargetPulled then
			ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin() + self.vHookOffset, true )
			ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 1, 0, 0 ) )
		else
			ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true);
		end

		EmitSoundOn( "Hero_Pudge.AttackHookRetract", hTarget )

		if self:GetCaster():IsAlive() then
			self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
			self:GetCaster():StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
		end

		self.bRetracting = true
	else
		if self:GetCaster() and self:GetCaster():IsHero() then
			local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
			if hHook ~= nil then
				hHook:RemoveEffects( EF_NODRAW )
			end
		end

		if self.hVictim ~= nil then
			local vFinalHookPos = vLocation
			self.hVictim:RemoveModifierByName( "modifier_butcher_meat_hook" )

			local vVictimPosCheck = self.hVictim:GetOrigin() - vFinalHookPos 
			local flPad = self:GetCaster():GetPaddedCollisionRadius() + self.hVictim:GetPaddedCollisionRadius()
			if vVictimPosCheck:Length2D() > flPad then
				FindClearSpaceForUnit( self.hVictim, self.vStartPosition, false )
			end
		end

		self.hVictim = nil
		ParticleManager:DestroyParticle( self.nChainParticleFXIndex, true )
		EmitSoundOn( "Hero_Pudge.AttackHookRetractStop", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function butcher_meat_hook:OnProjectileThink( vLocation )
	self.vProjectileLocation = vLocation
end

--------------------------------------------------------------------------------

function butcher_meat_hook:OnOwnerDied()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
	self:GetCaster():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
end

modifier_butcher_meat_hook = class({})
--------------------------------------------------------------------------------

function modifier_butcher_meat_hook:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_butcher_meat_hook:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_butcher_meat_hook:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_butcher_meat_hook:OnCreated( kv )
	if IsServer() then
        self.traveled_distance = 0

		self:StartIntervalThink(0.03)
		self.speed = self:GetAbility():GetSpecialValueFor("hook_speed")

		if not self:GetParent():IsAlive() then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_butcher_meat_hook:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_butcher_meat_hook:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_butcher_meat_hook:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end


function modifier_butcher_meat_hook:OnIntervalThink()
	if IsServer() then
        local target_point = self:GetCaster():GetAbsOrigin()
        local caster_location = self:GetParent():GetAbsOrigin()
        local distance = (target_point - caster_location):Length2D()
        local direction = (target_point - caster_location):Normalized()
        local duration = distance/self.speed

        self.curr = self.speed * 1/30 
        self.time_walk_direction = direction
        if distance > 128 then
      		self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + direction * self.curr)
      		self.traveled_distance = self.traveled_distance + self.curr
    	else
      		if self:GetAbility().nChainParticleFXIndex ~= nil then
      			 ParticleManager:DestroyParticle(self:GetAbility().nChainParticleFXIndex, true)
      		end
      		FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
    		self:Destroy()
    	end
	end
end


modifier_butcher_meat_hook_followthrough = class({})

--------------------------------------------------------------------------------

function modifier_butcher_meat_hook_followthrough:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function modifier_butcher_meat_hook_followthrough:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end