LinkLuaModifier ("night_king_winter_is_coming_aura",                      "abilities/night_king_winter_is_coming.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("night_king_winter_is_coming_modifier",                  "abilities/night_king_winter_is_coming.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("night_king_winter_is_coming_modifier_kill_dealy",       "abilities/night_king_winter_is_coming.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("night_king_winter_is_coming_modifier_kill_dealy_dummy", "abilities/night_king_winter_is_coming.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("night_king_winter_is_coming_modifier_zombie",           "abilities/night_king_winter_is_coming.lua", LUA_MODIFIER_MOTION_NONE)

local attacker = nil

night_king_winter_is_coming = class({})

function night_king_winter_is_coming:GetIntrinsicModifierName()
	return "night_king_winter_is_coming_aura"
end

night_king_winter_is_coming_aura = class({})

function night_king_winter_is_coming_aura:IsHidden()
	return true
end

function night_king_winter_is_coming_aura:IsAura()
	return true
end

function night_king_winter_is_coming_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function night_king_winter_is_coming_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function night_king_winter_is_coming_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function night_king_winter_is_coming_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function night_king_winter_is_coming_aura:GetModifierAura()
	return "night_king_winter_is_coming_modifier"
end

night_king_winter_is_coming_modifier = class({})

function night_king_winter_is_coming_modifier:IsHidden()
	return true
end

function night_king_winter_is_coming_modifier:OnCreated()
    if IsServer() then
        if self:GetParent():IsRealHero() then
          _G.ressurect_table[self:GetParent()] = true
        end
    end
end

function night_king_winter_is_coming_modifier:DeclareFunctions() --we want to use these functions in this item
	local funcs = {
	    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function night_king_winter_is_coming_modifier:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            if params.unit:IsRealHero() and params.unit == self:GetCaster() then
            	local hero = params.unit
            	if hero:GetHealth() == 0 and hero:GetTeamNumber() == self:GetAbility():GetCaster():GetTeamNumber() then
                    if not hero:HasModifier("night_king_winter_is_coming_modifier_kill_dealy_dummy") == true then
                		hero:SetHealth(1)
                		hero:AddNewModifier(hero, self:GetAbility(), "night_king_winter_is_coming_modifier_kill_dealy", {duration = self:GetAbility():GetSpecialValueFor("death_delay")})
                        attacker = target
                    end
                end
            else
            	local unit = params.unit
                if not unit:IsHero() then
                	if unit:GetHealth() == 0 and unit:GetUnitName() ~= "npc_night_king_zombie" then
                		local position = unit:GetAbsOrigin()
                		unit:RemoveSelf()
                		local zombie = CreateUnitByName("npc_night_king_zombie", position, true, self:GetAbility():GetCaster(), self:GetAbility():GetCaster():GetOwner(), self:GetAbility():GetCaster():GetTeamNumber())
                        zombie:SetControllableByPlayer(self:GetAbility():GetCaster():GetPlayerID(), false)
                        zombie:AddNewModifier(self:GetCaster(), self:GetAbility(), "night_king_winter_is_coming_modifier_zombie", nil)
                	end
                end
            end
        end
    end
end

night_king_winter_is_coming_modifier_kill_dealy = class({})

function night_king_winter_is_coming_modifier_kill_dealy:IsHidden()
    return false
end

function night_king_winter_is_coming_modifier_kill_dealy:IsPurgable()
    return false
end

function night_king_winter_is_coming_modifier_kill_dealy:GetStatusEffectName()
    return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

--------------------------------------------------------------------------------

function night_king_winter_is_coming_modifier_kill_dealy:StatusEffectPriority()
    return 1000
end

--------------------------------------------------------------------------------

function night_king_winter_is_coming_modifier_kill_dealy:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

--------------------------------------------------------------------------------

function night_king_winter_is_coming_modifier_kill_dealy:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function night_king_winter_is_coming_modifier_kill_dealy:OnCreated(keys)
    if IsServer() then
        EmitSoundOn("Hero_SkeletonKing.Reincarnate.Ghost", self:GetParent())
    end
end

function night_king_winter_is_coming_modifier_kill_dealy:OnDestroy()
    if IsServer() then
         local parent = self:GetParent()
         local abil = self:GetAbility()
         parent:AddNewModifier(parent, abil, "night_king_winter_is_coming_modifier_kill_dealy_dummy", {duration = 5})
         if attacker == nil then
            local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
            attacker = units[i]
         end
         parent:Kill(abil, attacker)
    end
end

function night_king_winter_is_coming_modifier_kill_dealy:CheckState()
    local state = {
    [MODIFIER_STATE_INVULNERABLE] = true,
    }

    return state
end

function night_king_winter_is_coming_modifier_kill_dealy:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MIN_HEALTH
    }

    return funcs
end

--------------------------------------------------------------------------------

function night_king_winter_is_coming_modifier_kill_dealy:GetMinHealth( params )
    return 1
end

if night_king_winter_is_coming_modifier_kill_dealy_dummy == nil then
    night_king_winter_is_coming_modifier_kill_dealy_dummy = class({})
end

function night_king_winter_is_coming_modifier_kill_dealy_dummy:IsHidden()
    return true
end

function night_king_winter_is_coming_modifier_kill_dealy_dummy:RemoveOnDeath()
     return true
end

function night_king_winter_is_coming_modifier_kill_dealy_dummy:IsPurgable()
     return true
end

if night_king_winter_is_coming_modifier_zombie == nil then night_king_winter_is_coming_modifier_zombie = class({}) end

function night_king_winter_is_coming_modifier_zombie:IsHidden()
    return true
end

function night_king_winter_is_coming_modifier_zombie:RemoveOnDeath()
     return true
end

function night_king_winter_is_coming_modifier_zombie:IsPurgable()
     return false
end

function night_king_winter_is_coming_modifier_zombie:OnCreated(htable)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function night_king_winter_is_coming_modifier_zombie:OnIntervalThink()
     if IsServer() then
        local parent = self:GetParent()
        local caster = self:GetCaster()

        local vDist = (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()

        if vDist > self:GetAbility():GetSpecialValueFor("aura_radius") then
            parent:ForceKill(false)
        end
     end
end

function night_king_winter_is_coming:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

