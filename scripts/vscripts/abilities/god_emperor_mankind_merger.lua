god_emperor_mankind_merger = class({})

LinkLuaModifier( "modifier_god_emperor_mankind_merger_units", "abilities/god_emperor_mankind_merger.lua", LUA_MODIFIER_MOTION_NONE )


function god_emperor_mankind_merger:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster() )
	local allied_units = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for i, nearby_ally in ipairs(allied_units) do  --Restore health and play a particle effect for every found ally.
		nearby_ally:EmitSound("Hero_ObsidianDestroyer.EssenceAura")
		nearby_ally:AddNewModifier( self:GetCaster(), self, "modifier_god_emperor_mankind_merger_units", { duration = duration } )
	end
end

if modifier_god_emperor_mankind_merger_units == nil then modifier_god_emperor_mankind_merger_units = class({}) end

--------------------------------------------------------------------------------

function modifier_god_emperor_mankind_merger_units:OnCreated( kv )
    if IsServer() then
       local nFXIndex = ParticleManager:CreateParticle( "particles/hero_god_emperor/god_emperor_mankind_unite.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
	   ParticleManager:SetParticleControl( nFXIndex, 2, Vector(100, 100, 1) )
	   ParticleManager:SetParticleControl( nFXIndex, 2, Vector(100, 100, 1) )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
	   ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
	   self:AddParticle( nFXIndex, false, false, -1, false, true )
	   EmitSoundOn("Hero_Oracle.FatesEdict", self:GetParent())
    end
end


function modifier_god_emperor_mankind_merger_units:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_god_emperor_mankind_merger_units:GetModifierIncomingDamage_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_god_emperor_mankind_merger_units:IsPurgable()
	return false
end

function modifier_god_emperor_mankind_merger_units:IsHidden()
	return false
end

--[[if modifier_god_emperor_mankind_merger_target == nil then modifier_god_emperor_mankind_merger_target = class({}) end

function modifier_god_emperor_mankind_merger_target:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/dimm/dimm_ancient_contract.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 8, Vector(1, 0, 0))
		self:AddParticle( nFXIndex, false, false, -1, false, true )

        self.damage = 0
	end
end
function modifier_god_emperor_mankind_merger_target:OnDestroy()
    if IsServer() then
        self:GetParent():ModifyHealth(self:GetParent():GetHealth() - self.damage, self:GetAbility(), true, 0)
        EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse", self:GetParent())
        EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.Cast", self:GetParent())
    end
end
function modifier_god_emperor_mankind_merger_target:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_god_emperor_mankind_merger_target:OnTakeDamage( params )
   local parent = params.unit
   local attacker = params.attacker
   local damage = params.damage
   local damage_type = params.damage_type

   if parent:HasModifier("modifier_god_emperor_mankind_merger_units") then
   		self.damage = self.damage + damage
   end
end

function modifier_god_emperor_mankind_merger_target:IsPurgable()
	return false
end]]

function god_emperor_mankind_merger:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

