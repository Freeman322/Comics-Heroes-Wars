LinkLuaModifier ("modifier_black_panther_cat_leap", "abilities/black_panther_cat_leap.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
black_panther_cat_leap = class ( {})

function black_panther_cat_leap:GetAOERadius()
   return 275
end

function black_panther_cat_leap:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
    return behav
end

function black_panther_cat_leap:OnSpellStart ()
    if IsServer () then
        local caster = self:GetCaster ()
        caster:AddNewModifier (caster, self, "modifier_black_panther_cat_leap", nil)
        EmitSoundOn ("Ability.Leap", caster)
    end
end

modifier_black_panther_cat_leap = class ( {})

function modifier_black_panther_cat_leap:IsDebuff ()
    return true
end

function modifier_black_panther_cat_leap:OnCreated ()
    if IsServer() then
        local caster = self:GetCaster ()
        ProjectileManager:ProjectileDodge (caster)
        self.target = caster:GetCursorPosition()
        -- Ability variables
        self.leap_direction = (self.target - caster:GetAbsOrigin()):Normalized()
        self.leap_distance = (self.target - caster:GetAbsOrigin()):Length2D()
        self.leap_speed = 1600/30
        self.leap_traveled = 0
        self.leap_z = 0
        
        self:StartIntervalThink(FrameTime())
    end
end


function modifier_black_panther_cat_leap:IsStunDebuff ()
    return true
end


function modifier_black_panther_cat_leap:RemoveOnDeath ()
    return false
end

function modifier_black_panther_cat_leap:GetEffectName()
    if self:GetParent():HasModifier("modifier_nike") then   return "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_leap.vpcf" end 
    return 
end

function modifier_black_panther_cat_leap:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_black_panther_cat_leap:IsHidden()
    return false
end


function modifier_black_panther_cat_leap:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end


function modifier_black_panther_cat_leap:GetOverrideAnimation (params)
    return ACT_DOTA_FLAIL
end


function modifier_black_panther_cat_leap:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end


function modifier_black_panther_cat_leap:OnIntervalThink()
    if IsServer () then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        if self.leap_traveled < self.leap_distance then
            caster:SetAbsOrigin (caster:GetAbsOrigin () + self.leap_direction * self.leap_speed)
            self.leap_traveled = self.leap_traveled + self.leap_speed
        else
            self:OnMotionInterrupted()
        end
    end
end

function modifier_black_panther_cat_leap:OnMotionInterrupted()
    if IsServer () then
        local nearby_units = FindUnitsInRadius (self:GetCaster():GetTeam (), self:GetCaster():GetAbsOrigin (), nil, 275,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, taget in ipairs (nearby_units) do  --Restore health and play a particle effect for every found ally.
            local duration = self:GetAbility ():GetSpecialValueFor ("stun_duration")
            local damage = self:GetAbility ():GetAbilityDamage ()

            taget:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_stunned", { duration = duration })
           
            ApplyDamage ( { attacker = self:GetAbility ():GetCaster (), victim = taget, ability = self:GetAbility (), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
        end
       
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 275, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.Totem", self:GetCaster() )
       
        FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

        self:Destroy ()
    end
end

function black_panther_cat_leap:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

