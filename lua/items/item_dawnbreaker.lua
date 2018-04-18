if item_dawnbreaker == nil then item_dawnbreaker = class({}) end 

LinkLuaModifier( "modifier_item_dawnbreaker_active", "items/item_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_dawnbreaker", "items/item_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE )

function item_dawnbreaker:GetIntrinsicModifierName()
    return "modifier_item_dawnbreaker"
end

if modifier_item_dawnbreaker == nil then modifier_item_dawnbreaker = class({}) end 

function modifier_item_dawnbreaker:IsPurgable()
    return false
end

function modifier_item_dawnbreaker:IsHidden()
    return true
end

function modifier_item_dawnbreaker:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_item_dawnbreaker:OnCreated(table)
	self.bonus_damage = 0
end

function modifier_item_dawnbreaker:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_START
    }

    return funcs
end

function modifier_item_dawnbreaker:GetModifierPreAttack_BonusDamage (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_damage")
end

function modifier_item_dawnbreaker:GetModifierBonusStats_Strength (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_dawnbreaker:GetModifierBonusStats_Intellect (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_dawnbreaker:GetModifierBonusStats_Agility (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_dawnbreaker:GetModifierPhysicalArmorBonus (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_armor")
end

function modifier_item_dawnbreaker:GetModifierProcAttack_BonusDamage_Pure (params)
 	if self.bonus_damage == nil then
 		self.bonus_damage = 0
 	end
    return self.bonus_damage
end

function modifier_item_dawnbreaker:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            self.bonus_damage = target:GetHealth()*(self:GetAbility():GetSpecialValueFor("damage_pers")/100)
            if target:IsBuilding() or target:IsConsideredHero() or target:IsAncient() then 
            	self.bonus_damage = 0
            end
        end
    end

    return 0
end


function modifier_item_dawnbreaker:SoulTransform()
	if IsServer() then 
		if self:GetAbility():IsCooldownReady() and self:GetParent():HasModifier("modifier_item_dawnbreaker_active") == false and not self:GetParent():PassivesDisabled() then 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_dawnbreaker_active", {duration = self:GetAbility():GetSpecialValueFor("soul_keep_duration")})
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		end 
	end
end

if modifier_item_dawnbreaker_active == nil then modifier_item_dawnbreaker_active = class({}) end 

function modifier_item_dawnbreaker_active:IsPurgable()
    return false
end

function modifier_item_dawnbreaker_active:IsHidden()
    return false
end

function modifier_item_dawnbreaker_active:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_item_dawnbreaker_active:OnCreated(table)
    if IsServer() then 
        local nFXIndex = ParticleManager:CreateParticle( "particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        
        EmitSoundOn("Hero_Oracle.FalsePromise.FP", self:GetParent())

         print("OnCreated()")
         print(self:GetRemainingTime())
    end 
end

function modifier_item_dawnbreaker_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_combo_breaker.vpcf"
end

function modifier_item_dawnbreaker_active:StatusEffectPriority()
    return 1000
end

function modifier_item_dawnbreaker_active:GetEffectName ()
    return "particles/dawnbreaker/dawnbreaker_active.vpcf"
end

function modifier_item_dawnbreaker_active:GetEffectAttachType ()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_dawnbreaker_active:CheckState ()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
    }

    return state
end

function modifier_item_dawnbreaker_active:OnDestroy()
    if IsServer() then 
        EmitSoundOn("Hero_Oracle.FalsePromise.Healed", self:GetParent())
        print("OnDestroy()")
    end 
end