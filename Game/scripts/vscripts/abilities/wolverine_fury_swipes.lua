LinkLuaModifier ("modifier_wolverine_fury_swipes", "abilities/wolverine_fury_swipes.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_wolverine_fury_swipes_cooldown", "abilities/wolverine_fury_swipes.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_wolverine_fury_swipes_debuff", "abilities/wolverine_fury_swipes.lua", LUA_MODIFIER_MOTION_NONE )

wolverine_fury_swipes = class({})

function wolverine_fury_swipes:GetIntrinsicModifierName ()
    return "modifier_wolverine_fury_swipes"
end

if modifier_wolverine_fury_swipes == nil then
     modifier_wolverine_fury_swipes = class ( {})
end

function modifier_wolverine_fury_swipes:IsHidden() return true end
function modifier_wolverine_fury_swipes:IsPurgable() return false end


function modifier_wolverine_fury_swipes:DeclareFunctions ()
    return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_wolverine_fury_swipes:OnAttackLanded(params)
    if IsServer () then
          if params.attacker == self:GetParent () then
               local chance = self:GetAbility():GetSpecialValueFor ("rupture_chance")
               if RollPercentage(chance) and not self:GetParent():HasModifier("modifier_wolverine_fury_swipes_cooldown") then
                    self:GetParent():AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_wolverine_fury_swipes_cooldown", {duration = self:GetAbility():GetSpecialValueFor("rupture_duration")})
                    params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_bloodseeker_rupture", {duration = self:GetAbility():GetSpecialValueFor("rupture_duration")})
               end 

               local debuff = params.target:FindModifierByName("modifier_wolverine_fury_swipes_debuff")
               if params.target:IsBuilding() then
                    return 
               else
               
               if debuff then
                    if debuff:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
                         debuff:SetStackCount(debuff:GetStackCount() + 1)
                    end
                         if debuff:GetStackCount() == self:GetAbility():GetSpecialValueFor("max_stacks") then
                              debuff:SetStackCount(debuff:GetStackCount())
                    end
               else 
                    params.target:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_wolverine_fury_swipes_debuff", {duration = self:GetAbility():GetSpecialValueFor("debuff_duration")}):SetStackCount(1)
               end
          end
    end
end

    return 0
end


if modifier_wolverine_fury_swipes_debuff == nil then
     modifier_wolverine_fury_swipes_debuff = class ( {})
end

function modifier_wolverine_fury_swipes_debuff:IsHidden() return false end
function modifier_wolverine_fury_swipes_debuff:RemoveOnDeath() return true end


function modifier_wolverine_fury_swipes_debuff:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_wolverine_fury_swipes_debuff:GetModifierPhysicalArmorBonus (params)
    return (-1) * self:GetAbility():GetSpecialValueFor ("armor_reduction") * self:GetStackCount()
end

function modifier_wolverine_fury_swipes_debuff:OnStackCountChanged(iStackCount)
     self:SetDuration(self:GetAbility():GetSpecialValueFor ("debuff_duration"), true)
end

function modifier_wolverine_fury_swipes_debuff:GetEffectName()
     return "particles/econ/items/sand_king/sandking_ti7_arms/sandking_ti7_caustic_finale_debuff.vpcf"
end

function modifier_wolverine_fury_swipes_debuff:GetEffectAttachType()
     return PATTACH_ABSORIGIN_FOLLOW
end
 
if modifier_wolverine_fury_swipes_cooldown == nil then
     modifier_wolverine_fury_swipes_cooldown = class ( {})
end

function modifier_wolverine_fury_swipes_cooldown:IsPurgable()return false end
function modifier_wolverine_fury_swipes_cooldown:IsHidden() return true end
 