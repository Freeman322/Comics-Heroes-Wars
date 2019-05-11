black_panther_bleeding_blow = class({})

LinkLuaModifier ("modifier_black_panther_bleeding_blow", "abilities/black_panther_bleeding_blow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_black_panther_bleeding_blow_target", "abilities/black_panther_bleeding_blow.lua", LUA_MODIFIER_MOTION_NONE)

function black_panther_bleeding_blow:GetIntrinsicModifierName()
    return "modifier_black_panther_bleeding_blow"
end

modifier_black_panther_bleeding_blow = class ({})

function modifier_black_panther_bleeding_blow:IsHidden() return true end

function modifier_black_panther_bleeding_blow:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end


function modifier_black_panther_bleeding_blow:OnAttackLanded(params)
  if self:GetParent () == params.attacker then
    if self:GetAbility():IsCooldownReady() then
      params.target:EmitSound("Item_Desolator.Target")
      params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_black_panther_bleeding_blow_target", {duration = self:GetAbility():GetSpecialValueFor("duration")})
      self:GetAbility():StartCooldown(self:GetAbility():GetCooldown (self:GetAbility():GetLevel()))
    end
  end
end

modifier_black_panther_bleeding_blow_target = class({})

function modifier_black_panther_bleeding_blow_target:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_black_panther_bleeding_blow_target:GetTexture()
    return "black_panther_bleeding_blow"
end

function modifier_black_panther_bleeding_blow_target:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_black_panther_bleeding_blow_target:OnIntervalThink()
    if IsServer() then
        local damage = self:GetAbility ():GetSpecialValueFor ("damage_perc") / 100 * self:GetParent():GetMaxHealth()
        
        if self:GetParent():IsBuilding() then
             damage =  damage / 4
        else
             damage = damage
        end

        ApplyDamage ({ attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility (), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end
