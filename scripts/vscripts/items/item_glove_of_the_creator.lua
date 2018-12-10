LinkLuaModifier( "modifier_item_glove_of_the_creator", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_death", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_item_glove_of_the_creator_space", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_soul", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_mind", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_reality", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_power", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_time", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_glove_of_the_creator_snap", "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier("modifier_daredevil_supersence", "abilities/daredevil_supersence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mind_gem_active", "items/item_mind_gem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_reality_gem_active", "items/item_reality_gem.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_glove_of_the_creator_time_buff",  "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_glove_of_the_creator_time_aura",  "items/item_glove_of_the_creator.lua", LUA_MODIFIER_MOTION_NONE )


MODIFIERS = { 
    ABILITY_SPACE = "modifier_item_glove_of_the_creator_space",
    ABILITY_SOUL = "modifier_item_glove_of_the_creator_soul",
    ABILITY_MIND = "modifier_item_glove_of_the_creator_mind",
    ABILITY_REALITY = "modifier_item_glove_of_the_creator_reality",
    ABILITY_POWER = "modifier_item_glove_of_the_creator_power",
    ABILITY_TIME = "modifier_item_glove_of_the_creator_time",
    ABILITY_SNAP = "modifier_item_glove_of_the_creator_snap"
}

function to_name( value )
    return VALUES[value]
end

VALUES = {}
VALUES[0] = "ABILITY_SOUL"
VALUES[1] = "ABILITY_MIND"
VALUES[2] = "ABILITY_SPACE"
VALUES[3] = "ABILITY_REALITY"
VALUES[4] = "ABILITY_TIME"
VALUES[5] = "ABILITY_POWER"
VALUES[6] = "ABILITY_SNAP"

ABILITY_SOUL = 0;
ABILITY_MIND = 1;
ABILITY_SPACE = 2;
ABILITY_REALITY = 3;
ABILITY_TIME = 4;
ABILITY_POWER = 5;
ABILITY_SNAP = 6;

BEHAVIORS = {}
BEHAVIORS[ABILITY_SNAP] = DOTA_ABILITY_BEHAVIOR_NO_TARGET
BEHAVIORS[ABILITY_SOUL]  = DOTA_ABILITY_BEHAVIOR_NO_TARGET
BEHAVIORS[ABILITY_SPACE] = DOTA_ABILITY_BEHAVIOR_POINT
BEHAVIORS[ABILITY_MIND]  = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
BEHAVIORS[ABILITY_REALITY]  = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
BEHAVIORS[ABILITY_TIME]  = DOTA_ABILITY_BEHAVIOR_NO_TARGET
BEHAVIORS[ABILITY_POWER]  = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET

if item_glove_of_the_creator == nil then item_glove_of_the_creator = class({}) end

function item_glove_of_the_creator:GetIntrinsicModifierName()
	return "modifier_item_glove_of_the_creator"
end

function item_glove_of_the_creator:GetCurrentAbilityModifier()
	return self:GetCaster():FindModifierByName(MODIFIERS[to_name(self:GetCurrentAbility())])
end

function item_glove_of_the_creator:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function item_glove_of_the_creator:GetCurrentAbility()
    if self:GetCaster() and self:GetCaster():HasModifier("modifier_item_glove_of_the_creator") then return self:GetCaster():GetModifierStackCount("modifier_item_glove_of_the_creator", self:GetCaster()) or 6 end 
    return 6
end

function item_glove_of_the_creator:GetCastRange( vLocation, hTarget )
	if self:GetCurrentAbility() == ABILITY_POWER then 
		return 1200
    end
    
    if self:GetCurrentAbility() == ABILITY_SOUL then 
		return 800
    end
    
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function item_glove_of_the_creator:GetBehavior()
    return BEHAVIORS[self:GetCurrentAbility()] or DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function item_glove_of_the_creator:SelectAbility(ability)
    EmitSoundOn("IG.Select.Gem", self:GetCaster())

    self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):SetStackCount(tonumber(ability))
end

function item_glove_of_the_creator:IsRefreshable()
    return false
end

function item_glove_of_the_creator:OnSpellStart()
    if IsServer() then
        local ability = self:GetCurrentAbilityModifier()
        if ability then
            if ability:IsCooldownReady() then
                ability:OnSpellStart({
                    vLoc = self:GetCursorPosition(),
                    target = self:GetCursorTarget()
                })
            else 
                CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "create_error_message", {message = "Ability is on cooldown!"})
            end 
        end 
    end
