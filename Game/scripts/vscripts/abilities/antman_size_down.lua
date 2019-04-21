antman_size_down = class({})

LinkLuaModifier( "modifier_antman_size_down", "abilities/antman_size_down.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "antman_size_modifier", "abilities/antman_size_modifier.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function antman_size_down:ProcsMagicStick()
	return false
end

function antman_size_down:IsStealable()
	return false
end

function antman_size_down:OnUpgrade()
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

function antman_size_down:GetSubAbility()
    if IsServer() then 
        return self:GetCaster():FindAbilityByName("antman_size_up")
    end
end

function antman_size_down:GetSubModifier()
    if IsServer() then 
        return self:GetCaster():FindModifierByName("antman_size_modifier")
    end
end

function antman_size_down:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_antman_size_down", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
        end
        
        if self:GetSubAbility():GetToggleState() then 
            self:GetSubAbility():ToggleAbility()
        end
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_antman_size_down" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

modifier_antman_size_down = class({})
--------------------------------------------------------------------------------

function modifier_antman_size_down:IsDebuff()
	return true
end

function modifier_antman_size_down:IsPurgable(  )
	return false
end

function modifier_antman_size_down:GetEffectName()
	return "particles/units/heroes/hero_morphling/morphling_morph_str.vpcf"
end

function modifier_antman_size_down:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_antman_size_down:OnCreated( kv )
	if IsServer() then
		StartSoundEvent("Hero_Morphling.MorphStrengh", self:GetParent())

		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("tick") )
		self:OnIntervalThink()
	end
end

function modifier_antman_size_down:OnDestroy()
	if IsServer() then
		StopSoundEvent( "Hero_Morphling.MorphStrengh", self:GetCaster() )
	end
end

function modifier_antman_size_down:OnIntervalThink()
	if IsServer() then
		self:GetAbility():GetSubModifier():DecrementStackCount()
	end
end

