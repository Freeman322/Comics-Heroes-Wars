LinkLuaModifier ("modifier_item_hells_glare", "items/item_hells_glare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_hells_glare_cooldown", "items/item_hells_glare.lua", LUA_MODIFIER_MOTION_NONE)

if item_hells_glare == nil then
    item_hells_glare = class ( {})
end

function item_hells_glare:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function item_hells_glare:GetIntrinsicModifierName ()
    return "modifier_item_hells_glare"
end

function item_hells_glare:OnSpellStart(  )
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_black_king_bar_immune", {duration = self:GetSpecialValueFor("duration")})
        EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetCaster())

        self:GetCaster():Purge(false, true, false, true, true) --- Функция есть, но нихуя не пурджит. ??? Геееейб?
    end
end

if modifier_item_hells_glare == nil then
    modifier_item_hells_glare = class ( {})
end

function modifier_item_hells_glare:IsHidden()
    return true
end

function modifier_item_hells_glare:IsPurgable()
    return false
end

function modifier_item_hells_glare:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_hells_glare:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_hells_glare:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_item_hells_glare:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_strength")
end

function modifier_item_hells_glare:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
            if self:GetParent():PassivesDisabled() then
                return 0
            end
            local target = params.target
            if RollPercentage(self:GetAbility():GetSpecialValueFor("bash_chance")) and self:GetParent():HasModifier("modifier_item_hells_glare_cooldown") == false then
                EmitSoundOn("DOTA_Item.SkullBasher", target)
                target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("bash_duration")})
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hells_glare_cooldown", {duration = 5})
            end
         end
    end
    return 0
end

if modifier_item_hells_glare_cooldown == nil then
    modifier_item_hells_glare_cooldown = class ( {})
end

function modifier_item_hells_glare_cooldown:IsHidden ()
    return true
end

function modifier_item_hells_glare_cooldown:IsPurgable()
    return false
end

function modifier_item_hells_glare_cooldown:RemoveOnDeath ()
    return false
end
