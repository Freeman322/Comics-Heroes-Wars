gorr_gorr = class ( {})

LinkLuaModifier ("modifier_gorr_gorr", "abilities/gorr_gorr.lua", LUA_MODIFIER_MOTION_NONE)

function gorr_gorr:Spawn() if IsServer() then self:SetLevel(1) end end
function gorr_gorr:GetIntrinsicModifierName () return "modifier_gorr_gorr" end
function gorr_gorr:GetBehavior () return DOTA_ABILITY_BEHAVIOR_PASSIVE end

modifier_gorr_gorr = class ( {})

function modifier_gorr_gorr:DeclareFunctions () return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT } end
function modifier_gorr_gorr:IsHidden() return false end
function modifier_gorr_gorr:IsPurgable() return false end

function modifier_gorr_gorr:GetModifierPreAttack_BonusDamagePostCrit(params)
    if IsServer() then
        if params.target:IsGod() and params.attacker == self:GetParent() then
            return self:GetParent():GetAverageTrueAttackDamage(params.target) * (self:GetAbility():GetSpecialValueFor("percent_damage") / 100)
        end
    end
    return 0
end
