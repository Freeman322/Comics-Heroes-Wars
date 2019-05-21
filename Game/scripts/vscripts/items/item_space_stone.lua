if item_space_stone == nil then item_space_stone = class({}) end

LinkLuaModifier ("modifier_item_space_stone", "items/item_space_stone.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_space_stone_delay", "items/item_space_stone.lua", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

item_space_stone.m_hAncients = {
	Vector(6880, 6368, 384),
	Vector(-7168, -6656, 384)
}

local MAX_DIST = 1100

function item_space_stone:CastFilterResultLocation( vLocation )
	for _,vector in pairs(self.m_hAncients) do
		if (vLocation - vector):Length2D() <= MAX_DIST then
			return UF_FAIL_OBSTRUCTED
		end
	end

	return UF_SUCCESS
end

function item_space_stone:OnSpellStart()
	if IsServer() then 
		local target = self:GetCursorPosition()
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_space_stone_delay", {duration = self:GetSpecialValueFor("wormhole_delay"), x = target.x, y = target.y, z = target.z})
	end	
end

function item_space_stone:GetIntrinsicModifierName()
    return "modifier_item_space_stone"
end

if modifier_item_space_stone == nil then
    modifier_item_space_stone = class({})
end

function modifier_item_space_stone:IsHidden()
    return true 
end

function modifier_item_space_stone:IsPurgable()
    return false
end

function modifier_item_space_stone:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end


function modifier_item_space_stone:GetModifierMoveSpeedBonus_Constant( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_speed" )
end

function modifier_item_space_stone:GetModifierHealthBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health" )
end

function modifier_item_space_stone:GetModifierManaBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_mana" )
end

modifier_item_space_stone_delay = class({})

function modifier_item_space_stone_delay:IsPurgable()
	return false
end

function modifier_item_space_stone_delay:IsHidden()
	return true
end

function modifier_item_space_stone_delay:OnCreated(table)
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_final_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 5, Vector(self:GetAbility():GetSpecialValueFor("wormhole_delay"), self:GetAbility():GetSpecialValueFor("wormhole_delay"), 0))
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice.TI8", self:GetParent())
		EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice.TI8", self:GetParent())

		self.target = self:GetCaster():GetCursorPosition()
	end
end

function modifier_item_space_stone_delay:OnDestroy()
	if IsServer() then
		local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("wormhole_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #allies > 0 then
			for _,ally in pairs(allies) do
				ally:SetAbsOrigin(self.target)

				EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", ally)
				FindClearSpaceForUnit(ally, self.target, false)
				ParticleManager:CreateParticle ("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_POINT_FOLLOW, ally)
			end
		end

		EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Complete", self:GetCaster() )
		GridNav:DestroyTreesAroundPoint(self.target, 450, false)
	end
end

function modifier_item_space_stone_delay:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end
