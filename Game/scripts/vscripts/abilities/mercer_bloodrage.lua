mercer_bloodrage = class({})
LinkLuaModifier("modifier_mercer_bloodrage", "abilities/mercer_bloodrage.lua", LUA_MODIFIER_MOTION_NONE)
function mercer_bloodrage:GetIntrinsicModifierName() return "modifier_mercer_bloodrage" end


if not modifier_mercer_bloodrage then modifier_mercer_bloodrage = class({}) end 


function modifier_mercer_bloodrage:IsHidden() return true end
function modifier_mercer_bloodrage:IsPurgable() return false end

function modifier_mercer_bloodrage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH
    }

    return funcs
end

function modifier_mercer_bloodrage:GetModifierTotalDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage_outgoing") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_mercer_1") or 0)
end

function modifier_mercer_bloodrage:GetEffectName()
    return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"
end 

function modifier_mercer_bloodrage:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end 


function modifier_mercer_bloodrage:OnDeath (params)
    if IsServer() then
        if params.attacker == self:GetParent() then
            local ptc = self:GetAbility():GetSpecialValueFor("heal_ptc")
            if self:GetParent():HasTalent("special_bonus_unique_mercer_1") then ptc = ptc + self:GetParent():FindTalentValue("special_bonus_unique_mercer_1") end 
    
            local heal = params.unit:GetMaxHealth() * (ptc / 100)  

            self:GetParent():Heal(heal, self:GetAbility())

            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_CUSTOMORIGIN,  self:GetParent());
            ParticleManager:ReleaseParticleIndex( nFXIndex );
        end  
    end 
end


