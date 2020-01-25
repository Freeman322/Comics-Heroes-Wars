if item_soul == nil then
	item_soul = class({})
end

LinkLuaModifier("modifier_item_soul", "items/item_soul.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_daredevil_supersence", "abilities/daredevil_supersence.lua", LUA_MODIFIER_MOTION_NONE)

function item_soul:GetIntrinsicModifierName()
	return "modifier_item_soul"
end

function item_soul:OnSpellStart()
	if IsServer() then 
		local duration = self:GetSpecialValueFor(  "overseer_duration" )

		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
		if #units > 0 then
			for _,unit in pairs(units) do
				unit:AddNewModifier( self:GetCaster(), self, "modifier_daredevil_supersence", { duration = duration } )
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_ElderTitan.EchoStomp.Channel.ti7", self:GetCaster() )
		EmitSoundOn( "Hero_ElderTitan.EchoStomp.ti7", self:GetCaster() )

		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 90000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
		if #units > 0 then
			for _,unit in pairs(units) do
				unit:AddNewModifier( self:GetCaster(), self, "modifier_item_dustofappearance", { duration = duration * 3 } )
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
	end
end

if modifier_item_soul == nil then
    modifier_item_soul = class ( {})
end

function modifier_item_soul:IsHidden()
	return true
end

function modifier_item_soul:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS
	}
	return funcs
end


function modifier_item_soul:OnTakeDamage( params )
	if IsServer() then
		if self:GetCaster() == nil then
			return 0
		end

		if self:GetCaster():PassivesDisabled() then
			return 0
		end

		if self:GetCaster() ~= self:GetParent() then
			return 0
		end

		local hAttacker = params.attacker
		local hVictim = params.unit
		local fDamage = params.damage

		if hVictim ~= nil and hAttacker ~= nil and hVictim == self:GetCaster() and hAttacker:GetTeamNumber() ~= hVictim:GetTeamNumber() then
			if params.damage_type > 1 then 
				ApplyDamage ( {
	                victim = hAttacker,
	                attacker = self:GetParent(),
	                damage = fDamage * (self:GetAbility():GetSpecialValueFor("magical_damage_return") / 100),
	                damage_type = DAMAGE_TYPE_PURE,
	                ability = self:GetAbility(),
	                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
	            })
			end
		end
	end

	return 0
end

function modifier_item_soul:GetBonusDayVision (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_vision")
end

function modifier_item_soul:GetModifierBonusStats_Agility( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_soul:GetModifierBonusStats_Intellect( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_soul:GetModifierBonusStats_Strength( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_soul:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
end

function modifier_item_soul:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_item_soul:GetModifierHealthBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_hp_mp" )
end

function modifier_item_soul:GetModifierManaBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_hp_mp" )
end





