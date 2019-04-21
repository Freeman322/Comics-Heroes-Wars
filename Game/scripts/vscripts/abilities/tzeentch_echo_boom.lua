if tzeentch_echo_boom == nil then tzeentch_echo_boom = class({}) end

LinkLuaModifier ("modifier_tzeentch_echo_boom", "abilities/tzeentch_echo_boom.lua", LUA_MODIFIER_MOTION_NONE)

function tzeentch_echo_boom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function tzeentch_echo_boom:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "slowing_duration" )

    self.mana_dmg = self:GetSpecialValueFor("mana_pool_ptc")

    if self:GetCaster():HasTalent("special_bonus_unique_tzeench") then
        self.mana_dmg = self.mana_dmg + self:GetCaster():FindTalentValue("special_bonus_unique_tzeench")
    end

    self.mana_dmg = self:GetCaster():GetMana() * ( self.mana_dmg / 100)

	local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #targets > 0 then
		for _,target in pairs(targets) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_tzeentch_echo_boom", { duration = duration } )
			ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage() + self.mana_dmg, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "mera") then
	    EmitSoundOn("Hero_MonkeyKing.Spring.Impact", self:GetCaster())
        EmitSoundOn("Hero_MonkeyKing.Spring.Water", self:GetCaster())
        EmitSoundOn("Hero_MonkeyKing.Spring.Impact.Water", self:GetCaster())
        EmitSoundOn("Hero_MonkeyKing.FurArmy.End", self:GetCaster())

        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_tzeench/tzeentch_warp_storm.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(400, 400, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(400, 400, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetCursorPosition() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    else
        EmitSoundOn("Hero_MonkeyKing.Spring.Impact", self:GetCaster())

        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_tzeench/tzeentch_echo_boom.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetCursorPosition() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    end
end

if modifier_tzeentch_echo_boom == nil then modifier_tzeentch_echo_boom = class({}) end

function modifier_tzeentch_echo_boom:GetEffectName()
    return "particles/items2_fx/rod_of_atos_debuff.vpcf"
end

function modifier_tzeentch_echo_boom:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_tzeentch_echo_boom:IsPurgable()
    return false
end

function modifier_tzeentch_echo_boom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_tzeentch_echo_boom:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("slowing")
end

function tzeentch_echo_boom:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

