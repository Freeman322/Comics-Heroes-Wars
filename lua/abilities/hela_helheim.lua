hela_helheim = class({})
LinkLuaModifier( "modifier_hela_helheim", "abilities/hela_helheim.lua", LUA_MODIFIER_MOTION_NONE )

function hela_helheim:OnHeroDiedNearby( hVictim, hKiller, kv )
	if hVictim == nil or hKiller == nil then
		return
	end

	if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
		if hKiller == self:GetCaster() then
			if self.nKills == nil then
				self.nKills = 0
			end

			self.nKills = self.nKills + 1

			local hBuff = self:GetCaster():FindModifierByName( "modifier_hela_helheim" )
			if hBuff ~= nil then
				hBuff:SetStackCount( self.nKills )
				self:GetCaster():CalculateStatBonus()
				hBuff:ForceRefresh()
			else
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hela_helheim", nil)
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )


			EmitSoundOn("Hero_DarkWillow.Shadow_Realm.Damage", hKiller)
		end
	end
end

function hela_helheim:OnOwnerDied()
	if IsServer() then 
		self.nKills = 0
	end	
end

--------------------------------------------------------------------------------

function hela_helheim:GetKills()
	if self.nKills == nil then
		self.nKills = 0
	end
	return self.nKills
end


modifier_hela_helheim = class ( {})


function modifier_hela_helheim:IsHidden()
    return true
end

function modifier_hela_helheim:RemoveOnDeath()
    return true
end

function modifier_hela_helheim:IsPurgable()
    return false
end

function modifier_hela_helheim:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_hela_helheim:GetEffectName()
    return "particles/hela/helheim_effect.vpcf"
end

function modifier_hela_helheim:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hela_helheim:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
	return funcs
end

function modifier_hela_helheim:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_kill") * self:GetStackCount()
end

function modifier_hela_helheim:GetModifierSpellAmplify_Percentage( params )
    return self:GetAbility():GetSpecialValueFor( "spell_amp_per_kill" ) * self:GetStackCount()
end
