LinkLuaModifier ("modifier_item_death_scyche", "items/item_death_scyche.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_death_scyche_active", "items/item_death_scyche.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_death_scyche_slowing", "items/item_death_scyche.lua", LUA_MODIFIER_MOTION_NONE)

if item_death_scyche == nil then
    item_death_scyche = class ( {})
end

function item_death_scyche:GetIntrinsicModifierName ()
    return "modifier_item_death_scyche"
end

function item_death_scyche:OnSpellStart ()
    local hCaster = self:GetCaster () --We will always have Caster.
    local duration = self:GetSpecialValueFor ("active_effect_duration")
    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_death_scyche_active", { duration = duration } )
    local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
    ParticleManager:SetParticleControlEnt (nFXIndex, 2, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster ():GetOrigin (), true)
    ParticleManager:ReleaseParticleIndex (nFXIndex)
    EmitSoundOn ("Hero_DoomBringer.Devour", self:GetCaster () )
end

if modifier_item_death_scyche == nil then
    modifier_item_death_scyche = class ( {})
end

function modifier_item_death_scyche:IsHidden ()
    return true
end



function modifier_item_death_scyche:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_death_scyche:GetModifierPreAttack_BonusDamage (params)
	local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_death_scyche:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_death_scyche:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_death_scyche:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_death_scyche:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_death_scyche:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end

function modifier_item_death_scyche:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hAbility = self:GetAbility ()
            params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_item_death_scyche_slowing", { duration = 5 })
            local cold_attack_damage = hAbility:GetSpecialValueFor ("cold_attack_damage")
            EmitSoundOn ("Hero_Ancient_Apparition.Attack", params.target)
            if not params.target:IsTower() then
              ApplyDamage ( { attacker = hAbility:GetCaster (), victim = params.target, ability = hAbility, damage = cold_attack_damage, damage_type = DAMAGE_TYPE_PURE })
            end
        end
    end
    return 0
end

if modifier_item_death_scyche_slowing == nil then
    modifier_item_death_scyche_slowing = class ( {})
end

function modifier_item_death_scyche_slowing:IsBuff()
    return false
end

function modifier_item_death_scyche_slowing:GetTexture()
    return "item_death_scyche"
end

function modifier_item_death_scyche_slowing:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_item_death_scyche_slowing:GetStatusEffectName ()
    return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_death_scyche_slowing:StatusEffectPriority ()
    return 1000
end

function modifier_item_death_scyche_slowing:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("cold_attack_speed")
end

function modifier_item_death_scyche_slowing:GetModifierMoveSpeedBonus_Percentage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("cold_movement_speed")
end

if modifier_item_death_scyche_active == nil then
    modifier_item_death_scyche_active = class ( {})
end

function modifier_item_death_scyche_active:IsBuff ()
    return true
end

function modifier_item_death_scyche_active:GetStatusEffectName ()
    return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_death_scyche_active:StatusEffectPriority ()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_item_death_scyche_active:GetEffectName ()
    return "particles/items_fx/ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_death_scyche_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_death_scyche_active:GetTexture ()
    return "item_death_scyche"
end

function modifier_item_death_scyche_active:IsPurgable ()
    return false
end

function modifier_item_death_scyche_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
    }

    return funcs
end

function modifier_item_death_scyche_active:GetModifierConstantHealthRegen (params)
    return 150
end

function modifier_item_death_scyche_active:GetAbsoluteNoDamagePhysical (params)
    return 1
end

function item_death_scyche:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

