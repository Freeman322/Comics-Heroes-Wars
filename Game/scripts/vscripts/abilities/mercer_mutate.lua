mercer_mutate = class({})

LinkLuaModifier("modifier_mercer_mutate", "abilities/mercer_mutate.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
EF_WEAPON_CLAWS = "Claws"
EF_WEAPON_BLADE = "Blade"
EF_WEAPON_PUNCH = "Punch"

mercer_mutate.weapon = "Unarmed"
mercer_mutate.weapon_id = 0

function mercer_mutate:IsStealable()
	return false
end

function mercer_mutate:ProcsMagicStick()
	return false
end

function mercer_mutate:GetIntrinsicModifierName()
	return "modifier_mercer_mutate"
end

function mercer_mutate:GetAbilityTextureName()
    if self:GetCaster():GetModifierStackCount(self:GetIntrinsicModifierName(), self:GetCaster()) == 1 then return "custom/mercer_mutate_blade" end 
    if self:GetCaster():GetModifierStackCount(self:GetIntrinsicModifierName(), self:GetCaster()) == 2 then return "custom/mercer_mutate_claws" end 
    if self:GetCaster():GetModifierStackCount(self:GetIntrinsicModifierName(), self:GetCaster()) == 3 then return "custom/mercer_mutate_punch" end 
    return self.BaseClass.GetAbilityTextureName(self) 
end
  

function mercer_mutate:ChangeWeapon(weapon)
    if IsServer() then 
        self:Clean()

        if weapon == 1 then self:GetCaster().abilities[1]:RemoveEffects(EF_NODRAW) self.weapon = EF_WEAPON_BLADE EmitSoundOn("Hero_Juggernaut.Attack", self:GetCaster())
        elseif (weapon == 2) then self:GetCaster().abilities[2]:RemoveEffects(EF_NODRAW) self.weapon = EF_WEAPON_CLAWS EmitSoundOn("Hero_Lycan.Attack", self:GetCaster())
        elseif (weapon == 3) then self:GetCaster().abilities[3]:RemoveEffects(EF_NODRAW) self.weapon = EF_WEAPON_PUNCH EmitSoundOn("Hero_OgreMagi.Attack", self:GetCaster())
        end

        self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):ForceRefresh()
    end
end

function mercer_mutate:Clean()
    if IsServer() then  
        for _,i in pairs(self:GetCaster().abilities) do i:AddEffects(EF_NODRAW) end
        
        self:GetCaster().wearables.arms:AddEffects(EF_NODRAW)
    end
end
--------------------------------------------------------------------------------

function mercer_mutate:OnSpellStart()
    if IsServer() then 
        self.weapon_id = self.weapon_id + 1
        if self.weapon_id > 3 then self.weapon_id = 1 end
        
        self:ChangeWeapon(self.weapon_id)
    end 
end

if not modifier_mercer_mutate then modifier_mercer_mutate = class({}) end 


function modifier_mercer_mutate:IsHidden() return true end
function modifier_mercer_mutate:IsPurgable() return false end

function modifier_mercer_mutate:OnCreated(params) 
    if IsServer() then self:StartIntervalThink(0.1) end 
end 

function modifier_mercer_mutate:OnIntervalThink() 
    if IsServer() then 
        self:SetStackCount(self:GetAbility().weapon_id)
    end 
end 

function modifier_mercer_mutate:HasBlade() 
    if self:GetStackCount() == 1 then return true end 
end 

function modifier_mercer_mutate:HasClaws() 
    if self:GetStackCount() == 2 then return true end 
end 

function modifier_mercer_mutate:HasPunch()
    if self:GetStackCount() == 3 then return true end 
end 

function modifier_mercer_mutate:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_mercer_mutate:GetModifierHealthBonus (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_hp")
end

function modifier_mercer_mutate:GetModifierMoveSpeedBonus_Percentage (params)
    if self:HasBlade() then return self:GetAbility():GetSpecialValueFor ("blades_bonus_movespeed") end 
end

function modifier_mercer_mutate:GetModifierAttackRangeBonus (params)
    if self:HasBlade() then return self:GetAbility():GetSpecialValueFor ("blades_bonus_attack_range") end 
end

function modifier_mercer_mutate:GetModifierPreAttack_BonusDamage (params)
    if self:HasPunch() then return self:GetAbility():GetSpecialValueFor ("punch_bonus_damage") end 
end

function modifier_mercer_mutate:GetModifierBonusStats_Strength (params)
    if self:HasPunch() then return self:GetAbility():GetSpecialValueFor ("punch_bonus_strength") end 
end

function modifier_mercer_mutate:GetModifierPhysicalArmorBonus (params)
    if self:HasPunch() then return self:GetAbility():GetSpecialValueFor ("punch_bonus_armor") end 
end

function modifier_mercer_mutate:GetModifierAttackSpeedBonus_Constant (params)
    if self:HasClaws() then return self:GetAbility():GetSpecialValueFor ("claws_attack_speed") end 
end

function modifier_mercer_mutate:GetModifierProcAttack_BonusDamage_Pure (params)
    if IsServer() then 
        if self:HasClaws() then if RollPercentage(self:GetAbility():GetSpecialValueFor ("claws_pierce_atack_chance")) then return self:GetAbility():GetSpecialValueFor ("claws_pierce_atack") end end
    end
end

function modifier_mercer_mutate:OnAttackLanded (params)
    if IsServer() then 
        if params.attacker == self:GetParent() then
        	if not params.target:IsBuilding() and RollPercentage(self:GetAbility():GetSpecialValueFor("punch_bash_chance")) and self:HasPunch() then
                local hTarget = params.target

                local dur = self:GetAbility():GetSpecialValueFor("punch_bash_duration")
                if self:GetParent():HasTalent("special_bonus_unique_mercer_3") then dur = dur + self:GetParent():FindTalentValue("special_bonus_unique_mercer_3") end    

                hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = dur})

                EmitSoundOn("DOTA_Item.Maim", hTarget)
        	end
            if params.target ~= nil and params.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:HasBlade() then
                self:GetParent():RemoveGesture(ACT_DOTA_ATTACK)
                self:GetParent():StartGesture(ACT_DOTA_ATTACK_EVENT_BASH)

                local ptc = self:GetAbility():GetSpecialValueFor("blades_splash_ptc")
                if self:GetParent():HasTalent("special_bonus_unique_mercer_2") then ptc = ptc + self:GetParent():FindTalentValue("special_bonus_unique_mercer_2") end     
                
                local cleaveDamage = (ptc * params.damage ) / 100.0

                DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, 225, 420, self:GetAbility():GetSpecialValueFor("blades_splash_radius"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf" )
            end
        end
    end
end

function modifier_mercer_mutate:GetAttackSound( params )
    if self:GetStackCount() == 1 then return "Hero_Juggernaut.Attack"
    elseif self:GetStackCount() == 2 then return "Hero_Lycan.Attack" 
    elseif self:GetStackCount() == 3 then return "Hero_OgreMagi.Attack" end 

    return "Hero_Undying.Attack"
end

function modifier_mercer_mutate:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end


