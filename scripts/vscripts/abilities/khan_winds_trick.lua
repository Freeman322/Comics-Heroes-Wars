if khan_winds_trick == nil then khan_winds_trick = class({}) end

LinkLuaModifier( "modifier_khan_winds_trick",  "abilities/khan_winds_trick.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_khan_winds_trick_aura",  "abilities/khan_winds_trick.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_khan_winds_trick_dummy",  "abilities/khan_winds_trick.lua", LUA_MODIFIER_MOTION_NONE )


function khan_winds_trick:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function khan_winds_trick:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_khan_winds_trick", { duration = self:GetSpecialValueFor("duration") } )
end


--------------------------------------------------------------------------------
if modifier_khan_winds_trick == nil then modifier_khan_winds_trick = class({}) end

function modifier_khan_winds_trick:OnCreated(event)
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        local caster_pos = caster:GetAbsOrigin()

        EmitSoundOn("Hero_Winter_Wyvern.ArcticBurn.Cast", caster)

        local EntIndex = ParticleManager:CreateParticle("particles/hero_khan/khan_wind_trick.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(EntIndex, 0, caster_pos)
        self:AddParticle(EntIndex, false, false, -1, false, false)

        caster:StartGesture(ACT_DOTA_TELEPORT)
    end
end

function modifier_khan_winds_trick:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveGesture(ACT_DOTA_TELEPORT)
	end
end


function modifier_khan_winds_trick:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_khan_winds_trick:GetModifierAura()
	return "modifier_khan_winds_trick_aura"
end

--------------------------------------------------------------------------------

function modifier_khan_winds_trick:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_khan_winds_trick:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_khan_winds_trick:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_khan_winds_trick:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

if modifier_khan_winds_trick_aura == nil then modifier_khan_winds_trick_aura = class({}) end

function modifier_khan_winds_trick_aura:IsPurgable()
	return false
end

function modifier_khan_winds_trick_aura:GetEffectName()
	return "particles/hero_khan/khan_wind_trick_buff.vpcf"
end

function modifier_khan_winds_trick_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_khan_winds_trick_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_khan_winds_trick_aura:GetAbsorbSpell(keys)
    if self.stored ~= nil then
        self.stored:RemoveSelf() --we make sure to remove previous spell.
    end
    local hCaster = self:GetParent()
    EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
    EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
    EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())
    if keys.ability:GetAbilityName() == "loki_spell_steal" then
        return nil
    end
    local hAbility = hCaster:AddAbility(keys.ability:GetAbilityName())

    hAbility:SetStolen(true) --just to be safe with some interactions.
    hAbility:SetHidden(true) --hide the ability.
    hAbility:SetLevel(keys.ability:GetLevel()) --same level of ability as the origin.
    hCaster:SetCursorCastTarget(keys.ability:GetCaster()) --lets send this spell back.
    hAbility:OnSpellStart() --cast the spell.
    self.stored = hAbility --store the spell reference for future use.

    ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
    return 1
end

function modifier_khan_winds_trick_aura:OnTakeDamage( params )
    if params.unit == self:GetParent() then
    	if params.attacker:HasModifier("modifier_khan_winds_trick_dummy") == false then
    		params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned",{duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
    		self:GetParent():Heal(params.damage, self:GetAbility())
            params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_khan_winds_trick_dummy",{duration = self:GetAbility():GetSpecialValueFor("duration")})
    	end
    end
end

if modifier_khan_winds_trick_dummy == nil then modifier_khan_winds_trick_dummy = class({}) end 

function modifier_khan_winds_trick_dummy:IsPurgable()
	return false
end

function modifier_khan_winds_trick_dummy:IsHidden()
	return true
end
function khan_winds_trick:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

