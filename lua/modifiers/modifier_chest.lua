require('ChestsUI')

local items = {
--- "item_clarity",
--- "item_enchanted_raspberries",
"item_mango",
--- "item_tango",
--- "item_flask",
"item_greater_salve",
"item_enchanted_pineapple",
--- "item_dust",
--- "item_ward_observer",
--- "item_ward_sentry",
--- "item_bottle",
--- "item_courier",
"item_boots_of_protection",
"item_bloodthorn",
--- "item_azuras_staff",
--- "item_gauntlets",
--- "item_slippers",
--- "item_mantle",
--- "item_circlet",
--- "item_belt_of_strength",
--- "item_boots_of_elves",
--- "item_robe",
--- "item_ogre_axe",
--- "item_battle_rage",
"item_ethernal_blink",
--- "item_hurricane_pike",
"item_tome_of_knowledge",
--- "item_gungner",
--- "item_sea_blade",
"item_coffee",
--- "item_sentinels_cuirass",
"item_force_boots",
"item_ring_of_protection",
--- "item_stout_shield",
--- "item_quelling_blade",
--- "item_orb_of_venom",
"item_blades_of_attack",
"item_chainmail",
"item_quarterstaff",
"item_helm_of_iron_will",
"item_broadsword",
"item_claymore",
"item_javelin",
"item_mithril_hammer",
"item_blight_stone",
--- "item_ethernal_dagon_scepter",
"item_magic_stick",
"item_sobi_mask",
"item_ring_of_regen",
"item_boots",
"item_gloves",
"item_cloak",
"item_ring_of_health",
"item_void_stone",
"item_gem",
"item_lifesteal",
"item_shadow_amulet",
"item_ghost",
"item_blink",
"item_wind_lace",
"item_necronomicon_4",
--- "item_ruby_sphere",
--- "item_rapier_ethereal",
--- "item_rapier_ancient",
--- "item_heart_2",
--- "item_sunshines_aromor",
--- "item_absolute_staff",
--- "item_desolator_2",
"item_hand_of_midas",
"item_travel_boots",
"item_moon_shard_marvel",
--- "item_high_frequency_blade",
--- "item_twisted_axe",
--- "item_chaotic_axe",
--- "item_burning_fiend",
--- "item_blessed_halberd",
--- "item_buckler",
"item_urn_of_shadows",
--- "item_death_scyche",
"item_ring_of_aquila",
"item_medallion_of_courage",
"item_arcane_boots",
"item_mekansm",
"item_vladmir",
"item_pipe",
"item_guardian_greaves",
"item_blink_2",
--- "item_vermilion_robe",
--- "item_monarh_bow",
--- "item_spirit_stone",
--- "item_heart_of_universe",
"item_force_staff",
"item_dagon",
"item_cyclone",
"item_rod_of_atos",
"item_orchid",
"item_ultimate_scepter",
"item_ethereal_blade",
"item_refresher",
--- "item_glimmers_armor",
"item_octarine_core",
--- "item_oathbreaker",
--- "item_vibranium_sword",
--- "item_eclipsed_blade",
--- "item_soul_urn",
"item_vanguard",
"item_blade_mail",
--- "item_ego_gem",
--- "item_ethernal_radiance_blade",
"item_black_king_bar",
"item_shivas_guard",
"item_bloodstone",
"item_manta",
--- "item_sphere",
"item_assault",
--- "item_heart",
--- "item_skadi_2",
--- "item_demon_shard_2",
--- "item_octarine_core_2",
--- "item_shine_of_sea",
--- "item_axe_of_phractos",
--- "item_demonic_claws",
--- "item_echoe_shield",
"item_basher",
"item_bfury",
--- "item_silver_edge",
--- "item_radiance",
--- "item_monkey_king_bar",
--- "item_greater_crit",
"item_butterfly",
--- "item_ritual_rapier",
--- "item_abyssal_blade",
--- "item_glove_of_the_creator",
--- "item_ds",
--- "item_effulgent_sword",
--- "item_grand_magus_scepter",
--- "item_ghost_staff",
--- "item_desolator",
--- "item_heart_of_abyss",
--- "item_skadi",
--- "item_void_gem",
--- "item_ego_gem",
--- "item_stoneofinity",
--- "item_soul",
--- "item_time",
--- "item_tesseract",
--- "item_aether",
--- "item_shere2",
--- "item_ancient_cursed_helmet",
--- "item_frostmourne",
"item_tpscroll",
"item_magic_stick",
"item_stout_shield",
--- "item_sobi_mask",
"item_ring_of_regen",
"item_orb_of_venom",
"item_boots",
"item_cloak",
"item_ring_of_health",
"item_void_stone",
"item_lifesteal",
"item_helm_of_iron_will",
"item_energy_booster",
"item_slippers",
"item_mantle",
"item_quelling_blade",
"item_belt_of_strength",
"item_boots_of_elves",
"item_robe",
"item_blades_of_attack",
"item_gloves",
"item_chainmail",
"item_quarterstaff",
"item_broadsword",
"item_ultimate_orb",
"item_blink",
"item_energy_booster",
"item_vitality_booster",
"item_point_booster",
"item_platemail",
"item_talisman_of_evasion",
"item_hyperstone",
"item_ultimate_orb",
"item_demon_edge",
"item_mystic_staff",
"item_reaver",
"item_eagle",
"item_relic"}


if modifier_chest == nil then modifier_chest = class({}) end

function modifier_chest:IsHidden()
	return true
end

function modifier_chest:IsPurgable()
	return false
end

function modifier_chest:OnCreated(htable)
	if IsServer() then
		EmitSoundOn("ui.treasure.underscore", self:GetParent())
	end
end

function modifier_chest:OnDestroy()
	if IsServer() then

		StopSoundOn("ui.treasure.underscore", self:GetParent())
		EmitSoundOn("ui.treasure_03", self:GetParent())
		GameRules:GetGameModeEntity():SetThink("SpawnChests", ChestsUI, 600)

		local item = CreateItem(items[RandomInt(0, #items)], nil, nil)
		local container = CreateItemOnPositionForLaunch(self:GetParent():GetAbsOrigin(), item)

		local dropRadius = RandomFloat( 10, 50 )

		item:LaunchLootInitialHeight( false, 0, 500, 0.75, self:GetParent():GetAbsOrigin() + RandomVector( dropRadius ) )

		Notifications:BottomToAll({text="Treasury gives ", continue=true, duration=5, style={color="red", ["font-size"]="34px", border="0px solid blue"}})
    	Notifications:BottomToAll({item=item:GetName(), continue=true, duration = 5})
    	self:GetParent():SetModelScale(0)
	end
end

function modifier_chest:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
	}

	return funcs
end

function modifier_chest:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_chest:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_chest:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_chest:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_chest:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_DISARMED] = true
	}

	return state
end
