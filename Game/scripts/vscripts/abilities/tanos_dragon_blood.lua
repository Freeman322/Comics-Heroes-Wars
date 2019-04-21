if tanos_dragon_blood == nil then tanos_dragon_blood = class({}) end

LinkLuaModifier ("modifier_tanos_dragon_blood", "abilities/tanos_dragon_blood.lua", LUA_MODIFIER_MOTION_NONE)

function tanos_dragon_blood:GetIntrinsicModifierName()
	return "modifier_tanos_dragon_blood"
end

if modifier_tanos_dragon_blood == nil then modifier_tanos_dragon_blood = class({}) end

function modifier_tanos_dragon_blood:IsPurgable(  )
    return false
end

function modifier_tanos_dragon_blood:IsHidden()
    return true
end


function modifier_tanos_dragon_blood:GetStatusEffectName()
    if self:GetCaster():HasModifier("modifier_king_thanos") then
        return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
    end
    return
end

function modifier_tanos_dragon_blood:StatusEffectPriority()
    return 1000
end


function modifier_tanos_dragon_blood:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_tanos_dragon_blood:GetModifierConstantHealthRegen( params )
    self.regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
    if self:GetParent():HasScepter() then 
        self.regen = self.regen + self:GetAbility():GetSpecialValueFor("bonus_health_regen_per_min_scepter")*(GameRules:GetGameTime()/60)
    end
    return self.regen
end

function modifier_tanos_dragon_blood:OnCreated(table)
    if IsServer() then 
        if self:GetCaster():HasModifier("modifier_king_thanos") then
            EmitSoundOn("Hero_Sven.WarCry.Signet", self:GetParent())

            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            self:AddParticle( nFXIndex, false, false, -1, false, true )
        end
    end
end

function tanos_dragon_blood:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_king_thanos") then
        return "custom/tanos_dragon_blood_sword"
    end
    return "custom/tanos_dragon_blood"
end