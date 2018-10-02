LinkLuaModifier ("modifier_beast_jinada", "abilities/beast_jinada.lua", LUA_MODIFIER_MOTION_NONE)

beast_jinada = class({})

function beast_jinada:GetIntrinsicModifierName()
	return "modifier_beast_jinada"
end

function beast_jinada:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_beast_arcana") then
		return "custom/beast_jinada_arcana"
	end
	return "custom/beast_passive"
end


modifier_beast_jinada = class({})

function modifier_beast_jinada:IsHidden()
	return true
end

function modifier_beast_jinada:RemoveOnDeath()
	return false
end

function modifier_beast_jinada:IsPurgable()
    return false
end

function modifier_beast_jinada:OnCreated(htable)
    if IsServer then
        self.killed_creeps = 0
    end
end

function modifier_beast_jinada:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_beast_jinada:OnAttackLanded(params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            local flDamage = self:GetAbility():GetSpecialValueFor("creep_dmg") + ((self:GetAbility():GetSpecialValueFor("creeps_per_damage")/100) * target:GetMaxHealth())
            if self:GetParent():HasScepter() then
                flDamage = flDamage + ((self:GetAbility():GetSpecialValueFor("creeps_per_damage_scepter")/100)*target:GetMaxHealth())
            end
            if target:IsRealHero() then
                flDamage = self:GetParent():GetLastHits() / 2
            else
                if target:IsAncient() or target:IsConsideredHero() or target:IsBuilding() or target:GetUnitName() == "npc_dota_warlock_golem_1" or target:GetUnitName() == "npc_mega_greevil" then
                    flDamage = 0
                else
                    flDamage = flDamage
                end
            end
            ApplyDamage ({attacker = self:GetParent(), victim = target, ability = self:GetAbility(), damage = flDamage, damage_type = DAMAGE_TYPE_PHYSICAL })
						print(self:GetParent():HasModifier("modifier_beast_arcana"))
						if self:GetParent():HasModifier("modifier_beast_arcana") then
							local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_basher.vpcf", PATTACH_CUSTOMORIGIN, nil );
							ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
							ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true );
							ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
							ParticleManager:SetParticleControlEnt( nFXIndex, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
							ParticleManager:ReleaseParticleIndex( nFXIndex );

							EmitSoundOn( "Hero_Antimage.ManaBreak", target )
						end
        end
    end

    return 0
end
