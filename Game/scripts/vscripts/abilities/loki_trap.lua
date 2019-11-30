LinkLuaModifier ("modifier_loki_trap_thinker", "abilities/loki_trap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_loki_trap", "abilities/loki_trap.lua", LUA_MODIFIER_MOTION_NONE)

loki_trap = class({})

function loki_trap:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function loki_trap:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function loki_trap:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")
    self.thinker = CreateModifierThinker (caster, self, "modifier_loki_trap_thinker", {duration = duration }, point, team_id, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "lovuska_jokera") == true then
        EmitSoundOn("Loki.CustomCast3", caster)
    end
end

modifier_loki_trap_thinker = class({})

function modifier_loki_trap_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    self:StartIntervalThink(0.1)
    self:OnIntervalThink()
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_loki/loki_spark_trap.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetCursorPosition())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn("Hero_ArcWarden.SparkWraith.Cast", thinker)
    end
end

function modifier_loki_trap_thinker:OnIntervalThink()
    if IsServer() then
        local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        if units ~= nil then
            if #units > 0 then
                for _, unit in pairs(units) do
                    local target = unit
                    target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_loki_trap", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
                    self:StartIntervalThink(-1)
                    self:Destroy()
                end
            end
        end
    end
end

function modifier_loki_trap_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_loki_trap = class({})

function modifier_loki_trap:IsDebuff ()
    return true
end

function modifier_loki_trap:IsHidden()
    return true
end

function modifier_loki_trap:OnCreated (event)
    local ability = self:GetAbility ()
    if IsServer() then
        EmitSoundOn("Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent())
        EmitSoundOn("Hero_AbyssalUnderlord.Pit.Target", self:GetParent())
        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", self:GetParent())
        local iDamage = self:GetAbility():GetSpecialValueFor("spark_damage")
        if self:GetCaster():HasTalent("special_bonus_unique_loki") then
            iDamage = self:GetCaster():FindTalentValue("special_bonus_unique_loki") + self:GetAbility():GetSpecialValueFor("spark_damage")
        end
        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = iDamage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function modifier_loki_trap:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_SILENCED] = true,
    }

    return state
end

function modifier_loki_trap:GetEffectName()
    return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function modifier_loki_trap:GetEffectAttachType ()
    return PATTACH_ABSORIGIN
end

function loki_trap:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_lovuska_jokera") then return "custom/loki_trap_custom" end
    return self.BaseClass.GetAbilityTextureName(self) 
end