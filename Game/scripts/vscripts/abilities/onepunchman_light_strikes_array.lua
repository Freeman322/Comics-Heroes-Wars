if onepunchman_light_strikes_array == nil then onepunchman_light_strikes_array = class({}) end
LinkLuaModifier( "modifier_onepunchman_light_strikes_array", "abilities/onepunchman_light_strikes_array.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_onepunchman_light_strikes_array_thinker", "abilities/onepunchman_light_strikes_array.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_onepunchman_light_strikes_array_caster", "abilities/onepunchman_light_strikes_array.lua" ,LUA_MODIFIER_MOTION_NONE )

function onepunchman_light_strikes_array:GetAOERadius()
    return 400
end


function onepunchman_light_strikes_array:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function onepunchman_light_strikes_array:OnSpellStart()
	if IsServer() then
	    local caster = self:GetCaster()
	    local point = self:GetCursorPosition()
	    local team_id = caster:GetTeamNumber()
	    local thinker = CreateModifierThinker(caster, self, "modifier_onepunchman_light_strikes_array_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
	    thinker:SetForwardVector(self:GetCaster():GetForwardVector())

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "kama_bullet") then
            EmitSoundOn( "Kama.CastAbil", self:GetCaster() )
        end

	    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_onepunchman_light_strikes_array_caster", {duration = self:GetSpecialValueFor("duration")})
	end
end

modifier_onepunchman_light_strikes_array_thinker = class ({})

function modifier_onepunchman_light_strikes_array_thinker:OnCreated(event)
    if IsServer() then
        local hCaster = self:GetCaster()
	    EmitSoundOn("Hero_Riki.TricksOfTheTrade.Cast", hCaster)

	  	local direction = (self:GetCaster():GetAbsOrigin() - self:GetCaster():GetCursorPosition()):Normalized()
	  	local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf", PATTACH_CUSTOMORIGIN, target)
	  	ParticleManager:SetParticleControl(particle, 0, hCaster:GetCursorPosition())
	  	ParticleManager:SetParticleControl(particle, 1, Vector(self:GetAbility():GetSpecialValueFor("range"), self:GetAbility():GetSpecialValueFor("range"), 1))
	  	ParticleManager:SetParticleControl(particle, 2, Vector(self:GetAbility():GetSpecialValueFor("range"), self:GetAbility():GetSpecialValueFor("range"), 1))
	  	ParticleManager:SetParticleControl(particle, 3, hCaster:GetCursorPosition())
	  	self:AddParticle(particle, false, false, -1, false, false)

	    EmitSoundOn("Hero_Riki.TricksOfTheTrade", hCaster)
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("attack_interval"))

		self.strikes = 0
    end
end

function modifier_onepunchman_light_strikes_array_thinker:OnIntervalThink()
   if IsServer() then
   		EmitSoundOn("Hero_Pangolier.Swashbuckle.Attack", self:GetCaster())
   		local hCaster = self:GetCaster()
    	local unit_table = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	    if #unit_table > 0 then
		    for _, unit in pairs(unit_table) do
		    	if self:GetCaster():HasTalent("special_bonus_unique_saitama_2") and self.strikes >= 0 then
		    		self:GetCaster():PerformAttack(unit, true, true, true, true, false, false, true)
		    	end

		    	EmitSoundOn("Hero_Pangolier.Swashbuckle.Damage", unit)

		    	local iDamage = self:GetAbility():GetSpecialValueFor( "damage" )
				local damage = {
					victim = unit,
					attacker = self:GetAbility():GetCaster(),
					damage = iDamage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self:GetAbility()
				}
				
			    local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_CUSTOMORIGIN, unit);
			    ParticleManager:SetParticleControlEnt (nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin (), true);
			    ParticleManager:ReleaseParticleIndex (nFXIndex);

				unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_onepunchman_light_strikes_array", {duration = self:GetAbility():GetSpecialValueFor("duration_slowing")})
				
				ApplyDamage(damage)
		    end
	    end

	    self.strikes = self.strikes + 1
	    if self.strikes == 6 then
	    	self.strikes = 0
	    end
   end
end

function modifier_onepunchman_light_strikes_array_thinker:OnDestroy()
    if IsServer() then
       EmitSoundOn("Hero_Riki.Blink_Strike.Immortal", self:GetParent())
    end
end

function modifier_onepunchman_light_strikes_array_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

if modifier_onepunchman_light_strikes_array == nil then
    modifier_onepunchman_light_strikes_array = class({})
end

function modifier_onepunchman_light_strikes_array:IsHidden ()
    return true
end

function modifier_onepunchman_light_strikes_array:IsPurgable ()
    return false
end

function modifier_onepunchman_light_strikes_array:GetStatusEffectName ()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

function modifier_onepunchman_light_strikes_array:StatusEffectPriority ()
    return 1000
end

function modifier_onepunchman_light_strikes_array:GetHeroEffectName ()
    return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end

function modifier_onepunchman_light_strikes_array:HeroEffectPriority ()
    return 100
end

function modifier_onepunchman_light_strikes_array:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_onepunchman_light_strikes_array:GetModifierMoveSpeedBonus_Percentage(params)
    return self:GetAbility():GetSpecialValueFor("slowing")
end


if modifier_onepunchman_light_strikes_array_caster == nil then
    modifier_onepunchman_light_strikes_array_caster = class({})
end

function modifier_onepunchman_light_strikes_array_caster:IsHidden ()
    return true
end

function modifier_onepunchman_light_strikes_array_caster:IsPurgable ()
    return false
end


function modifier_onepunchman_light_strikes_array_caster:CheckState ()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end
