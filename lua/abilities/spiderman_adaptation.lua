--[[spiderman_adaptation = class ( {})

LinkLuaModifier ("spiderman_adaptation_thinker", "heroes/hero_spiderman/spiderman_adaptation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_spiderman_adaptation", "heroes/hero_spiderman/spiderman_adaptation.lua", LUA_MODIFIER_MOTION_NONE)

function spiderman_adaptation:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

function spiderman_adaptation:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end
function spiderman_adaptation:OnSpellStart ()
    local point = self:GetCursorPosition ()
    local caster = self:GetCaster ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor ("duration")
    local thinker = CreateModifierThinker (caster, self, "spiderman_adaptation_thinker", {duration = duration }, point, team_id, false)
end

spiderman_adaptation_thinker = class ( {})

function spiderman_adaptation_thinker:OnCreated (event)
    if IsServer() then
        local thinker = self:GetParent ()
        local ability = self:GetAbility ()
        local point = self:GetCaster():GetCursorPosition ()
        self.team_number = thinker:GetTeamNumber ()
        self.radius = ability:GetSpecialValueFor ("radius")
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_web.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, point)
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, 0, 150))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function spiderman_adaptation_thinker:IsAura ()
    return true
end

function spiderman_adaptation_thinker:GetAuraRadius ()
    return self.radius
end

function spiderman_adaptation_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function spiderman_adaptation_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_HERO
end

function spiderman_adaptation_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function spiderman_adaptation_thinker:GetModifierAura ()
    return "modifier_spiderman_adaptation"
end


modifier_spiderman_adaptation = class ( {})

function modifier_spiderman_adaptation:IsBuff ()
    return true
end

function modifier_spiderman_adaptation:OnCreated (event)
    if IsServer() then
        local ability = self:GetAbility ()
        self:GetParent():AddNewModifier(ability:GetCaster(), ability, "modifier_persistent_invisibility", nil)
    end
end

function modifier_spiderman_adaptation:OnDestroy(event)
    if IsServer() then
        local ability = self:GetAbility ()
        if self:GetParent():HasModifier("modifier_persistent_invisibility") then
            self:GetParent():RemoveModifierByName("modifier_persistent_invisibility")
        end
    end
end

function modifier_spiderman_adaptation:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT }
end

function modifier_spiderman_adaptation:GetModifierMoveSpeedBonus_Percentage ()
    local ability = self:GetAbility ()
    return ability:GetSpecialValueFor("bonus_movespeed")
end

function modifier_spiderman_adaptation:GetModifierConstantHealthRegen ()
    local ability = self:GetAbility ()
    return ability:GetSpecialValueFor("heath_regen")
end

function modifier_spiderman_adaptation:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }

    return state
end]]
LinkLuaModifier ("modifier_spiderman_adaptation", "abilities/spiderman_adaptation.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier ("modifier_spiderman_adaptation_slowing", "abilities/spiderman_adaptation.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
spiderman_adaptation = class ( {})

function spiderman_adaptation:GetAOERadius()
   return 275
end

function spiderman_adaptation:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
    return behav
end

function spiderman_adaptation:OnSpellStart ()
    if IsServer () then
        local caster = self:GetCaster ()
        caster:AddNewModifier (caster, self, "modifier_spiderman_adaptation", nil)
        EmitSoundOn ("Ability.Leap", caster)
    end
end

modifier_spiderman_adaptation = class ( {})

function modifier_spiderman_adaptation:IsDebuff ()
    return true
end

function modifier_spiderman_adaptation:OnCreated ()
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
        if self:ApplyHorizontalMotionController () == false then
            self:Destroy ()
        end
    end
end


function modifier_spiderman_adaptation:IsStunDebuff ()
    return true
end


function modifier_spiderman_adaptation:RemoveOnDeath ()
    return false
end

function modifier_spiderman_adaptation:IsHidden()
    return false
end


function modifier_spiderman_adaptation:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end


function modifier_spiderman_adaptation:GetOverrideAnimation (params)
    return ACT_DOTA_FLAIL
end


function modifier_spiderman_adaptation:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end


function modifier_spiderman_adaptation:UpdateHorizontalMotion (me, dt)
    if IsServer () then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        if self.leap_traveled < self.leap_distance then
            caster:SetAbsOrigin (caster:GetAbsOrigin () + self.leap_direction * self.leap_speed)
            self.leap_traveled = self.leap_traveled + self.leap_speed
        else
            caster:InterruptMotionControllers (true)
        end
    end
end

function modifier_spiderman_adaptation:OnHorizontalMotionInterrupted ()
    if IsServer () then
        local nearby_units = FindUnitsInRadius (self:GetCaster():GetTeam (), self:GetCaster():GetAbsOrigin (), nil, 275,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, taget in ipairs (nearby_units) do  --Restore health and play a particle effect for every found ally.
            local duration = self:GetAbility ():GetSpecialValueFor ("duration")
            local damage = self:GetAbility ():GetAbilityDamage ()

            taget:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_spiderman_adaptation_slowing", { duration = duration })
            ApplyDamage ( { attacker = self:GetAbility ():GetCaster (), victim = taget, ability = self:GetAbility (), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
        end
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
        --ParticleManager:SetParticleControl( nFXIndex, 1, Vector( hAbility:GetSpecialValueFor( "aftershock_range" ), 1, 1 ) )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 275, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.Totem", self:GetCaster() )
        self:Destroy ()
    end
end

if modifier_spiderman_adaptation_slowing == nil then modifier_spiderman_adaptation_slowing = class({}) end

function modifier_spiderman_adaptation_slowing:IsBuff ()
    return false
end

function modifier_spiderman_adaptation_slowing:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_spiderman_adaptation_slowing:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_spiderman_adaptation_slowing:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_spiderman_adaptation_slowing:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("slowing")
end

function spiderman_adaptation:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

