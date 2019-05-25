mercer_ambush = class({})
LinkLuaModifier( "modifier_mercer_ambush", "abilities/mercer_ambush.lua", LUA_MODIFIER_MOTION_NONE )


function mercer_ambush:IsStealable()
	return false
end
--------------------------------------------------------------------------------

function mercer_ambush:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()

        if hTarget ~= nil then
            self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_mercer_ambush", {target = hTarget:entindex(), duration = self:GetSpecialValueFor("duration")} )

            EmitSoundOn("Hero_Undying.SoulRip.Cast", hTarget)

            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );
        end
    end
end 

if modifier_mercer_ambush == nil then modifier_mercer_ambush = class({}) end
--------------------------------------------------------------------------------

function modifier_mercer_ambush:IsPurgable() return false end
function modifier_mercer_ambush:RemoveOnDeath() return false end

function modifier_mercer_ambush:OnCreated(params)
    if IsServer() then
        self.target = EntIndexToHScript(params.target)

        self.hp = self.target:GetHealth()
        self.damage = self.target:GetAverageTrueAttackDamage(self:GetParent())
        self.armor = self.target:GetPhysicalArmorValue( false )

        self.target:Kill(self:GetAbility(), self:GetParent())
    end
end

function modifier_mercer_ambush:OnDestroy()
	if IsServer() then
        self:GetAbility():SetActivated(true)

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        EmitSoundOn("Hero_LifeStealer.Assimilate.Destroy", self:GetParent())
    end
end

function modifier_mercer_ambush:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }

    return funcs
end

function modifier_mercer_ambush:GetModifierPhysicalArmorBonus( params )
    return self.armor
end

function modifier_mercer_ambush:GetModifierHealthBonus(args)
    return self.hp
end

function modifier_mercer_ambush:GetModifierBaseAttack_BonusDamage( params )
    return self.damage
end

function modifier_mercer_ambush:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_mercer_ambush:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
