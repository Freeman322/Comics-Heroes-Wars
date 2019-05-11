cap_dragon_tail = class ( {})

function cap_dragon_tail:OnSpellStart()
    if IsServer() then 
        local info = {
            EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
            Ability = self,
            iMoveSpeed = 1600,
            Source = self:GetCaster (),
            Target = self:GetCursorTarget (),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }

        ProjectileManager:CreateTrackingProjectile (info)
        EmitSoundOn ("Hero_DragonKnight.DragonTail.Target", self:GetCaster () )
    end
end

function cap_dragon_tail:OnProjectileHit (hTarget, vLocation)
    if hTarget ~= nil and ( not hTarget:IsInvulnerable () ) and ( not hTarget:TriggerSpellAbsorb (self) ) and ( not hTarget:IsMagicImmune () ) then
        local nFXIndex = ParticleManager:CreateParticleForTeam ("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_death_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetCaster (), self:GetCaster ():GetTeamNumber () )
        ParticleManager:SetParticleControl (nFXIndex, 0, hTarget:GetOrigin () )
        ParticleManager:SetParticleControl (nFXIndex, 1, hTarget:GetOrigin () )
        ParticleManager:SetParticleControl (nFXIndex, 2, hTarget:GetOrigin () )
        ParticleManager:SetParticleControl (nFXIndex, 3, hTarget:GetOrigin () )
        ParticleManager:SetParticleControl (nFXIndex, 11, hTarget:GetOrigin () )
        ParticleManager:SetParticleControl (nFXIndex, 12, hTarget:GetOrigin () )
        ParticleManager:ReleaseParticleIndex (nFXIndex)

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then
            EmitSoundOn( "Alisa.First.Impact", hTarget )
        else 
            EmitSoundOn ("Hero_DragonKnight.DragonTail.Target", hTarget)
        end 

        hTarget:AddNewModifier (self:GetCaster (), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") } )

        local damage = {
            victim = hTarget,
            attacker = self:GetCaster (),
            damage = self:GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }

        ApplyDamage (damage)
    end

    return true
end
