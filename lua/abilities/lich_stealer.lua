LinkLuaModifier ("modifier_lich_stealer", "abilities/lich_stealer.lua", LUA_MODIFIER_MOTION_NONE)
---LinkLuaModifier ("modifier_lich_aura_passive", "abilities/lich_stealer.lua", LUA_MODIFIER_MOTION_NONE)
lich_stealer = class({})

function lich_stealer:GetIntrinsicModifierName()
	return "modifier_lich_stealer"
end

--[[function lich_stealer:OnUpgrade()
	local caster = self:GetCaster()

	if not caster:HasModifier("modifier_lich_aura_passive") then
		caster:AddNewModifier(caster, self, "modifier_lich_aura_passive", nil)
	end
end

function lich_stealer:OnHeroDiedNearby( hVictim, hKiller, kv )
	if hVictim == nil or hKiller == nil then
		return
	end

	if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
		self.flesh_heap_range = self:GetSpecialValueFor( "range" )
        if self:GetCaster():FindAbilityByName("lich_king_cold_reaper") ~= nil then
           self.flesh_heap_range = self.flesh_heap_range + (self:GetCaster():FindAbilityByName("lich_king_cold_reaper"):GetLevel()*50)
        end
        if self:GetCaster():HasScepter() then
            self.flesh_heap_range = self.flesh_heap_range + 100
        end
		local vToCaster = self:GetCaster():GetOrigin() - hVictim:GetOrigin()
		local flDistance = vToCaster:Length2D()
		if hKiller == self:GetCaster() or self.flesh_heap_range >= flDistance then
			if self.nKills == nil then
				self.nKills = 0
			end

			self.nKills = self.nKills + 1

			local hBuff = self:GetCaster():FindModifierByName( "modifier_lich_aura_passive" )
			if hBuff ~= nil then
				hBuff:SetStackCount( self.nKills )
				self:GetCaster():CalculateStatBonus()
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end

--------------------------------------------------------------------------------

function lich_stealer:GetFleshHeapKills()
	if self.nKills == nil then
		self.nKills = 0
	end
	return self.nKills
end

modifier_lich_aura_passive = class({})

--------------------------------------------------------------------------------

function modifier_lich_aura_passive:OnCreated( kv )
    self.damage_buff_amount = self:GetAbility():GetSpecialValueFor( "damage_buff_amount" )
    if IsServer() then
        self:SetStackCount( self:GetAbility():GetFleshHeapKills() )
        self:GetParent():CalculateStatBonus()
    end
end

--------------------------------------------------------------------------------

function modifier_lich_aura_passive:OnRefresh( kv )
    self.damage_buff_amount = self:GetAbility():GetSpecialValueFor( "damage_buff_amount" )
    if IsServer() then
        self:GetParent():CalculateStatBonus()
    end
end

--------------------------------------------------------------------------------

function modifier_lich_aura_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_lich_aura_passive:IsPurgable()
	return false
end

function modifier_lich_aura_passive:IsHidden()
	return false
end

function modifier_lich_aura_passive:RemoveOnDeath()
	return false
end

function modifier_lich_aura_passive:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount() * self.damage_buff_amount
end
]]
modifier_lich_stealer = class({})

function modifier_lich_stealer:IsHidden()
	return true
end

function modifier_lich_stealer:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_lich_stealer:GetModifierProcAttack_BonusDamage_Pure (params)
 	if self.bonus_damage == nil then
 		self.bonus_damage = 0
 	end
    return self.bonus_damage
end


function modifier_lich_stealer:OnAttackStart (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            self.bonus_damage = target:GetHealth()*(self:GetAbility():GetSpecialValueFor("hp_leech_percent")/100)
            if target:IsBuilding() or target:IsAncient() then
            	self.bonus_damage = 0
            end
        end
    end

    return 0
end

function modifier_lich_stealer:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local target = params.target
            local heal = target:GetHealth()*(self:GetAbility():GetSpecialValueFor("hp_leech_percent")/100)
            if not target:IsBuilding() then
                self:GetParent ():Heal(heal, self:GetParent ())
                local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
                local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
                ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
            end
        end
    end

    return 0
end

function lich_stealer:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

