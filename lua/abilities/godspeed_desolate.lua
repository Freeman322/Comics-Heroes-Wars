if not godspeed_desolate then godspeed_desolate = class({}) end
function godspeed_desolate:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
LinkLuaModifier ("modifier_godspeed_desolate", "abilities/godspeed_desolate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_godspeed_desolate_targets", "abilities/godspeed_desolate.lua", LUA_MODIFIER_MOTION_NONE)

function godspeed_desolate:IsRefreshable()
    return false
end

function godspeed_desolate:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_godspeed_desolate", {duration = self:GetSpecialValueFor("duration")})

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_godspeed_desolate_targets", {duration = self:GetSpecialValueFor("duration")})
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )
        EmitSoundOn( "Hero_Silencer.GlobalSilence.Cast", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end

if not modifier_godspeed_desolate then modifier_godspeed_desolate = class({}) end

function modifier_godspeed_desolate:OnCreated(htable)
    if IsServer() then
        self._flSpeed = 0

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                if unit then
                    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_zoom/blackzoom_time_shift.vpcf", PATTACH_CUSTOMORIGIN, nil );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
                    ParticleManager:ReleaseParticleIndex( nFXIndex );

                    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_godspeed/godspeed_desolate_target.vpcf", PATTACH_CUSTOMORIGIN, unit );

                    local damage = ((unit:GetMoveSpeedModifier(unit:GetBaseMoveSpeed()) - 50)  * (self:GetAbility():GetSpecialValueFor("damage") / 100)) or 0

                    local damage = {
                        victim = unit,
                        attacker = self:GetCaster(),
                        damage = damage,
                        damage_type = DAMAGE_TYPE_PURE,
                        ability = self:GetAbility()
                    }
                    if not self:GetParent():IsTempestDouble() then
                        ApplyDamage( damage )  
                    end
                  
                    self._flSpeed = self._flSpeed + unit:GetMoveSpeedModifier(unit:GetBaseMoveSpeed())
                end
            end
        end
	end
end

function modifier_godspeed_desolate:IsPurgable()
    return false
end

function modifier_godspeed_desolate:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
		    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_godspeed_desolate:GetModifierMoveSpeed_Max()
	return 99999
end

function modifier_godspeed_desolate:GetModifierMoveSpeed_Limit()
	return 99999
end

function modifier_godspeed_desolate:GetModifierMoveSpeedBonus_Constant()
	return self._flSpeed
end

if not modifier_godspeed_desolate_targets then modifier_godspeed_desolate_targets = class({}) end

function modifier_godspeed_desolate_targets:IsPurgeException()
    return true
end

function modifier_godspeed_desolate_targets:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end

function modifier_godspeed_desolate_targets:StatusEffectPriority()
	return 1000
end


function modifier_godspeed_desolate_targets:OnCreated( kv )
    if IsServer() then
	     EmitSoundOn("Hero_Oracle.FatesEdict", self:GetParent())
    end
end

function modifier_godspeed_desolate_targets:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_godspeed_desolate_targets:GetModifierMoveSpeed_Max()
	return 50
end

function modifier_godspeed_desolate_targets:GetModifierMoveSpeed_Limit()
	return 50
end

function modifier_godspeed_desolate_targets:GetModifierTurnRate_Percentage()
	return -500
end

function modifier_godspeed_desolate_targets:GetModifierMoveSpeedBonus_Constant()
	return 50
end
