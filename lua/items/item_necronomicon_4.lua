if item_necronomicon_4 == nil then item_necronomicon_4 = class({}) end 

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
	    melee_ability_1:SetLevel(necro_level)
	    melee_ability_2:SetLevel(necro_level)
	    melee_ability_3:SetLevel(1)
	    ranged_ability_1:SetLevel(necro_level)
	    ranged_ability_2:SetLevel(necro_level)
   	    ranged_ability_3:SetLevel(1)
	end
end
function item_necronomicon_4:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

