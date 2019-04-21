batman_midas_lua = class({})
LinkLuaModifier( "modifier_batman_midas_lua", "abilities/batman_midas_lua.lua", LUA_MODIFIER_MOTION_NONE )

function batman_midas_lua:CastFilterResultTarget( hTarget )
    if IsServer() then

        if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
        return nResult
    end

    return UF_SUCCESS
end

function batman_midas_lua:GetCastRange( vLocation, hTarget )
    if self:GetCaster():HasScepter() then
        return 1200
    end

    return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function batman_midas_lua:GetCooldown( nLevel )
    if self:GetCaster():HasModifier("modifier_batman_midas_lua") then
        return 25
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function batman_midas_lua:GetAOERadius()
    return 350
end

function batman_midas_lua:GetManaCost( hTarget )
    return (self:GetCaster():GetMaxMana()*0.30)
end

function batman_midas_lua:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end
--------------------------------------------------------------------------------

function batman_midas_lua:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    local caster = self:GetCaster()
    local target = hTarget
    local ability = self
    local damage = self:GetSpecialValueFor( "damage" )
    local bourder = self:GetSpecialValueFor( "bourder" )
    local BonusGold = self:GetSpecialValueFor( "bonus_gold" )
    local XPMultiplier = self:GetSpecialValueFor( "xp_multiplier" )

    if not target:IsRealHero() then
        caster:ModifyGold(BonusGold, true, 0)  --Give the player a flat amount of reliable gold.
        caster:AddExperience(target:GetDeathXP() * XPMultiplier, false, false)  --Give the player some XP.

        --Start the particle and sound.
        target:EmitSound("DOTA_Item.Hand_Of_Midas")
        local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
        target:Kill(ability, caster) --Kill the creep.  This increments the caster's last hit counter.
    else
        if target:GetHealthPercent() <= bourder then
            target:Kill (ability, caster)
            target:EmitSound ("DOTA_Item.Hand_Of_Midas")
            local midas_particle = ParticleManager:CreateParticle ("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt (midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin (), false)
        else
            ApplyDamage ( { victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
            target:EmitSound ("DOTA_Item.Hand_Of_Midas")
            local midas_particle = ParticleManager:CreateParticle ("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt (midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin (), false)
        end
    end

    if self:GetCaster():HasModifier("modifier_batman_infinity_gauntlet") then
        local particle = ParticleManager:CreateParticle ("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt (particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin (), false)
        ParticleManager:ReleaseParticleIndex(particle)

        local particle = ParticleManager:CreateParticle ("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt (particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin (), false)
        ParticleManager:SetParticleControlEnt (particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin (), false)
        ParticleManager:ReleaseParticleIndex(particle)
    end

    local passives = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
    for i = 1, #passives do
        local targets = passives[i]
        if not targets:IsMagicImmune() then
            if not targets:IsRealHero() then
                caster:ModifyGold(BonusGold, true, 0)  --Give the player a flat amount of reliable gold.
                caster:AddExperience(targets:GetDeathXP() * XPMultiplier, false, false)  --Give the player some XP.

                --Start the particle and sound.
                targets:EmitSound("DOTA_Item.Hand_Of_Midas")
                local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, targets)
                ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
                targets:Kill(ability, caster) --Kill the creep.  This increments the caster's last hit counter.
            else
                if targets:GetHealthPercent() <= bourder then
                    targets:Kill (ability, caster)
                    targets:EmitSound ("DOTA_Item.Hand_Of_Midas")
                    local midas_particle = ParticleManager:CreateParticle ("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, targets)
                    ParticleManager:SetParticleControlEnt (midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin (), false)
                else
                    ApplyDamage ( { victim = targets, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
                    target:EmitSound ("DOTA_Item.Hand_Of_Midas")
                    local midas_particle = ParticleManager:CreateParticle ("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, targets)
                    ParticleManager:SetParticleControlEnt (midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin (), false)
                end
            end
            if self:GetCaster():HasModifier("modifier_batman_infinity_gauntlet") then
                local particle = ParticleManager:CreateParticle ("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, targets)
                ParticleManager:SetParticleControlEnt (particle, 0, targets, PATTACH_POINT_FOLLOW, "attach_hitloc", targets:GetAbsOrigin (), false)
                ParticleManager:SetParticleControlEnt (particle, 1, targets, PATTACH_POINT_FOLLOW, "attach_hitloc", targets:GetAbsOrigin (), false)
                ParticleManager:ReleaseParticleIndex(particle)

                local particle = ParticleManager:CreateParticle ("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, targets)
                ParticleManager:SetParticleControlEnt (particle, 0, targets, PATTACH_POINT_FOLLOW, "attach_hitloc", targets:GetAbsOrigin (), false)
                ParticleManager:SetParticleControlEnt (particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin (), false)
                ParticleManager:ReleaseParticleIndex(particle)
            end
        end
    end

    if self:GetCaster():HasModifier("modifier_batman_infinity_gauntlet") then
        EmitSoundOn("Batman.InfinityMidas.Cast", self:GetCaster())
    end

    if self:GetCaster():HasTalent("special_bonus_unique_batman") and self:GetCaster():HasModifier("modifier_batman_midas_lua") == false then 
        self:EndCooldown()
        self:StartCooldown(25)

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_batman_midas_lua", nil)
    end
end

function batman_midas_lua:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_batman_infinity_gauntlet") then
      return "custom/batman_midas_infinity"
    end
    return self.BaseClass.GetAbilityTextureName(self)
end

modifier_batman_midas_lua = class({})

function modifier_batman_midas_lua:IsHidden()
    return true
end

function modifier_batman_midas_lua:IsPurgable()
    return false
end

function modifier_batman_midas_lua:RemoveOnDeath()
    return false
end