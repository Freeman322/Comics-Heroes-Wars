LinkLuaModifier("modifier_daredevil_unity_thinker",  "abilities/daredevil_unity.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_daredevil_unity_modifier", "abilities/daredevil_unity.lua", LUA_MODIFIER_MOTION_NONE)

if daredevil_unity == nil then daredevil_unity = class({}) end

function daredevil_unity:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function daredevil_unity:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function daredevil_unity:OnAbilityPhaseStart()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/hero_daredevil/daredevil_unity_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	    ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetCaster():GetAbsOrigin());
	    ParticleManager:SetParticleControl(self.nFXIndex, 3, self:GetCaster():GetAbsOrigin());
	    ParticleManager:SetParticleControl(self.nFXIndex, 4, self:GetCaster():GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex( self.nFXIndex );

	    EmitSoundOn("Hero_MonkeyKing.FurArmy.Channel", self:GetCaster())

	    self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_6 );
	end

	return true
end

function daredevil_unity:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "duration" )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_EmberSpirit.FlameGuard.Cast", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_5 );

	local point = self:GetCaster():GetAbsOrigin()
    local team_id = self:GetCaster():GetTeamNumber()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_daredevil_unity_modifier", {duration = self:GetSpecialValueFor("duration")})
    local thinker = CreateModifierThinker(caster, self, "modifier_daredevil_unity_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
end

if modifier_daredevil_unity_thinker == nil then modifier_daredevil_unity_thinker = class ({}) end

function modifier_daredevil_unity_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = thinker:GetAbsOrigin()

        self.radius = ability:GetSpecialValueFor("radius")


        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_daredevil/daredevil_unity.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("duration"), self:GetAbility():GetSpecialValueFor("duration"), 0))
        ParticleManager:SetParticleControl( nFXIndex, 6, Vector(255, 255, 255))
        ParticleManager:SetParticleControl( nFXIndex, 7, target)
        self:AddParticle( nFXIndex, false, false, -1, false, true )


        EmitSoundOn("Hero_EmberSpirit.FlameGuard.Loop", thinker)
        AddFOWViewer( thinker:GetTeam(), target, self.radius, self:GetAbility():GetSpecialValueFor("duration"), false)
        GridNav:DestroyTreesAroundPoint(target, self.radius, false)

        ---self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_daredevil_unity", {duration = self:GetAbility():GetSpecialValueFor("duration")})
    	EmitSoundOn("Hero_MonkeyKing.Strike.Impact", thinker)
    end
end


function modifier_daredevil_unity_thinker:OnDestroy()
    if IsServer() then
    	StopSoundOn("Hero_EmberSpirit.FlameGuard.Loop", self:GetParent())
        EmitSoundOn("Hero_EmberSpirit.FireRemnant.Cast", self:GetParent())
    end
end

function modifier_daredevil_unity_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_thinker:GetModifierAura()
	return "modifier_daredevil_unity_modifier"
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_thinker:GetAuraRadius()
	return 500
end

if modifier_daredevil_unity_modifier == nil then modifier_daredevil_unity_modifier = class({}) end

function modifier_daredevil_unity_modifier:IsPurgable()
	return false
end

function modifier_daredevil_unity_modifier:GetHeroEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_hero_effect.vpcf"
end

function modifier_daredevil_unity_modifier:GetStatusEffectName()
	return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf"
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_modifier:StatusEffectPriority()
	return 1000
end

function modifier_daredevil_unity_modifier:HeroEffectPriority()
	return 1000
end

function modifier_daredevil_unity_modifier:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
	self.crit = 0
	if IsServer() then
		if self:GetCaster():HasTalent("special_bonus_unique_daredevil") then
	        self.crit = self:GetCaster():FindTalentValue("special_bonus_unique_daredevil")
	    end
	end
	if self:GetParent():GetUnitName() ~= "npc_dota_hero_antimage" then
		self:Destroy()
	end
end


function modifier_daredevil_unity_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_daredevil_unity_modifier:GetModifierPreAttack_BonusDamage()
	if self:GetParent():GetUnitName() == "npc_dota_hero_antimage" then
		return self.bonus_damage
	end
	return
end

function modifier_daredevil_unity_modifier:GetModifierEvasion_Constant()
	if self:GetParent():GetUnitName() == "npc_dota_hero_antimage" then
		return self.bonus_evasion
	end
	return
end

function modifier_daredevil_unity_modifier:GetModifierPreAttack_CriticalStrike()
	if self.crit ~= 0 then
		return self.crit
	end
	return
end

function daredevil_unity:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