end
--------------------------------------------------------------------------------
if modifier_item_glove_of_the_creator == nil then  modifier_item_glove_of_the_creator = class({}) end

function modifier_item_glove_of_the_creator:IsHidden() return true end
function modifier_item_glove_of_the_creator:IsPurgable() return false end
function modifier_item_glove_of_the_creator:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

    }

    return funcs
end
function modifier_item_glove_of_the_creator:GetModifierPreAttack_BonusDamage( params ) return self:GetAbility():GetSpecialValueFor( "bonus_damage" ) end
function modifier_item_glove_of_the_creator:GetModifierBonusStats_Strength( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_glove_of_the_creator:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_glove_of_the_creator:GetModifierBonusStats_Agility( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_glove_of_the_creator:GetModifierConstantManaRegen( params ) return self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" ) end
function modifier_item_glove_of_the_creator:GetModifierConstantHealthRegen( params )  return self:GetAbility():GetSpecialValueFor("bonus_health_regen" ) end
function modifier_item_glove_of_the_creator:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_glove_of_the_creator:OnCreated(params)
   if IsServer() then 
        if MODIFIERS then 
            for type, modifier in pairs(MODIFIERS) do
                self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifier, nil)
            end
        end 
   end
end
function modifier_item_glove_of_the_creator:OnDestroy()
    if IsServer() then 
         if MODIFIERS then 
             for type, modifier in pairs(MODIFIERS) do
                 self:GetParent():RemoveModifierByName(modifier)
             end
         end 
    end
 end

if not modifier_item_glove_of_the_creator_death then modifier_item_glove_of_the_creator_death = class({}) end 
function modifier_item_glove_of_the_creator_death:OnDestroy() if IsServer() then self:GetParent():Kill(self:GetAbility(), self:GetCaster()) end end
function modifier_item_glove_of_the_creator_death:IsHidden() return true end
function modifier_item_glove_of_the_creator_death:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_death:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_death:IsDebuff() return true end
if not modifier_item_glove_of_the_creator_space then modifier_item_glove_of_the_creator_space = class({}) end 
function modifier_item_glove_of_the_creator_space:IsHidden() return false end
function modifier_item_glove_of_the_creator_space:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_space:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_space:DestroyOnExpire() return false end
function modifier_item_glove_of_the_creator_space:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_glove_of_the_creator_space:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
function modifier_item_glove_of_the_creator_space:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_glove_of_the_creator_space:OnSpellStart(params)
    if IsServer() then
        local loc = params.vLoc
        local direction = (loc - self:GetCaster():GetAbsOrigin())

        EmitSoundOn("DOTA_Item.BlinkDagger.NailedIt", self:GetParent())

        local effect_cast_a = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( effect_cast_a, 0, loc )
        ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
        ParticleManager:ReleaseParticleIndex( effect_cast_a )

        self:GetParent():SetAbsOrigin(loc)
        FindClearSpaceForUnit(self:GetParent(), loc, false)

        EmitSoundOn("DOTA_Item.BlinkDagger.NailedIt", self:GetParent())

        local effect_cast_b = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( effect_cast_b, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControlForward( effect_cast_b, 0, direction:Normalized() )
        ParticleManager:ReleaseParticleIndex( effect_cast_b )

        self:StartCooldown(self:GetAbility():GetSpecialValueFor("ability_space"))
    end 
end 
function modifier_item_glove_of_the_creator_space:GetTexture() return "custom/space_stone" end
if not modifier_item_glove_of_the_creator_soul then modifier_item_glove_of_the_creator_soul = class({}) end 
function modifier_item_glove_of_the_creator_soul:IsHidden() return false end
function modifier_item_glove_of_the_creator_soul:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_soul:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_soul:DestroyOnExpire() return false end
function modifier_item_glove_of_the_creator_soul:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_glove_of_the_creator_soul:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
function modifier_item_glove_of_the_creator_soul:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_glove_of_the_creator_soul:OnSpellStart(params)
    if IsServer() then
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
		if #units > 0 then
			for _,unit in pairs(units) do
				unit:AddNewModifier( self:GetCaster(), self, "modifier_daredevil_supersence", { duration = 12 } )
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_ElderTitan.EchoStomp.Channel.ti7", self:GetCaster() )
        EmitSoundOn( "Hero_ElderTitan.EchoStomp.ti7", self:GetCaster() )
        
        self:StartCooldown(self:GetAbility():GetSpecialValueFor("ability_soul"))
    end 
end 
function modifier_item_glove_of_the_creator_soul:GetTexture() return "custom/soul" end

if not modifier_item_glove_of_the_creator_mind then modifier_item_glove_of_the_creator_mind = class({}) end 
function modifier_item_glove_of_the_creator_mind:IsHidden() return false end
function modifier_item_glove_of_the_creator_mind:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_mind:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_mind:DestroyOnExpire() return false end
function modifier_item_glove_of_the_creator_mind:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_glove_of_the_creator_mind:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
function modifier_item_glove_of_the_creator_mind:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_glove_of_the_creator_mind:OnSpellStart(params)
    if IsServer() then
        local target = params.target
		local caster = self:GetCaster()
        if target ~= nil then
            local particleName = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"	
            local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )
            ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
            local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
            ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

            EmitSoundOn("Hero_Terrorblade.Sunder.Cast", target)
            EmitSoundOn("Hero_Terrorblade.Sunder.Target", caster)

            if target:GetHealth() > 0 then
                target:AddNewModifier(caster, self, "modifier_item_mind_gem_active", {duration = 8})
            end

            self:StartCooldown(self:GetAbility():GetSpecialValueFor("ability_mind"))
        end
    end 
end 
function modifier_item_glove_of_the_creator_mind:GetTexture() return "custom/mind_gem" end

if not modifier_item_glove_of_the_creator_reality then modifier_item_glove_of_the_creator_reality = class({}) end 
function modifier_item_glove_of_the_creator_reality:IsHidden() return false end
function modifier_item_glove_of_the_creator_reality:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_reality:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_reality:DestroyOnExpire() return false end
function modifier_item_glove_of_the_creator_reality:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_glove_of_the_creator_reality:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
function modifier_item_glove_of_the_creator_reality:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_glove_of_the_creator_reality:OnSpellStart(params)
    if IsServer() then 
        local duration = 8
        local target = params.target

        EmitSoundOn("Item.RealityStone.Unit", target)
        target:AddNewModifier(self:GetCaster(), self, "modifier_item_reality_gem_active", {duration = duration})

        local nFXIndex = ParticleManager:CreateParticle( "particles/items/reality_gem_aoe.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0,  target:GetAbsOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(500, 500, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 2,  Vector(500, 500, 0)  )
        ParticleManager:SetParticleControl( nFXIndex, 3,  target:GetAbsOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Item.RealityStone.Cast", self:GetCaster() )

        self:StartCooldown(self:GetAbility():GetSpecialValueFor("ability_reality"))
    end
end
function modifier_item_glove_of_the_creator_reality:GetTexture() return "custom/reality_gem" end 
if not modifier_item_glove_of_the_creator_power then modifier_item_glove_of_the_creator_power = class({}) end 
function modifier_item_glove_of_the_creator_power:IsHidden() return false end
function modifier_item_glove_of_the_creator_power:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_power:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_power:DestroyOnExpire() return false end
function modifier_item_glove_of_the_creator_power:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_glove_of_the_creator_power:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
function modifier_item_glove_of_the_creator_power:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_glove_of_the_creator_power:OnSpellStart(params)
    if IsServer() then 
        local duration = 8
        local target = params.target
        
        if ( not target:TriggerSpellAbsorb( self ) ) then
            ApplyDamage ( { attacker = self:GetCaster(), victim = target, ability = self:GetAbility(), damage = 1000, damage_type = DAMAGE_TYPE_PURE })

			EmitSoundOn( "Ability.LagunaBladeImpact", target )
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti4/dagon_ti4.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn( "Ability.LagunaBladeImpact", self:GetCaster() )
        
        self:StartCooldown(self:GetAbility():GetSpecialValueFor("ability_power"))
    end
end 
function modifier_item_glove_of_the_creator_power:GetTexture() return "custom/power_gem" end 

if not modifier_item_glove_of_the_creator_time then modifier_item_glove_of_the_creator_time = class({}) end 
function modifier_item_glove_of_the_creator_time:IsHidden() return false end
function modifier_item_glove_of_the_creator_time:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_time:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_time:DestroyOnExpire() return false end
function modifier_item_glove_of_the_creator_time:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_glove_of_the_creator_time:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
function modifier_item_glove_of_the_creator_time:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_glove_of_the_creator_time:OnSpellStart(params)
    if IsServer() then 
        local duration = 8
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_glove_of_the_creator_time_aura", {duration = duration})
        
        EmitSoundOn("Strange.Obliteration_of_eternity.Cast", self:GetCaster())

        self:StartCooldown(self:GetAbility():GetSpecialValueFor("ability_time"))
    end
end 
function modifier_item_glove_of_the_creator_time:GetTexture() return "custom/time" end 

if not modifier_item_glove_of_the_creator_snap then modifier_item_glove_of_the_creator_snap = class({}) end 
function modifier_item_glove_of_the_creator_snap:IsHidden() return false end
function modifier_item_glove_of_the_creator_snap:IsPurgable() return false  end
function modifier_item_glove_of_the_creator_snap:RemoveOnDeath() return false  end
function modifier_item_glove_of_the_creator_snap:DestroyOnExpire() return false end
function modifier_item_glove_of_the_creator_snap:IsCooldownReady() return self:GetRemainingTime() <= 0 end
function modifier_item_glove_of_the_creator_snap:StartCooldown(flCooldown) self:SetDuration(flCooldown, true) end
function modifier_item_glove_of_the_creator_snap:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_glove_of_the_creator_snap:OnSpellStart(params)
    if IsServer() then 
        EmitSoundOn("Item.InfinityGauntlet.Cast", self:GetCaster())
       
        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 0, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, false )
        if #units > 0 then
            for _,unit in pairs(units) do
               if RollPercentage(50) and unit:IsFort() == false and unit ~= self:GetCaster() then
                  unit:AddNewModifier(self:GetCaster(), self, "modifier_item_glove_of_the_creator_death", {duration = math.random(5, 10)})
               end
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/items/infinity_gauntlet_snap_full.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex ) 

        ApplyDamage({victim = self:GetCaster(), attacker = self:GetCaster(), damage = self:GetCaster():GetHealth() / 2, damage_type = DAMAGE_TYPE_PURE})

        self:StartCooldown(self:GetAbility():GetSpecialValueFor("ability_snap"))
    end
end 
function modifier_item_glove_of_the_creator_time:GetTexture() return "custom/glove_of_the_creator" end 


if modifier_item_glove_of_the_creator_time_aura == nil then modifier_item_glove_of_the_creator_time_aura = class({}) end

function modifier_item_glove_of_the_creator_time_aura:IsAura() return true end

function modifier_item_glove_of_the_creator_time_aura:OnCreated()
    if IsServer () then
        local particle = ParticleManager:CreateParticleForPlayer("particles/hero_tzeench/tzeentch_warp_realm_of_chaos_screen.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
        self:AddParticle( particle, false, false, -1, false, true )
    end
end

function modifier_item_glove_of_the_creator_time_aura:OnDestroy() if IsServer () then EmitSoundOn("Strange.Obliteration_of_eternity.End", self:GetParent()) end end
function modifier_item_glove_of_the_creator_time_aura:IsHidden() return true end
function modifier_item_glove_of_the_creator_time_aura:IsPurgable() return false end
function modifier_item_glove_of_the_creator_time_aura:GetAuraRadius() return 99999 end
function modifier_item_glove_of_the_creator_time_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_item_glove_of_the_creator_time_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
function modifier_item_glove_of_the_creator_time_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD end
function modifier_item_glove_of_the_creator_time_aura:GetModifierAura() return "modifier_item_glove_of_the_creator_time_buff" end
if modifier_item_glove_of_the_creator_time_buff == nil then modifier_item_glove_of_the_creator_time_buff = class({}) end
function modifier_item_glove_of_the_creator_time_buff:IsPurgable() return false end
function modifier_item_glove_of_the_creator_time_buff:RemoveOnDeath() return false end
function modifier_item_glove_of_the_creator_time_buff:IsHidden() return true end
function modifier_item_glove_of_the_creator_time_buff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_item_glove_of_the_creator_time_buff:StatusEffectPriority() return 1000 end
function modifier_item_glove_of_the_creator_time_buff:IsPurgable() return false end
function modifier_item_glove_of_the_creator_time_buff:CheckState()
    if IsServer() then 
        if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() or not self:GetParent():IsRealHero() then 
            return {[MODIFIER_STATE_STUNNED] = true,[MODIFIER_STATE_FROZEN] = true}
        end 
    end 
    return 
end