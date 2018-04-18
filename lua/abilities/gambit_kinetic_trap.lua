LinkLuaModifier ("modifier_gambit_kinetic_trap", "abilities/gambit_kinetic_trap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_gambit_kinetic_trap_tinker", "abilities/gambit_kinetic_trap.lua", LUA_MODIFIER_MOTION_NONE)

if gambit_kinetic_trap == nil then gambit_kinetic_trap = class({}) end


function gambit_kinetic_trap:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function gambit_kinetic_trap:OnAbilityPhaseStart()
    if IsServer() then
        self.hVictim = self:GetCursorTarget()

        self.nFXIndex = ParticleManager:CreateParticleForTeam( "particles/hero_predator/predator_plasma_shot_aim.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
        ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( self.nFXIndex, 1, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( self.nFXIndex, 2, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( self.nFXIndex, 3, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( self.nFXIndex, 4, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( self.nFXIndex, 5, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( self.nFXIndex, 16, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( self.nFXIndex, 20, self:GetCaster():GetCursorPosition())

        EmitSoundOn("Hero_TemplarAssassin.Meld", self:GetCaster())

        Timers:CreateTimer(self:GetCastPoint(), function()
            if self.nFXIndex then
                ParticleManager:DestroyParticle(self.nFXIndex, true)
            end
        end)
    end

    return true
end

function gambit_kinetic_trap:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")
    self.thinker = CreateModifierThinker (caster, self, "modifier_gambit_kinetic_trap_tinker", {duration = duration }, point, team_id, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)
end

if modifier_gambit_kinetic_trap_tinker == nil then modifier_gambit_kinetic_trap_tinker = class({}) end

function modifier_gambit_kinetic_trap_tinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_gambit/kinetic_trap.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, thinker:GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, thinker:GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 5, thinker:GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 20, thinker:GetAbsOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn("Hero_TemplarAssassin.Trap.Cast", thinker)
    end
    self:StartIntervalThink(0.1)
    self:OnIntervalThink()
end

function modifier_gambit_kinetic_trap_tinker:OnIntervalThink()
     if IsServer() then
        if self:GetParent() then
            local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
            if units ~= nil then
                if #units > 0 then
                    for _, unit in pairs(units) do
                        local target = unit
                        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gambit_kinetic_trap", {duration = self:GetAbility():GetSpecialValueFor("movement_speed_duration")})
                        self:StartIntervalThink(-1)
                        self:Destroy()
                    end
                end
            end
        end
     end
end

--[[function modifier_gambit_kinetic_trap_tinker:OnDestroy()
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    local origin = thinker:GetAbsOrigin()
    local team = thinker:GetTeamNumber()

    if thinker then
        local units = FindUnitsInRadius(team, origin, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        if units ~= nil then
            if #units > 0 then
                for _, unit in pairs(units) do
                    local target = unit
                    target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gambit_kinetic_trap", {duration = self:GetAbility():GetSpecialValueFor("movement_speed_duration")})
                    EmitSoundOn("Hero_TemplarAssassin.Trap", target)
                    EmitSoundOn("Hero_TemplarAssassin.Trap.Trigger", target)
                    EmitSoundOn("Hero_TemplarAssassin.Trap.Explode", target)
                end
            end
        end
    end
end]]

function modifier_gambit_kinetic_trap_tinker:CheckState()
   return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

if modifier_gambit_kinetic_trap == nil then modifier_gambit_kinetic_trap = class({}) end

function modifier_gambit_kinetic_trap:IsDebuff ()
    return true
end

function modifier_gambit_kinetic_trap:IsHidden()
    return true
end

function modifier_gambit_kinetic_trap:OnCreated (event)
    local ability = self:GetAbility ()
    if IsServer() then
        EmitSoundOn("Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent())
        EmitSoundOn("Hero_AbyssalUnderlord.Pit.Target", self:GetParent())
        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", self:GetParent())
        local iDamage = (self:GetAbility():GetSpecialValueFor("damage")/100)*self:GetParent():GetHealth()

        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = iDamage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function modifier_gambit_kinetic_trap:CheckState()
    local state = {
    [MODIFIER_STATE_SILENCED] = true,
    }

    return state
end

function modifier_gambit_kinetic_trap:GetEffectName()
    return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function modifier_gambit_kinetic_trap:GetEffectAttachType ()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_gambit_kinetic_trap:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_gambit_kinetic_trap:GetModifierMoveSpeedBonus_Percentage ()
    return self:GetAbility():GetSpecialValueFor("movement_speed_slow")
end

function gambit_kinetic_trap:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

