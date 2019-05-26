LinkLuaModifier( "modifier_oblivios_astral", "abilities/oblivios_astral", LUA_MODIFIER_MOTION_VERTICAL )

---@class oblivios_astral

local ABILITY_DURATION = 6

oblivios_astral = class({}) 

function oblivios_astral:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_oblivios_astral", {duration = ABILITY_DURATION} )
		EmitSoundOn( "DOTA_Item.GhostScepter.Activate", self:GetCaster() )
	end
end


modifier_oblivios_astral = class({})


--------------------------------------------------------------------------------

function modifier_oblivios_astral:IsStunDebuff() return false end
function modifier_oblivios_astral:IsHidden() return true end
function modifier_oblivios_astral:IsPurgable() return false end
function modifier_oblivios_astral:RemoveOnDeath() return false end

--------------------------------------------------------------------------------

function modifier_oblivios_astral:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

function modifier_oblivios_astral:GetEffectName() return "particles/items_fx/ghost.vpcf" end
function modifier_oblivios_astral:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_oblivios_astral:GetStatusEffectName() return "particles/status_fx/status_effect_ghost.vpcf" end
function modifier_oblivios_astral:StatusEffectPriority() return 1 end