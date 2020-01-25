LinkLuaModifier( "modifier_roug_embrace_of_ethernity", "abilities/roug_embrace_of_ethernity.lua" ,LUA_MODIFIER_MOTION_NONE )

roug_embrace_of_ethernity = class({})

function roug_embrace_of_ethernity:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end
    return self.BaseClass.GetCooldown( self, nLevel )
end

function roug_embrace_of_ethernity:OnSpellStart()
    if not self:GetCursorTarget():TriggerSpellAbsorb(self) then
        self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_roug_embrace_of_ethernity", {duration = self:GetSpecialValueFor("duration")})
    end
    EmitSoundOn("Hero_Enigma.Malefice", self:GetCursorTarget())
end

modifier_roug_embrace_of_ethernity = class ({})

function modifier_roug_embrace_of_ethernity:IsDebuff() return true end
function modifier_roug_embrace_of_ethernity:IsStunDebuff() return true end
function modifier_roug_embrace_of_ethernity:IsPurgable() return false end
function modifier_roug_embrace_of_ethernity:OnCreated()
    self:StartIntervalThink(0.1)
    if IsServer() then
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "succubus") == true then
            local nFXIndex = ParticleManager:CreateParticle( "particles/spectre/succubus_drain.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetParent():GetOrigin() + Vector( 0, 0, 96 ), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
            self:AddParticle( nFXIndex, false, false, -1, false, true )
        else
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )

            ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
            self:AddParticle( nFXIndex, false, false, -1, false, true )
        end
    end
end

function modifier_roug_embrace_of_ethernity:OnIntervalThink()
    if IsServer() then
        local damage = (self:GetAbility():GetSpecialValueFor("damage_pers")/100) * self:GetParent():GetHealth()/10
        if self:GetCaster():HasScepter() then
            damage = (self:GetAbility():GetSpecialValueFor("damage_pers_scepter")/100) * self:GetParent():GetHealth()/10
        end

        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        })
    end
end

function modifier_roug_embrace_of_ethernity:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVISIBLE] = false,
        [MODIFIER_STATE_FROZEN] = true
    }
end
