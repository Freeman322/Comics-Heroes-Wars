LinkLuaModifier("modifier_ares_dissecting_strike", "abilities/ares_dissecting_strike.lua", 0)

ares_dissecting_strike = class({GetIntrinsicModifierName = function() return "modifier_ares_dissecting_strike" end})

modifier_ares_dissecting_strike = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER} end
})

function ares_dissecting_strike:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_izanagi") then return "custom/ares_dissecting_strike_izanagi" end
    return self.BaseClass.GetAbilityTextureName(self)
end

function modifier_ares_dissecting_strike:OnCreated()
    if not IsServer() then return end

    if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "ares_son_of_zeus") == true then
        self.bLightning = true
    end

    self.strike = false
end

function modifier_ares_dissecting_strike:OnAttackLanded (params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and self:GetParent():IsRealHero() and (self:GetAbility():GetAutoCastState() or self.strike) and self:GetAbility():IsOwnersManaEnough() then
        local target = params.target
        if self.bLightning then
            local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ares/ares_immortal_lightning_weapon_proc.vpcf", PATTACH_CUSTOMORIGIN, target );
            ParticleManager:SetParticleControl( nFXIndex, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, 1500) );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 6, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );
            EmitSoundOn( "Hero_Zuus.LightningBolt.Cast.Righteous", self:GetParent() )
            EmitSoundOn( "Hero_Zuus.LightningBolt.Righteous", target )
            EmitSoundOn( "Hero_Zuus.Righteous.Layer", target )
            EmitSoundOn( "Hero_Zuus.GodsWrath.PreCast.Arcana", target )
        else
            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "izanagi") then
                ------------------------------ Skin Effect ------------------------------------
                local nFXIndex = ParticleManager:CreateParticle( "particles/ares_izanagi/dissecting_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
                ParticleManager:SetParticleControl( nFXIndex, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z) )
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, 1500))
                ParticleManager:SetParticleControl( nFXIndex, 2, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z) )
                ParticleManager:ReleaseParticleIndex( nFXIndex );
                EmitSoundOn( "Hero_Zuus.LightningBolt.Cast.Righteous", self:GetParent() )
                EmitSoundOn( "Hero_Zuus.LightningBolt.Righteous", target )
                ------------------------------ Skin Effect ------------------------------------
            else
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );
                EmitSoundOn( "Hero_DoomBringer.InfernalBlade.PreAttack", self:GetParent() )
                EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", target )
            end
        end
        ApplyDamage({
            victim = target,
            attacker = self:GetCaster(),
            ability = self:GetAbility(),
            damage = self:GetAbility():GetAbilityDamage(),
            damage_type = self:GetAbility():GetAbilityDamageType()
        })
        if target:IsRealHero() then
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
            self:GetParent():Heal(params.damage * (self:GetAbility():GetSpecialValueFor("crit_lifesteal")/100), self:GetAbility())
            local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
            local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())
        elseif target:IsBuilding() then
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("creep_stun_duration")})
        else
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("creep_stun_duration")})
            self:GetParent():Heal(params.damage * (self:GetAbility():GetSpecialValueFor("crit_lifesteal")/100), self:GetAbility())
            local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
            local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())
        end

        self:GetAbility():UseResources(true, false, true)
        self.strike = false
    end
end

function modifier_ares_dissecting_strike:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.strike = true
        else
            self.strike = false
        end
    end
end
