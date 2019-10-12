marvel_quantum_fier = class({})

LinkLuaModifier( "modifier_marvel_quantum_fier", "abilities/marvel_quantum_fier.lua", LUA_MODIFIER_MOTION_NONE )

function marvel_quantum_fier:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function marvel_quantum_fier:OnSpellStart()
	if IsServer() then 
		local duration = self:GetSpecialValueFor("duration")
		if self:GetCaster():HasTalent("special_bonus_unique_marvel") then 
            duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_marvel")
        end
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_marvel_quantum_fier", {duration = duration})
	end 
end

if modifier_marvel_quantum_fier == nil then modifier_marvel_quantum_fier = class({}) end 

function modifier_marvel_quantum_fier:IsHidden()
	return false
end

function modifier_marvel_quantum_fier:IsPurgable()
	return false
end

function modifier_marvel_quantum_fier:RemoveOnDeath()
	return true
end

function modifier_marvel_quantum_fier:OnCreated(table)
	if IsServer() then

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "jiren") == true then
			EmitSoundOn("Jiren.Custom.Cast", self:GetCaster())

			local nFXIndex = ParticleManager:CreateParticle("particles/hero_marvel/quantum_fier_custom.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControl( nFXIndex, 3, Vector(300, 300, 0) );
			ParticleManager:SetParticleControl( nFXIndex, 9, Vector(300, 300, 0) );
			self:AddParticle(nFXIndex, false, false, -1, false, false)

			self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_6)
		else 
			EmitSoundOn("Marvel.Ult.Cast", self:GetCaster())

			local nFXIndex = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8_eyes.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetCaster():GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetCaster():GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetCaster():GetOrigin(), true );
			self:AddParticle(nFXIndex, false, false, -1, false, false)
	
			local nFXIndex1 = ParticleManager:CreateParticle("particles/hero_marvel/quantum_fier.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControl( nFXIndex1, 3, Vector(300, 300, 0) );
			ParticleManager:SetParticleControl( nFXIndex1, 9, Vector(300, 300, 0) );
			self:AddParticle(nFXIndex1, false, false, -1, false, false)
		end 

		self._hUnits = {}
	end
end

function modifier_marvel_quantum_fier:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_marvel_quantum_fier:GetModifierDamageOutgoing_Percentage( params )
   return self:GetAbility():GetSpecialValueFor("bonus_damage_outgoing")
end

function modifier_marvel_quantum_fier:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker

            if not target:IsRealHero() then return end

            self._hUnits[target] = (self._hUnits[target] or 0) + params.damage
        end
    end
end

function modifier_marvel_quantum_fier:OnDestroy()
	if IsServer() then
		if self._hUnits then 
			for unit, damage in pairs(self._hUnits) do
				if unit and damage then 
					ApplyDamage ( {
		                victim = unit,
		                attacker = self:GetCaster(),
		                damage = damage,
		                damage_type = DAMAGE_TYPE_PURE,
		                ability = self:GetAbility(),
		                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		            })
				end 
			end
		end 
	end
end

function modifier_marvel_quantum_fier:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_marvel_quantum_fier:StatusEffectPriority()
	return 1000
end

function modifier_marvel_quantum_fier:CheckState()
	local state = {
	[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}

	return state
end
