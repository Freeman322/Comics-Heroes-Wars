---@class misterio_mirror_remnant
LinkLuaModifier( "modifier_misterio_mirror_remnant", "abilities/misterio_mirror_remnant.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_misterio_mirror_remnant_invis", "abilities/misterio_mirror_remnant.lua", LUA_MODIFIER_MOTION_NONE )

misterio_mirror_remnant = class({}) 

misterio_mirror_remnant.m_duration = 0
misterio_mirror_remnant.m_vector = nil
misterio_mirror_remnant.m_hUnit = nil

function misterio_mirror_remnant:OnSpellStart()
    if IsServer() then
        self.m_duration = self:GetDuration()
        self.m_vector = Vector(RandomInt(GetWorldMinX(), GetWorldMaxX()), RandomInt(GetWorldMinY(), GetWorldMaxY()))

        PrecacheUnitByNameAsync("npc_dota_unit_misterio_remnant", function()
            self.m_hUnit = CreateUnitByName("npc_dota_unit_misterio_remnant", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
            self.m_hUnit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
            self.m_hUnit:SetUnitCanRespawn(false)

            self:AddParticles(self.m_hUnit)

            self.m_hUnit:SetMaxHealth(self:GetCaster():GetMaxHealth()) self.m_hUnit:Heal(self:GetCaster():GetMaxHealth(), self)
            self.m_hUnit:SetBaseDamageMin(self:GetCaster():GetAverageTrueAttackDamage(self.m_hUnit)) self.m_hUnit:SetBaseDamageMax(self:GetCaster():GetAverageTrueAttackDamage(self.m_hUnit))
            
            self.m_hUnit:SetPhysicalArmorBaseValue(self:GetCaster():GetPhysicalArmorValue( false ))

            self.m_hUnit:AddNewModifier(self:GetCaster(), self, "modifier_misterio_mirror_remnant", nil)      
            self.m_hUnit:AddNewModifier(self:GetCaster(), self, "modifier_kill", {["duration"] = self.m_duration})

            self.m_hUnit:SetAttackCapability(self:GetCaster():GetAttackCapability())
            self.m_hUnit:SetRangedProjectileName(self:GetCaster():GetRangedProjectileName())
            
            Timers:CreateTimer(0.1, function()
                if not self.m_hUnit:IsNull() and self.m_hUnit then
                self.m_hUnit:MoveToPosition(self.m_vector) end 
            end)
        end)

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/death/mk_arcana_spring_cast_outer_death_pnt.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_PhantomLancer.Doppelwalk", self:GetCaster() )

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_misterio_mirror_remnant_invis", {duration = self.m_duration})
    end 
end

function misterio_mirror_remnant:AddParticles(unit)
    if IsServer() then
        ParticleManager:CreateParticle( "particles/misterio/misterio_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )

        local pfx = ParticleManager:CreateParticle( "particles/misterio/misterio_ambient_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControlEnt( pfx, 11, unit, PATTACH_POINT_FOLLOW, "attach_eye_l" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( pfx, 12, unit, PATTACH_POINT_FOLLOW, "attach_eye_r" , unit:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex(pfx)

        local pfx = ParticleManager:CreateParticle( "particles/misterio/misterio_ambient_hand.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControlEnt( pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1" , unit:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_attack2" , unit:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex(pfx)
    end 
end

---@class modifier_misterio_mirror_remnant
modifier_misterio_mirror_remnant = class({})

modifier_misterio_mirror_remnant.m_flDamage = 0

function modifier_misterio_mirror_remnant:IsHidden() return true end
function modifier_misterio_mirror_remnant:IsPurgable() return false end
function modifier_misterio_mirror_remnant:RemoveOnDeath() return false end

function modifier_misterio_mirror_remnant:OnCreated(params)
    if IsServer() then 
        local dmg_ptc = self:GetAbility():GetSpecialValueFor("damage_ptc")

        if self:GetCaster():HasTalent("special_bonus_unique_misterio_1") then 
            dmg_ptc = dmg_ptc + self:GetCaster():FindTalentValue("special_bonus_unique_misterio_1")
        end 

        self.m_flDamage = (self:GetParent():GetMaxHealth() / 100) * dmg_ptc
    end 
end

function modifier_misterio_mirror_remnant:DeclareFunctions ()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_misterio_mirror_remnant:OnTakeDamage(params)
    if IsServer() then
        for key, value in pairs(params) do
            print(key, value)
        end
        if params.unit == self:GetParent() and self:GetParent():GetHealth() <= params.original_damage then
            local target = params.attacker
            
            ApplyDamage({
                attacker = self:GetCaster(),
                victim = target,
                ability = self:GetAbility(),
                damage_type = self:GetAbility():GetAbilityDamageType(),
                damage = self.m_flDamage
            })
		end
    end 
end

---@class modifier_misterio_mirror_remnant_invis

modifier_misterio_mirror_remnant_invis = class({})

local MOVESPEED = 600
local INVISIBILITY_LEVEL = 1
local CHECK_TIME = 0.1

function modifier_misterio_mirror_remnant_invis:IsHidden() return false end
function modifier_misterio_mirror_remnant_invis:IsPurgable() return false end
function modifier_misterio_mirror_remnant_invis:RemoveOnDeath() return true end

function modifier_misterio_mirror_remnant_invis:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(CHECK_TIME)
    end 
end

function modifier_misterio_mirror_remnant_invis:OnIntervalThink()
    if IsServer() then
        if not self:GetAbility().m_hUnit then self:Destroy() end 
    end 
end

function modifier_misterio_mirror_remnant_invis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ATTACK
    }

    return funcs
end


function modifier_misterio_mirror_remnant_invis:OnAttack(params)
    if IsServer() then
        if params.attacker == self:GetParent() then
            self:Destroy()
		end
    end 
end

function modifier_misterio_mirror_remnant_invis:GetModifierPersistentInvisibility(args)
    return INVISIBILITY_LEVEL
end

function modifier_misterio_mirror_remnant_invis:GetModifierMoveSpeed_Absolute(args)
    return MOVESPEED
end

function modifier_misterio_mirror_remnant_invis:GetModifierInvisibilityLevel(args)
    return INVISIBILITY_LEVEL
end

function modifier_misterio_mirror_remnant_invis:CheckState()
	local state = {
        [MODIFIER_STATE_INVISIBLE] = true
	}

	return state
end