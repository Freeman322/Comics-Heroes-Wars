LinkLuaModifier ("modifier_predator_hunter_strike", "abilities/predator_hunter_strike.lua", LUA_MODIFIER_MOTION_NONE)

if predator_hunter_strike == nil then predator_hunter_strike = class({}) end

function predator_hunter_strike:OnSpellStart ()
    if IsServer () then
        local damage = self:GetAbilityDamage()
        local radius = self:GetSpecialValueFor ("area_of_effect")
        local duration = self:GetSpecialValueFor ("stun_duration")
        local caster = self:GetCaster ()
        EmitSoundOn ("Hero_Axe.CounterHelix", caster)

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "beerus") then
            local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ares/ares_shadow_realm_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControl( nFXIndex, 0,  self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(radius, 1, 0))
            ParticleManager:SetParticleControl( nFXIndex, 3,  self:GetCaster():GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex )
        end

        local nearby_units = FindUnitsInRadius (caster:GetTeam (), caster:GetAbsOrigin (), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for i, target in ipairs (nearby_units) do
            EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
            target:AddNewModifier (caster, self, "modifier_stunned", { duration = duration })
            caster:AddNewModifier (caster, self, "modifier_predator_hunter_strike", { duration = 1.5 })
            ApplyDamage ( { victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    end
end

if modifier_predator_hunter_strike == nil then modifier_predator_hunter_strike = class({}) end

function modifier_predator_hunter_strike:IsHidden()
    return true
end

function modifier_predator_hunter_strike:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 5, Vector(200, 200, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function predator_hunter_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

