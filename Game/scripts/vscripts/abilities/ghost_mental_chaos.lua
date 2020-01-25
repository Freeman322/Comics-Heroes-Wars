if ghost_mental_chaos == nil then ghost_mental_chaos = class({}) end

LinkLuaModifier( "modifier_ghost_mental_chaos", "abilities/ghost_mental_chaos.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ghost_mental_chaos:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function ghost_mental_chaos:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function ghost_mental_chaos:OnSpellStart()
    if IsServer() then 
        local duration = self:GetSpecialValueFor("damage_duration")
        if self:GetCaster():HasTalent("special_bonus_unique_ghost_4") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_ghost_4") or 1) end

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("cast_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _, unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_ghost_mental_chaos", { duration = duration} )
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/ghost/mind_chaos_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() );
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("cast_radius"), self:GetSpecialValueFor("cast_radius"), 0) );
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn("Hero_FacelessVoid.TimeWalk.Aeons", self:GetCaster())
    end 
end


if modifier_ghost_mental_chaos == nil then modifier_ghost_mental_chaos = class({}) end

function modifier_ghost_mental_chaos:IsPurgable()
	return false
end

function modifier_ghost_mental_chaos:IsPurgeException()
    return true
end

function modifier_ghost_mental_chaos:IsHidden()
	return false
end

function modifier_ghost_mental_chaos:GetEffectName()
	return "particles/ghost/mind_chaos_cast_debuff.vpcf"
end

function modifier_ghost_mental_chaos:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ghost_mental_chaos:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_ghost_mental_chaos:OnIntervalThink()
    if IsServer() then
        local k = 1 - (((self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D())/self:GetAbility():GetSpecialValueFor("max_distance"))
        local damage = (self:GetAbility():GetSpecialValueFor("max_distance") * k) * self:GetAbility():GetSpecialValueFor( "distance_mult" )

        local base = self:GetAbility():GetSpecialValueFor("damage_per_second") + damage

        if self:GetCaster():HasTalent("special_bonus_unique_ghost_3") then base = base + (self:GetCaster():FindTalentValue("special_bonus_unique_ghost_3") or 1) end

        ApplyDamage ( {victim = self:GetParent(), attacker = self:GetCaster(), damage = base, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS })      
    end
end

function modifier_ghost_mental_chaos:OnDestroy()
	if IsServer() then

	end
end

function modifier_ghost_mental_chaos:CheckState()
	local state = {
        [MODIFIER_STATE_SILENCED] = true
	}
	return state
end

