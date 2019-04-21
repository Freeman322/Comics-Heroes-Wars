if item_blade_mail == nil then
	item_blade_mail = class({})
end

LinkLuaModifier ("modifier_blade_mail", "items/item_blade_mail.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_blade_mail_lua", "items/item_blade_mail.lua", LUA_MODIFIER_MOTION_NONE)

if item_blade_mail == nil then
    item_blade_mail = class ( {})
end

function item_blade_mail:GetIntrinsicModifierName ()
    return "modifier_item_blade_mail_lua"
end

function item_blade_mail:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("duration")
    local caster = self:GetCaster ()
    EmitSoundOn("DOTA_Item.BladeMail.Activate", caster)
    caster:AddNewModifier(caster, self, "modifier_blade_mail", {duration = duration})
end


if modifier_blade_mail == nil then
    modifier_blade_mail = class({})
end


function modifier_blade_mail:IsPurgable()
    return false
end

function modifier_blade_mail:GetEffectName()
    return "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
end


function modifier_blade_mail:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_blade_mail:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker

            if target == self:GetParent() then
                return
            end

            if target:GetClassname() == "ent_dota_fountain" then
        	   return
            end

            ApplyDamage ( {
                victim = target,
                attacker = self:GetParent(),
                damage = params.damage,
                damage_type = DAMAGE_TYPE_PURE,
                ability = self:GetAbility(),
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
            })
            EmitSoundOn("DOTA_Item.BladeMail.Damage", target)
        end
    end
end

if modifier_item_blade_mail_lua == nil then
    modifier_item_blade_mail_lua = class({})
end

function modifier_item_blade_mail_lua:IsHidden()
    return true
end

function modifier_item_blade_mail_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_item_blade_mail_lua:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_blade_mail_lua:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_item_blade_mail_lua:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end

function item_blade_mail:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

