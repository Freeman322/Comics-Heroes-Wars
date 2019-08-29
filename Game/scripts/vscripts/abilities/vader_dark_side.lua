vader_dark_side = class({})

LinkLuaModifier( "modifier_vader_dark_side", "abilities/vader_dark_side.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vader_dark_side_leak", "abilities/vader_dark_side.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function vader_dark_side:GetIntrinsicModifierName()
	return "modifier_vader_dark_side"
end

function vader_dark_side:OnHeroDiedNearby( hVictim, hKiller, kv )
	if hVictim == nil or hKiller == nil then
		return
	end

	if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
		local vToCaster = self:GetCaster():GetOrigin() - hVictim:GetOrigin()
		local flDistance = vToCaster:Length2D()
		if hKiller == self:GetCaster() or 400 >= flDistance then
			if self:GetCaster():HasModifier("modifier_vader") then
				local mod = self:GetCaster():FindModifierByName("modifier_vader")
				mod:SetStackCount(mod:GetStackCount() + 1)
				local mod2 = self:GetCaster():FindModifierByName("modifier_vader_dark_side")
				mod2:ForceRefresh()
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end

modifier_vader_dark_side = class({})

function modifier_vader_dark_side:IsAura()
	return false
end

function modifier_vader_dark_side:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_vader_dark_side:OnCreated()
	self.bonus = 0;
	if IsServer() then
				self:StartIntervalThink(1)
    end
end

function modifier_vader_dark_side:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_vader") then
				local mod = self:GetCaster():FindModifierByName("modifier_vader")
				self.bonus = mod:GetStackCount()
		end
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 0, false )

		local damage = (self:GetAbility():GetLevel() * 3) + self.bonus
		for _, enemy in pairs(units) do
			enemy:SetMana(enemy:GetMana() - damage)
			self:GetAbility():GetCaster():SetMana(self:GetCaster():GetMana() + damage)
			ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = enemy, ability = self:GetAbility(), damage = damage*2, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS})
		end
	end
end

function modifier_vader_dark_side:GetModifierMagicalResistanceBonus( params )
	return self.bonus
end

function vader_dark_side:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

