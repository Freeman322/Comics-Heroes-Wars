---@class item_orb_of_osuvox 

item_orb_of_osuvox = class({})

LinkLuaModifier( "modifier_item_orb_of_osuvox_active", "items/item_orb_of_osuvox.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_orb_of_osuvox_active_aura", "items/item_orb_of_osuvox.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_orb_of_osuvox", "items/item_orb_of_osuvox.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_orb_of_osuvox_cooldown", "items/item_orb_of_osuvox.lua", LUA_MODIFIER_MOTION_NONE )

function item_orb_of_osuvox:GetChannelTime() return self:GetSpecialValueFor("active_duration") end
function item_orb_of_osuvox:GetIntrinsicModifierName() return "modifier_item_orb_of_osuvox" end

item_orb_of_osuvox.m_vCenter = nil
item_orb_of_osuvox.m_hThinkerAura = nil

function item_orb_of_osuvox:GetAOERadius() return self:GetSpecialValueFor("active_radius") end
function item_orb_of_osuvox:IsStealable() return false end

function item_orb_of_osuvox:OnSpellStart()
    if IsServer() then
        self.m_vCenter = self:GetCursorPosition()

        self.m_hThinkerAura = CreateModifierThinker(self:GetCaster(), self, "modifier_item_orb_of_osuvox_active", {duration = self:GetChannelTime()}, self.m_vCenter, self:GetCaster():GetTeamNumber(), false)
    end 
end

function item_orb_of_osuvox:OnChannelFinish( bInterrupted )
    if IsServer() then 
        if self.m_hThinkerAura and not self.m_hThinkerAura:IsNull() then
            UTIL_Remove(self.m_hThinkerAura)
        end 
	end
end

if modifier_item_orb_of_osuvox_active == nil then modifier_item_orb_of_osuvox_active = class({}) end 

function modifier_item_orb_of_osuvox_active:IsAura() return true end
function modifier_item_orb_of_osuvox_active:IsHidden() return true end
function modifier_item_orb_of_osuvox_active:IsPurgable() return false end
function modifier_item_orb_of_osuvox_active:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("active_radius") end
function modifier_item_orb_of_osuvox_active:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_item_orb_of_osuvox_active:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end 
function modifier_item_orb_of_osuvox_active:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_item_orb_of_osuvox_active:GetModifierAura()
	return "modifier_item_orb_of_osuvox_active_aura"
end

function modifier_item_orb_of_osuvox_active:OnCreated( kv )
	if IsServer() then
        local bhParticle1 = ParticleManager:CreateParticle ("particles/oszuvox/oszuvox.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(bhParticle1, 0, self:GetAbility().m_vCenter)
        ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self:GetAbility():GetSpecialValueFor("active_radius"), self:GetAbility():GetSpecialValueFor("active_radius"), 0))
        self:AddParticle(bhParticle1, false, false, -1, false, false)

        EmitSoundOn("Hero_ArcWarden.MagneticField.Cast", self:GetParent())
	end
end

function modifier_item_orb_of_osuvox_active:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()

        EmitSoundOn("Hero_Antimage.SpellShield.Block", self:GetParent())
        EmitSoundOn("Hero_Antimage.SpellShield.Reflect", self:GetParent())
	end
end

if modifier_item_orb_of_osuvox_active_aura == nil then modifier_item_orb_of_osuvox_active_aura = class({}) end

modifier_item_orb_of_osuvox_active_aura._bEnemy = false
modifier_item_orb_of_osuvox_active_aura._iIntervalThink = 0.1
modifier_item_orb_of_osuvox_active_aura._flDamage = 3.75

function modifier_item_orb_of_osuvox_active_aura:IsDebuff() return self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() end
function modifier_item_orb_of_osuvox_active_aura:IsHidden() return false end
function modifier_item_orb_of_osuvox_active_aura:IsPurgable() return false end

function modifier_item_orb_of_osuvox_active_aura:OnCreated(htable)
    if IsServer() then
        self._flDamage = (self:GetAbility():GetSpecialValueFor("damage_interval") * self._iIntervalThink) / 100

    	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
            self._bEnemy = true
            
            self:StartIntervalThink(self._iIntervalThink)
    	end
	end
end

function modifier_item_orb_of_osuvox_active_aura:CheckState()
	if not self._bEnemy then 
		return {
            [MODIFIER_STATE_INVULNERABLE] = true,
            [MODIFIER_STATE_MAGIC_IMMUNE] = true,
            [MODIFIER_STATE_ATTACK_IMMUNE] = true,
            [MODIFIER_STATE_DISARMED] = true
        }
	end	
	return {
        [MODIFIER_STATE_INVISIBLE] = false
    }
end

function modifier_item_orb_of_osuvox_active_aura:OnIntervalThink()
    if IsServer() then 
        print(self._flDamage)
        self:GetParent():ModifyHealth(self:GetParent():GetHealth() - (self:GetParent():GetHealth() * self._flDamage), self:GetAbility(), false, 0)
    end 
end

--[[function modifier_item_orb_of_osuvox_active_aura:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_item_orb_of_osuvox_active_aura:GetModifierMoveSpeed_Limit (params)
	if self.enemy then 
		return 1 
	end
	return 
end

function modifier_item_orb_of_osuvox_active_aura:GetModifierMoveSpeed_Absolute (params)
	if self.enemy then 
		return 1 
	end
	return 
end

function modifier_item_orb_of_osuvox_active_aura:GetModifierMoveSpeed_Max (params)
	if self.enemy then 
		return 1 
	end
	return 
end]]

if modifier_item_orb_of_osuvox == nil then
	modifier_item_orb_of_osuvox = class({})
end

function modifier_item_orb_of_osuvox:IsHidden()
    return true
end

function modifier_item_orb_of_osuvox:IsPurgable()
    return false
end

function modifier_item_orb_of_osuvox:RemoveOnDeath()
    return true
end

function modifier_item_orb_of_osuvox:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL,
  	    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  	    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  	    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_orb_of_osuvox:GetAbsorbSpell(keys)
	if self:GetParent():HasModifier("modifier_item_orb_of_osuvox_cooldown") == false then
       	local nFXIndex = ParticleManager:CreateParticle( "particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        EmitSoundOn("DOTA_Item.ComboBreaker", self:GetParent())

        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_orb_of_osuvox_cooldown", {duration = self:GetAbility():GetSpecialValueFor("shield_cooldown")})
        return 1
	end
	return false
end

function modifier_item_orb_of_osuvox:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_orb_of_osuvox:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_orb_of_osuvox:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_orb_of_osuvox:GetModifierConstantManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end

function modifier_item_orb_of_osuvox:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end

if modifier_item_orb_of_osuvox_cooldown == nil then modifier_item_orb_of_osuvox_cooldown = class({}) end 

function modifier_item_orb_of_osuvox_cooldown:IsHidden()
    return false
end

function modifier_item_orb_of_osuvox_cooldown:IsPurgable()
    return false
end

function modifier_item_orb_of_osuvox_cooldown:RemoveOnDeath()
    return false
end