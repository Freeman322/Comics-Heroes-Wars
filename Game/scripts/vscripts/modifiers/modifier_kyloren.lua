if modifier_kyloren == nil then modifier_kyloren = class({}) end

local sounds = {
    "Kyloren.Intro1",
    "Kyloren.Intro2",
    "Kyloren.Intro3", 
    "Kyloren.Intro4"
}

modifier_kyloren.On = "default"
modifier_kyloren.Off = "disabled"

function modifier_kyloren:IsHidden() return true end
function modifier_kyloren:IsPurgable() return false end
function modifier_kyloren:RemoveOnDeath() return false end

function modifier_kyloren:OnCreated(params)
    if IsServer() then 
       self:GetParent().weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_kyloren/kyloren_weapon.vmdl"})
       self:GetParent().weapon:FollowEntity(self:GetParent(), true)

       local nFXIndex = ParticleManager:CreateParticle( "particles/kyloren/kyloren_sword_color.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent().weapon )
       ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent().weapon, PATTACH_POINT_FOLLOW, "attach_root", self:GetParent().weapon:GetAbsOrigin(), true )
       ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent().weapon, PATTACH_POINT_FOLLOW, "attach_root", self:GetParent().weapon:GetAbsOrigin(), true )
	   self:AddParticle(nFXIndex, false, false, -1, false, false)

       self:EnableWeapon()
    end
end

function modifier_kyloren:EnableWeapon()
    if IsServer() then 
        EmitSoundOn("Kyloren.Lightsaber_Cast", self:GetParent().weapon)

        EmitSoundOn(sounds[ math.random( #sounds ) ], self:GetParent())

        self:GetParent().weapon:SetMaterialGroup(self.On)

        StartSoundEventReliable("Kyloren.IdleLoop", self:GetParent())
    end 
end

function modifier_kyloren:DisableWeapon()
    if IsServer() then 
        self:GetParent().weapon:SetMaterialGroup(self.Off)

        StopSoundEvent("Kyloren.IdleLoop", self:GetParent())
    end 
end

function modifier_kyloren:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_RESPAWN
    }

    return funcs
end


function modifier_kyloren:OnDeath(params)
    if IsServer() then 
       if params.unit == self:GetParent() then 
            self:DisableWeapon()
       end 
    end 
end


function modifier_kyloren:OnRespawn(params)
    if IsServer() then 
        if params.unit == self:GetParent() then 
            self:EnableWeapon()
        end 
    end 
end