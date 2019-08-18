LinkLuaModifier ("modifier_item_vermilion_robe", "items/item_vermilion_robe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_vermilion_robe_effect", "items/item_vermilion_robe.lua", LUA_MODIFIER_MOTION_NONE)
if item_vermilion_robe == nil then
    item_vermilion_robe = class ( {})
end

function item_vermilion_robe:GetIntrinsicModifierName ()
    return "modifier_item_vermilion_robe"
end

function item_vermilion_robe:OnSpellStart ()
    EmitSoundOn ("Item.CrimsonGuard.Cast", self:GetCaster () )
    ParticleManager:CreateParticle ("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster ())
    local nearby_allied_units = FindUnitsInRadius (self:GetCaster ():GetTeam (), self:GetCaster ():GetAbsOrigin (), nil, 900,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for i, nearby_ally in ipairs (nearby_allied_units) do  --Restore health and play a particle effect for every found ally.
        local duration = self:GetSpecialValueFor ("active_duration")
        nearby_ally:AddNewModifier (self:GetCaster (), self, "modifier_item_vermilion_robe_effect", { duration = duration })
    end
end

if modifier_item_vermilion_robe == nil then
    modifier_item_vermilion_robe = class ( {})
end

function modifier_item_vermilion_robe:IsHidden ()
    return true
end

function modifier_item_vermilion_robe:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
    }

    return funcs
end

function modifier_item_vermilion_robe:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_vermilion_robe:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_vermilion_robe:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_vermilion_robe:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_vermilion_robe:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end
function modifier_item_vermilion_robe:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end
function modifier_item_vermilion_robe:GetModifierMagicalResistanceBonus(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_magical_armor")
end

function modifier_item_vermilion_robe:GetModifierPhysical_ConstantBlock (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("block_damage_melee")
end


if modifier_item_vermilion_robe_effect == nil then
    modifier_item_vermilion_robe_effect = class({})
end
--------------------------------------------------------------------------------

function modifier_item_vermilion_robe_effect:IsPurgable()
    return false
end


function modifier_item_vermilion_robe_effect:OnCreated( kv )
    if IsServer() then
        local caster = self:GetParent()
        local particle = ParticleManager:CreateParticle("particles/vermilion_robe/vermillion_robe_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(particle, 3, Vector(100, 100, 0))
        ParticleManager:SetParticleControlEnt(particle, 5, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        self:AddParticle( particle, false, false, -1, false, true )
    end
end

function modifier_item_vermilion_robe_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end
        
function modifier_item_vermilion_robe_effect:GetTexture()
    return "item_vermilion_robe"
end
--------------------------------------------------------------------------------

function modifier_item_vermilion_robe_effect:GetModifierIncomingDamage_Percentage()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("block_damage")
end

function item_vermilion_robe:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

