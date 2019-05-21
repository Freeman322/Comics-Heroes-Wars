fate_phase_mirror = class({})
LinkLuaModifier( "modifier_fate_phase_mirror", "abilities/fate_phase_mirror.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function fate_phase_mirror:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function fate_phase_mirror:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

--------------------------------------------------------------------------------

function fate_phase_mirror:OnSpellStart()
	if IsServer() then 
		local hTarget = self:GetCursorTarget()
		if hTarget ~= nil then
			local duration = self:GetSpecialValueFor( "buff_duration" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_fate_phase_mirror", { duration = duration } )
			
			EmitSoundOn( "Fate.Phasemirror.Cast", hTarget )
		end
	end
end

if not modifier_fate_phase_mirror then modifier_fate_phase_mirror = class({}) end 
function modifier_fate_phase_mirror:IsPurgable() return false end
function modifier_fate_phase_mirror:GetStatusEffectName() return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold.vpcf" end
function modifier_fate_phase_mirror:StatusEffectPriority() return 1000 end
function modifier_fate_phase_mirror:RemoveOnDeath() return false end
function modifier_fate_phase_mirror:GetEffectName() return "particles/econ/courier/courier_devourling_gold/courier_devourling_gold_ambient.vpcf" end
function modifier_fate_phase_mirror:GetEffectName() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_fate_phase_mirror:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_doctor_fate/phase_mirror_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		self._iDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
end

function modifier_fate_phase_mirror:OnDestroy( params )
    if IsServer() then
        local radius = self:GetAbility():GetSpecialValueFor("radius")
        if self:GetCaster():HasTalent("special_bonus_unique_fate_1") then radius  = radius  + (self:GetCaster():FindTalentValue("special_bonus_unique_fate_1") or 1) end

        local nearby_units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        EmitSoundOn("Fate.Phasemirror.Damage", self:GetParent())

        self._iDamage = self._iDamage * (self:GetAbility():GetSpecialValueFor("damage_ptc") / 100)

        if self:GetCaster():HasTalent("special_bonus_unique_fate_2") then self._iDamage  = self._iDamage  + (self:GetCaster():FindTalentValue("special_bonus_unique_fate_2") or 1) end


        for i, unit in ipairs(nearby_units) do  --Restore health and play a particle effect for every found ally.             	
            EmitSoundOn("Fate.Phasemirror.Target", unit)

            local nFXIndex = ParticleManager:CreateParticle( "particles/hero_doctor_fate/phase_mirror_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1))
            ParticleManager:ReleaseParticleIndex(nFXIndex)
    
            self:GetParent():Heal(self._iDamage, self:GetAbility())

            unit:AddNewModifier (self:GetParent(), self, "modifier_stunned", { duration = 0.5 })
            
            local damage = {
                victim = unit,
                attacker = self:GetParent(),
                damage = self._iDamage,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                ability = self:GetAbility(),
            }

            ApplyDamage( damage )
        end
    end
end


function modifier_fate_phase_mirror:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_fate_phase_mirror:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local caster = params.unit
            local damage = params.damage

            self._iDamage = self._iDamage + damage
        end
    end
end
