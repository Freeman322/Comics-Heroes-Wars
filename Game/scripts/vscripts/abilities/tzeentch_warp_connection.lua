LinkLuaModifier( "modifier_tzeentch_warp_connection", "abilities/tzeentch_warp_connection.lua", LUA_MODIFIER_MOTION_NONE )

if tzeentch_warp_connection == nil then tzeentch_warp_connection = class({}) end

function tzeentch_warp_connection:GetCooldown (nLevel)
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end
    return self.BaseClass.GetCooldown (self, nLevel)
end

function tzeentch_warp_connection:IsStealable ()
    return false
end

--[[function tzeentch_warp_connection:IsRefreshable()
    return false
end]]

function tzeentch_warp_connection:OnSpellStart ()
    local caster = self:GetCaster ()
    local location = caster:GetOrigin ()

    self.duration = self:GetSpecialValueFor ("duration")

    if caster:HasScepter() then
        self.duration = self:GetSpecialValueFor ("duration_scepter")
    end

    local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
    ParticleManager:SetParticleControl (nFXIndex, 0, self:GetCaster ():GetAbsOrigin())
    ParticleManager:SetParticleControl (nFXIndex, 2, self:GetCaster ():GetAbsOrigin())

    EmitSoundOn ("Hero_FacelessVoid.TimeDilation.Cast", self:GetCaster () )

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	  if #units > 0 then
  	  for _,unit in pairs(units) do
  			unit:AddNewModifier( self:GetCaster(), self, "modifier_tzeentch_warp_connection", { duration = self.duration } )
  		end
	end
end

if modifier_tzeentch_warp_connection == nil then modifier_tzeentch_warp_connection = class({}) end

function modifier_tzeentch_warp_connection:IsHidden()
    return false
end

function modifier_tzeentch_warp_connection:IsBuff()
    if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return true
    else
        return false
    end
end

function modifier_tzeentch_warp_connection:IsPurgable()
    return false
end

function modifier_tzeentch_warp_connection:OnCreated(table)
    if IsServer() then
        local pfx = "particles/hero_tzeench/tzeentch_warp_connection.vpcf"
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "mera") then
            pfx = "particles/units/heroes/hero_razor_reduced_flash/razor_rain_storm_reduced_flash.vpcf"

            EmitSoundOn("Hero_Razor.Storm.Cast", self:GetParent())

            local paticle = ParticleManager:CreateParticle( "particles/econ/items/lion/fish_stick/lion_fish_stick_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt( paticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), false )
            ParticleManager:SetParticleControlEnt( paticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), false )
        end 

        local nFXIndex = ParticleManager:CreateParticle( pfx, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl (nFXIndex, 0, self:GetCaster ():GetAbsOrigin())
        ParticleManager:SetParticleControl (nFXIndex, 1, Vector(1, 0, 0))
        ParticleManager:SetParticleControl (nFXIndex, 2, Vector(400, 400, 0))
        ParticleManager:SetParticleControl (nFXIndex, 3, self:GetCaster ():GetAbsOrigin())
        ParticleManager:SetParticleControl (nFXIndex, 5, Vector(400, 400, 0))
		self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function tzeentch_warp_connection:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

