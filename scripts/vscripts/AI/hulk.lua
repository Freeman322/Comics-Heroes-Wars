require( "ai/ai_core" )

LinkLuaModifier("modifier_hulk","ai/hulk.lua", LUA_MODIFIER_MOTION_NONE)

Event.m_Hulk = {}

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
        Event.m_Hulk.creature = self:GetParent():entindex()

		CustomNetTables:SetTableValue("event", "unit", Event.m_Hulk)
	end
end

function modifier_hulk:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_hulk:GetModifierBaseAttack_BonusDamage( params )
	return self:GetStackCount() * 50
end

function modifier_hulk:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount() * 2
end

function modifier_hulk:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * 45
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

        self:IncrementStackCount() self:ForceRefresh() self:GetParent():CalculateStatBonus()

        Timers:CreateTimer (4, function ()
            ParticleManager:DestroyParticle (self.ReincarnateParticle, false)

            self:GetParent():EmitSound ("Hero_SkeletonKing.Reincarnate.Stinger")

            self:GetParent():SetMinimumGoldBounty(self:GetStackCount() * 500)
            self:GetParent():SetMaximumGoldBounty(self:GetStackCount() * 500)

            self:GetParent():SetBaseMaxHealth((self:GetStackCount() * 500) + 1000)
            self:GetParent():RespawnUnit() self:GetParent():Heal(self:GetParent():GetMaxHealth(), self) 
        end)

        return 4
    end
end
