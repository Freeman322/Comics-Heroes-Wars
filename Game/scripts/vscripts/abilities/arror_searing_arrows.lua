if arror_searing_arrows == nil then arror_searing_arrows = class({}) end
LinkLuaModifier( "modifier_arror_searing_arrows",	"abilities/arror_searing_arrows.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arror_searing_arrows_target",	"abilities/arror_searing_arrows.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function arror_searing_arrows:GetIntrinsicModifierName()
  return "modifier_arror_searing_arrows"
end

function arror_searing_arrows:OnSpellStart()
  if IsServer() then
    
  end
end

if modifier_arror_searing_arrows == nil then
    modifier_arror_searing_arrows = class ( {})
end

function modifier_arror_searing_arrows:IsHidden ()
  return true
end

function modifier_arror_searing_arrows:IsPurgable()
  return false
end

function modifier_arror_searing_arrows:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_arror_searing_arrows:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
                if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
                if not params.target:HasModifier("modifier_arror_searing_arrows_target") then params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_arror_searing_arrows_target", {duration = 10}):IncrementStackCount() end 
                
                local mod = params.target:FindModifierByName("modifier_arror_searing_arrows_target")
                local stacks = mod:GetStackCount()

                if PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID()) ~= 77291876 then stacks = 1 end 

                ApplyDamage({victim = params.target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage_bonus") * stacks, damage_type = DAMAGE_TYPE_PHYSICAL})

                self:GetAbility():PayManaCost()

                mod:IncrementStackCount()
  
                EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", params.target)
                EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)
            end
        end
    end
end

return 0
end



if modifier_arror_searing_arrows_target == nil then modifier_arror_searing_arrows_target = class({}) end
function modifier_arror_searing_arrows_target:IsHidden() return true end
function modifier_arror_searing_arrows_target:IsPurgable() return false end
function modifier_arror_searing_arrows_target:RemoveOnDeath() return false end
function modifier_arror_searing_arrows_target:DestroyOnExpire() return true end 