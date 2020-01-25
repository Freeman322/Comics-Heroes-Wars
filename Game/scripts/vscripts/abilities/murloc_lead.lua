LinkLuaModifier ("modifier_murloc_lead", "abilities/murloc_lead.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_murloc_lead_thinker", "abilities/murloc_lead.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_charges", "modifiers/modifier_generic_charges.lua", LUA_MODIFIER_MOTION_NONE )

murloc_lead = class ({})

function murloc_lead:GetIntrinsicModifierName()
    return "modifier_generic_charges"
end

function murloc_lead:GetAOERadius() return self:GetSpecialValueFor("radius") end
function murloc_lead:GetCooldown (nLevel) return self.BaseClass.GetCooldown (self, nLevel) end
function murloc_lead:GetManaCost (hTarget) return self.BaseClass.GetManaCost (self, hTarget) end
function murloc_lead:GetBehavior() return DOTA_ABILITY_BEHAVIOR_AOE +  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end

function murloc_lead:OnSpellStart ()
    if IsServer() then
        local thinker = CreateModifierThinker (self:GetCaster(), self, "modifier_murloc_lead_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        AddFOWViewer (self:GetCaster():GetTeam (), self:GetCursorPosition(), 450, 4, false)
        GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), 500, false)

        EmitSoundOn("Hero_Morphling.ReplicateEnd", thinker)
        EmitSoundOn("Hero_Morphling.Death", self:GetCaster())
    end
end

modifier_murloc_lead_thinker = class ({})
modifier_murloc_lead_thinker.m_iCurrentTarget = 0

function modifier_murloc_lead_thinker:OnCreated(event)
    if IsServer() then
        EmitSoundOn("Hero_Morphling.Replicate", self:GetParent())

        self.radius = self:GetAbility():GetSpecialValueFor("radius")
        self.caster = self:GetAbility():GetCaster()
        self.damage = self:GetAbility():GetSpecialValueFor("bonus_hero_damage")
        self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_murloc_lead", nil)
        self.pos = self:GetCaster():GetAbsOrigin()

        if self.caster:HasTalent("special_bonus_unique_murloc_1") then self.damage = self.damage + self.caster:FindTalentValue("special_bonus_unique_murloc_1") end

        local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        self.units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #self.units > 0 then
            self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("attack_interval"))
            self.m_iCurrentTarget = 1
            self:OnIntervalThink()
        end

        if not self.units or #self.units <= 0 then
            self:Destroy()
        end
    end
end

function modifier_murloc_lead_thinker:OnDestroy()
    if IsServer() then
        if self.mod and not self.mod:IsNull() then
            self.mod:Destroy()

            FindClearSpaceForUnit(self.caster, self.pos, true)
        end
    end
end

function modifier_murloc_lead_thinker:OnIntervalThink()
    if IsServer() then
        if not self.units then self:Destroy() end
        local target = self.units[self.m_iCurrentTarget]
        if target == nil or target:IsNull() then self:Destroy() return end

        self:CreateTrail(target, self.units[self.m_iCurrentTarget + 1])

        self.caster:SetAbsOrigin(target:GetAbsOrigin())
        FindClearSpaceForUnit(self.caster, target:GetAbsOrigin(), false)

        EmitSoundOn("Hero_Morphling.AdaptiveStrikeAgi.Cast", target)
        EmitSoundOn("Hero_Morphling.projectileImpact", self.caster)

        ApplyDamage({
            victim = target,
            attacker = self.caster,
            ability = self:GetAbility(),
            damage = self.damage,
            damage_type = self:GetAbility():GetAbilityDamageType()
        })

        self.caster:PerformAttack(target, false, true, true, false, false, false, true)
        self.caster:PerformAttack(target, false, true, true, false, false, false, true)
        self.caster:PerformAttack(target, false, true, true, false, false, false, true)

        self.m_iCurrentTarget = self.m_iCurrentTarget + 1
    end
end

function modifier_murloc_lead_thinker:CreateTrail(curTarget, nextTarget)
    if IsServer() then
        if curTarget and nextTarget and not nextTarget:IsNull() then
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt_rope.vpcf", PATTACH_CUSTOMORIGIN, curTarget );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, curTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", curTarget:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, nextTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", nextTarget:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN, curTarget);
            ParticleManager:ReleaseParticleIndex (nFXIndex);
        end
    end
end

if modifier_murloc_lead == nil then modifier_murloc_lead = class({}) end

function modifier_murloc_lead:IsHidden() return true end
function modifier_murloc_lead:IsPurgable() return false end
function modifier_murloc_lead:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_murloc_lead:CheckState () return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true, [MODIFIER_STATE_OUT_OF_GAME] = true } end
