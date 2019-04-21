antman_spirit_ant = class ( {})
LinkLuaModifier("modifier_antman_spirit_ant", "abilities/antman_spirit_ant.lua", LUA_MODIFIER_MOTION_NONE)

function antman_spirit_ant:OnUpgrade()
    if IsServer() then 
        if self:GetLevel() == 1 and self:GetCaster():IsRealHero() then 
            PrecacheUnitByNameAsync("npc_dota_antman_ant", function()
                self._hAnt = CreateUnitByName("npc_dota_antman_ant", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
                self._hAnt:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
                self._hAnt:SetUnitCanRespawn(true)

                self._hAnt:AddNewModifier(self:GetCaster(), self, "modifier_antman_spirit_ant", nil)
            end)
        end
    end
end

function antman_spirit_ant:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

function antman_spirit_ant:GetManaCost (hTarget)
    return self.BaseClass.GetManaCost (self, hTarget)
end

function antman_spirit_ant:OnSpellStart ()
    local hCaster = self:GetCaster()
    local pID = hCaster:GetPlayerID()

    if self._hAnt and IsValidEntity(self._hAnt)then
        local particleName = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"

        if not self._hAnt:IsAlive() then self._hAnt:RespawnUnit() end

        EmitSoundOn("Hero_Enigma.Malefice", hCaster)
    
        local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, hCaster )
        ParticleManager:SetParticleControl( particle1, 0, hCaster:GetAbsOrigin() )
        ParticleManager:SetParticleControl( particle1, 1, hCaster:GetAbsOrigin() )
        ParticleManager:SetParticleControl( particle1, 2, Vector(500,0,0) )
    
        FindClearSpaceForUnit(self._hAnt, hCaster:GetAbsOrigin(), true)
        self._hAnt:Heal(self._hAnt:GetMaxHealth(), self)

        self._hAnt:FindModifierByName("modifier_antman_spirit_ant"):ForceRefresh()
	end
end

if modifier_antman_spirit_ant == nil then modifier_antman_spirit_ant = class({}) end

function modifier_antman_spirit_ant:IsHidden()
	return true
end
function modifier_antman_spirit_ant:RemoveOnDeath()
	return false
end
function modifier_antman_spirit_ant:IsPurgable()
	return false
end

function modifier_antman_spirit_ant:OnCreated(params)
    if IsServer() then
        self._iEntityHealth = self:GetParent():GetMaxHealth()

        self:StartIntervalThink(1)
        self:SetStackCount(self:GetCaster():GetMaxHealth())
	end
end

function modifier_antman_spirit_ant:OnIntervalThink()
	if IsServer() then
        self:SetStackCount(self:GetCaster():GetMaxHealth())

        self:GetParent():SetMaxHealth(self._iEntityHealth + (self:GetCaster():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("spider_health_damage") / 100)))
	end
end

function modifier_antman_spirit_ant:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_antman_spirit_ant:GetModifierBaseAttack_BonusDamage( params )
	return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("spider_damage") / 100)
end

function modifier_antman_spirit_ant:GetModifierConstantHealthRegen( params )
	return self:GetAbility():GetSpecialValueFor("spider_regen_tooltip")
end

function modifier_antman_spirit_ant:GetModifierPhysicalArmorBonus( params )
	return self:GetAbility():GetSpecialValueFor("spider_armor")
end
