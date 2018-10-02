LinkLuaModifier ("modifier_tribunal_crit", "abilities/tribunal_crit.lua", LUA_MODIFIER_MOTION_NONE)

if tribunal_crit == nil then tribunal_crit = class ( {}) end

function tribunal_crit:GetIntrinsicModifierName ()
    return "modifier_tribunal_crit"
end

if modifier_tribunal_crit == nil then modifier_tribunal_crit = class ( {}) end
function modifier_tribunal_crit:IsHidden() return true end
function modifier_tribunal_crit:IsPurgable() return false end
function modifier_tribunal_crit:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end

function modifier_tribunal_crit:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then 
    	if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
            local hTarget = params.target

            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
            EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Target", hTarget)
            ScreenShake(hTarget:GetOrigin(), 100, 0.1, 0.3, 500, 0, true)

    		return self:GetAbility():GetSpecialValueFor("crit_bonus")
    	end
    end 
	return
end
