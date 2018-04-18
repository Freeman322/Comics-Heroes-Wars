if item_corrupted_boots == nil then item_corrupted_boots = class({}) end
LinkLuaModifier("modifier_item_corrupted_boots", "items/item_corrupted_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_corrupted_boots_active", "items/item_corrupted_boots.lua", LUA_MODIFIER_MOTION_NONE)

function item_corrupted_boots:GetIntrinsicModifierName()
    return "modifier_item_corrupted_boots"
end

function item_corrupted_boots:OnSpellStart()
  if IsServer() then
      local radius = self:GetSpecialValueFor( "radius" )
    	local duration = self:GetSpecialValueFor(  "duration" )

    	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    	if #allies > 0 then
    		for _,ally in pairs(allies) do
    			ally:AddNewModifier( self:GetCaster(), self, "modifier_item_corrupted_boots_active", { duration = duration } )
          ally:Heal((self:GetSpecialValueFor("health_restore")/100)*ally:GetMaxHealth(), self)
          ally:SetMana(ally:GetMana() + ((self:GetSpecialValueFor("mana_restore")/100)*ally:GetMaxMana()))
          local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally )
        	ParticleManager:SetParticleControlEnt( nFXIndex, 2, ally, PATTACH_POINT_FOLLOW, "attach_head", ally:GetOrigin(), true )
        	ParticleManager:ReleaseParticleIndex( nFXIndex )
          EmitSoundOn("DOTA_Item.Mekansm.Target", ally)
      		ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
    		end
    	end
  end
end

if modifier_item_corrupted_boots == nil then modifier_item_corrupted_boots = class({}) end

function modifier_item_corrupted_boots:IsHidden ()
    return true
end


function modifier_item_corrupted_boots:IsPurgable()
    return false
end

function modifier_item_corrupted_boots:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_corrupted_boots:GetModifierBonusStats_Intellect(params)
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_corrupted_boots:GetModifierBonusStats_Intellect(params)
    return self:GetAbility():GetSpecialValueFor("GetModifierManaBonus")
end

function modifier_item_corrupted_boots:GetModifierPercentageManaRegen(params)
    return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_item_corrupted_boots:GetModifierPhysicalArmorBonus(params)
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_corrupted_boots:GetModifierConstantHealthRegen(params)
    return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_item_corrupted_boots:GetModifierSpellAmplify_Percentage(params)
    return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_corrupted_boots:GetModifierCastRangeBonus(params)
    return self:GetAbility():GetSpecialValueFor("cast_range_tooltip")
end

function modifier_item_corrupted_boots:GetModifierMoveSpeedBonus_Constant(params)
    return self:GetAbility():GetSpecialValueFor("move_speed")
end

if modifier_item_corrupted_boots_active == nil then modifier_item_corrupted_boots_active = class({}) end

function modifier_item_corrupted_boots_active:IsHidden ()
    return false
end

function modifier_item_corrupted_boots_active:IsPurgable()
    return false
end

function modifier_item_corrupted_boots_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

function modifier_item_corrupted_boots_active:GetTexture()
	return "custom/corrupted_boots"
end

function modifier_item_corrupted_boots_active:StatusEffectPriority()
	return 1000
end

function modifier_item_corrupted_boots_active:GetEffectName()
	return "particles/world_shrine/radiant_shrine_regen.vpcf"
end

function modifier_item_corrupted_boots_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function item_corrupted_boots:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

