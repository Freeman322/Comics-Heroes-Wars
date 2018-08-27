antman_size_up = class({})

LinkLuaModifier( "modifier_antman_size_up", "abilities/antman_size_up.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "antman_size_modifier", "abilities/antman_size_modifier.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function antman_size_up:ProcsMagicStick()
	return false
end

function antman_size_up:IsStealable()
	return false
end

function antman_size_up:OnUpgrade()
    if IsServer() then 
        if self:GetLevel() == 1 then 
            if not self:GetSubModifier() then 
                self:GetCaster():AddNewModifier(self:GetCaster(), self, "antman_size_modifier", nil):SetStackCount(100)
            end 
            if self:GetSubAbility():GetLevel() == 0 then
                self:GetSubAbility():UpgradeAbility(1) 
            end
        end
    end
end

function antman_size_up:GetSubAbility()
    return self:GetCaster():FindAbilityByName("antman_size_down")
end

function antman_size_up:GetSubModifier()
    return self:GetCaster():FindModifierByName("antman_size_modifier")
end

function antman_size_up:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_antman_size_up", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
        end
        
        if self:GetSubAbility():GetToggleState() then 
            self:GetSubAbility():ToggleAbility()
        end
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_antman_size_up" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

modifier_antman_size_up = class({})
--------------------------------------------------------------------------------

function modifier_antman_size_up:IsDebuff()
	return true
end

function modifier_antman_size_up:IsPurgable(  )
	return false
end

function modifier_antman_size_up:GetEffectName()
	return "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

--------------------------------------------------------------------------------

function modifier_antman_size_up:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
--------------------------------------------------------------------------------

function modifier_antman_size_up:OnCreated( kv )
	if IsServer() then
		StartSoundEvent("Hero_Morphling.MorphAgility", self:GetParent())

		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("tick") )
		self:OnIntervalThink()
	end
end

function modifier_antman_size_up:OnDestroy()
	if IsServer() then
		StopSoundEvent( "Hero_Morphling.MorphAgility", self:GetCaster() )
	end
end

function modifier_antman_size_up:OnIntervalThink()
	if IsServer() then
		self:GetAbility():GetSubModifier():IncrementStackCount()
	end
end

