LinkLuaModifier ("modifier_item_ultimate_nullifier", "items/item_ultimate_nullifier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ultimate_nullifier_active", "items/item_ultimate_nullifier.lua", LUA_MODIFIER_MOTION_NONE)

if item_ultimate_nullifier == nil then 
    item_ultimate_nullifier = class ( {})
end

function item_ultimate_nullifier:GetIntrinsicModifierName ()
    return "modifier_item_ultimate_nullifier"
end

function item_ultimate_nullifier:OnSpellStart ()
    if IsServer() then 
        local target = self:GetCursorTarget()

        EmitSoundOn ("DOTA_Item.Nullifier.Cast", self:GetCaster() )
        EmitSoundOn ("DOTA_Item.Nullifier.Target", target )

        local allModifiers = target:FindAllModifiers()
        for _,v in ipairs(allModifiers) do
            print(v:GetName())
        end

        target:Purge(true, true, true, true, true)

        target:AddNewModifier(self:GetCaster(), self, "modifier_item_ultimate_nullifier_active", {duration = self:GetSpecialValueFor("mute_duration")})
    end
end

if modifier_item_ultimate_nullifier == nil then
    modifier_item_ultimate_nullifier = class ( {})
end

function modifier_item_ultimate_nullifier:IsHidden ()
    return true 
end

function modifier_item_ultimate_nullifier:IsPurgable()
    return false
end

function modifier_item_ultimate_nullifier:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_item_ultimate_nullifier:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_agility")
end
    
function modifier_item_ultimate_nullifier:GetModifierBonusStats_Intellect( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
end

function modifier_item_ultimate_nullifier:GetModifierPhysicalArmorBonus(params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_item_ultimate_nullifier:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_ultimate_nullifier:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end

function modifier_item_ultimate_nullifier:OnAttackLanded (params)
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
         end
    end
    return 0
end

function modifier_item_ultimate_nullifier:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_item_ultimate_nullifier_active == nil then
    modifier_item_ultimate_nullifier_active = class ( {})
end

function modifier_item_ultimate_nullifier_active:IsHidden()
    return false
end

function modifier_item_ultimate_nullifier_active:OnCreated(table)
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

function modifier_item_ultimate_nullifier_active:IsPurgable()
    return false
end

function modifier_item_ultimate_nullifier_active:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_item_ultimate_nullifier_active:GetModifierMoveSpeedBonus_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
end

function modifier_item_ultimate_nullifier_active:CheckState ()
    local state = {
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end


