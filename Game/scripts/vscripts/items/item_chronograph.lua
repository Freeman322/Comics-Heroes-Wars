LinkLuaModifier("modifier_item_chronograph", "items/item_chronograph.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chronograph_active", "items/item_chronograph.lua", LUA_MODIFIER_MOTION_NONE)

item_chronograph = class({})

function item_chronograph:GetIntrinsicModifierName() return "modifier_item_chronograph" end

function item_chronograph:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()

        if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
            if hTarget:IsIllusion() then hTarget:Kill(self, self:GetCaster()) end

            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_chronograph_active", {duration = self:GetSpecialValueFor("active_duration")})

            EmitSoundOn("Hero_FacelessVoid.TimeDilation.Target", hTarget)
            ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget()))
        end
    end
end


modifier_item_chronograph = class({})

function modifier_item_chronograph:IsHidden() return true end
function modifier_item_chronograph:IsPurgable() return false end
function modifier_item_chronograph:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_chronograph:GetModifierEvasion_Constant() return self:GetAbility():GetSpecialValueFor("bonus_evasion") end
function modifier_item_chronograph:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_chronograph:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_chronograph:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_chronograph:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_chronograph:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_chronograph:GetModifierHPRegenAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("hp_regen_amp") end
function modifier_item_chronograph:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_chronograph:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_item_chronograph:OnAttackLanded(params)
    if IsServer() then
        local mana_damage = self:GetAbility():GetSpecialValueFor("mana_burn")

        if params.attacker == self:GetParent() and params.attacker:IsRealHero() and params.target:IsBuilding() == false and params.target:GetMana() > 0 then
            params.target:SpendMana(mana_damage, self:GetAbility())

            ApplyDamage({victim = params.target, attacker = params.attacker, damage = mana_damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
            ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target))
            EmitSoundOn("Hero_Antimage.ManaBreak", params.target)
        end
    end
end

modifier_item_chronograph_active = class({})

local ABSOLUTE_MOVESPEED = 128

function modifier_item_chronograph_active:IsPurgable() return false end
function modifier_item_chronograph_active:IsHidden() return false end

function modifier_item_chronograph_active:OnCreated( kv )
    if IsServer() then
        if self:GetAbility():GetCaster() ~= self:GetParent() then
            for i=0, 15, 1 do
                local current_ability = self:GetParent():GetAbilityByIndex(i)
                if current_ability ~= nil then
                    current_ability:SetFrozenCooldown( true )
                end
            end
        end
    end
end

function modifier_item_chronograph_active:OnDestroy()
    if IsServer() then
        if self:GetAbility():GetCaster() ~= self:GetParent() then
            for i=0, 15, 1 do
                local current_ability = self:GetParent():GetAbilityByIndex(i)
                if current_ability ~= nil then
                    current_ability:SetFrozenCooldown( false )
                end
            end
        end
    end
end


function modifier_item_chronograph_active:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end


function modifier_item_chronograph_active:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE} end
function modifier_item_chronograph_active:GetModifierMoveSpeed_Absolute() return ABSOLUTE_MOVESPEED end

function modifier_item_chronograph_active:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate.vpcf" end
function modifier_item_chronograph_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
