LinkLuaModifier ("modifier_bolt_passive", "abilities/bolt_passive.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_bolt_passive_dummy", "abilities/bolt_passive.lua", LUA_MODIFIER_MOTION_NONE)

bolt_passive = class({})

function bolt_passive:GetIntrinsicModifierName()
	return "modifier_bolt_passive"
end

modifier_bolt_passive = class({})

function modifier_bolt_passive:IsHidden()
	return true
end

function modifier_bolt_passive:OnCreated(htable)
   	if IsServer() then
        self:StartIntervalThink(1)
    end
end


function modifier_bolt_passive:OnIntervalThink()
    if IsServer () then
        local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
        if #units > 0 then
            for _,target in pairs(units) do
				if target then
					if target:HasModifier("modifier_bolt_passive_dummy") then
						return
					end
					if not target:IsMagicImmune() and self:GetParent():IsAlive() then
						target:AddNewModifier( self:GetCaster(), self, "modifier_bolt_passive_dummy", { duration = 3.5 } )
						target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor("duration") } )
						ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbility():GetAbilityDamage(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL})
   					break
					end
				end
			end
        end
    end
    return 0
end
modifier_bolt_passive_dummy = class({})

function modifier_bolt_passive_dummy:IsHidden()
	return true
end

function modifier_bolt_passive_dummy:IsPurgable()
	return false
end

function bolt_passive:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

