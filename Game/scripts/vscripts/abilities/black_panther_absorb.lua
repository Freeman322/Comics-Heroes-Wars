black_panther_absorb = class({})
LinkLuaModifier( "modifier_black_panther_absorb", "abilities/black_panther_absorb.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_panther_absorb_dummy", "abilities/black_panther_absorb.lua",LUA_MODIFIER_MOTION_NONE )

function black_panther_absorb:GetIntrinsicModifierName()
    return "modifier_black_panther_absorb"
end

function black_panther_absorb:OnUpgrade()
    if IsServer() then 
        if not self._iDamage then 
            self._iDamage = 0
        end
        if not self:GetCaster():HasModifier("modifier_black_panther_absorb_dummy") then 
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_black_panther_absorb_dummy", nil)
        end
    end
end

function black_panther_absorb:OnOwnerDied()
    if IsServer() then 
        local modifier = self:GetCaster():FindModifierByName("modifier_black_panther_absorb_dummy")
        if modifier then modifier:SetStackCount(0) end 
        
        self._iDamage = 0
    end
end

function black_panther_absorb:GetModifier()
    return self:GetCaster():FindModifierByName("modifier_black_panther_absorb_dummy")
end

function black_panther_absorb:OnSpellStart()
    if IsServer() then 
        local duration = self:GetSpecialValueFor(  "stun_duration" )

        local unit = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #unit > 0 then
            for _, target in pairs(unit) do
                local DamageTable = {
                    attacker = self:GetCaster(),
                    victim = target,
                    ability = self,
                    damage = self._iDamage,
                    damage_type = DAMAGE_TYPE_MAGICAL
                }
                ApplyDamage(DamageTable)

                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_panther/panther_absorb_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Abaddon.AphoticShield.Destroy", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );


        self._iDamage = 0
        self:GetModifier():SetStackCount(self._iDamage)
    end 
end

modifier_black_panther_absorb = class({})

function modifier_black_panther_absorb:IsHidden()
    return true
end

function modifier_black_panther_absorb:IsPurgable()
    return false
end

function modifier_black_panther_absorb:GetEffectName()
    return "particles/hero_panther/panther_absorb_ambient.vpcf"
end

function modifier_black_panther_absorb:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_black_panther_absorb:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker

            if target == self:GetParent() then
                return
            end
            
            if (self:GetAbility()._iDamage < self:GetAbility():GetSpecialValueFor("damage_threshold")) or self:GetCaster():HasScepter() then 
                self:GetAbility()._iDamage = (self:GetAbility()._iDamage or 0) + params.damage

                self:GetAbility():GetModifier():SetStackCount(self:GetAbility():GetModifier():GetStackCount() + params.damage)
            end
        end     
    end
end

modifier_black_panther_absorb_dummy = class({})

function modifier_black_panther_absorb_dummy:IsHidden()
    return false
end

function modifier_black_panther_absorb_dummy:IsPurgable()
    return false
end

function modifier_black_panther_absorb_dummy:RemoveOnDeath()
    return false
end