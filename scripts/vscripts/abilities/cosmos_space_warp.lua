if not cosmos_space_warp then cosmos_space_warp = class({}) end
LinkLuaModifier( "modifier_cosmos_space_warp", "abilities/cosmos_space_warp.lua", LUA_MODIFIER_MOTION_NONE )

function cosmos_space_warp:OnSpellStart()
	if IsServer() then
		local duration = self:GetDuration()

		if self:GetCaster():HasTalent("special_bonus_unique_cosmos_2") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_cosmos_2") end 
		
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		if #units > 0 then
			for _,unit in pairs(units) do
				unit:AddNewModifier( self:GetCaster(), self, "modifier_cosmos_space_warp", { duration = duration } )
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/cosmos/cosmos_space_warp_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0,  self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1,  self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Warlock.Upheaval", self:GetCaster() )
	end
end


if modifier_cosmos_space_warp == nil then modifier_cosmos_space_warp = class({}) end

function modifier_cosmos_space_warp:IsDebuff() return true end
function modifier_cosmos_space_warp:IsHidden() return true end
function modifier_cosmos_space_warp:IsPurgable() return false end
function modifier_cosmos_space_warp:GetEffectName() return "particles/cosmos/cosmos_space_warp_debuff.vpcf" end
function modifier_cosmos_space_warp:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_cosmos_space_warp:GetStatusEffectName() return "particles/status_fx/status_effect_enigma_malefice.vpcf" end
function modifier_cosmos_space_warp:StatusEffectPriority() return 1000 end
function modifier_cosmos_space_warp:CheckState() return { [MODIFIER_STATE_SPECIALLY_DENIABLE] = true } end
function modifier_cosmos_space_warp:DeclareFunctions() return { MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE } end
function modifier_cosmos_space_warp:GetModifierTotalDamageOutgoing_Percentage ( params ) return self:GetAbility():GetSpecialValueFor("bonus_damage_outgoing") end
 