LinkLuaModifier ("modifier_fate_fatebind", "abilities/fate_fatebind.lua", LUA_MODIFIER_MOTION_NONE)

fate_fatebind = class({})

function fate_fatebind:GetIntrinsicModifierName()
	return "modifier_gostrider_punishing_gaze"
end

function fate_fatebind:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function fate_fatebind:GetCustomCastErrorTarget( hTarget )
	return ""
end

function fate_fatebind:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

function fate_fatebind:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil then
		return
	end

	local vPos1 = hCaster:GetOrigin()
	local vPos2 = hTarget:GetOrigin()

	GridNav:DestroyTreesAroundPoint( vPos1, 300, false )
	GridNav:DestroyTreesAroundPoint( vPos2, 300, false )

	hTarget:Interrupt()
    local hTarget_Unit

	EmitSoundOn( "Fate.Fatebind.Cast", hCaster )

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), nil, self:GetSpecialValueFor("chain_break_distance"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
    if #units > 0 then
        for _, unit in pairs(units) do
            if unit ~= hTarget then 
                hTarget_Unit = unit
                break
            end 
        end
    end

    local duration = self:GetSpecialValueFor("chain_duration")
    if self:GetCaster():HasTalent("special_bonus_unique_fate_4") then duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_fate_4") or 0) end

    if hTarget_Unit then 
        hTarget:AddNewModifier(hCaster, self, "modifier_fate_fatebind", {duration = duration, unit = hTarget_Unit:entindex()})
        hTarget_Unit:AddNewModifier(hCaster, self, "modifier_fate_fatebind", {duration = duration, unit = hTarget:entindex()})
    else 
        hTarget:AddNewModifier(hCaster, self, "modifier_fate_fatebind", {duration = duration})
    end
end


if modifier_fate_fatebind == nil then
    modifier_fate_fatebind = class({})
end

function modifier_fate_fatebind:IsHidden()
	return true
end

function modifier_fate_fatebind:IsPurgable()
    return false
end

function modifier_fate_fatebind:GetStatusEffectName()
    return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf"
end

function modifier_fate_fatebind:StatusEffectPriority()
    return 1000
end

function modifier_fate_fatebind:GetEffectName()
    return "particles/hero_doctor_fate/fatebind_buff.vpcf"
end

function modifier_fate_fatebind:IsPurgable()
    return false
end

function modifier_fate_fatebind:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_fate_fatebind:GetBindedUnit()
    return self._hUnit 
end

function modifier_fate_fatebind:OnCreated(params)
    if IsServer() then 
        if params.unit then 
            self._hUnit = EntIndexToHScript(params.unit)
            if IsValidEntity(self._hUnit) then 
                local nFXIndex = ParticleManager:CreateParticle( "particles/hero_doctor_fate/fatebind_rope.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self._hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", self._hUnit:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
                
                self:AddParticle(nFXIndex, false, false, -1, false, false)
            end 
        end 
    end
end

function modifier_fate_fatebind:Destroy()
    if IsServer() then 
        
    end
end

function modifier_fate_fatebind:OnModifierApplied( params )
    if IsServer() then 
        local modifier = params.modifier_name
        local ability = params.ability
        local unit = params.unit 
        local attacker = params.attacker 

        if unit and unit == self:GetParent() and self._hUnit and modifier ~= self:GetName() then 
            local debuff = self:GetParent():FindModifierByName(modifier)
            if debuff and debuff:IsDebuff() == true then 
                if not self._hUnit:HasModifier(modifier) then self._hUnit:AddNewModifier(attacker, ability, modifier, {duration = debuff:GetDuration()}) end 
            end 
        end 
    end 
end

function modifier_fate_fatebind:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            local victim = params.unit

            if self._hUnit then 
                EmitSoundOn("Hero_Pugna.NetherWard.Target", target)

                local nFXIndex = ParticleManager:CreateParticle( "particles/hero_doctor_fate/fatebind_damage.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, self._hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", self._hUnit:GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                ApplyDamage ( {
                    victim = self._hUnit,
                    attacker = target,
                    damage = params.damage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                })
            end 
        end
    end
end


function modifier_fate_fatebind:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_fate_fatebind:GetModifierMoveSpeed_Absolute(params)
    if IsServer() then 
        if self._hUnit then 
            local distToUnit = (self:GetParent():GetAbsOrigin() - self._hUnit:GetAbsOrigin()):Normalized()
            local unit_dir = self:GetParent():GetForwardVector() 
            if distToUnit:Dot(unit_dir) > math.cos(2.44346) then 
                if (self:GetParent():GetAbsOrigin() - self._hUnit:GetAbsOrigin()):Length2D() >= self:GetAbility():GetSpecialValueFor("chain_latch_radius") then
                    return 1  
                end
            end 
        end 
    end 
    return 150
end
