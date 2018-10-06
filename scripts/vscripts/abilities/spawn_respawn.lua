if spawn_respawn == nil then spawn_respawn = class({}) end
LinkLuaModifier("modifier_spawn_respawn", "abilities/spawn_respawn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_respawn_astral", "abilities/spawn_respawn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spawn_respawn_buff", "abilities/spawn_respawn.lua", LUA_MODIFIER_MOTION_NONE)

function spawn_respawn:GetIntrinsicModifierName()
    return "modifier_spawn_respawn"
end

if modifier_spawn_respawn == nil then modifier_spawn_respawn = class({}) end

function modifier_spawn_respawn:IsHidden()
    return true
end

function modifier_spawn_respawn:IsPurgable()
    return false
end

function modifier_spawn_respawn:DeclareFunctions ()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_spawn_respawn:OnTakeDamage(args)
    if self:GetParent() == args.unit then
        if IsServer() then
            if self:GetParent():IsRealHero() == false or self:GetParent():IsIllusion() then
                return nil
            end
            if self:GetParent():GetHealth() <= 0 and self:GetAbility():IsCooldownReady() then
                EmitSoundOn( "Hero_PhantomLancer.Doppelganger.Appear", self:GetCaster() )
                self:GetParent():Heal(self:GetCaster():GetMaxHealth(), self:GetAbility())
                self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
                self:GetAbility():PayManaCost()

                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_spawn_respawn_astral", {duration = self:GetAbility():GetSpecialValueFor("reincarnate_time")})
            end
        end
    end
end

modifier_spawn_respawn_astral = class({})

function modifier_spawn_respawn_astral:IsDebuff()
	return false
end

function modifier_spawn_respawn_astral:IsHidden()
	return true
end

function modifier_spawn_respawn_astral:IsPurgable()
	return false
end

function modifier_spawn_respawn_astral:GetEffectName()
	return "particles/hero_spawn/spawn_respawn.vpcf"
end

function modifier_spawn_respawn_astral:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_spawn_respawn_astral:CheckState()
	local state = {
  	[MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true
	}

	return state
end

function modifier_spawn_respawn_astral:OnCreated(args)
	if IsServer() then
        self:GetCaster():SetModelScale(0)
   end
end

function modifier_spawn_respawn_astral:OnDestroy()
    if IsServer() then

        if self:GetCaster():HasScepter() then
            local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
            if #units > 0 then
                for _,target in pairs(units) do
    
                local damage = {
                          victim = target,
                          attacker = self:GetCaster(),
                          damage = self:GetAbility():GetSpecialValueFor("damage_scepter"),
                          damage_type = DAMAGE_TYPE_MAGICAL,
                          ability = self:GetAbility()
                }
    
                ApplyDamage( damage )
    
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
                ParticleManager:ReleaseParticleIndex(nFXIndex)
    
                EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.End", target)
                end
            end
            EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.Cast", self:GetCaster())
            EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster())
        end

        self:GetCaster():SetModelScale(0.7000)

        self:GetCaster():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_spawn_respawn_buff", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
        EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.End", self:GetCaster())
    end
   
end

if modifier_spawn_respawn_buff == nil then modifier_spawn_respawn_buff = class({}) end

function modifier_spawn_respawn_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_templar_slow.vpcf"
end

function modifier_spawn_respawn_buff:StatusEffectPriority()
	return 1000
end

function modifier_spawn_respawn_buff:IsHidden()
    return true
end

function modifier_spawn_respawn_buff:IsPurgable()
    return false
end

function modifier_spawn_respawn_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end
function modifier_spawn_respawn_buff:GetModifierHealthBonus( params )
    return self:GetAbility():GetSpecialValueFor( "health_bonus" )
end

function modifier_spawn_respawn_buff:GetModifierSpellAmplify_Percentage( params )
    return self:GetAbility():GetSpecialValueFor( "spell_amp" )
end

function spawn_respawn:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

