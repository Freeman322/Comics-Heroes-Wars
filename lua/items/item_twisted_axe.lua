LinkLuaModifier ("modifier_item_twisted_axe", "items/item_twisted_axe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_twisted_axe_range", "items/item_twisted_axe.lua", LUA_MODIFIER_MOTION_NONE)

if item_twisted_axe == nil then
    item_twisted_axe = class ( {})
end
  
function item_twisted_axe:GetIntrinsicModifierName ()
    return "modifier_item_twisted_axe"
end

function item_twisted_axe:CastFilterResultTarget (hTarget)
    if IsServer () then

        if hTarget ~= nil and hTarget:IsMagicImmune () then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

--------------------------------------------------------------------------------

function item_twisted_axe:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local duration = self:GetSpecialValueFor ("range_duration")
            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5 } )
            self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_twisted_axe_range", { duration = duration } )
            EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
        end
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if modifier_item_twisted_axe == nil then
    modifier_item_twisted_axe = class ( {})
end

function modifier_item_twisted_axe:IsHidden ()
    return true
end

function modifier_item_twisted_axe:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_twisted_axe:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_twisted_axe:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_twisted_axe:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_twisted_axe:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_twisted_axe:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end


function modifier_item_twisted_axe:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hAbility = self:GetAbility ()
            local target = params.target
            local chance = hAbility:GetSpecialValueFor ("minibash_chance")
            local damage = hAbility:GetSpecialValueFor ("minibash_damage")
            local random = math.random (100)
            if random <= chance then
                target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_stunned", {duration = 0.03})
                ApplyDamage({attacker = self:GetParent (), victim = target, ability = hAbility, damage = damage, damage_type = DAMAGE_TYPE_PURE})
                return 0
            end
        end
    end
end



if modifier_item_twisted_axe_range == nil then
    modifier_item_twisted_axe_range = class ( {})
end


function modifier_item_twisted_axe_range:IsHidden ()
    return true
end


function modifier_item_twisted_axe_range:RemoveOnDeath ()
    return true
end


function modifier_item_twisted_axe_range:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end

function modifier_item_twisted_axe_range:GetModifierAttackRangeBonus (params)
    if IsServer() then
        if self:GetParent():IsRangedAttacker() then 
            return 99999
        end
    end
end

function item_twisted_axe:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

