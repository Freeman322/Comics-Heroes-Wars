LinkLuaModifier ("modifier_spiderman_adaptation", "abilities/spiderman_adaptation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_spiderman_adaptation_slowing", "abilities/spiderman_adaptation.lua", LUA_MODIFIER_MOTION_NONE)

spiderman_adaptation = class ( {})

function spiderman_adaptation:GetAOERadius()
   return 275
end

function spiderman_adaptation:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel ) - (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_spiderman_4") or 0)
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

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "lee") then EmitSoundOn( "Lee.Cast1", self:GetCaster() ) end
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
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
        
        self:StartIntervalThink(FrameTime())
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


function modifier_spiderman_adaptation:OnIntervalThink()
    if IsServer () then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        if self.leap_traveled < self.leap_distance then
            caster:SetAbsOrigin (caster:GetAbsOrigin () + self.leap_direction * self.leap_speed)
            self.leap_traveled = self.leap_traveled + self.leap_speed
        else
            self:OnUnitLanded()
        end
    end
end

function modifier_spiderman_adaptation:OnUnitLanded()
    if IsServer () then
        local nearby_units = FindUnitsInRadius (self:GetCaster():GetTeam (), self:GetCaster():GetAbsOrigin (), nil, 275,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, taget in ipairs (nearby_units) do  --Restore health and play a particle effect for every found ally.
            local duration = self:GetAbility ():GetSpecialValueFor ("duration")
            local damage = self:GetAbility ():GetAbilityDamage ()
            if self:GetCaster():HasTalent("special_bonus_unique_spiderman_3") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_spiderman_3") end
            
            taget:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_spiderman_adaptation_slowing", { duration = duration })
            
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

