cap_sheild_blast = class({})
--------------------------------------------------------------------------------
function cap_sheild_blast:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 45
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function cap_sheild_blast:OnSpellStart()
    local pfx = "particles/cap_magic_missle.vpcf"

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then
        pfx = "particles/alisa/alisa_punch.vpcf"
    end 

    local info = {
        EffectName = pfx,
        Ability = self,
        iMoveSpeed = 800,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    }

    ProjectileManager:CreateTrackingProjectile( info )
    EmitSoundOn( "Hero_WitchDoctor.Paralyzing_Cask_Cast", self:GetCaster() )
    local hero = self:GetCaster()
    local ability = self
    hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" and string.find(model:GetModelName(), "shield") ~= nil then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

--------------------------------------------------------------------------------

function cap_sheild_blast:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:IsMagicImmune() ) then

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then
            EmitSoundOn( "Alisa.Ult.Impact", hTarget )
        else 
            EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )
            EmitSoundOn( "Hero_WitchDoctor.Paralyzing_Cask_Bounce", hTarget )
        end 

        local stun_duration = self:GetSpecialValueFor( "hero_duration" )
        local damage = self:GetSpecialValueFor( "hero_damage" )
        local bonus = 0
        
        if self:GetCaster():HasScepter() then bonus = self:GetSpecialValueFor("bonus_damage_scepter") end
        
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )
        
        local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = damage + bonus,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }

        ApplyDamage( damage )
        
        local caster = self:GetCaster()
        local target = hTarget
        local ability = self
        local bounce_range = ability:GetSpecialValueFor("bounce_range")
        local bounce_delay = ability:GetSpecialValueFor("bounce_delay")
        local speed = ability:GetSpecialValueFor("speed")
        local hero_duration = ability:GetSpecialValueFor("hero_duration")
        local creep_duration = ability:GetSpecialValueFor("creep_duration")
        local hero_damage = ability:GetSpecialValueFor("hero_damage")
        local creep_damage = 400
        local passives = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for i = 1, #passives do
            local vic = passives[i]
            if #vic == 0 then
                for i,v in pairs(self:GetCaster().hiddenWearables) do
                    v:RemoveEffects(EF_NODRAW)
                end
            end
        end
        -- Determines the number of bounces the cask has left
        if ability.bounces_left == nil then
            ability.bounces_left = ability:GetLevelSpecialValueFor("bounces", (ability:GetLevel() -1))
        else
            ability.bounces_left = ability.bounces_left - 1
        end

        -- Apply the stun to the current target
        if target:IsHero() then
            target:AddNewModifier(target, ability, "modifier_stunned", {duration = hero_duration})

            ApplyDamage({victim = target, attacker = caster, damage = hero_damage, damage_type = ability:GetAbilityDamageType()})
        else
            target:AddNewModifier(target, ability, "modifier_stunned", {duration = creep_duration})

            ApplyDamage({victim = target, attacker = caster, damage = creep_damage, damage_type = ability:GetAbilityDamageType()})
        end

        if not target:IsNull() and target then
        -- If the cask has bounces left, it finds a new target to bounce to
            if ability.bounces_left > 0 then
                -- We wait on the delay
                Timers:CreateTimer(bounce_delay,
                    function()
                        -- Finds all units in the area
                        local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounce_range, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), 0, 0, false)
                        -- Go through the target_enties table, checking for the first one that isn't the same as the target
                        local target_to_jump = nil
                        for _,unit in pairs(units) do
                            if unit ~= target and not target_to_jump then
                                target_to_jump = unit
                            end
                        end
                        -- If there is a new target to bounce to, we create the a projectile
                        if target_to_jump then
                            -- Create the next projectile
                            local pfx = "particles/cap_magic_missle.vpcf"

                            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then
                                pfx = "particles/alisa/alisa_punch.vpcf"
                            end 

                            local info = {
                                Target = target_to_jump,
                                Source = target,
                                Ability = ability,
                                EffectName = pfx,
                                bDodgeable = true,
                                bProvidesVision = false,
                                iMoveSpeed = speed,
                                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
                            }
                            ProjectileManager:CreateTrackingProjectile( info )
                        else
                            ability.bounces_left = nil
                        end
                    end)
            else
                ability.bounces_left = nil
            end
        end
    end
    return true
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function cap_sheild_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

