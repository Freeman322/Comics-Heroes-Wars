LinkLuaModifier("modifier_oblivion_dark_ritual", "abilities/oblivion_dark_ritual.lua", 0)

oblivion_dark_ritual = class({})

function oblivion_dark_ritual:OnSpellStart()
    if IsServer() then
        if not self:GetCursorTarget():TriggerSpellAbsorb(self) then
            local projectile = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf"
            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "oblivion_shard_of_creation") == true then
                projectile = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_prj.vpcf"
            end
            ProjectileManager:CreateTrackingProjectile({
                EffectName = prj,
                Ability = self,
                iMoveSpeed = 2500,
                Source = self:GetCaster (),
                Target = self:GetCursorTarget (),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            })
            EmitSoundOn("Hero_ArcWarden.Flux.Cast", self:GetCaster ())
        end
    end
end

function oblivion_dark_ritual:OnProjectileHit (hTarget, vLocation)
    if IsServer() and hTarget ~= nil then
	    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_oblivion_dark_ritual", {duration = self:GetSpecialValueFor("duration")})
	    EmitSoundOn ("DOTA_Item.Bloodthorn.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)
    end
    return true
end

modifier_oblivion_dark_ritual = class({
    IsPurgable = function() return true end,
    GetStatusEffectName = function() return "particles/status_fx/status_effect_gods_strength.vpcf" end,
    StatusEffectPriority = function() return 1 end,
    GetEffectName = function() return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end,

    CheckState = function() return {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    } end

})

function modifier_oblivion_dark_ritual:OnCreated() self.bonus_damage = 0 end
function modifier_oblivion_dark_ritual:OnTakeDamage(params)	if params.unit == self:GetParent() then self.bonus_damage = self.bonus_damage + params.damage end end

function modifier_oblivion_dark_ritual:OnDestroy()
	if IsServer() then
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetParent())
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetParent())

        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetAbility():GetCaster())
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetAbility():GetCaster())

        local particle = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector(100, 0, 0))
        ParticleManager:ReleaseParticleIndex(particle)

        self:GetCaster():Heal(self.bonus_damage * self:GetAbility():GetSpecialValueFor("health_conversion") / 100, self:GetAbility())

        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self.bonus_damage * self:GetAbility():GetSpecialValueFor("health_conversion") / 100, damage_type = DAMAGE_TYPE_MAGICAL})

        self.bonus_damage = 0
	end
end
