LinkLuaModifier ("modifier_deadpool_omniverse", "abilities/deadpool_omniverse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_deadpool_omniverse_thinker", "abilities/deadpool_omniverse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_deadpool_omniverse_illusion", "abilities/deadpool_omniverse.lua", LUA_MODIFIER_MOTION_NONE)

deadpool_omniverse = class ({})

function deadpool_omniverse:GetCastRange(vLocation, hTarget) return self.BaseClass.GetCastRange (self, vLocation, hTarget) end
function deadpool_omniverse:GetAOERadius() return self:GetSpecialValueFor("radius") end
function deadpool_omniverse:GetCooldown (nLevel) return self.BaseClass.GetCooldown (self, nLevel) end
function deadpool_omniverse:GetManaCost (hTarget) return self.BaseClass.GetManaCost (self, hTarget) end
function deadpool_omniverse:GetBehavior() return DOTA_ABILITY_BEHAVIOR_AOE +  DOTA_ABILITY_BEHAVIOR_POINT end


function deadpool_omniverse:OnSpellStart ()
    if IsServer() then 
        local thinker = CreateModifierThinker (self:GetCaster(), self, "modifier_deadpool_omniverse_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
        AddFOWViewer (self:GetCaster():GetTeam (), self:GetCursorPosition(), 450, 4, false)
        GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), 500, false)
    end 
end

modifier_deadpool_omniverse_thinker = class ( {})

function modifier_deadpool_omniverse_thinker:OnCreated(event)
    if IsServer() then
        EmitSoundOn("Hero_Clinkz.BurningArmy.SpellStart", self:GetParent())
        EmitSoundOn("Hero_Clinkz.BurningArmy.Cast", self:GetParent())

        local nFXIndex = ParticleManager:CreateParticle ("particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_crimson_ti8_immortal_pitofmalice.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), 22, 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("duration"), 1, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_deadpool_omniverse_thinker:IsAura() return true end
function modifier_deadpool_omniverse_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_deadpool_omniverse_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_deadpool_omniverse_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_deadpool_omniverse_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_deadpool_omniverse_thinker:GetModifierAura() return "modifier_deadpool_omniverse" end


if modifier_deadpool_omniverse == nil then modifier_deadpool_omniverse = class({}) end

function modifier_deadpool_omniverse:IsHidden() return false end
function modifier_deadpool_omniverse:IsPurgable() return false end
function modifier_deadpool_omniverse:IsDebuff() return true end
function modifier_deadpool_omniverse:IsStunDebuff() return true end
function modifier_deadpool_omniverse:GetStatusEffectName() return "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_omni.vpcf" end
function modifier_deadpool_omniverse:StatusEffectPriority() return 1000 end
function modifier_deadpool_omniverse:GetEffectName() return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf" end
function modifier_deadpool_omniverse:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_deadpool_omniverse:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_deadpool_omniverse:GetModifierMoveSpeed_Absolute() return 128 end
function modifier_deadpool_omniverse:CheckState () return { [MODIFIER_STATE_SILENCED] = true } end
function modifier_deadpool_omniverse:OnCreated( kv )
    if IsServer() then
        self:StartIntervalThink(1 / self:GetCaster():GetAttacksPerSecond())
        self:OnIntervalThink()
    end
end

function modifier_deadpool_omniverse:OnIntervalThink()
    if IsServer() then
        self:GetCaster():PerformAttack(self:GetParent(), false, true, true, false, false, false, false)
    end
end
