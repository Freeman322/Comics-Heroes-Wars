LinkLuaModifier ("modifier_medivh_ancient_force",         "abilities/medivh_ancient_force.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_medivh_ancient_force_passive", "abilities/medivh_ancient_force.lua", LUA_MODIFIER_MOTION_NONE)

if medivh_ancient_force == nil then medivh_ancient_force = class({}) end

function medivh_ancient_force:GetIntrinsicModifierName()
	return "modifier_medivh_ancient_force"
end

if modifier_medivh_ancient_force == nil then modifier_medivh_ancient_force = class({}) end

function modifier_medivh_ancient_force:IsAura()
	return true
end

function modifier_medivh_ancient_force:IsHidden()
	return true
end

function modifier_medivh_ancient_force:IsPurgable()
	return true
end

function modifier_medivh_ancient_force:GetAuraRadius()
	return 99999
end

function modifier_medivh_ancient_force:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_medivh_ancient_force:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_medivh_ancient_force:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_medivh_ancient_force:GetModifierAura()
	return "modifier_medivh_ancient_force_passive"
end

if modifier_medivh_ancient_force_passive == nil then modifier_medivh_ancient_force_passive = class({}) end

function modifier_medivh_ancient_force_passive:IsHidden()
    return false
end

function modifier_medivh_ancient_force_passive:IsPurgable()
    return true
end

--------------------------------------------------------------------------------

function modifier_medivh_ancient_force_passive:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf"
end

--------------------------------------------------------------------------------

function modifier_medivh_ancient_force_passive:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_medivh_ancient_force_passive:OnCreated(htable)
    if IsServer() then
        self:StartIntervalThink(1)
        if self:GetParent():IsRealHero() then
        	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_aether_lens", nil)
        end
    end
end

function modifier_medivh_ancient_force_passive:OnDestroy()
    if IsServer() then
        if self:GetParent():HasModifier("modifier_item_aether_lens") then
            self:GetParent():RemoveModifierByName("modifier_item_aether_lens")
        end
    end
end

function modifier_medivh_ancient_force_passive:OnIntervalThink()
	 if IsServer() then
	    local parent = self:GetParent()
	    local caster = self:GetCaster()

	    local vDist = (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
	    if parent:IsCreep() or parent:IsCreature() then
	    	if vDist <= self:GetAbility():GetSpecialValueFor("creep_radius") then
	            self.armor = self:GetAbility():GetSpecialValueFor("creep_armor")
				self.as = self:GetAbility():GetSpecialValueFor("creep_attack_speed")
	        else
	        	self.armor = 0
				self.as = 0
	        end
		end
	 end
end


function modifier_medivh_ancient_force_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_medivh_ancient_force_passive:GetModifierAttackSpeedBonus_Constant( params )
    return self.as
end

function modifier_medivh_ancient_force_passive:GetModifierPhysicalArmorBonus( params )
    return self.armor
end

function medivh_ancient_force:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

