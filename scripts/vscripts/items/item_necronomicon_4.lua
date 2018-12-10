if item_necronomicon_4 == nil then item_necronomicon_4 = class({}) end 
LinkLuaModifier ("modifier_item_necronomicon_4", "items/item_necronomicon_4.lua", LUA_MODIFIER_MOTION_NONE)

function item_necronomicon_4:GetIntrinsicModifierName()
	return "modifier_item_necronomicon_4"
end

function item_necronomicon_4:OnSpellStart()
	if IsServer() then 
		local caster = self:GetCaster()
		EmitSoundOn("DOTA_Item.Necronomicon.Activate", caster)
	    -- Parameters
	    local summon_duration = self:GetSpecialValueFor("summon_duration")
	    local caster_loc = caster:GetAbsOrigin()
	    local caster_direction = caster:GetForwardVector()
	    local melee_summon_name = "npc_imba_necronomicon_warrior_4"
	    local ranged_summon_name = "npc_imba_necronomicon_archer_4"

	    -- Calculate summon positions
	    local melee_loc = RotatePosition(caster_loc, QAngle(0, 30, 0), caster_loc + caster_direction * 180)
	    local ranged_loc = RotatePosition(caster_loc, QAngle(0, -30, 0), caster_loc + caster_direction * 180)

	    -- Destroy trees
	    GridNav:DestroyTreesAroundPoint(caster_loc + caster_direction * 180, 180, false)

	    -- Spawn the summons
	    local melee_summon = CreateUnitByName(melee_summon_name, melee_loc, true, caster, caster, caster:GetTeam())
	    local ranged_summon = CreateUnitByName(ranged_summon_name, ranged_loc, true, caster, caster, caster:GetTeam())

	    -- Make the summons limited duration and controllable
	    melee_summon:SetControllableByPlayer(caster:GetPlayerID(), true)
	    melee_summon:AddNewModifier(caster, self, "modifier_kill", {duration = summon_duration})
	    ranged_summon:SetControllableByPlayer(caster:GetPlayerID(), true)
	    ranged_summon:AddNewModifier(caster, self, "modifier_kill", {duration = summon_duration})


	    -- Find summon abilities
	    local melee_ability_1 = melee_summon:FindAbilityByName("necronomicon_warrior_mana_burn")
	    local melee_ability_2 = melee_summon:FindAbilityByName("necronomicon_warrior_last_will")
	    local melee_ability_3 = melee_summon:FindAbilityByName("necronomicon_warrior_sight")

	    local ranged_ability_1 = ranged_summon:FindAbilityByName("necronomicon_archer_mana_burn")
	    local ranged_ability_2 = ranged_summon:FindAbilityByName("necronomicon_archer_aoe")
	    local ranged_ability_3 = ranged_summon:FindAbilityByName("black_dragon_fireball")

	    -- Upgrade abilities according to the Necronomicon level
	    melee_ability_1:SetLevel(1)
	    melee_ability_2:SetLevel(1)
	    melee_ability_3:SetLevel(1)
	    ranged_ability_1:SetLevel(1)
	    ranged_ability_2:SetLevel(1)
		ranged_ability_3:SetLevel(1)
		   
		if Util:PlayerEquipedItem(caster:GetPlayerOwnerID(), "ultron") == true then
			melee_summon:SetOriginalModel("models/heroes/hero_dormammu/dormammu_custom/modern/ultron_modern.vmdl")
			ranged_summon:SetOriginalModel("models/heroes/hero_dormammu/dormammu_custom/flying/ultron.vmdl")
			ranged_summon:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
			ranged_summon:SetRangedProjectileName("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf")
		end
	end
end


if modifier_item_necronomicon_4 == nil then
    modifier_item_necronomicon_4 = class ( {})
end

function modifier_item_necronomicon_4:IsHidden()
    return true 
end

function modifier_item_necronomicon_4:IsPurgable()
    return false
end

function modifier_item_necronomicon_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_item_necronomicon_4:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_strength")
end

function modifier_item_necronomicon_4:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end

function item_necronomicon_4:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

