if tracer_overload == nil then tracer_overload = class({}) end
LinkLuaModifier ("modifier_tracer_overload", "abilities/tracer_overload.lua", LUA_MODIFIER_MOTION_NONE)

if tracer_overload == nil then
    tracer_overload = class ( {})
end

function tracer_overload:OnSpellStart ()
    local caster = self:GetCaster ()

    caster:AddNewModifier(caster, self, "modifier_tracer_overload", {duration = 30})
end


if modifier_tracer_overload == nil then
    modifier_tracer_overload = class({})
end

function modifier_tracer_overload:GetEffectName()
    if self:GetCaster():HasModifier("modifier_arcana") then return "particles/reverse_flash/reverse_flash_debuff.vpcf" end 
    return "particles/hero_tracer/tracer_overload.vpcf"
end

function modifier_tracer_overload:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_tracer_overload:IsPurgable()
    return false
end

function modifier_tracer_overload:OnCreated( params )
    if IsServer() then
        EmitSoundOn ("Hero_FacelessVoid.TimeWalk.Aeons", self:GetParent())
        self.attacks = self:GetAbility():GetSpecialValueFor("attack_count")
    end
end


function modifier_tracer_overload:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_tracer_overload:GetAttackSound()
    return "Hero_Tinker.Attack"
end

function modifier_tracer_overload:GetModifierPreAttack_CriticalStrike()
    return self:GetAbility():GetSpecialValueFor("crit")
end

function modifier_tracer_overload:OnAttackStart( params )
    if IsServer() then
        if params.attacker == self:GetParent() then
            local target = params.attacker
            local damage = params.damage
            self.attacks = self.attacks - 1
            if self.attacks <= 1 then
            	self:Destroy()
            end
        end
    end
end

function tracer_overload:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

