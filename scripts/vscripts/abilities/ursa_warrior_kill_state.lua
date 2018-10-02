if ursa_warrior_kill_state == nil then ursa_warrior_kill_state = class({}) end

function ursa_warrior_kill_state:GetCooldown( nLevel )
    if self:GetCaster():HasModifier("modifier_special_bonus_unique_ursa_warrior") then
        return 0
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function ursa_warrior_kill_state:GetBehavior()
    if self:GetCaster():HasModifier("modifier_special_bonus_unique_ursa_warrior") then
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function ursa_warrior_kill_state:GetIntrinsicModifierName()
	if self:GetCaster():HasModifier("modifier_special_bonus_unique_ursa_warrior") then
	    return "modifier_alchemist_chemical_rage"
	end
	return
end

function ursa_warrior_kill_state:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "duration" ) + (GameRules:GetGameTime()/60)


	if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior") then
        duration = 99999
    end

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_alchemist_chemical_rage", { duration = duration } )


	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Alchemist.ChemicalRage.Cast", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

function ursa_warrior_kill_state:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

