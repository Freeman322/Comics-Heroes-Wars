LinkLuaModifier ("modifier_godspeed_speed_abyss", "abilities/godspeed_speed_abyss.lua", LUA_MODIFIER_MOTION_NONE)

if not godspeed_speed_abyss then godspeed_speed_abyss = class({}) end

function godspeed_speed_abyss:OnSpellStart()
    if IsServer() then
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            if ( not hTarget:TriggerSpellAbsorb( self ) ) then
                local nFXIndex = ParticleManager:CreateParticle( "particles/godspeed/godspeed_speed_void.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                EmitSoundOn("Godspeed.SpeedVoid.Cast", hTarget)

                local damage = hTarget:GetIdealSpeed()

                self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_godspeed_speed_abyss", {duration = self:GetSpecialValueFor("duration"), damage = damage})

                ApplyDamage({
                    victim = hTarget,
                    attacker = self:GetCaster(),
                    damage = damage,
                    damage_type = self:GetAbilityDamageType(),
                    damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
                    ability = self
                })
            end
        end
    end
end

modifier_godspeed_speed_abyss = class({})

modifier_godspeed_speed_abyss.m_iDamage = 0

function modifier_godspeed_speed_abyss:IsHidden() return false end
function modifier_godspeed_speed_abyss:IsPurgable() return false end
function modifier_godspeed_speed_abyss:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_godspeed_speed_abyss:OnCreated(params)
    if IsServer() then
        self.m_iDamage = params.damage
    end
end


function modifier_godspeed_speed_abyss:GetModifierPreAttack_BonusDamage (params)
    return self.m_iDamage
end
