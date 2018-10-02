LinkLuaModifier ("modifier_item_dark_sabre", "items/item_dark_sabre.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_dark_sabre_echo", "items/item_dark_sabre.lua", LUA_MODIFIER_MOTION_NONE)

if item_dark_sabre == nil then  item_dark_sabre = class({}) end

function item_dark_sabre:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function item_dark_sabre:GetAOERadius()
    return 150
end

function item_dark_sabre:GetIntrinsicModifierName ()
    return "modifier_item_dark_sabre"
end

function item_dark_sabre:OnSpellStart(  )
    if IsServer() then
        local caster = self:GetCaster()
        local point = self:GetCursorTarget():GetAbsOrigin()

        local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        for _, target in pairs(units) do
            EmitSoundOn("DOTA_Item.AbyssalBlade.Activate", target)
            target:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("bash_duration")})
            ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        end
    end
end

if modifier_item_dark_sabre == nil then  modifier_item_dark_sabre = class({}) end

function modifier_item_dark_sabre:IsHidden()
    return true
end

function modifier_item_dark_sabre:IsPurgable()
    return false
end

function modifier_item_dark_sabre:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_dark_sabre:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_dark_sabre:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end
function modifier_item_dark_sabre:GetModifierPhysical_ConstantBlock (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("block_damage_melee")
end
function modifier_item_dark_sabre:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_dark_sabre:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_dark_sabre:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_dark_sabre:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_dark_sabre:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_dark_sabre:GetModifierConstantManaRegen(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end
function modifier_item_dark_sabre:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
            if self:GetParent():PassivesDisabled() or self:GetParent():IsRangedAttacker() then
                return
            end
            local target = params.target
            local hAbility = self:GetAbility ()
            if hAbility:IsCooldownReady () then
                EmitSoundOn( "DOTA_Item.Maim", target )
                self:GetParent ():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_dark_sabre_echo", nil)
                EmitSoundOn("DOTA_Item.AbyssalBlade.Activate", target)
                target:AddNewModifier(self:GetParent (), hAbility, "modifier_stunned", {duration = hAbility:GetSpecialValueFor("bash_duration")})
                ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
                hAbility:StartCooldown (hAbility:GetCooldown (hAbility:GetLevel ()))
                return 0
             end
         end
    end
    return 0
end

if modifier_item_dark_sabre_echo == nil then modifier_item_dark_sabre_echo = class({}) end

function modifier_item_dark_sabre_echo:IsHidden ()
    return true
end

function modifier_item_dark_sabre_echo:RemoveOnDeath ()
    return true
end

function modifier_item_dark_sabre_echo:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_dark_sabre_echo:GetModifierPreAttack_CriticalStrike (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_chance_crit_damage")
end

function modifier_item_dark_sabre_echo:GetModifierAttackSpeedBonus_Constant (params)
    return 10000
end

function modifier_item_dark_sabre_echo:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() then
            if self:GetParent ():HasModifier ("modifier_item_dark_sabre_echo") then
                self:Destroy()
            end
        end
    end

    return 0
end

function item_dark_sabre:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

