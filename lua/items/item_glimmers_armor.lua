LinkLuaModifier ("modifier_item_glimmers_armor", "items/item_glimmers_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_glimmers_armor_active", "items/item_glimmers_armor.lua", LUA_MODIFIER_MOTION_NONE)
if item_glimmers_armor == nil then 
    item_glimmers_armor = class ( {})
end
function item_glimmers_armor:GetIntrinsicModifierName ()
    return "modifier_item_glimmers_armor"
end

function item_glimmers_armor:OnSpellStart ()
    EmitSoundOn ("Item.GlimmerCape.Activate", self:GetCaster () )
    local duration = self:GetSpecialValueFor ("windwalk_duration")
    local target = self:GetCursorTarget()
    target:AddNewModifier (self:GetCaster (), self, "modifier_item_glimmers_armor_active", { duration = duration })
    target:AddNewModifier (self:GetCaster (), self, "modifier_persistent_invisibility", { duration = duration })
end

if modifier_item_glimmers_armor == nil then
    modifier_item_glimmers_armor = class ( {})
end

function modifier_item_glimmers_armor:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_glimmers_armor:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_glimmers_armor:GetModifierMagicalResistanceBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_magical_armor")
end
function modifier_item_glimmers_armor:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_glimmers_armor:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_glimmers_armor:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_glimmers_armor:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_glimmers_armor:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end
function modifier_item_glimmers_armor:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_glimmers_armor:GetModifierConstantManaRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end

function modifier_item_glimmers_armor:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_item_glimmers_armor_active == nil then
    modifier_item_glimmers_armor_active = class ( {})
end

function modifier_item_glimmers_armor_active:IsHidden()
    return true
end

function modifier_item_glimmers_armor_active:OnCreated(args)
    local caster = self:GetParent ()
    if IsServer () then
        local nFXIndex = ParticleManager:CreateParticle ("particles/vermilion_robe/glimmers_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin (), true)
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(100, 100, 0))
        ParticleManager:SetParticleControlEnt (nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin (), true)
        ParticleManager:SetParticleControlEnt (nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin (), true)
        ParticleManager:SetParticleControlEnt (nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin (), true)
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
end

function modifier_item_glimmers_armor_active:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY
    }

    return funcs
end

function modifier_item_glimmers_armor_active:GetModifierPersistentInvisibility (params)
    return 1
end

function modifier_item_glimmers_armor_active:CheckState ()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }

    return state
end
function item_glimmers_armor:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

