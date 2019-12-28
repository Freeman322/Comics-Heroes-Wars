if nurgle_acid_puddle == nil then nurgle_acid_puddle = class({}) end

LinkLuaModifier( "modifier_nurgle_acid_puddle", "abilities/nurgle_acid_puddle.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "thinker_nurgle_acid_puddle", "abilities/nurgle_acid_puddle.lua", LUA_MODIFIER_MOTION_NONE )


function nurgle_acid_puddle:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function nurgle_acid_puddle:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function nurgle_acid_puddle:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function nurgle_acid_puddle:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function nurgle_acid_puddle:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")
    local thinker = CreateModifierThinker (caster, self, "thinker_nurgle_acid_puddle", {duration = duration }, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, duration, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)
end

thinker_nurgle_acid_puddle = class({})

function thinker_nurgle_acid_puddle:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")

    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
        ParticleManager:SetParticleControl( nFXIndex, 15, Vector(243, 153, 0))
        ParticleManager:SetParticleControl( nFXIndex, 16, Vector(self.radius, self.radius, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_Alchemist.AcidSpray", thinker)
    end
    self:StartIntervalThink(1)
end

function thinker_nurgle_acid_puddle:OnIntervalThink()
    if IsServer() then
        local flDamagePerTick = self:GetAbility():GetSpecialValueFor("damage")
        local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                local damage = {
                    victim = unit,
                    attacker = self:GetCaster(),
                    damage = flDamagePerTick,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility()
                }

                if not unit:IsMagicImmune() then
                    EmitSoundOn("Hero_Alchemist.AcidSpray.Damage", unit)
                    unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_nurgle_acid_puddle", { duration = 10 } )

                    ApplyDamage( damage )
                end
            end
        end
    end
end


if modifier_nurgle_acid_puddle == nil then modifier_nurgle_acid_puddle = class({}) end

function modifier_nurgle_acid_puddle:IsDebuff()
    return true
end

function modifier_nurgle_acid_puddle:IsPurgeException()
    return true
end

function modifier_nurgle_acid_puddle:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 100, 1, 100 ) )
        self:AddParticle( nFXIndex, false, false, -1, false, false )
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, false )
        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()
    end
end

function modifier_nurgle_acid_puddle:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_nurgle_acid_puddle:GetModifierMoveSpeedBonus_Percentage( params )
    return -20
end

function modifier_nurgle_acid_puddle:OnIntervalThink()
    if IsServer() and not self:GetParent():IsMagicImmune() then
        local flDamagePerTick = self:GetAbility():GetSpecialValueFor("damage") / 10
        local damage = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = flDamagePerTick,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        }
        ApplyDamage( damage )
    end
end

function nurgle_acid_puddle:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

