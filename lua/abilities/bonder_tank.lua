bonder_tank = class ( {})
LinkLuaModifier("modifier_bonder_tank", "abilities/bonder_tank.lua", LUA_MODIFIER_MOTION_NONE)

function bonder_tank:GetCooldown (nLevel)
	if self:GetCaster():HasModifier("modifier_special_bonus_unique_byonder") then
        return 20
    end
    return self.BaseClass.GetCooldown (self, nLevel)
end

function bonder_tank:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function bonder_tank:OnSpellStart ()
    local hCaster = self:GetCaster()
    local pID = hCaster:GetPlayerID()
    local particleName = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"
    EmitSoundOn("Hero_Enigma.Malefice", hCaster)
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, hCaster )
	ParticleManager:SetParticleControl( particle1, 0, hCaster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle1, 1, hCaster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle1, 2, Vector(500,0,0) )

    local duration = self:GetSpecialValueFor("duration")

    local treant = CreateUnitByName("npc_dota_warlock_golem_scepter_1", hCaster:GetAbsOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber())
    treant:SetControllableByPlayer(pID, true)
    treant:AddNewModifier(hCaster, self, "modifier_kill", {duration = duration})
    treant:AddNewModifier(hCaster, self, "modifier_bonder_tank", {duration = duration})
    FindClearSpaceForUnit(treant, hCaster:GetAbsOrigin(), true)
	if hCaster:HasModifier("modifier_bynder_passive") then
		local mod = hCaster:FindModifierByName("modifier_bynder_passive")
		mod:SetStackCount(mod:GetStackCount() + 1)
		hCaster:CalculateStatBonus()
	end
end

if modifier_bonder_tank == nil then modifier_bonder_tank = class({}) end

function modifier_bonder_tank:IsHidden()
	return true
	-- body
end

function modifier_bonder_tank:IsPurgable()
	return false
	-- body
end

function modifier_bonder_tank:OnCreated(table)
	if IsServer() then
		self.strength = self:GetCaster():GetStrength()
        self.agility = self:GetCaster():GetAgility()
	end
end

function modifier_bonder_tank:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bonder_tank:GetModifierExtraHealthBonus( params )
	return self.strength*self:GetAbility():GetSpecialValueFor("health_bonus")
end

--------------------------------------------------------------------------------

function modifier_bonder_tank:GetModifierBaseAttack_BonusDamage( params )
	return self.agility*self:GetAbility():GetSpecialValueFor("damage_bonus")
end

function bonder_tank:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

