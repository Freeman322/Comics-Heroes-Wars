if diablo_fire_dissipation == nil then diablo_fire_dissipation = class({}) end
LinkLuaModifier( "modifier_diablo_fire_dissipation", "abilities/diablo_fire_dissipation.lua", LUA_MODIFIER_MOTION_NONE )

function diablo_fire_dissipation:OnSpellStart()
	local duration = self:GetSpecialValueFor( "tooltip_duration" )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_diablo_fire_dissipation", { duration = duration } )

	EmitSoundOn( "Hero_Phoenix.SunRay.Cast.Immortal", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

if modifier_diablo_fire_dissipation == nil then modifier_diablo_fire_dissipation = class({}) end

function modifier_diablo_fire_dissipation:IsPurgable()
	return false
end

function modifier_diablo_fire_dissipation:OnCreated(table)
    if IsServer() then
        local effect = "particles/hero_diablo/diablo_fire_dissipation.vpcf"
        local soundEffect = "Hero_Phoenix.SunRay.Beam"
        local soundEffectLoop = "Hero_Phoenix.SunRay.Loop"

        if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "freeza") == true then 
            effect = "particles/freeza/diablo_fire_dissipation.vpcf" 
            soundEffect = "Freeza.Cast1"
        end 

		self.nFXIndex = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, self:GetCaster():GetAbsOrigin().z+96)+(self:GetCaster():GetForwardVector():Normalized()*1200))
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 4, Vector(1000, 1000, 1) )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, false, true )

        self:StartIntervalThink(0.05)
        
		EmitSoundOn (soundEffect, self:GetCaster())
        StartSoundEvent (soundEffectLoop, self:GetCaster())
	end
end

function modifier_diablo_fire_dissipation:GetStatusEffectName ()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end


function modifier_diablo_fire_dissipation:StatusEffectPriority ()
    return 1000
end

function modifier_diablo_fire_dissipation:GetHeroEffectName ()
    return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end


function modifier_diablo_fire_dissipation:HeroEffectPriority ()
    return 100
end


function modifier_diablo_fire_dissipation:CheckState ()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

function modifier_diablo_fire_dissipation:OnIntervalThink ()
    if IsServer () then
        local caster = self:GetParent()
        local hp_cost = self:GetAbility():GetSpecialValueFor("hp_perc_dmg")/100
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z+96)+(caster:GetForwardVector():Normalized()*1200))
        local side_units = FindUnitsInLine(caster:GetTeam (), caster:GetAbsOrigin(), caster:GetAbsOrigin()+(caster:GetForwardVector():Normalized()*1200), nil, 128, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
        for i=1, #side_units do
            local targets = side_units[i]
            local damage = (targets:GetMaxHealth()*hp_cost)/10
            ApplyDamage({attacker = caster, victim = targets, ability = self:GetAbility(), damage = damage , damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
        end
    end
end

function modifier_diablo_fire_dissipation:OnDestroy (kv)
    if IsServer () then
        local target = self:GetParent ()
        StopSoundEvent ("Hero_Phoenix.SunRay.Loop", target)
        EmitSoundOn ("Hero_Phoenix.SunRay.Stop", target)
    end
end

function diablo_fire_dissipation:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
