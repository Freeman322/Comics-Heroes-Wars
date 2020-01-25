if predator_observer == nil then predator_observer = class({}) end

LinkLuaModifier ("modifier_predator_observer_debuff", "abilities/predator_observer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_predator_observer", "abilities/predator_observer.lua", LUA_MODIFIER_MOTION_NONE)

function predator_observer:GetIntrinsicModifierName ()
    return "modifier_predator_observer"
end

if modifier_predator_observer == nil then modifier_predator_observer = class({}) end

function modifier_predator_observer:IsHidden ()
    return true
end

function modifier_predator_observer:AllowIllusionDuplicate()
    return false
end

function modifier_predator_observer:IsPurgable()
    return false
end

function modifier_predator_observer:RemoveOnDeath ()
    return true
end

function modifier_predator_observer:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_predator_observer:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            local ability = self:GetAbility ()
            if self:GetCaster():IsRealHero() == false then return end
            if target:IsBuilding() then return end 
            if target:HasModifier("modifier_predator_observer_debuff") == false then
              local duration = ability:GetSpecialValueFor("debuff_duration")
            	target:AddNewModifier(self:GetParent(), ability, "modifier_predator_observer_debuff", {duration = duration})
            	target:FindModifierByName("modifier_predator_observer_debuff"):SetStackCount(1)
            else
            	local hDebuff = target:FindModifierByName("modifier_predator_observer_debuff")
            	hDebuff:SetStackCount(hDebuff:GetStackCount() + 1)
            	local staks = hDebuff:GetStackCount()
            	ApplyDamage ({attacker = self:GetCaster(), victim = target, ability = ability, damage = staks*ability:GetSpecialValueFor("damager_per_stack"), damage_type = DAMAGE_TYPE_PHYSICAL })
            end
        end
    end

    return 0
end

if modifier_predator_observer_debuff == nil then modifier_predator_observer_debuff = class({}) end


function modifier_predator_observer_debuff:IsHidden ()
    return false
end


function modifier_predator_observer_debuff:RemoveOnDeath ()
    return true
end

function modifier_predator_observer_debuff:IsPurgeException()
    return true
end

function modifier_predator_observer_debuff:IsBuff()
    return false
end

function modifier_predator_observer_debuff:OnCreated(htable)
    if IsServer() then
    	if self.nFXIndex then
    		ParticleManager:DestroyParticle(self.nFXIndex, true)
    	end
        local pfx = "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "beerus") then
            pfx = "particles/items4_fx/nullifier_mute_debuff.vpcf"
        end 
    	self.nFXIndex = ParticleManager:CreateParticle( pfx, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_OVERHEAD_FOLLOW, "attach_overhead", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(0, self:GetStackCount(), 1) )

		self:AddParticle( self.nFXIndex, false, false, -1, false, true )
    end
end


function modifier_predator_observer_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_predator_observer_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_per_hit")*self:GetStackCount()
end

function modifier_predator_observer_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_phantom_lancer_illusion.vpcf"
end

--------------------------------------------------------------------------------

function modifier_predator_observer_debuff:StatusEffectPriority()
    return 1000
end


function modifier_predator_observer_debuff:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function predator_observer:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

