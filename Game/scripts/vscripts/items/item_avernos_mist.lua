item_avernos_mist = class({})
LinkLuaModifier( "modifier_item_avernos_mist_active", "items/item_avernos_mist.lua", LUA_MODIFIER_MOTION_NONE )

function item_avernos_mist:ProcsMagicStick()
	return false
end

function item_avernos_mist:GetIntrinsicModifierName()
	return "modifier_item_guardian_greaves"
end

function item_avernos_mist:OnSpellStart()
    if IsServer() then 
        EmitSoundOn ("Item.CrimsonGuard.Cast", self:GetCaster () )

        local nearby_allied_units = FindUnitsInRadius (self:GetCaster ():GetTeam (), self:GetCaster ():GetAbsOrigin (), nil, self:GetSpecialValueFor("aura_radius"),
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)    
        
        for i, nearby_ally in ipairs (nearby_allied_units) do  
            nearby_ally:AddNewModifier (self:GetCaster (), self, "modifier_item_avernos_mist_active", { duration = self:GetSpecialValueFor ("active_duration") })
        end
    end 
end

if modifier_item_avernos_mist_active == nil then modifier_item_avernos_mist_active = class({}) end

function modifier_item_avernos_mist_active:IsHidden()
    return false
end

function modifier_item_avernos_mist_active:IsPurgable()
    return false
end

function modifier_item_avernos_mist_active:OnCreated(params)
    if IsServer() then
        self:GetParent():Purge(false, true, false, true, false) 
    end 
end


function modifier_item_avernos_mist_active:GetEffectName()
    return "particles/items_fx/avernos_mist.vpcf"
end

function modifier_item_avernos_mist_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_avernos_mist_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE 
    }

    return funcs
end

function modifier_item_avernos_mist_active:GetModifierIncomingDamage_Percentage (params)
    return self:GetAbility():GetSpecialValueFor ("status_resistance") * (-1)
end

function modifier_item_avernos_mist_active:GetModifierHealthRegenPercentage (params)
    return self:GetAbility():GetSpecialValueFor ("active_hp_regen")
end

function modifier_item_avernos_mist_active:GetModifierTotalPercentageManaRegen (params)
    return self:GetAbility():GetSpecialValueFor ("active_mana_regen")
end

