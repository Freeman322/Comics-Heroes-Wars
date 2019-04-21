if hulk_devour == nil then hulk_devour = class({}) end

LinkLuaModifier( "modifier_hulk_devour", "abilities/hulk_devour", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hulk_devour_team", "abilities/hulk_devour", LUA_MODIFIER_MOTION_NONE )

function hulk_devour:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor( "duration" )
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hulk_devour", { duration = duration })

        for _,v in pairs(HeroList:GetAllHeroes()) do
            v:AddNewModifier( self:GetCaster(), self, "modifier_hulk_devour_team", { duration = duration })
        end
    end
end

if modifier_hulk_devour == nil then modifier_hulk_devour = class({}) end

function modifier_hulk_devour:IsHidden()
	return true
end

function modifier_hulk_devour:IsPurgable()
	return true
end

function modifier_hulk_devour:GetStatusEffectName()
    return "particles/status_fx/status_effect_battle_hunger.vpcf"
end

function modifier_hulk_devour:StatusEffectPriority()
    return 1000
end

function modifier_hulk_devour:GetEffectName()
    return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf"
end

function modifier_hulk_devour:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hulk_devour:SearchTarget()
    if IsServer() then 
        local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 99999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )
        if #units > 0 then 
            for _,unit in pairs(units) do
                if unit ~= self:GetParent() then
                    print(unit:GetUnitName()) 
                    return unit
                end
            end
        end
    end
    return nil
end

function modifier_hulk_devour:AttackTarget()
    if IsServer() then 
        local order =
		{
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			TargetIndex = self.target:entindex()
		}
        ExecuteOrderFromTable(order)
        
        if self.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then 
            self:GetParent():SetForceAttackTargetAlly(self.target)
        else
            self:GetParent():SetForceAttackTarget(self.target)
        end
    end
end

function modifier_hulk_devour:OnCreated(params)
	if IsServer() then
        EmitSoundOn("Hero_TrollWarlord.BattleTrance.Cast", self:GetParent())
        EmitSoundOn("Hero_TrollWarlord.BattleTrance.Cast.Team", self:GetParent())

        self.target = self:SearchTarget()
        if self.target == nil then 
            self:GetAbility():EndCooldown()
            self:Destroy()
        end
        self:StartIntervalThink(0.05)

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "pursuer") == true then
            StartSoundEvent("Hulk.Ult.Custom", self:GetParent())
        end 
	end
end

function modifier_hulk_devour:OnDestroy()
	if IsServer() then
        self:GetParent():Interrupt()
		self:GetParent():SetForceAttackTarget(nil)
        self:GetParent():SetForceAttackTargetAlly(nil)
        self:GetParent():Stop()

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "pursuer") == true then
            StopSoundEvent("Hulk.Ult.Custom", self:GetParent())
        end
	end
end

function modifier_hulk_devour:OnIntervalThink()
    if IsServer() then 
        if self.target:IsAlive() == false then 
            self.target = self:SearchTarget()
            if self.target == nil then 
                self:Destroy()
            end
        else
            self:AttackTarget()
        end
    end
end

function modifier_hulk_devour:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_hulk_devour:GetModifierDamageOutgoing_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("damage_amply")
end

function modifier_hulk_devour:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attack_speed_amply")
end

function modifier_hulk_devour:GetAbsoluteNoDamagePhysical( params )
	return 1
end
function modifier_hulk_devour:GetAbsoluteNoDamageMagical( params )
	return 1
end
function modifier_hulk_devour:GetAbsoluteNoDamagePure( params )
	return 1
end

function modifier_hulk_devour:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = false,
        [MODIFIER_STATE_FAKE_ALLY] = true
	}

	return state
end


if modifier_hulk_devour_team == nil then modifier_hulk_devour_team = class({}) end 

function modifier_hulk_devour_team:IsHidden()
	return true
end

function modifier_hulk_devour_team:IsPurgable()
	return false
end

function modifier_hulk_devour_team:RemoveOnDeath()
	return false
end

function modifier_hulk_devour_team:CheckState()
	local state = {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	}

	return state
end
