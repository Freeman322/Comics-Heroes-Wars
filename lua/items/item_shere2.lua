item_shere2 = class ( {})

LinkLuaModifier( "item_shere2_effect_modifier", "items/item_shere2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_shere2_passive_modifier", "items/item_shere2.lua", LUA_MODIFIER_MOTION_NONE )

function item_shere2:GetIntrinsicModifierName()
    return "item_shere2_passive_modifier"
end

function item_shere2:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local duration = self:GetSpecialValueFor( "duration" )
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "item_shere2_effect_modifier", {duration = duration} )
 
    EmitSoundOn( "Hero_Invoker.EMP.Discharge", self:GetCaster() )
end
---------------------------------------------------------------------------------

if item_shere2_effect_modifier == nil then
    item_shere2_effect_modifier = class({})
end
--------------------------------------------------------------------------------

function item_shere2_effect_modifier:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function item_shere2_effect_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function item_shere2_effect_modifier:StatusEffectPriority()
    return 1
end

--------------------------------------------------------------------------------

function item_shere2_effect_modifier:GetEffectName()
    return "particles/items_fx/armlet.vpcf"
end

--------------------------------------------------------------------------------

function item_shere2_effect_modifier:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function item_shere2_effect_modifier:IsAura()
    return false
end

function item_shere2_effect_modifier:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/rod_of_atos.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
      

        EmitSoundOn( "Item.StarEmblem.Enemy", self:GetCaster() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function item_shere2_effect_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }

    return funcs
end

--------------------------------------------------------------------------------

function item_shere2_effect_modifier:GetModifierPreAttack_CriticalStrike()
    return self:GetAbility():GetSpecialValueFor("active_crit")
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
if item_shere2_passive_modifier == nil then
    item_shere2_passive_modifier = class({})
end

function item_shere2_passive_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_shere2_passive_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS
    }

    return funcs
end

function item_shere2_passive_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_shere2_passive_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_shere2_passive_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_shere2_passive_modifier:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end

function item_shere2_passive_modifier:GetModifierManaBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana" )
end

function item_shere2:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

