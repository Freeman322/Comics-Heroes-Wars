hela_helheim = class({})
LinkLuaModifier( "modifier_hela_helheim", "abilities/hela_helheim.lua", LUA_MODIFIER_MOTION_NONE )

function hela_helheim:GetIntrinsicModifierName() return "modifier_hela_helheim" end

function hela_helheim:OnDied(modifier)
    if IsServer() then
        if self:GetCaster():HasTalent("special_bonus_unique_hela_3") then
			modifier:SetStackCount(modifier:GetStackCount() / 2)
		else
			modifier:SetStackCount(1)
		end
    end
end

modifier_hela_helheim = class ( {})

function modifier_hela_helheim:IsHidden() return true end
function modifier_hela_helheim:RemoveOnDeath() return false end
function modifier_hela_helheim:IsPurgable() return false end
function modifier_hela_helheim:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_hela_helheim:GetEffectName() return "particles/econ/events/ti7/fountain_regen_ti7.vpcf" end
function modifier_hela_helheim:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_hela_helheim:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
	return funcs
end

function modifier_hela_helheim:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetAbility():OnDied(self)
		end
	end
end

function modifier_hela_helheim:OnHeroKilled(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetCaster():CalculateStatBonus()
			self:ForceRefresh()

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn("Hero_DarkWillow.Shadow_Realm.Damage", self:GetParent())

			self:IncrementStackCount()
		end
	end
end

function modifier_hela_helheim:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_kill") * self:GetStackCount()
end

function modifier_hela_helheim:GetModifierSpellAmplify_Percentage( params )
    return self:GetAbility():GetSpecialValueFor( "spell_amp_per_kill" ) * self:GetStackCount()
end
