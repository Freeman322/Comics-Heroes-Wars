marvel_primal_shield = class({})

LinkLuaModifier( "modifier_marvel_primal_shield", "abilities/marvel_primal_shield.lua", LUA_MODIFIER_MOTION_NONE )

function marvel_primal_shield:OnSpellStart()
    if IsServer() then 
    	local hTarget = self:GetCursorTarget()
    	if hTarget ~= nil then
            local duration = self:GetSpecialValueFor( "duration" )
            if self:GetCaster():HasTalent("special_bonus_unique_marvel_2") then 
                duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_marvel_2")
            end
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_marvel_primal_shield", { duration = duration } )
            EmitSoundOn( "Hero_LegionCommander.PressTheAttack", hTarget )
    	end
    end
end

modifier_marvel_primal_shield = class({})

function modifier_marvel_primal_shield:IsPurgable()
    return true
end

function modifier_marvel_primal_shield:OnCreated(table)
	if IsServer() then
		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "jiren") == true then
			local nFXIndex = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControl( nFXIndex, 14, Vector(1, 1, 1) );
			ParticleManager:SetParticleControl( nFXIndex, 15, Vector(255, 0, 0) );
			self:AddParticle(nFXIndex, false, false, -1, false, false)
		end 
	end
end

function modifier_marvel_primal_shield:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2_dire.vpcf"
end

function modifier_marvel_primal_shield:StatusEffectPriority()
    return 1000
end

function modifier_marvel_primal_shield:GetEffectName()
    if self:GetParent():HasModifier("modifier_jiren") then return end 
    return "particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift_buff.vpcf"
end

function modifier_marvel_primal_shield:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marvel_primal_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ABSORB_SPELL
    }

    return funcs
end

function modifier_marvel_primal_shield:GetModifierPhysical_ConstantBlock( params )
    return self:GetAbility():GetSpecialValueFor("damage_absorb")
end

function modifier_marvel_primal_shield:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_marvel_primal_shield:GetAbsorbSpell( params )
    if IsServer() then 
        local nFXIndex = ParticleManager:CreateParticle( "particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex(nFXIndex)

        EmitSoundOn("DOTA_Item.ComboBreaker", self:GetParent())
    end
    return 1
end
