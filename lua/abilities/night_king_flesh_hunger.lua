LinkLuaModifier("modifier_night_king_flesh_hunger", "abilities/night_king_flesh_hunger.lua", LUA_MODIFIER_MOTION_NONE)
night_king_flesh_hunger = class({})

function night_king_flesh_hunger:GetIntrinsicModifierName()
	return "modifier_night_king_flesh_hunger"
end

if modifier_night_king_flesh_hunger == nil then modifier_night_king_flesh_hunger = class({}) end

function modifier_night_king_flesh_hunger:IsHidden ()
    return true
end

function modifier_night_king_flesh_hunger:IsPurgable()
    return false
end

function modifier_night_king_flesh_hunger:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end


function modifier_night_king_flesh_hunger:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
						for k,v in pairs(params) do
							print(k,v)
						end
            local target = params.target
            if target:IsAncient() or target:IsBuilding() then
                return nil
            end
            self:GetParent():Heal(params.damage*(self:GetAbility():GetSpecialValueFor("heal")/100), self:GetAbility())
            local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
            local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
            ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
        end
    end

    return 0
end

function night_king_flesh_hunger:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

