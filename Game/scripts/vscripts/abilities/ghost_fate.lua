LinkLuaModifier ("modifier_ghost_fate", "abilities/ghost_fate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ghost_fate_damage", "abilities/ghost_fate.lua", LUA_MODIFIER_MOTION_NONE)

if ghost_fate == nil then
    ghost_fate = class ( {})
end

function ghost_fate:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function ghost_fate:GetIntrinsicModifierName ()
    return "modifier_ghost_fate"
end

if modifier_ghost_fate == nil then
    modifier_ghost_fate = class ( {})
end

function modifier_ghost_fate:IsHidden()
    return true
end

function modifier_ghost_fate:IsPurgable()
    return false
end


function modifier_ghost_fate:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_ghost_fate:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker

            if target == self:GetParent() then return end
            if self:GetCaster():PassivesDisabled() then return end

            if params.damage_type > 1 and self:GetParent():IsAlive() then
                local damage = params.damage * (self:GetAbility():GetSpecialValueFor("damage_drain_ptc") / 100)
                if self:GetParent():HasTalent("special_bonus_unique_ghost_2") then damage = damage * (self:GetParent():FindTalentValue("special_bonus_unique_ghost_2") or 1) end 

                local duration = self:GetAbility():GetSpecialValueFor("damage_drain_duration") 
                if self:GetParent():HasTalent("special_bonus_unique_ghost_1") then duration = duration + (self:GetParent():FindTalentValue("special_bonus_unique_ghost_1") or 1) end 

                if self:GetParent():HasModifier("modifier_ghost_fate_damage") then
                    local mod = self:GetParent():FindModifierByName("modifier_ghost_fate_damage")

                    mod:SetStackCount(mod:GetStackCount() + math.floor(damage))
                else 
                    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ghost_fate_damage", {duration = duration}):SetStackCount(math.floor(damage))
                end 

                local nFXIndex = ParticleManager:CreateParticle( "particles/ghost/fate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true);
                ParticleManager:ReleaseParticleIndex( nFXIndex );
            end  
        end
    end
end


if modifier_ghost_fate_damage == nil then modifier_ghost_fate_damage = class ( {}) end

function modifier_ghost_fate_damage:IsPurgable()
  return false
end

function modifier_ghost_fate_damage:IsHidden()
  return false
end

function modifier_ghost_fate_damage:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ghost_fate_damage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_ghost_fate_damage:GetModifierPreAttack_BonusDamage (params)
    return self:GetStackCount()
end
