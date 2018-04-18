LinkLuaModifier ("modifier_ds_doomslash", "abilities/ds_doomslash.lua", LUA_MODIFIER_MOTION_NONE)

ds_doomslash = class ( {})

function  ds_doomslash:OnSpellStart ()
    if IsServer () then
        local damage = self:GetSpecialValueFor ("damage")
        local radius = self:GetSpecialValueFor ("radius")
        local duration = self:GetSpecialValueFor ("duration")
        local caster = self:GetCaster ()
        EmitSoundOn ("Hero_Axe.CounterHelix", caster)
        local nearby_units = FindUnitsInRadius (caster:GetTeam (), caster:GetAbsOrigin (), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for i, target in ipairs (nearby_units) do  --Restore health and play a particle effect for every found ally.
            EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
            target:AddNewModifier (caster, self, "modifier_stunned", { duration = duration })
            caster:AddNewModifier (caster, self, "modifier_ds_doomslash", { duration = 1.5 })
            ApplyDamage ( { victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
        end
    end
end

modifier_ds_doomslash = class({})

function modifier_ds_doomslash:IsHidden()
    return true
end

function modifier_ds_doomslash:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 5, Vector(200, 200, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function ds_doomslash:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

