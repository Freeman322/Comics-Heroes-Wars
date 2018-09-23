LinkLuaModifier ("modifier_item_anti_life_equation", "items/item_anti_life_equation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_anti_life_equation_active", "items/item_anti_life_equation.lua", LUA_MODIFIER_MOTION_NONE)

if item_anti_life_equation == nil then item_anti_life_equation = class ( {}) end

function item_anti_life_equation:GetIntrinsicModifierName ()
    return "modifier_item_anti_life_equation"
end

function item_anti_life_equation:OnSpellStart ()
    if IsServer() then 
        local target = self:GetCursorTarget()
        EmitSoundOn ("DOTA_Item.Nullifier.Cast", self:GetCaster() )
        EmitSoundOn ("DOTA_Item.Nullifier.Target", target )
        target:Purge(true, true, true, true, true)
        target:AddNewModifier(self:GetCaster(), self, "modifier_item_anti_life_equation_active", {duration = self:GetSpecialValueFor("mute_duration")})
    end
end

if modifier_item_anti_life_equation == nil then
    modifier_item_anti_life_equation = class ( {})
end

function modifier_item_anti_life_equation:IsHidden ()
    return true 
end

function modifier_item_anti_life_equation:IsPurgable()
    return true
end

function modifier_item_anti_life_equation:IsPurgeException()
    return true
end

function modifier_item_anti_life_equation:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_anti_life_equation:GetModifierPhysicalArmorBonus(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_item_anti_life_equation:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_anti_life_equation:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end

function modifier_item_anti_life_equation:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_anti_life_equation:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_anti_life_equation:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_anti_life_equation:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
            if self:GetParent():PassivesDisabled() then
                return 0
            end

            local target = params.target
            if target:GetMana() > 0 then 
                target:SetMana(target:GetMana() - self:GetAbility():GetSpecialValueFor("mana_burn"))

                local damage = {
                    victim = target,
                    attacker = self:GetCaster(),
                    damage = self:GetAbility():GetSpecialValueFor("mana_burn"),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                ApplyDamage( damage )
            end

            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
            ParticleManager:ReleaseParticleIndex(nFXIndex)
            EmitSoundOn("Hero_Antimage.ManaBreak", target)

            if RollPercentage(self:GetAbility():GetSpecialValueFor("minibash_chance")) then
                if not target:IsTower() then
                    params.target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
                    ApplyDamage({attacker = self:GetParent(), victim = target, ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("minibash_damage"), damage_type = DAMAGE_TYPE_PURE})
                end
            end
         end
    end
    return 0
end

function modifier_item_anti_life_equation:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_item_anti_life_equation_active == nil then
    modifier_item_anti_life_equation_active = class ( {})
end

function modifier_item_anti_life_equation_active:IsHidden()
    return false
end

function modifier_item_anti_life_equation_active:OnCreated(table)
    if IsServer() then 
        local nFXIndex = ParticleManager:CreateParticle( "particles/absolute_nulifer/nulifier.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.5})
    end
end

function modifier_item_anti_life_equation_active:IsPurgable()
    return false
end

function modifier_item_anti_life_equation_active:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_item_anti_life_equation_active:GetModifierMoveSpeed_Absolute(params)
    return 128
end

function modifier_item_anti_life_equation_active:GetModifierMoveSpeed_Max(params)
    return 128
end

function modifier_item_anti_life_equation_active:GetModifierMoveSpeed_Limit(params)
    return 128
end

function modifier_item_anti_life_equation_active:GetModifierMoveSpeedBonus_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
end

function modifier_item_anti_life_equation_active:CheckState ()
    local state = {
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end


