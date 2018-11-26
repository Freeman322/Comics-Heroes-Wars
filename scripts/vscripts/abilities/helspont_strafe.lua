helspont_strafe = class({})
LinkLuaModifier( "modifier_helspont_strafe", "abilities/helspont_strafe.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function helspont_strafe:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor(  "duration" )

        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_helspont_strafe", { duration = duration } )

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end 
end

modifier_helspont_strafe = class({})
--------------------------------------------------------------------------------

function modifier_helspont_strafe:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor_bonus" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_helspont_strafe:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_helspont_strafe:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed
end

--------------------------------------------------------------------------------

function modifier_helspont_strafe:GetModifierPhysicalArmorBonus( params )
	return self.armor
end