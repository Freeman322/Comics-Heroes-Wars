tzeentch_magic_mystic = class ( {})

LinkLuaModifier ("modifier_tzeentch_magic_mystic", "abilities/tzeentch_magic_mystic.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function tzeentch_magic_mystic:CastFilterResultTarget (hTarget)
    if IsServer () then

        if hTarget ~= nil and hTarget:IsMagicImmune() then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

function tzeentch_magic_mystic:GetAbilityDamageType()
    return DAMAGE_TYPE_MAGICAL
end

function tzeentch_magic_mystic:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end
--------------------------------------------------------------------------------

function tzeentch_magic_mystic:GetCastRange (vLocation, hTarget)
    return self.BaseClass.GetCastRange (self, vLocation, hTarget)
end

--------------------------------------------------------------------------------

function tzeentch_magic_mystic:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local info = {
                EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf",
                Ability = self,
                iMoveSpeed = 1500,
                Source = self:GetCaster (),
                Target = self:GetCursorTarget (),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile (info)
            EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster () )
        end
    end
end

function tzeentch_magic_mystic:OnProjectileHit (hTarget, vLocation)
    EmitSoundOn ("Hero_Disruptor.Glimpse.End", hTarget)
    local duration = self:GetSpecialValueFor ("duration")
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_tzeentch_magic_mystic", { duration = duration } )
    return true
end

modifier_tzeentch_magic_mystic = class ( {})

function modifier_tzeentch_magic_mystic:IsHidden()
    return false
end

function modifier_tzeentch_magic_mystic:IsBuff()
    return false
end

function modifier_tzeentch_magic_mystic:GetStatusEffectName()
    return "particles/status_fx/status_effect_necrolyte_spirit.vpcf"
end

function modifier_tzeentch_magic_mystic:StatusEffectPriority()
    return 1000
end

function modifier_tzeentch_magic_mystic:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_tzeentch_magic_mystic:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_tzeentch_magic_mystic:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
        self.armor_red = self:GetParent():GetPhysicalArmorValue( false ) * (self:GetAbility():GetSpecialValueFor("armor_reduction_pct")/100)
        self.mag_red = self:GetParent():GetMagicalArmorValue() * (self:GetAbility():GetSpecialValueFor("magical_armor_reduction")/100)
        self:OnIntervalThink()
        local pert = "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
        
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "mera") then
             pert = "particles/hero_tzeench/mera_marker.vpcf"
        end 
       
        local nFXIndex = ParticleManager:CreateParticle( pert, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 0,  self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 2,  Vector(200, 200, 0) )
        ParticleManager:SetParticleControl( nFXIndex, 3,  self:GetParent():GetAbsOrigin() )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_tzeentch_magic_mystic:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent ()
        local hAbility = self:GetAbility ()
        local damage = hAbility:GetSpecialValueFor("damage_per_second")
        ApplyDamage ( { attacker = self:GetCaster (), victim = thinker, ability = hAbility, damage = damage, damage_type = hAbility:GetAbilityDamageType()})

        local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), thinker:GetAbsOrigin(), self:GetCaster(), 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        if #targets > 0 then
            for _,target in pairs(targets) do
                if target ~= self:GetParent() then
                    ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbility():GetSpecialValueFor("damage_per_unit") * #targets, ability = hAbility, damage_type = DAMAGE_TYPE_PURE})
                end
            end
        end
    end
end
function modifier_tzeentch_magic_mystic:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_tzeentch_magic_mystic:GetModifierPhysicalArmorBonus (params)
    return self.armor_red
end

function modifier_tzeentch_magic_mystic:GetModifierMagicalResistanceBonus (params)
    return self.mag_red
end

function tzeentch_magic_mystic:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

