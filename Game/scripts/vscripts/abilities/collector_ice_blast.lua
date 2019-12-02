if collector_ice_blast == nil then collector_ice_blast = class({}) end

function collector_ice_blast:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function collector_ice_blast:IsStealable()
	return false
end

function collector_ice_blast:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_alma") then return "custom/alma_cold" end
  return self.BaseClass.GetAbilityTextureName(self)
end


function collector_ice_blast:OnSpellStart()
    if IsServer() then 
        local duration = self:GetOrbSpecialValueFor("duration","q")
        local damage = self:GetOrbSpecialValueFor("damage","e")
        local radius = self:GetOrbSpecialValueFor("radius","q")

        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, 0, false )
        if #targets > 0 then
            for _,target in pairs(targets) do
                target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
                ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
            end
        end

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alma") then
            particle_cast = "particles/collector/alma_ice_blast.vpcf"
            sound_cast =    "Alma.IcaBlast.Cast"

            local nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster() )
            ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetCursorPosition())
            ParticleManager:SetParticleControl(nFXIndex, 2, Vector (600, 600, 0))
            ParticleManager:SetParticleControl(nFXIndex, 4, self:GetCaster():GetCursorPosition())

            EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )

            Timers:CreateTimer(2, function()
                if nFXIndex then 
                    ParticleManager:DestroyParticle(nFXIndex, true)
                end 
            end)

          return 
        end

        EmitSoundOn("Hero_Centaur.DoubleEdge.TI9_layer", self:GetCaster())
        EmitSoundOn("hero_Crystal.CrystalNovaCast", self:GetCaster())
    
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
    end
end
