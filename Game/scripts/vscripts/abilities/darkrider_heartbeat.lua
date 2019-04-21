if not darkrider_heartbeat then darkrider_heartbeat = class({}) end
function darkrider_heartbeat:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

LinkLuaModifier ("modifier_darkrider_heartbeat", "abilities/darkrider_heartbeat.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_darkrider_heartbeat_aura", "abilities/darkrider_heartbeat.lua", LUA_MODIFIER_MOTION_NONE)

function darkrider_heartbeat:GetIntrinsicModifierName() return "modifier_darkrider_heartbeat_aura" end

if modifier_darkrider_heartbeat_aura == nil then modifier_darkrider_heartbeat_aura = class({}) end
function modifier_darkrider_heartbeat_aura:IsAura() return true end
function modifier_darkrider_heartbeat_aura:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_darkrider_heartbeat_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_darkrider_heartbeat_aura:IsHidden() return true end
function modifier_darkrider_heartbeat_aura:IsPurgable() return false end
function modifier_darkrider_heartbeat_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_darkrider_heartbeat_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_darkrider_heartbeat_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_darkrider_heartbeat_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_darkrider_heartbeat_aura:GetModifierAura() return "modifier_darkrider_heartbeat" end

function modifier_darkrider_heartbeat_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_darkrider_heartbeat_aura:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_darkrider_heartbeat_aura:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end


if modifier_darkrider_heartbeat == nil then modifier_darkrider_heartbeat = class({}) end

function modifier_darkrider_heartbeat:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_UNIT_MOVED
    }

    return funcs
end

function modifier_darkrider_heartbeat:GetModifierConstantHealthRegen() return self:GetStackCount() * (-1) * (self:GetAbility():GetSpecialValueFor("health_regen") / 100) end
function modifier_darkrider_heartbeat:GetModifierConstantManaRegen() return self:GetStackCount() * (-1) * (self:GetAbility():GetSpecialValueFor("mana_regen") / 100) end
function modifier_darkrider_heartbeat:IsHidden() return true end
function modifier_darkrider_heartbeat:IsPurgable() return false end

function modifier_darkrider_heartbeat:OnCreated( params )
    if IsServer() then self._vPosition = self:GetParent():GetAbsOrigin() end 
end

function modifier_darkrider_heartbeat:OnUnitMoved(params)
	if IsServer() and self:GetParent():IsRealHero() then 
		if params.unit == self:GetParent() then 
			if self._vPosition ~= self:GetParent():GetAbsOrigin() then 
				local distance = (self:GetParent():GetAbsOrigin() - self._vPosition):Length2D()

				self._vPosition = self:GetParent():GetAbsOrigin()

				self:OnPositionChanged(distance)
			end 			
		end
	end 
end

function modifier_darkrider_heartbeat:OnPositionChanged( distance )
	if IsServer() then 
		local value = math.floor( distance ) * (self:GetAbility():GetSpecialValueFor("aura_damage") / 100)
            
        self:SetStackCount(self:GetStackCount() + math.floor( distance ))

        local damage_table = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = value,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility()
        }

        ApplyDamage (damage_table)
	end
end
