LinkLuaModifier ("modifier_aqua_man_sphere_thinker", "abilities/aqua_man_sphere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_aqua_man_sphere_thinker_debuff", "abilities/aqua_man_sphere.lua", LUA_MODIFIER_MOTION_NONE)

aqua_man_sphere = class ( {})

function aqua_man_sphere:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function aqua_man_sphere:OnSpellStart ()
    local point = self:GetCursorPosition ()
    local caster = self:GetCaster ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor ("duration")

    local thinker = CreateModifierThinker (caster, self, "modifier_aqua_man_sphere_thinker", {duration = duration, x = point.x, y = point.y, z = point.z  }, point, team_id, false)

    EmitSoundOn("Aquaman.Ult.Cast", caster)
end

function aqua_man_sphere:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

modifier_aqua_man_sphere_thinker = class ( {})

function modifier_aqua_man_sphere_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()

    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor("radius")

    if IsServer() then
        local thinker_pos = self:GetParent():GetAbsOrigin()

        local bhParticle1 = ParticleManager:CreateParticle ("particles/aquaman/aquaman_water_puddle_cast.vpcf", PATTACH_WORLDORIGIN, thinker)
        ParticleManager:SetParticleControl(bhParticle1, 0, thinker_pos)
        ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self.radius, 1, 0))

        self:AddParticle( bhParticle1, false, false, -1, false, true )
    end
end

function modifier_aqua_man_sphere_thinker:IsAura () return true end
function modifier_aqua_man_sphere_thinker:GetAuraRadius () return self.radius end
function modifier_aqua_man_sphere_thinker:GetAuraSearchTeam () return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_aqua_man_sphere_thinker:GetAuraSearchType () return DOTA_UNIT_TARGET_ALL end
function modifier_aqua_man_sphere_thinker:GetAuraSearchFlags () return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_aqua_man_sphere_thinker:GetModifierAura ()
    return "modifier_aqua_man_sphere_thinker_debuff"
end

modifier_aqua_man_sphere_thinker_debuff = class ( {})

function modifier_aqua_man_sphere_thinker_debuff:IsBuff()
    if self:GetParent() == self:GetAbility():GetCaster() then
        return true
    end

    return false
end


function modifier_aqua_man_sphere_thinker_debuff:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(1.75)

        self.radius = self:GetAbility():GetSpecialValueFor("radius")

        -- aura references
        self.aura_origin = Vector(params.x, params.y, params.z)

        self.parent = self:GetParent()
        self.width = 100
        self.max_speed = 550
        self.min_speed = 0.1
        self.max_min = self.max_speed-self.min_speed

        -- check inside/outside
        self.inside = (self.parent:GetOrigin()-self.aura_origin):Length2D() < self.radius

        self:OnIntervalThink()
    end
end


function modifier_aqua_man_sphere_thinker_debuff:OnIntervalThink()
    if IsServer() then
        if self:IsBuff() == false then
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.9})
        end
    end
end

function modifier_aqua_man_sphere_thinker_debuff:DeclareFunctions ()
    return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_aqua_man_sphere_thinker_debuff:GetModifierMoveSpeed_Absolute (params)
    if self:IsBuff() then
        return self:GetAbility():GetSpecialValueFor("aqua_man_movespeed")
    end

    return 25
end


function modifier_aqua_man_sphere_thinker_debuff:GetModifierAttackSpeedBonus_Constant (params)
    if self:IsBuff() then
        return 200
    end

    return 0
end


function modifier_aqua_man_sphere_thinker_debuff:CheckState()
    if self:IsBuff() then
        return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_INVULNERABLE] = true}
    end

    return
end

function aqua_man_sphere:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

