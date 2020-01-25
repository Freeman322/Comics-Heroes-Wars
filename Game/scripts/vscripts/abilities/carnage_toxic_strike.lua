carnage_toxic_strike = class({})
LinkLuaModifier( "modifier_carnage_toxic_strike_buff", "abilities/carnage_toxic_strike.lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
local PROJ_SPEED = 1200


function carnage_toxic_strike:OnSpellStart()
    if IsServer() then
        local info = {
            EffectName = "particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_attack_ti7.vpcf",
            Ability = self,
            iMoveSpeed = PROJ_SPEED,
            Source = self:GetCaster(),
            Target = self:GetCursorTarget(),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "hero_viper.poisonAttack.Cast.ti7", self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function carnage_toxic_strike:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        EmitSoundOn( "hero_viper.PoisonAttack.Target.ti7", hTarget )

        local duration = self:GetSpecialValueFor( "duration" )
        local buff_duration = self:GetSpecialValueFor( "attributes_steal" )
        local damage = self:GetSpecialValueFor( "damage" )

        ApplyDamage( {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        } )

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_viper_viper_strike_slow", { duration = duration } )

        if hTarget:IsRealHero() then
            local str = hTarget:GetStrength()
            local int = hTarget:GetIntellect()
            local agi = hTarget:GetAgility()

            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_carnage_toxic_strike_buff", { duration = buff_duration, str = str, int = int, agi = agi } )
        end
    end

    return true
end

modifier_carnage_toxic_strike_buff = class({})

function modifier_carnage_toxic_strike_buff:OnCreated(params)
    if IsServer() then
        local mult = self:GetAbility():GetSpecialValueFor("attributes_steal") / 100

        self.str = params.str * mult
        self.int = params.int * mult
        self.agi = params.agi * mult
    end
end

function modifier_carnage_toxic_strike_buff:IsHidden() return false end
function modifier_carnage_toxic_strike_buff:IsPurgable() return false end
function modifier_carnage_toxic_strike_buff:RemoveOnDeath() return true end

function modifier_carnage_toxic_strike_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_carnage_toxic_strike_buff:GetModifierBonusStats_Strength()
    return self.str
end
function modifier_carnage_toxic_strike_buff:GetModifierBonusStats_Agility()
    return self.agi
end
function modifier_carnage_toxic_strike_buff:GetModifierBonusStats_Intellect()
    return self.int
end

function modifier_carnage_toxic_strike_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

