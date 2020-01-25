murlock_dark_pact = class({})

LinkLuaModifier( "modifier_murlock_dark_pact", "abilities/murlock_dark_pact.lua",LUA_MODIFIER_MOTION_NONE )

function murlock_dark_pact:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_dark_pact_pulses_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster );
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1));
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn( "Hero_Slark.DarkPact.PreCast", self:GetCaster())

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );

        Timers:CreateTimer(1.5, function()
            caster:AddNewModifier(caster, self, "modifier_murlock_dark_pact", {duration = 1.1})
            return nil
        end)

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sanji") == true then EmitSoundOn("Sanji.Cast1", caster) end
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
    end
end

modifier_murlock_dark_pact = class({})

function modifier_murlock_dark_pact:IsHidden()
    return true
end

function modifier_murlock_dark_pact:IsPurgable()
    return false
end

function modifier_murlock_dark_pact:OnCreated()
    local caster = self:GetParent()
    if IsServer() then
        self:StartIntervalThink(0.1)
        self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
        self.damage = self:GetAbility():GetSpecialValueFor(  "damage" )/100
        self.total_pulses = self:GetAbility():GetSpecialValueFor(  "total_pulses" )
        EmitSoundOn( "Hero_Slark.DarkPact.Cast", self:GetCaster())
    end
end

function modifier_murlock_dark_pact:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()

        local RemovePositiveBuffs = false
        local RemoveDebuffs = true
        local BuffsCreatedThisFrameOnly = false
        local RemoveStuns = true
        local RemoveExceptions = false
        caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

        local damage = ((caster:GetAgility()*self.damage) + self:GetAbility():GetAbilityDamage())/10

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1));
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #enemies > 0 then
            for _,target in pairs(enemies) do
                ApplyDamage({victim = target, attacker = caster, damage = damage, ability = damage, damage_type = DAMAGE_TYPE_MAGICAL})
            end
        end
    end
end

function murlock_dark_pact:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

