LinkLuaModifier("modifier_gl_shield", "abilities/green_lantern_shield.lua", LUA_MODIFIER_MOTION_NONE)

green_lantern_shield = class ({})

function green_lantern_shield:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_gl_shield", {duration = self:GetSpecialValueFor("duration")})

        EmitSoundOn("Hero_VengefulSpirit.NetherSwap", self:GetCaster())
    end
end

modifier_gl_shield = class({})

function modifier_gl_shield:IsPurgable() return true end

function modifier_gl_shield:OnCreated()
    self.shield_hp = self:GetCaster():GetMana() * self:GetAbility():GetSpecialValueFor("mana_to_shield") / 100
    EmitSoundOn("Hero_Medusa.ManaShield.On", self:GetParent())
end

function modifier_gl_shield:OnDestroy()
    if IsServer() then
        EmitSoundOn("Hero_Medusa.ManaShield.Off", self:GetParent())
    end
end

function modifier_gl_shield:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_gl_shield:GetModifierIncomingDamage_Percentage() return -100 end

function modifier_gl_shield:GetEffectName()
    return "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf"
end

function modifier_gl_shield:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_gl_shield:OnTakeDamage(params)
    if IsServer() then
        if params.unit == self:GetParent() then
            local caster = params.unit
            local damage = params.original_damage

            if self.shield_hp >= damage then
                self.shield_hp = self.shield_hp - damage
                local particle = ParticleManager:CreateParticle("particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield_shell_impact.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
                ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(particle)

            else
                self:Destroy()

            end
        end
    end
end
