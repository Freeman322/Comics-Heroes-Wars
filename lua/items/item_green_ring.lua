LinkLuaModifier ("modifier_item_green_ring", "items/item_green_ring.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_green_ring_lift", "items/item_green_ring.lua", LUA_MODIFIER_MOTION_NONE)
if item_green_ring == nil then
    item_green_ring = class({})
end

function item_green_ring:GetIntrinsicModifierName()
	return "modifier_item_green_ring"
end

function item_green_ring:OnSpellStart() 
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			EmitSoundOn( "Hero_Rubick.Telekinesis.Cast", self:GetCaster() )
			EmitSoundOn( "Hero_Rubick.Telekinesis.Target", hTarget )
			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_green_ring_lift", {duration = self:GetSpecialValueFor("lift_duration")})
		end
	end
end

if modifier_item_green_ring_lift == nil then
    modifier_item_green_ring_lift = class({})
end
function modifier_item_green_ring_lift:OnCreated( table )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/green_ring/green_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(nFXIndex, 0, Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,self:GetParent():GetAbsOrigin().z))
        ParticleManager:SetParticleControl(nFXIndex, 1, Vector(1, 0, 0))
        ParticleManager:SetParticleControl(nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("lift_duration"), 0, 0))
		self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end
function modifier_item_green_ring_lift:OnDestroy(  )
    if IsServer() then
        EmitSoundOn( "Hero_Rubick.Telekinesis.Target.Land", self:GetParent() )
    end
end
function modifier_item_green_ring_lift:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
function modifier_item_green_ring_lift:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_item_green_ring_lift:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

if modifier_item_green_ring == nil then
    modifier_item_green_ring = class({})
end

function modifier_item_green_ring:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_green_ring:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_green_ring:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end

function modifier_item_green_ring:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end
function modifier_item_green_ring:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_green_ring:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end

function modifier_item_green_ring:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end

function modifier_item_green_ring:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
function item_green_ring:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

