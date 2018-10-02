if ebonymaw_hazard == nil then ebonymaw_hazard = class({}) end

LinkLuaModifier ("modifier_ebonymaw_hazard", "abilities/ebonymaw_hazard.lua", LUA_MODIFIER_MOTION_NONE)

function ebonymaw_hazard:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function ebonymaw_hazard:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "hazard_duration" )
    if self:GetCaster():HasTalent("special_bonus_unique_ebonymaw_1") then 
        duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_ebonymaw_1")
    end

	local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #targets > 0 then
		for _,target in pairs(targets) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_ebonymaw_hazard", { duration = duration } )
			ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetSpecialValueFor("damage"), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end

    EmitSoundOn("Hero_MonkeyKing.Spring.Impact", self:GetCaster())
    EmitSoundOn("Hero_MonkeyKing.Spring.Water", self:GetCaster())
    EmitSoundOn("Hero_MonkeyKing.Spring.Impact.Water", self:GetCaster())
    EmitSoundOn("Hero_MonkeyKing.FurArmy.End", self:GetCaster())

    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ebony/ebonymaw_hazard.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor( "radius" ), self:GetSpecialValueFor( "radius" ), 0) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
end

if modifier_ebonymaw_hazard == nil then modifier_ebonymaw_hazard = class({}) end

function modifier_ebonymaw_hazard:IsHidden()
    return false
end

function modifier_ebonymaw_hazard:IsBuff()
    return false
end

function modifier_ebonymaw_hazard:GetStatusEffectName()
    return "particles/status_fx/status_effect_necrolyte_spirit.vpcf"
end

function modifier_ebonymaw_hazard:StatusEffectPriority()
    return 1000
end

function modifier_ebonymaw_hazard:GetEffectName()
    return "particles/hero_ebony/ebonymaw_false_predict.vpcf"
end

function modifier_ebonymaw_hazard:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ebonymaw_hazard:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_ebonymaw_hazard:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent()
        local hAbility = self:GetAbility()
        local base_damage = ((self:GetAbility():GetSpecialValueFor("hazard_damage") / 100) * thinker:GetMaxHealth())
        local mult = self:GetAbility():GetSpecialValueFor("hazard_mult_creture")

        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), thinker:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
        if #targets > 0 then
           mult = mult * #targets
        end
        ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = base_damage * mult, ability = hAbility, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end
