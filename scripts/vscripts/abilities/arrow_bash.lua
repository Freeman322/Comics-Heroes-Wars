if arrow_bash == nil then arrow_bash = class({}) end

LinkLuaModifier( "modifier_arrow_bash",	"abilities/arrow_bash.lua", LUA_MODIFIER_MOTION_NONE )

function arrow_bash:GetIntrinsicModifierName() return "modifier_arrow_bash" end

if modifier_arrow_bash == nil then modifier_arrow_bash = class ( {}) end
function modifier_arrow_bash:IsHidden() return true end
function modifier_arrow_bash:IsPurgable() return false end
function modifier_arrow_bash:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_arrow_bash:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetAbility():IsCooldownReady() and RollPercentage(self:GetAbility():GetSpecialValueFor("bash_chance")) and self:GetParent():IsRealHero() then
               params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})

               ApplyDamage({victim = params.target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("bonus_damage"), damage_type = DAMAGE_TYPE_PHYSICAL})

               EmitSoundOn("Hero_Slardar.Bash", params.target)

               self:GetAbility():UseResources(false, false, true)
            end
        end
    end
end
