LinkLuaModifier( "modifier_po_walrus_punch", "abilities/po_walrus_punch.lua", LUA_MODIFIER_MOTION_NONE )

po_walrus_punch = class({})

function po_walrus_punch:OnSpellStart()

  self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_po_walrus_punch", { duration = self:GetSpecialValueFor("buff_duration") })

  local nFXIndex = ParticleManager:CreateParticle ("particles/items3_fx/iron_talon_active.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster());
  ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin (), true);
  ParticleManager:SetParticleControl(nFXIndex, 1, self:GetCaster():GetOrigin ());
  ParticleManager:SetParticleControl(nFXIndex, 3, self:GetCaster():GetOrigin ());
  ParticleManager:SetParticleControl(nFXIndex, 4, self:GetCaster():GetOrigin ());
  ParticleManager:ReleaseParticleIndex (nFXIndex);

  EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

  self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

modifier_po_walrus_punch = class({})
function modifier_po_walrus_punch:IsHidden() return false end
function modifier_po_walrus_punch:IsPurgable() return false end

function modifier_po_walrus_punch:GetStatusEffectName()
   return "particles/status_fx/status_effect_mjollnir_shield.vpcf"
end

function modifier_po_walrus_punch:StatusEffectPriority()
   return 1000
end

function modifier_po_walrus_punch:DeclareFunctions ()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_po_walrus_punch:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hTarget = params.target
            EmitSoundOn("Hero_Tusk.WalrusPunch.Damage", hTarget)
            EmitSoundOn("Hero_Tusk.WalrusKick.Target", hTarget)
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor("stun_duration") } )
            self:Destroy()
        end
    end
    return 0
end

function modifier_po_walrus_punch:GetModifierPreAttack_CriticalStrike ()
    return self:GetAbility():GetSpecialValueFor("crit")
end
