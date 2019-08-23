LinkLuaModifier ("modifier_item_demon_shard_2", "items/item_demon_shard_2.lua", LUA_MODIFIER_MOTION_NONE)

if item_demon_shard_2 == nil then
    item_demon_shard_2 = class ( {})
end

function item_demon_shard_2:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function item_demon_shard_2:GetIntrinsicModifierName ()
    return "modifier_item_demon_shard_2"
end

if modifier_item_demon_shard_2 == nil then
    modifier_item_demon_shard_2 = class ( {})
end

function modifier_item_demon_shard_2:IsHidden()
    return true
end

function modifier_item_demon_shard_2:IsPurgable()
    return false
end

function modifier_item_demon_shard_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
    }

    return funcs
end

function modifier_item_demon_shard_2:GetModifierProcAttack_BonusDamage_Pure (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage_post_attack")
end

function modifier_item_demon_shard_2:GetBonusNightVision(params)
    local hAbility = self:GetAbility()
     return hAbility:GetSpecialValueFor("bonus_night_vision")
end

function modifier_item_demon_shard_2:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_demon_shard_2:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all")
end

function modifier_item_demon_shard_2:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all")
end

function modifier_item_demon_shard_2:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all")
end

function modifier_item_demon_shard_2:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("as")
end

function modifier_item_demon_shard_2:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then
        local chance = self:GetAbility():GetSpecialValueFor("crit_chance")

        if self:GetAbility():GetCaster():IsHasSuperStatus() then chance = chance + 10 end

    	if RollPercentage(chance) then
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

function modifier_item_demon_shard_2:OnAttackLanded (params)
    if IsServer() then 
        if params.attacker == self:GetParent() then
            if not self:GetParent():IsRangedAttacker() then 
                if params.target ~= nil and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                    local cleaveDamage = ( self:GetAbility():GetSpecialValueFor("percent_cleave") * params.damage ) / 100.0
                    DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, 150, 300, 570, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf" )
                end
            	if IsHasCrit and not params.target:IsBuilding() then
                    local hTarget = params.target
                    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
                    ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
                    ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
                    EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Target", hTarget)
                    ScreenShake(hTarget:GetOrigin(), 100, 0.1, 0.3, 500, 0, true)
                end 
            --[[else 
                local target = params.target
                local splash_damage = self:GetAbility():GetSpecialValueFor("percent_cleave") / 100
                local splash_range = FindUnitsInRadius(self:GetCaster():GetTeam(), target:GetAbsOrigin(), nil, 275, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
                local damage_table = {}
                damage_table.attacker = self:GetCaster()
                damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
                damage_table.damage = self:GetCaster():GetAverageTrueAttackDamage(target) * splash_damage
                for i,v in ipairs(splash_range) do
                    if v ~= target then 
                        damage_table.victim = v
                        ApplyDamage(damage_table)
                    end
                end]]
            end
        end
    end 
end

function modifier_item_demon_shard_2:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_demon_shard_2:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

