require( "ai/ai_core" )

LinkLuaModifier("modifier_hulk","ai/hulk.lua", LUA_MODIFIER_MOTION_NONE)


function Spawn( entityKeyValues )
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_hulk", nil)
end

function AIThink() 
  
end

if not modifier_hulk then modifier_hulk = class({}) end 

function modifier_hulk:IsPurgable() return false end
function modifier_hulk:IsHidden() return false end
function modifier_hulk:RemoveOnDeath() return false end

function modifier_hulk:OnCreated(table)
    if IsServer() then
        self.m_Hulk = {}
        
        self.m_Hulk.creature = self:GetParent():entindex()
        self.m_Hulk.round = 1
        
		CustomNetTables:SetTableValue("event", "unit", self.m_Hulk)
	end
end

function modifier_hulk:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}

	return funcs
end

function modifier_hulk:GetModifierPreAttack_CriticalStrike( params )
    if IsServer() and RollPercentage(7) then 
        return self:GetStackCount() * 250
    end 
end

function modifier_hulk:GetModifierSpellAmplify_Percentage( params )
	return self:GetStackCount() * 16
end

function modifier_hulk:GetModifierBaseAttack_BonusDamage( params )
	return self:GetStackCount() * 600
end

function modifier_hulk:GetModifierProcAttack_BonusDamage_Pure( params )
	return self:GetStackCount() * 35
end

function modifier_hulk:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount() * 4
end

function modifier_hulk:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * 45
end

function modifier_hulk:CheckState()
	local state = {
	    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end

function modifier_hulk:ReincarnateTime (params)
    if IsServer () then
        local respawnPosition = self:GetParent():GetAbsOrigin()

        print("Respawn!")

        local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
        self.ReincarnateParticle = ParticleManager:CreateParticle (particleName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl (self.ReincarnateParticle, 0, respawnPosition)
        ParticleManager:SetParticleControl (self.ReincarnateParticle, 1, Vector (500, 0, 0))
        ParticleManager:SetParticleControl (self.ReincarnateParticle, 1, Vector (500, 500, 0))

        self:GetParent():EmitSound ("Hero_SkeletonKing.Reincarnate")
        self:GetParent():EmitSound ("Hero_SkeletonKing.Death")

        self:IncrementStackCount() 

        self.m_Hulk.round = self.m_Hulk.round + 1
        self.m_Hulk.creature = self:GetParent():entindex()

        CustomNetTables:SetTableValue("event", "unit", self.m_Hulk)

        Timers:CreateTimer (4, function ()
            ParticleManager:DestroyParticle (self.ReincarnateParticle, false)

            self:GetParent():EmitSound ("Hero_SkeletonKing.Reincarnate.Stinger")

            self:GetParent():SetMinimumGoldBounty(self:GetStackCount() * 500)
            self:GetParent():SetMaximumGoldBounty(self:GetStackCount() * 500)

            Event.m_nRounds = self:GetStackCount()

            self:GetParent():SetModelScale(self:GetParent():GetModelScale() + 0.01)

            self:GetParent():SetBaseMaxHealth((self:GetStackCount() * 1500) + 1000)
            self:GetParent():RespawnUnit() self:GetParent():Heal(self:GetParent():GetMaxHealth(), self) 

            self:ForceRefresh() 
        end)

        return 4
    end
end

if not modifier_hulk_dummy then modifier_hulk_dummy = class({}) end 

function modifier_hulk_dummy:IsPurgable() return false end
function modifier_hulk_dummy:IsHidden() return false end
function modifier_hulk_dummy:RemoveOnDeath() return false end
function modifier_hulk_dummy:CheckState()
	local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
	}

	return state
end
