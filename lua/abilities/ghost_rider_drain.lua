if ghost_rider_drain == nil then ghost_rider_drain = class({}) end
LinkLuaModifier("modifier_ghost_rider_drain", "abilities/ghost_rider_drain.lua", LUA_MODIFIER_MOTION_NONE)

function ghost_rider_drain:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/ghost_rider_drain_arcana"
	end
	return "custom/Demonic_Purge_icon"
end

function ghost_rider_drain:GetIntrinsicModifierName()
   return "modifier_ghost_rider_drain"
end

if modifier_ghost_rider_drain == nil then modifier_ghost_rider_drain = class({}) end

function modifier_ghost_rider_drain:IsHidden()
   return true
end

function modifier_ghost_rider_drain:IsPurgable()
  return false
end

function modifier_ghost_rider_drain:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_ghost_rider_drain:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
  			if self:GetParent():PassivesDisabled() then
  				return 0
  			end
			  local target = params.target
        if target:IsHero() then
      			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                local patricle = "particles/econ/items/spectre/spectre_weapon_diffusal/spectre_desolate_diffusal.vpcf"
                if self:GetCaster():HasModifier("modifier_arcana") then
                  patricle = "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_basher.vpcf"
                end
        				target:SetMana(target:GetMana() - self:GetAbility():GetSpecialValueFor("mana_per_hit"))
                ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbility():GetSpecialValueFor("mana_per_hit"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
                local nFXIndex = ParticleManager:CreateParticle( patricle, PATTACH_CUSTOMORIGIN, target );
            		ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

            		EmitSoundOn( "Hero_Antimage.ManaBreak", target )
            end
        end
		end
	end

	return 0
end
