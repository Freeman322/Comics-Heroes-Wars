---@class misterio_mystic_arena 
---@author Freeman
LinkLuaModifier( "modifier_misterio_mystic_arena_thinker",	"abilities/misterio_mystic_arena.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_misterio_mystic_arena_debuff",	"abilities/misterio_mystic_arena.lua", LUA_MODIFIER_MOTION_NONE )

misterio_mystic_arena = class({})

misterio_mystic_arena.m_vCenter = nil

function misterio_mystic_arena:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function misterio_mystic_arena:IsStealable() return false end

function misterio_mystic_arena:OnSpellStart()
    if IsServer() then
        self.m_vCenter = self:GetCursorPosition()

        CreateModifierThinker(self:GetCaster(), self, "modifier_misterio_mystic_arena_thinker", {duration = self:GetSpecialValueFor("duration")}, self.m_vCenter, self:GetCaster():GetTeamNumber(), false)
    end 
end

---@class modifier_misterio_mystic_arena_thinker 

modifier_misterio_mystic_arena_thinker = class({}) 

modifier_misterio_mystic_arena_thinker.radius = 400

function modifier_misterio_mystic_arena_thinker:OnCreated(params)
    if IsServer() then
        self.radius = self:GetAbility():GetSpecialValueFor("radius")

        if self:GetCaster():HasTalent("special_bonus_unique_misterio_2") then 
            self.radius = self.radius + self:GetCaster():FindTalentValue("special_bonus_unique_misterio_2")
        end 

        AddFOWViewer( self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), self.radius, self:GetAbility():GetSpecialValueFor("duration"), false)
        GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.radius, false)

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0,  self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(self.radius, self.radius, self.radius) )
        self:AddParticle(nFXIndex, false, false, -1, false, false)

        EmitSoundOn( "Hero_Rubick.NullField.Offense", self:GetCaster() )
        EmitSoundOn( "Hero_Rubick.NullField.Defense", self:GetCaster() )
    end
end

function modifier_misterio_mystic_arena_thinker:OnDestroy()
end

function modifier_misterio_mystic_arena_thinker:CheckState()
     return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_misterio_mystic_arena_thinker:IsAura() return true end
function modifier_misterio_mystic_arena_thinker:GetAuraRadius() return self.radius end
function modifier_misterio_mystic_arena_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_misterio_mystic_arena_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_misterio_mystic_arena_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end

function modifier_misterio_mystic_arena_thinker:GetModifierAura()
    return "modifier_misterio_mystic_arena_debuff"
end

---@class modifier_misterio_mystic_arena_debuff

modifier_misterio_mystic_arena_debuff = class({})

modifier_misterio_mystic_arena_debuff.radius = 400

local DAMAGE_INTERVAL = 1

function modifier_misterio_mystic_arena_debuff:IsHidden() return false end
function modifier_misterio_mystic_arena_debuff:IsPurgable() return false end
function modifier_misterio_mystic_arena_debuff:IsDebuff() return true end

function modifier_misterio_mystic_arena_debuff:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(DAMAGE_INTERVAL)

        self.radius = self:GetAbility():GetSpecialValueFor("radius")

        if self:GetCaster():HasTalent("special_bonus_unique_misterio_2") then 
            self.radius = self.radius + self:GetCaster():FindTalentValue("special_bonus_unique_misterio_2")
        end 

        -- aura references
        self.aura_origin = self:GetAbility().m_vCenter
        
        self.parent = self:GetParent()
        self.width = 100
        self.max_speed = 550
        self.min_speed = 0.1
        self.max_min = self.max_speed-self.min_speed

        -- check inside/outside
        self.inside = (self.parent:GetOrigin()-self.aura_origin):Length2D() < self.radius
        
        self:OnIntervalThink()
    end 
end

function modifier_misterio_mystic_arena_debuff:OnIntervalThink()
    if IsServer() then
        ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("damage_second"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
    end 
end

function modifier_misterio_mystic_arena_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_misterio_mystic_arena_debuff:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_misterio_mystic_arena_debuff:GetModifierMoveSpeed_Absolute(params)
    if not IsServer() then return end

	-- get data
	local parent_vector = self.parent:GetOrigin() - self.aura_origin
	local parent_direction = parent_vector:Normalized()

	-- check inside/outside
	local actual_distance = parent_vector:Length2D()
	local wall_distance = actual_distance-self.radius
    local over_walls = false
    
	if self.inside ~= (wall_distance<0) then
		-- moved to other side, check buffer
		if math.abs( wall_distance ) > self.width then
			-- flip
			self.inside = not self.inside
		else
			over_walls = true
		end
	end	

	-- no limit if outside width
    wall_distance = math.abs(wall_distance)
    
	if wall_distance > self.width then return 0 end

	-- calculate facing angle
	local parent_angle = 0
	if self.inside then
		parent_angle = VectorToAngles(parent_direction).y
	else
		parent_angle = VectorToAngles(-parent_direction).y
    end
    
	local unit_angle = self:GetParent():GetAnglesAsVector().y
	local wall_angle = math.abs( AngleDiff( parent_angle, unit_angle ) )

	-- calculate movespeed limit
	local limit = 0
	if wall_angle<=90 then
		-- facing and touching wall
		if over_walls then
			limit = self.min_speed
		else
			-- interpolate
			limit = (wall_distance/self.width)*self.max_min + self.min_speed
		end
	else
		-- no limit if facing away
		limit = 0
	end

	return limit
end

function modifier_misterio_mystic_arena_debuff:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("damage_increase")
end

function modifier_misterio_mystic_arena_debuff:GetAbsoluteNoDamagePhysical()
    if self:GetCaster():HasTalent("special_bonus_unique_misterio_3") then 
        return 0
    end

    return 1
end

function modifier_misterio_mystic_arena_debuff:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
end

function modifier_misterio_mystic_arena_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end