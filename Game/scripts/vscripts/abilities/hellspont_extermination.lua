LinkLuaModifier ("hellspont_extermination_thinker", "abilities/hellspont_extermination.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier ("hellspont_extermination_scepter", "abilities/hellspont_extermination.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
hellspont_extermination = class ( {})

function hellspont_extermination:GetAOERadius()
    return 450
end

function hellspont_extermination:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function hellspont_extermination:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_hellspont") then return "custom/helspont_hammer" end
  return self.BaseClass.GetAbilityTextureName(self)
end

function hellspont_extermination:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local thinker = CreateModifierThinker (caster, self, "hellspont_extermination_thinker", { duration = 1.7 }, point, team_id, false)
end

hellspont_extermination_thinker = class({})

function hellspont_extermination_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        self.target = self:GetAbility():GetCaster():GetCursorPosition()
        self.radius = ability:GetSpecialValueFor("radius")
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "hellspont_immortal_axe") then
             local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf", PATTACH_CUSTOMORIGIN, thinker, thinker:GetTeamNumber())
            ParticleManager:SetParticleControl( nFXIndex, 0, self.target)
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
            ParticleManager:SetParticleControl( nFXIndex, 3, self.target)
            self:AddParticle( nFXIndex, false, false, -1, false, true )
        else 
            local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/hellspont/hellspont_extermination_load.vpcf", PATTACH_CUSTOMORIGIN, thinker, thinker:GetTeamNumber())
            ParticleManager:SetParticleControl( nFXIndex, 0, self.target)
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
            ParticleManager:SetParticleControl( nFXIndex, 3, self.target)
            self:AddParticle( nFXIndex, false, false, -1, false, true )
        end
        EmitSoundOn("Hero_Invoker.SunStrike.Charge", thinker)
        AddFOWViewer( thinker:GetTeam(), self.target, 500, 3, false)
    end
end

function hellspont_extermination_thinker:OnDestroy(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "hellspont_immortal_axe") then
            local nFXIndex1 = ParticleManager:CreateParticle( "particles/hellspont/hellspont_extermination_hammer.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex1, 0, thinker:GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex1, 1, Vector(self.radius, 1, 1))
            ParticleManager:SetParticleControl( nFXIndex1, 2, Vector(self.radius, self.radius, 1))
            ParticleManager:SetParticleControl( nFXIndex1, 3, thinker:GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex1, 4, thinker:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex1 );
        else 
            local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex1, 0, thinker:GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex1, 1, Vector(self.radius, self.radius, 0))
            ParticleManager:SetParticleControl( nFXIndex1, 2, thinker:GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex1, 3, thinker:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex1 );
        end 

        self.damage = ability:GetSpecialValueFor("damage")
        self.damage_percent = ability:GetSpecialValueFor("damage_percent")/100
        self.radius = ability:GetSpecialValueFor("radius")

        EmitSoundOn("Hero_Invoker.SunStrike.Ignite", thinker)
        GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 500, false)

        local thinker =  self:GetParent()
        local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, target in ipairs(nearby_targets) do
            if target and not target:IsNull() then 
                local health = target:GetHealth()
                local damage = (target:GetMaxHealth()*self.damage_percent) + self.damage
               
                target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 3})

                if self:GetCaster():HasScepter() then
                    target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "hellspont_extermination_scepter", {duration = self:GetAbility():GetSpecialValueFor("debuff_dur_scepter")})
                    ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage_scepter"), damage_type = DAMAGE_TYPE_MAGICAL})
                end

                ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
            end
        end
    end
end


if hellspont_extermination_scepter == nil then hellspont_extermination_scepter = class({}) end

function hellspont_extermination_scepter:IsHidden()
    return false
end

function hellspont_extermination_scepter:IsBuff()
    return false
end

function hellspont_extermination_scepter:GetStatusEffectName()
    return "particles/status_fx/status_effect_necrolyte_spirit.vpcf"
end

function hellspont_extermination_scepter:StatusEffectPriority()
    return 1000
end

function hellspont_extermination_scepter:GetEffectName()
    return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf"
end

function hellspont_extermination_scepter:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function hellspont_extermination_scepter:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()

        local nFXIndex1 = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex1 )
    end
end

function hellspont_extermination_scepter:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent ()
        local hAbility = self:GetAbility ()
        local damage = (hAbility:GetSpecialValueFor("debuff_damage_scepter") / 100) * self:GetParent():GetMaxHealth()

        ApplyDamage ( { attacker = self:GetCaster (), victim = thinker, ability = hAbility, damage = damage, damage_type = hAbility:GetAbilityDamageType()})
    end
end

function hellspont_extermination_scepter:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
