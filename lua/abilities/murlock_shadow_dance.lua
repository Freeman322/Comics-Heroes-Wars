LinkLuaModifier( "modifier_murlock_shadow_dance", "abilities/murlock_shadow_dance.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_murlock_shadow_dance_illusion", "abilities/murlock_shadow_dance.lua", LUA_MODIFIER_MOTION_NONE )

if murlock_shadow_dance == nil then murlock_shadow_dance = class({}) end

function murlock_shadow_dance:GetIntrinsicModifierName()
    return "modifier_murlock_shadow_dance"
end

if modifier_murlock_shadow_dance == nil then modifier_murlock_shadow_dance = class({}) end

function modifier_murlock_shadow_dance:IsPurgable()
	return false
end

function modifier_murlock_shadow_dance:IsHidden()
	return true
end

function modifier_murlock_shadow_dance:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_murlock_shadow_dance:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() and self:GetParent():IsRealHero() then
        	if self:GetAbility():IsCooldownReady() then
	            local target = params.attacker
	            if target == self:GetParent() then
	                return
	            end
	            local damage = params.damage
	            if RollPercentage(self:GetAbility():GetSpecialValueFor("chance_pct")) then
	            	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
	            	local caster = self:GetParent()
		            EmitSoundOn("Hero_Terrorblade.Reflection", self:GetParent())
		            EmitSoundOn("Hero_Terrorblade.ConjureImage", self:GetParent())

		            local player_id = caster:GetPlayerID()
					local caster_team = caster:GetTeam()

					local illusion = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin(), true, caster, caster, caster_team)  --handle_UnitOwner needs to be nil, or else it will crash the game.
					illusion:SetPlayerID(player_id)

					local caster_level = caster:GetLevel()
					for i = 1, caster_level - 1 do
						illusion:HeroLevelUp(false)
					end

					illusion:SetAbilityPoints(0)
					for ability_slot = 0, 15 do
						local individual_ability = caster:GetAbilityByIndex(ability_slot)
						if individual_ability ~= nil then
							local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
							if illusion_ability ~= nil then
								illusion_ability:SetLevel(individual_ability:GetLevel())
							end
						end
					end

					--Recreate the caster's items for the illusion.
					for item_slot = 0, 5 do
						local individual_item = caster:GetItemInSlot(item_slot)
						if individual_item ~= nil then
							local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
							illusion:AddItem(illusion_duplicate_item)
						end
					end

					-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
					illusion:AddNewModifier(caster, self:GetAbility(), "modifier_illusion", {duration = self:GetAbility():GetSpecialValueFor("illusion_duration"), outgoing_damage = self:GetAbility():GetSpecialValueFor("outgoing_damage"), incoming_damage = self:GetAbility():GetSpecialValueFor("incoming_damage")})
					illusion:AddNewModifier(caster, self:GetAbility(), "modifier_murlock_shadow_dance_illusion", {duration = self:GetAbility():GetSpecialValueFor("illusion_duration")})
					illusion:AddNewModifier(caster, self:GetAbility(), "modifier_kill", {duration = self:GetAbility():GetSpecialValueFor("illusion_duration")})
					if params.attacker ~= nil then
						local order_caster =
						{
							UnitIndex = illusion:entindex(),
							OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
							TargetIndex = params.attacker:entindex()
						}

						params.attacker:Stop()
						ExecuteOrderFromTable(order_caster)

						illusion:SetForceAttackTarget(params.attacker)
					end

					illusion:MakeIllusion()
		        end
		    end
        end
    end
end

if modifier_murlock_shadow_dance_illusion == nil then modifier_murlock_shadow_dance_illusion = class({}) end

function modifier_murlock_shadow_dance_illusion:IsHidden(  )
    return true
end

function modifier_murlock_shadow_dance_illusion:IsPurgable(  )
    return false
end

function modifier_murlock_shadow_dance_illusion:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_murlock_shadow_dance_illusion:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_murlock_shadow_dance_illusion:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

--------------------------------------------------------------------------------

function modifier_murlock_shadow_dance_illusion:StatusEffectPriority()
	return 1000
end


function modifier_murlock_shadow_dance_illusion:CheckState()
	local state = {
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}

	return state
end

function murlock_shadow_dance:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

