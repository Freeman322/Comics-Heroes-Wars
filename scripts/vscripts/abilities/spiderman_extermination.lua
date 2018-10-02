LinkLuaModifier ("modifier_spiderman_extermination", "abilities/spiderman_extermination.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_spiderman_extermination_active", "abilities/spiderman_extermination.lua", LUA_MODIFIER_MOTION_NONE)

if spiderman_extermination == nil then
    spiderman_extermination = class ( {})
end

function spiderman_extermination:GetIntrinsicModifierName ()
    return "modifier_spiderman_extermination"
end

function spiderman_extermination:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") end
    return self.BaseClass.GetCooldown( self, nLevel )
end

function spiderman_extermination:GetBehavior()
    if self:GetCaster():HasScepter() then return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE end return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function spiderman_extermination:OnSpellStart()
    local duration = self:GetSpecialValueFor( "duration_scepter" )

    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_spiderman_extermination_active", { duration = duration }  )

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Item.CrimsonGuard.Cast", self:GetCaster() )

    self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
end

if modifier_spiderman_extermination == nil then
    modifier_spiderman_extermination = class({})
end

function modifier_spiderman_extermination:IsHidden()
    return true
end

function modifier_spiderman_extermination:IsPurgable()
    return true
end

function modifier_spiderman_extermination:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_spiderman_extermination:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            local damage = params.damage
            if self:GetAbility():IsCooldownReady() then
                self:GetParent():SetHealth( self:GetParent():GetHealth() + damage)
                EmitSoundOn( "Hero_Oracle.FalsePromise.Healed", target )
                local cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())
                if self:GetParent():HasTalent("special_bonus_unique_spiderman") then 
                    cooldown = cooldown - self:GetParent():FindTalentValue("special_bonus_unique_spiderman")
                end
                self:GetAbility():StartCooldown(cooldown)
            end
        end
    end
end

function spiderman_extermination:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

if not modifier_spiderman_extermination_active then modifier_spiderman_extermination_active = class({}) end 

function modifier_spiderman_extermination_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end
-------------------------------------------------------------------------------
function modifier_spiderman_extermination_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination_active:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_jade_stone_dire.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination_active:StatusEffectPriority()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination_active:GetEffectName()
    return "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_spiderman_extermination_active:GetModifierEvasion_Constant( params )
    return self:GetAbility():GetSpecialValueFor( "evasion_scepter" )
end
