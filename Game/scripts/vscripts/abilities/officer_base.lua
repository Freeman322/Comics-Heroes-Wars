officer_base = class({})

officer_base.m_hAncients = {
	Vector(6880, 6368, 384),
	Vector(-7168, -6656, 384)
}

local MAX_DIST = 1100

function officer_base:CastFilterResultLocation( vLocation )
	for _,vector in pairs(self.m_hAncients) do
		if (vLocation - vector):Length2D() <= MAX_DIST then
			return UF_FAIL_OBSTRUCTED
		end
	end

	return UF_SUCCESS
end

function officer_base:OnSpellStart( )
     if IsServer() then
          local caster = self:GetCaster()
          local point = self:GetCaster():GetCursorPosition()
          local bases = Entities:FindAllByModel("models/heroes/hero_officer/base/base.vmdl")

          if #bases < self:GetSpecialValueFor("max_buildings") then
               PrecacheUnitByNameAsync("npc_dota_unit_officer_base", function()
                    local base = CreateUnitByName("npc_dota_unit_officer_base", point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
                    base:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
                    base:SetUnitCanRespawn(false)

                    local mana = self:GetSpecialValueFor("max_mana_regen")

                    if self:GetCaster():HasTalent("special_bonus_unique_officer_2") then mana = mana + self:GetCaster():FindTalentValue("special_bonus_unique_officer_2") end 
                   
                    base:SetBaseManaRegen(base:GetManaRegen() + mana)

                    base.i_mRounds = 0
                    base.i_Hero = self:GetCaster()

                    base:SetAbsOrigin(point)
               end)
          end
     end
end

