if gorr_seduction == nil then gorr_seduction = class({}) end

LinkLuaModifier( "modifier_gorr_seduction_thinker", "abilities/gorr_seduction.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_gorr_seduction_modifier", "abilities/gorr_seduction.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

function gorr_seduction:OnSpellStart()
    local radius = self:GetSpecialValueFor( "radius" )
    local duration = self:GetSpecialValueFor(  "duration" )
    local deal_damage = self:GetCaster():HasTalent("special_bonus_unique_gorr_5")
    local damage = self:GetSpecialValueFor(  "stomp_damage" )

    if self:GetCaster():HasTalent("special_bonus_unique_gorr_4") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_gorr_4") end

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if #units > 0 then
        for _,target in pairs(units) do
            target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 1.0 } )

            local bonus_damage = 0

            if deal_damage then bonus_damage = self:GetCaster():GetAverageTrueAttackDamage(target) end

            EmitSoundOn("Hero_VoidSpirit.AetherRemnant.Triggered", target)
            EmitSoundOn("Hero_VoidSpirit.AetherRemnant.Target", target)

            ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage + bonus_damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    end

    local nFXIndex = ParticleManager:CreateParticle( "particles/gorr/gorr_scream.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Hero_VoidSpirit.AetherRemnant.Cast", self:GetCaster() )

    CreateModifierThinker(self:GetCaster(), self, "modifier_gorr_seduction_thinker", {duration = duration}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

    self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

function gorr_seduction:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

modifier_gorr_seduction_thinker = class ({})

function modifier_gorr_seduction_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = thinker:GetAbsOrigin()

        local radius = ability:GetSpecialValueFor("radius")

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, target)
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(radius, radius, 1))

        self:AddParticle( nFXIndex, false, false, -1, false, true )

        AddFOWViewer( thinker:GetTeam(), target, radius, 5, false)
        GridNav:DestroyTreesAroundPoint(target, radius, false)
    end
end

function modifier_gorr_seduction_thinker:CheckState() return {[MODIFIER_STATE_PROVIDES_VISION] = true} end
function modifier_gorr_seduction_thinker:IsAura() return true end
function modifier_gorr_seduction_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_gorr_seduction_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_gorr_seduction_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_gorr_seduction_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end

function modifier_gorr_seduction_thinker:GetModifierAura()
    return "modifier_gorr_seduction_modifier"
end

modifier_gorr_seduction_modifier = class ( {})

function modifier_gorr_seduction_modifier:IsDebuff () return true end
function modifier_gorr_seduction_modifier:IsPurgable() return false end
function modifier_gorr_seduction_modifier:GetEffectName() return "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf" end
function modifier_gorr_seduction_modifier:GetEffectAttachType () return PATTACH_POINT_FOLLOW end

function modifier_gorr_seduction_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_SPECIALLY_DENIABLE] = true
    }

    return state
end

