LinkLuaModifier ("modifier_item_darkmatter_axe", "items/item_darkmatter_axe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_bash_cooldown", "items/item_darkmatter_axe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_darkmatter_axe_target", "items/item_darkmatter_axe.lua", LUA_MODIFIER_MOTION_NONE)

if item_darkmatter_axe == nil then
    item_darkmatter_axe = class ( {})
end

function item_darkmatter_axe:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    return behav
end

function item_darkmatter_axe:GetIntrinsicModifierName ()
    return "modifier_item_darkmatter_axe"
end

function item_darkmatter_axe:CastFilterResultTarget( hTarget )
    if IsServer() then

        if hTarget ~= nil and hTarget:IsMagicImmune() then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
        return nResult
    end

    return UF_SUCCESS
end

function item_darkmatter_axe:OnSpellStart()
    self.hTarget = self:GetCursorTarget()
    if self.hTarget ~= nil then
        if ( not self.hTarget:TriggerSpellAbsorb( self ) ) then
            local duration = self:GetSpecialValueFor( "eternity_duration" )
            self.hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_darkmatter_axe_target", { duration = duration } )
            EmitSoundOn( "Hero_Oracle.FalsePromise.Cast", self.hTarget )
        end
    end
end

function item_darkmatter_axe:GetAbilityTarget()
    return self.hTarget
end


if modifier_item_darkmatter_axe == nil then
    modifier_item_darkmatter_axe = class ( {})
end

function modifier_item_darkmatter_axe:IsHidden()
    return true
end

function modifier_item_darkmatter_axe:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_darkmatter_axe:GetModifierPhysical_ConstantBlock (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("block_damage_melee")
end

function modifier_item_darkmatter_axe:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_darkmatter_axe:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_strength")
end

function modifier_item_darkmatter_axe:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end

function modifier_item_darkmatter_axe:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end

function modifier_item_darkmatter_axe:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end

function modifier_item_darkmatter_axe:IsModifierCooldownReady(unit)
    if unit:HasModifier("modifier_bash_cooldown") then
        return false
    else
        return true
    end
end
function modifier_item_darkmatter_axe:CheckState()
    local state = {
    [MODIFIER_STATE_CANNOT_MISS] = true,
    }

    return state
end

function modifier_item_darkmatter_axe:OnAttackLanded (params)
    if params.attacker == self:GetParent() then
        if params.target ~= nil and not params.attacker:IsRangedAttacker() then
            if RollPercentage(self:GetAbility():GetSpecialValueFor("bash_chance_melee")) and self:IsModifierCooldownReady(params.target) then
                params.target:AddNewModifier(params.attacker, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("bash_duration")})
                params.target:AddNewModifier(params.attacker, self, "modifier_bash_cooldown", {duration = self:GetAbility():GetSpecialValueFor("3")})
            end
        end
    end
end

if modifier_bash_cooldown == nil then modifier_bash_cooldown = class({}) end

function modifier_bash_cooldown:IsHidden()
    return true
end

function modifier_bash_cooldown:IsPurgable()
    return false
end

if modifier_item_darkmatter_axe_target == nil then modifier_item_darkmatter_axe_target = class({}) end

function modifier_item_darkmatter_axe_target:IsPurgable()
    return false
end

function modifier_item_darkmatter_axe_target:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    }

    return state
end

function modifier_item_darkmatter_axe_target:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_item_darkmatter_axe_target:GetOverrideAnimation( params )
    return ACT_DOTA_FLAIL
end

function modifier_item_darkmatter_axe_target:OnCreated(table)
    if IsServer() then
        self.hp_onCreated = self:GetAbility():GetCaster():GetHealth()
    end

end

function modifier_item_darkmatter_axe_target:OnDestroy()
    if IsServer() then
        local caster = self:GetCaster()
        local parent = self:GetParent()
        local modifier = self
        if self.hp_onCreated < caster:GetHealth() then
            damage = caster:GetHealth() - self.hp_onCreated
        else
            damage = caster:GetHealthDeficit()
        end

        if not caster:IsAlive() then
            damage = 99999
        end

        ApplyDamage({attacker = caster, victim = parent, ability = modifier:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})
        EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Target", parent)
        EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Cast", caster)
    end
end


function item_darkmatter_axe:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

