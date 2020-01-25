katana_dagger = class({})
--------------------------------------------------------------------------------

function katana_dagger:OnSpellStart()
    if IsServer() then
        local target = self:GetCursorTarget()

		local particle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "goku") == true then 
			particle = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf"
		end 
		
        local info = {
            EffectName = particle,
            Ability = self,
            iMoveSpeed = self:GetSpecialValueFor( "missile_speed" ),
            Source = self:GetCaster(),
            Target = target,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "Hero_PhantomAssassin.Dagger.Cast", self:GetCaster() )

        if self:GetCaster():HasTalent("special_bonus_unique_katana_2") then
            local num = self:GetCaster():FindTalentValue("special_bonus_unique_katana_2")
            local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), target, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

            ---- Если юнитов в массиве больше 0
            if #units > 1 then
                for _,  unit in pairs(units) do
                    num = num - 1

                    self:CreateProjectile(unit)
                    if num <= 0 then break end
                end

                if num > 0 then
                    for i = 1, num do
                        self:CreateProjectile(target)
                    end
                end
            end
        end
    end
end

function katana_dagger:CreateProjectile(target)
    ProjectileManager:CreateTrackingProjectile( {
        EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
        Ability = self,
        iMoveSpeed = self:GetSpecialValueFor( "missile_speed" ),
        Source = self:GetCaster(),
        Target = target,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    })
end

--------------------------------------------------------------------------------

function katana_dagger:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) )  then
        EmitSoundOn( "Hero_PhantomAssassin.Dagger.Target", hTarget )
        local magic_missile_damage = self:GetSpecialValueFor( "dagger_damage" )

        self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)

        local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = magic_missile_damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self
        }

        ApplyDamage( damage )

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("dagger_stun") } )

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "goku") then
			local nFXIndex = ParticleManager:CreateParticle( "particles/hero_predator/predator_plasma_shot_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 3, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse.TI8", self:GetCaster() )
		end
    end
end

function katana_dagger:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_goku") then
        return "custom/goku_skin_first_spell"
	end
	
    return self.BaseClass.GetAbilityTextureName(self)
end
  
  