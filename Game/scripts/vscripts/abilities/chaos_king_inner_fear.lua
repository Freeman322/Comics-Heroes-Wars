chaos_king_inner_fear = class ( {})

LinkLuaModifier( "modifier_inner_fear",   "abilities/chaos_king_inner_fear.lua", LUA_MODIFIER_MOTION_NONE)


function chaos_king_inner_fear:OnSpellStart ()
    if IsServer() then
        local hTarget = self:GetCaster():GetCursorCastTarget()
        local duration = self:GetSpecialValueFor("latch_duration")

        EmitSoundOn ("Hero_Grimstroke.InkCreature.Cast", self:GetCaster() )
        EmitSoundOn ("Hero_Grimstroke.InkCreature.Spawn", hTarget)

        PrecacheUnitByNameAsync("npc_dota_chaos_king_ink_creature", function()
            local unit = CreateUnitByName( "npc_dota_chaos_king_ink_creature", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
           
            unit:AddNewModifier(unit, self, "modifier_inner_fear", {duration = duration, target = hTarget:entindex()})
            unit:AddNewModifier(unit, self, "modifier_kill", {duration = duration})
            unit:AddNewModifier(unit, self, "modifier_doom_bringer_scorched_earth_effect_aura", {duration = duration})

            FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

            unit:SetBaseDamageMin(self:GetSpecialValueFor("creature_damage"))
            unit:SetBaseDamageMax(self:GetSpecialValueFor("creature_damage"))
            unit:SetBaseMoveSpeed(self:GetSpecialValueFor("speed"))
            unit:SetBaseMaxHealth(self:GetSpecialValueFor("destroy_attacks"))
            unit:SetAttackCapability(1)

            local order_caster =
            {
                UnitIndex = unit:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                TargetIndex = hTarget:entindex()
            }
    
            hTarget:Stop()
            ExecuteOrderFromTable(order_caster)
    
            unit:SetForceAttackTarget(hTarget)
        end)

        ApplyDamage({
            victim = hTarget,
            attacker = self:GetCaster(),
            ability = self,
            damage = self:GetSpecialValueFor("pop_damage"),
            damage_type = self:GetAbilityDamageType()
        })
    end 
end


modifier_inner_fear = class({})

modifier_inner_fear.m_hTarget = nil

function modifier_inner_fear:OnCreated( kv )
    if IsServer() then
        self.m_hTarget = EntIndexToHScript(kv.target)

        self:StartIntervalThink(1)
        self:OnIntervalThink()
    end
end

function modifier_inner_fear:FindNextTarget()
    local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )

    return units[1];
end
  

function modifier_inner_fear:OnIntervalThink()
    if IsServer() then
        if not self.m_hTarget or self.m_hTarget:IsNull() or not self.m_hTarget:IsAlive() then
            self.m_hTarget = self:FindNextTarget()

            if not self.m_hTarget then self:Destroy() end 
        end 

        local order_caster =
        {
            UnitIndex = self:GetParent():entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = self.m_hTarget:entindex()
        }

        ExecuteOrderFromTable(order_caster)
        self:GetParent():SetForceAttackTarget(hTarget)
    end
end

function modifier_inner_fear:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_inner_fear:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_inner_fear:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_inner_fear:OnTakeDamage(params)
    if IsServer() then 
        if params.unit == self:GetParent() then
            self:GetParent():ModifyHealth(self:GetParent():GetHealth() - 1, self:GetAbility(), true, 0)
        end 
	end
end

function modifier_inner_fear:CheckState()
	local state = {
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true
	}

	return state
end

function modifier_inner_fear:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_inner_fear:GetAbsoluteNoDamageMagical() return 1 end
function modifier_inner_fear:GetAbsoluteNoDamagePhysical() return 1 end
