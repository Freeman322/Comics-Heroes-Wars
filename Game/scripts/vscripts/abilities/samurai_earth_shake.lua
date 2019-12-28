samurai_earth_shake = class({})
LinkLuaModifier( "modifier_samurai_earth_shake", "abilities/samurai_earth_shake.lua", LUA_MODIFIER_MOTION_NONE )

function samurai_earth_shake:IsStealable(  )
    return false
end

function samurai_earth_shake:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_legacy_of_blast_gold") then return "custom/legacy_of_blast_gold" end
    return self.BaseClass.GetAbilityTextureName(self) 
end
  
function samurai_earth_shake:OnSpellStart(  )
    if IsServer() then
        local caster = self:GetCaster()
        local absorigin = caster:GetAbsOrigin()
        local target_origin = caster:GetCursorPosition()

        local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
        vDirection = vDirection:Normalized()
        local fDistance = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Length2D()


        local prj = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf"

        if self:GetCaster():HasModifier("modifier_legacy_of_blast_gold") then
            prj = "particles/hero_khan/khan_echo_strike_projectile.vpcf"

            EmitSoundOn ("Hero_Necrolyte.ReapersScythe.Target", caster)
            EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast", target)
        else 
            EmitSoundOn ("Hero_Axe.CounterHelix", caster)
            EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
        end

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "zoro") then
            EmitSoundOn( "Zoro.Cast1", self:GetCaster() )
        end

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "samurai_sword_od_darkness") == true then
            prj = "particles/units/heroes/hero_demonartist/demonartist_darkartistry_proj.vpcf"
        end

        local info = {
            EffectName = prj,
            Ability = self,
            vSpawnOrigin = self:GetCaster():GetOrigin(),
            fStartRadius = 300,
            fEndRadius = 300,
            vVelocity = vDirection * 1000,
            fDistance = fDistance,
            Source = self:GetCaster(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            bProvidesVision = true,
            iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
            iVisionRadius = 150,
        }
        local duration = (fDistance/1000)
        EmitSoundOn( "Hero_VengefulSpirit.WaveOfTerror" , self:GetCaster() )
        caster:AddNewModifier( caster, self, "modifier_samurai_earth_shake", {duration = duration} )
        self.nProjID = ProjectileManager:CreateLinearProjectile( info )
    end
end
function samurai_earth_shake:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
        self:GetCaster():PerformAttack (hTarget, false, false, true, true, false, false, true)
        self:GetCaster():PerformAttack (hTarget, false, false, true, true, false, false, true)
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
        }
        		
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor( "stun_duration" )} )
        
        ApplyDamage( damage )
	end

	return false
end

modifier_samurai_earth_shake = class({})
function modifier_samurai_earth_shake:IsHidden()
    return true
end

function modifier_samurai_earth_shake:OnCreated( kv )
    if IsServer() then
        self:GetParent():AddNoDraw()
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 5, Vector(200, 200, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        self.destroy_pos = self:GetAbility():GetCaster():GetCursorPosition()
    end
end
function modifier_samurai_earth_shake:OnDestroy(  )
     if IsServer() then
        self:GetParent():RemoveNoDraw()
        self:GetParent():SetAbsOrigin( self.destroy_pos )
        FindClearSpaceForUnit( self:GetParent(), self.destroy_pos, false )
        -- Place a unit somewhere not already occupied.
    end
end

function modifier_samurai_earth_shake:CheckState()
	local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end