if oblivios_dark_ritual == nil then oblivios_dark_ritual = class({}) end
LinkLuaModifier( "modifier_oblivios_dark_ritual", "abilities/oblivios_dark_ritual.lua", LUA_MODIFIER_MOTION_NONE )

function oblivios_dark_ritual:OnSpellStart ()
  if IsServer() then
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local prj = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf"
            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "oblivion_shard_of_creation") == true then
                prj = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_prj.vpcf"
            end
            local info = {
                EffectName = prj,
                Ability = self,
                iMoveSpeed = 2500,
                Source = self:GetCaster (),
                Target = self:GetCursorTarget (),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile (info)
            EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster () )
        end
    end
  end
end

function oblivios_dark_ritual:OnProjectileHit (hTarget, vLocation)
    if IsServer() then
	    local duration = self:GetSpecialValueFor ("duration")
	    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_oblivios_dark_ritual", { duration = duration } )
	    EmitSoundOn ("DOTA_Item.Bloodthorn.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)
    end
    return true
end

if modifier_oblivios_dark_ritual == nil then modifier_oblivios_dark_ritual = class({}) end

function modifier_oblivios_dark_ritual:IsPurgable()
    return true
end

function modifier_oblivios_dark_ritual:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end


function modifier_oblivios_dark_ritual:StatusEffectPriority()
    return 1
end

function modifier_oblivios_dark_ritual:GetEffectName()
    return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
end

function modifier_oblivios_dark_ritual:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_oblivios_dark_ritual:OnCreated( kv )
    self.bonus_damage = 0
end

function modifier_oblivios_dark_ritual:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE

    }

    return funcs
end

function modifier_oblivios_dark_ritual:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    }

    return state
end

function modifier_oblivios_dark_ritual:OnTakeDamage( params )
	if self:GetParent() == params.unit then
		self.bonus_damage = self.bonus_damage + params.damage
	end
	return 0
end

function modifier_oblivios_dark_ritual:OnDestroy()
	if IsServer() then
		local hTarget = self:GetParent()
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", hTarget)
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)

        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetAbility():GetCaster())
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetAbility():GetCaster())

        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = hTarget, ability = self:GetAbility(), damage = self.bonus_damage*0.3, damage_type = DAMAGE_TYPE_MAGICAL})

        local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
        ParticleManager:SetParticleControl(pop_pfx, 0, hTarget:GetAbsOrigin())
        ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
        ParticleManager:ReleaseParticleIndex(pop_pfx)

        self:GetCaster():Heal(self.bonus_damage * self:GetAbility():GetSpecialValueFor("health_conversion"), self:GetAbility())

        self.bonus_damage = 0
	end
end

function oblivios_dark_ritual:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
