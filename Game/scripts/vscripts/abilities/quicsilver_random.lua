if quicsilver_random == nil then quicsilver_random = class({}) end
LinkLuaModifier( "modifier_quicsilver_random", "abilities/quicsilver_random.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function quicsilver_random:GetIntrinsicModifierName()
	return "modifier_quicsilver_random"
end

if modifier_quicsilver_random == nil then modifier_quicsilver_random = class({}) end

function modifier_quicsilver_random:IsHidden ()
    return true
end

function modifier_quicsilver_random:IsPurgable()
	return false
end

function modifier_quicsilver_random:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
    }

    return funcs
end

function modifier_quicsilver_random:OnAbilityFullyCast( params )
	 if params.unit == self:GetParent() then
		 if RollPercentage(self:GetAbility():GetSpecialValueFor("refresh_chance_pct")) then
		 	if params.ability:IsItem() then
		 		return nil
		 	end
			if params.ability:GetAbilityName() == "quicsilver_abstract_run" then
				return nil
			end
		 	params.ability:EndCooldown()
		 	local nFXIndex = ParticleManager:CreateParticle ("particles/refresh_2.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent());
		    ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true);
		    ParticleManager:ReleaseParticleIndex (nFXIndex);
		    EmitSoundOn ("DOTA_Item.Refresher.Activate", self:GetParent())
		 end
	end
end

function quicsilver_random:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

