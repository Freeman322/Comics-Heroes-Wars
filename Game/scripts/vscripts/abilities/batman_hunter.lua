batman_hunter = class({})
LinkLuaModifier( "modifier_batman_hunter", "abilities/batman_hunter.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function batman_hunter:GetIntrinsicModifierName()
	return "modifier_batman_hunter"
end

function batman_hunter:OnSpellStart(params)
	local ability = self
	local duration = 15

	if self:GetCaster():HasTalent("special_bonus_unique_batman_2") then
        duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_batman_2")
  	end

	-- Time variables
	local time_flow = 0.0020833333
	local time_elapsed = 0
	-- Calculating what time of the day will it be after Darkness ends
	local start_time_of_day = GameRules:GetTimeOfDay()
	local end_time_of_day = start_time_of_day + duration * time_flow

	if end_time_of_day >= 1 then end_time_of_day = end_time_of_day - 1 end

	-- Setting it to the middle of the night
	GameRules:SetTimeOfDay(0)

	-- Using a timer to keep the time as middle of the night and once Darkness is over, normal day resumes
	Timers:CreateTimer(1, function()
		if time_elapsed < duration then
			GameRules:SetTimeOfDay(0)
			time_elapsed = time_elapsed + 1
			return 1
		else
			GameRules:SetTimeOfDay(end_time_of_day)
			return nil
		end
	end)
end

if modifier_batman_hunter == nil then modifier_batman_hunter = class({}) end


function modifier_batman_hunter:IsPurgable()
	return false
end

function modifier_batman_hunter:IsHidden()
	return false
end

function modifier_batman_hunter:OnCreated(table)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_batman_hunter:OnIntervalThink()
	if IsServer() then
		if not GameRules:IsDaytime() then
			self:SetStackCount(1)
		else
			self:SetStackCount(0)
		end
	end
end

function modifier_batman_hunter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end


function modifier_batman_hunter:GetEffectName()
	if self:GetStackCount() == 1 then
		return "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8_body_glow.vpcf"
	end 

	return
end

function modifier_batman_hunter:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_batman_hunter:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetStackCount() == 1 then
		return self:GetAbility():GetSpecialValueFor("bonus_movement_speed_pct_night")
	end
	return
end

function modifier_batman_hunter:GetModifierAttackSpeedBonus_Constant(params)
	if self:GetStackCount() == 1 then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed_night")
	end
	return
end

function batman_hunter:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

