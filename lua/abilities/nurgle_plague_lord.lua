if nurgle_plague_lord == nil then nurgle_plague_lord = class({}) end

LinkLuaModifier( "modifier_nurgle_acid_puddle", "abilities/nurgle_acid_puddle.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "thinker_nurgle_acid_puddle", "abilities/nurgle_acid_puddle.lua", LUA_MODIFIER_MOTION_NONE )


function nurgle_plague_lord:OnOwnerDied()
  if IsServer() then
    local caster = self:GetCaster ()
    local point = caster:GetAbsOrigin()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")

    local thinker = CreateModifierThinker (caster, self, "thinker_nurgle_acid_puddle", {duration = duration }, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, duration, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)


    EmitSoundOn("Hero_Alchemist.UnstableConcoction.Stun", caster)

    local nFXIndex = ParticleManager:CreateParticle( "particles/frostivus_gameplay/wraith_king_hellfire_eruption_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin())

    local nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/ethereal_blade_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl( nFXIndex, 2, Vector(200, 200, 1))


    local flDamagePerTick = self:GetSpecialValueFor("near_damage")
    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

    if #units > 0 then
        for _,unit in pairs(units) do
            local damage = {
                victim = unit,
                attacker = self:GetCaster(),
                damage = flDamagePerTick,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self
            }
            ApplyDamage( damage )
            EmitSoundOn("Hero_Alchemist.AcidSpray.Damage", unit)
            unit:AddNewModifier( self:GetCaster(), self, "modifier_nurgle_acid_puddle", { duration = 10 } )
        end
     end
  end
end

function nurgle_plague_lord:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

