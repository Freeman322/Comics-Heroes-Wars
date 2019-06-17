LinkLuaModifier ("modifier_nightcrawler_nightcrawler_cloud_jumps", "abilities/nightcrawler_cloud_jumps.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_nightcrawler_nightcrawler_cloud_jumps_fake", "abilities/nightcrawler_cloud_jumps.lua", LUA_MODIFIER_MOTION_NONE)

if nightcrawler_cloud_jumps == nil then nightcrawler_cloud_jumps = class({}) end

--------------------------------------------------------------------------------

function nightcrawler_cloud_jumps:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function nightcrawler_cloud_jumps:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function nightcrawler_cloud_jumps:OnSpellStart()
	local hCaster = self:GetCaster()
	EmitSoundOn( "Hero_MonkeyKing.FurArmy.Channel", hCaster )
	hCaster:AddNewModifier(hCaster, self, "modifier_nightcrawler_nightcrawler_cloud_jumps", {duration = self:GetSpecialValueFor("duration")})
end

if modifier_nightcrawler_nightcrawler_cloud_jumps == nil then modifier_nightcrawler_nightcrawler_cloud_jumps = class({}) end

function modifier_nightcrawler_nightcrawler_cloud_jumps:IsHidden()
    return false
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:IsBuff()
    return false
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:GetStatusEffectName()
    return "particles/status_fx/status_effect_phase_shift.vpcf"
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:StatusEffectPriority()
    return 1000
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:GetEffectName()
    return "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf"
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:OnCreated()
    if IsServer() then
        local interval = self:GetAbility():GetSpecialValueFor("tick_interval")
        self:StartIntervalThink(interval)
        self:OnIntervalThink()

        local particle1 = "particles/hero_nightcrawler/nightcrawler_cloud_jumps.vpcf"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "octavia") then
            particle1 = "particles/octavia_skin/nightcrawler_cloud_jumps.vpcf"

            EmitSoundOn("OctaviaSkin.Ult", self:GetCaster())
        end

        local nFXIndex = ParticleManager:CreateParticle( particle1, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 0,  self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0) )
        ParticleManager:SetParticleControl( nFXIndex, 2,  Vector(self:GetAbility():GetSpecialValueFor("duration"), 1, 0))
        ParticleManager:SetParticleControl( nFXIndex, 7,  self:GetParent():GetAbsOrigin() )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent ()
        local hAbility = self:GetAbility ()

        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), thinker:GetAbsOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
        if #targets > 0 then
            for _,target in pairs(targets) do
                local nFXIndex = ParticleManager:CreateParticle ("particles/hero_nightcrawler/nightcrawler_cloud_jumps_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit);
                ParticleManager:SetParticleControlEnt (nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin (), true);
                ParticleManager:SetParticleControlEnt (nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin (), true);
                ParticleManager:ReleaseParticleIndex (nFXIndex);

                EmitSoundOn("Hero_MonkeyKing.Attack", target)
                EmitSoundOn("Hero_MonkeyKing.IronCudgel", target)

                self:GetAbility():GetCaster():PerformAttack(target, true, true, true, true, false, false, true)   
            end
        end
    end
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }

    return state
end

function modifier_nightcrawler_nightcrawler_cloud_jumps:OnDestroy()
	if IsServer() then
		EmitSoundOn("Hero_MonkeyKing.FurArmy.End", self:GetParent())
	end
end

if modifier_nightcrawler_nightcrawler_cloud_jumps_fake == nil then modifier_nightcrawler_nightcrawler_cloud_jumps_fake = class({}) end

function modifier_nightcrawler_nightcrawler_cloud_jumps_fake:IsHidden ()
    return true
end

function modifier_nightcrawler_nightcrawler_cloud_jumps_fake:IsPurgable ()
    return false
end

function nightcrawler_cloud_jumps:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

