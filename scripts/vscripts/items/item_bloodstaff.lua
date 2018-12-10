LinkLuaModifier("modifier_item_bloodstaff", "items/item_bloodstaff.lua", LUA_MODIFIER_MOTION_NONE)

if item_bloodstaff == nil then item_bloodstaff = class({}) end

function item_bloodstaff:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function item_bloodstaff:GetIntrinsicModifierName()
	return "modifier_item_bloodstaff"
end

function item_bloodstaff:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local base_damage = self:GetSpecialValueFor("tooltip_damage")
			local stats = self:GetCaster():GetIntellect() + self:GetCaster():GetStrength() + self:GetCaster():GetAgility()
			local mult = self:GetSpecialValueFor("blast_stats_multiplier")
			local damage = base_damage + (stats * mult)

			ApplyDamage ( {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
                damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			})
			
			EmitSoundOn( "DOTA_Item.MedallionOfCourage.Activate", self:GetCaster() )
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 3, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 4, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end
end

if modifier_item_bloodstaff == nil then modifier_item_bloodstaff = class({}) end

function modifier_item_bloodstaff:IsHidden()
	return true
end

function modifier_item_bloodstaff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
    }

    return funcs
end

function modifier_item_bloodstaff:OnTakeDamageKillCredit( params )
    if IsServer() then
        if params.inflictor and params.attacker == self:GetParent()	then 
			local damage = (params.damage * (self:GetAbility():GetSpecialValueFor("magical_vampirism") / 100))

			self:GetParent():Heal(damage, self:GetAbility())

			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_HEAL , self:GetParent(), math.floor( damage ), nil )
        end 
    end 
end


function modifier_item_bloodstaff:GetModifierBonusStats_Strength( params )
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_bloodstaff:GetModifierBonusStats_Agility( params )
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_bloodstaff:GetModifierBonusStats_Intellect( params )
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_bloodstaff:GetModifierTotalDamageOutgoing_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("spell_amp_bonus")
end

function modifier_item_bloodstaff:GetModifierPercentageCooldown( params )
	return self:GetAbility():GetSpecialValueFor("cooldown_reduction_bonus")
end

function modifier_item_bloodstaff:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

