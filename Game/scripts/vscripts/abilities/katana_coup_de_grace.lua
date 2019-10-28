LinkLuaModifier( "modifier_katana_coup_de_grace", "abilities/katana_coup_de_grace.lua", LUA_MODIFIER_MOTION_NONE )

katana_coup_de_grace = class({})

local KILL_DAMAGE = 9999999

function katana_coup_de_grace:GetIntrinsicModifierName()
    return "modifier_katana_coup_de_grace"
end

modifier_katana_coup_de_grace = class({})
function modifier_katana_coup_de_grace:IsHidden()	return true end
function modifier_katana_coup_de_grace:IsPurgable()	return false end
function modifier_katana_coup_de_grace:RemoveOnDeath()	return false end
function modifier_katana_coup_de_grace:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_HERO_KILLED
    }
end

function modifier_katana_coup_de_grace:GetModifierPreAttack_CriticalStrike(params)
    if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
        if IsServer() then
            local target = params.target
            local damage = self:GetAbility():GetSpecialValueFor("crit_bonus")

            if self:GetCaster():HasTalent("special_bonus_unique_katana") then
                damage = self:GetAbility():GetSpecialValueFor("crit_bonus") + self:GetCaster():FindTalentValue("special_bonus_unique_katana")
            end

            if RollPercentage(self:GetAbility():GetSpecialValueFor("scepter_kill_chance_pct")) then
                EmitSoundOn("Hero_Clinkz.DeathPact", target)

                local particleName = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"
                local particle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, target)

                ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

                -- Show the particle target-> caster
                local particleName = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"
                local particle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, self:GetParent())

                ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

                return KILL_DAMAGE
            end

            local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf" , PATTACH_ABSORIGIN_FOLLOW, target )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

            EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)

            ScreenShake(target:GetOrigin(), 100, 0.1, 0.3, 500, 0, true)

            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "goku") == true then 
                local nFXIndex = ParticleManager:CreateParticle("particles/goku_skin/goku_explode.vpcf" , PATTACH_ABSORIGIN_FOLLOW, target )
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
                ParticleManager:ReleaseParticleIndex( nFXIndex )

                local nFXIndex = ParticleManager:CreateParticle( "particles/galactus/galactus_seed_of_ambition_eternal_item.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
                ParticleManager:SetParticleControl(nFXIndex, 0, target:GetAbsOrigin())
                ParticleManager:SetParticleControl(nFXIndex, 2, target:GetAbsOrigin())
                ParticleManager:SetParticleControl(nFXIndex, 3, target:GetAbsOrigin())
                ParticleManager:SetParticleControl(nFXIndex, 6, target:GetAbsOrigin())
                ParticleManager:SetParticleControl (nFXIndex, 1, Vector (750, 750, 0))
                ParticleManager:ReleaseParticleIndex( nFXIndex )

                EmitSoundOn( "Hero_EarthShaker.EchoSlam", target )
                EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", target )
                EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", target )
            end 

            return damage
        end
    end
end

function modifier_katana_coup_de_grace:OnHeroKilled(params)
    if params.target:GetTeam() ~= self:GetParent():GetTeam() then
        if params.attacker == self:GetParent() then
            self:IncrementStackCount()
        end
    end
end

function modifier_katana_coup_de_grace:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_katana_coup_de_grace:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function katana_coup_de_grace:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_goku") then
        return "custom/goku_skin_ultimate_spell"
    end

    return self.BaseClass.GetAbilityTextureName(self)
end
