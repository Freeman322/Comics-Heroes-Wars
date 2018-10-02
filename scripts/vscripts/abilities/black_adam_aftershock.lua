if black_adam_aftershock == nil then
    black_adam_aftershock = class({})
end
LinkLuaModifier( "black_adam_aftershock_passive", "abilities/black_adam_aftershock.lua", LUA_MODIFIER_MOTION_NONE )
function black_adam_aftershock:GetBehavior()
    local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
    return behav
end

function black_adam_aftershock:GetIntrinsicModifierName()
    return "black_adam_aftershock_passive"
end

function black_adam_aftershock:OnSpellStart()
	if IsServer() then
		--DeepPrintTable(params)
		local hAbility = self
        local mod
        if self:GetCaster():HasModifier("black_adam_aftershock_passive") then
            mod = self:GetCaster():FindModifierByName("black_adam_aftershock_passive")
        end
		local iAoE = hAbility:GetSpecialValueFor( "aftershock_range" )
		local fDuration = hAbility:GetSpecialValueFor( "tooltip_duration" )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		--ParticleManager:SetParticleControl( nFXIndex, 1, Vector( hAbility:GetSpecialValueFor( "aftershock_range" ), 1, 1 ) )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( iAoE, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )


		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), iAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
            mod:SetStackCount(mod:GetStackCount() + #enemies)
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = hAbility:GetAbilityDamage() + (3*mod:GetStackCount()),
						damage_type = hAbility:GetAbilityDamageType(),
						ability = self
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = fDuration } )
				end
			end
		end
	end
end

if black_adam_aftershock_passive == nil then
    black_adam_aftershock_passive = class({})
end

function black_adam_aftershock_passive:IsPurgable()
    return false
end

function black_adam_aftershock_passive:IsHidden()
    return true
end

function black_adam_aftershock_passive:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function black_adam_aftershock:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

