slaanesh_obedience = class({})
LinkLuaModifier( "modifier_slaanesh_obedience_delay", "abilities/slaanesh_obedience.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slaanesh_obedience", "abilities/slaanesh_obedience.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function slaanesh_obedience:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function slaanesh_obedience:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_voland_custom") then return "custom/voland_obdience" end  
    return self.BaseClass.GetAbilityTextureName(self)  
end

function slaanesh_obedience:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            local info = {
                EffectName = "particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_meld_attack_butterfly.vpcf",
                Ability = self,
                iMoveSpeed = 1900,
                Source = self:GetCaster(),
                Target = hTarget,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile( info )
            
            EmitSoundOn( "Hero_DarkWillow.Shadow_Realm.Attack", self:GetCaster() )
        end
    end
end

--------------------------------------------------------------------------------

function slaanesh_obedience:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_slaanesh_obedience_delay", { duration = self:GetSpecialValueFor("delay") } )
	end

	return true
end

if not modifier_slaanesh_obedience_delay then modifier_slaanesh_obedience_delay = class({}) end 


function modifier_slaanesh_obedience_delay:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_debuff_energy.vpcf"
end

function modifier_slaanesh_obedience_delay:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_slaanesh_obedience_delay:IsPurgable()
	return false
end

function modifier_slaanesh_obedience_delay:OnDestroy()
    if IsServer() then 
        local radius = self:GetAbility():GetSpecialValueFor( "radius" ) 
        local duration = self:GetAbility():GetSpecialValueFor(  "duration" )

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _, target in pairs(units) do
                target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_slaanesh_obedience", { duration = duration } )
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_marker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(radius, radius, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetAbsOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        ScreenShake(self:GetParent():GetOrigin(), 100, 0.1, 0.3, 500, 0, true)
        EmitSoundOn( "Hero_DarkWillow.Ley.Stun", self:GetCaster() )
    end 
end


modifier_slaanesh_obedience = class({})

function modifier_slaanesh_obedience:IsDebuff()
	return true
end

function modifier_slaanesh_obedience:IsStunDebuff()
	return true
end

function modifier_slaanesh_obedience:GetEffectName()
	return "particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf"
end

function modifier_slaanesh_obedience:OnCreated(params)
    if IsServer() then 
        local damage_ptc = (self:GetAbility():GetSpecialValueFor("dmg_pct") / 100) * self:GetParent():GetMaxHealth()
        local bonus_damage = self:GetAbility():GetSpecialValueFor("base_dmg")

        if self:GetCaster():HasTalent("special_bonus_unique_slaanesh_1") then 
            bonus_damage = bonus_damage + self:GetCaster():FindTalentValue("special_bonus_unique_slaanesh_1")
        end 

        ApplyDamage ( { attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = bonus_damage + damage_ptc, damage_type = self:GetAbility():GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})

        EmitSoundOn("Hero_DarkWillow.WispStrike.Cast", self:GetParent())
    end 
end

function modifier_slaanesh_obedience:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_slaanesh_obedience:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

