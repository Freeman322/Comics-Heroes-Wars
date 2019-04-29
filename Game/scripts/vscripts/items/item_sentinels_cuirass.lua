LinkLuaModifier ("modifier_item_sentinels_cuirass", "items/item_sentinels_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_sentinels_cuirass_active", "items/item_sentinels_cuirass.lua", LUA_MODIFIER_MOTION_NONE)

if item_sentinels_cuirass == nil then
    item_sentinels_cuirass = class({})
end

function item_sentinels_cuirass:GetIntrinsicModifierName ()
    return "modifier_item_sentinels_cuirass"
end

if modifier_item_sentinels_cuirass == nil then
    modifier_item_sentinels_cuirass = class ( {})
end

function modifier_item_sentinels_cuirass:IsHidden ()
    return true
end

function modifier_item_sentinels_cuirass:IsPurgable()
    return false
end

function modifier_item_sentinels_cuirass:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_sentinels_cuirass:GetModifierAura()
	return "modifier_item_assault_negative_armor"
end

--------------------------------------------------------------------------------

function modifier_item_sentinels_cuirass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_item_sentinels_cuirass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING
end

--------------------------------------------------------------------------------

function modifier_item_sentinels_cuirass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_item_sentinels_cuirass:GetAuraRadius()
	return 900
end

function modifier_item_sentinels_cuirass:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_sentinels_cuirass:GetModifierPreAttack_BonusDamage (params) return self:GetAbility():GetSpecialValueFor ("bonus_damage") end
function modifier_item_sentinels_cuirass:GetModifierPhysicalArmorBonus(params) return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_item_sentinels_cuirass:GetModifierAttackSpeedBonus_Constant (params) return self:GetAbility():GetSpecialValueFor ("bonus_attack_speed") end
function modifier_item_sentinels_cuirass:GetModifierBonusStats_Strength( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_sentinels_cuirass:GetModifierBonusStats_Intellect( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end
function modifier_item_sentinels_cuirass:GetModifierBonusStats_Agility( params ) return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" ) end


function modifier_item_sentinels_cuirass:OnAttackLanded(params)
    if IsServer () then
        if params.attacker == self:GetParent() then
            local hAbility = self:GetAbility()
            local hTarget = params.target
            local chance = hAbility:GetSpecialValueFor ("strike_chance")
            if self:GetParent():IsRealHero() and RollPercentage(chance) and hTarget:IsBuilding() == false and hTarget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 8, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 10, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 11, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                EmitSoundOn( "Ability.LagunaBladeImpact", hTarget )
                local damage = {
                    victim = hTarget,
                    attacker = self:GetCaster(),
                    damage = self:GetAbility():GetSpecialValueFor( "strike_damage" ),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                }

                ApplyDamage( damage )
            end
        end
    end

    return 0
end

function modifier_item_sentinels_cuirass:OnTakeDamage(params)
    if IsServer () then
        if params.unit == self:GetParent() and self:GetAbility():IsCooldownReady() then
            local hAbility = self:GetAbility ()
            local hTarget = params.attacker
            local chance = hAbility:GetSpecialValueFor ("strike_chance")
            if self:GetParent():IsRealHero() and RollPercentage(chance) and hTarget:IsBuilding() == false and hTarget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                if not self:GetParent():IsRealHero() then 
                    return
                end

                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 8, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 10, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 11, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                EmitSoundOn( "Ability.LagunaBladeImpact", hTarget )
                local damage = {
                    victim = hTarget,
                    attacker = self:GetCaster(),
                    damage = self:GetAbility():GetSpecialValueFor( "strike_damage" ),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                }

                ApplyDamage( damage )
                self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
            end
        end
    end

    return 0
end
function item_sentinels_cuirass:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

