if item_stoneofinity == nil then
    item_stoneofinity = class ( {})
end
LinkLuaModifier ("item_stoneofinity_passive_modifier", "items/item_stoneofinity.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("item_stoneofinity_active_modifier", "items/item_stoneofinity.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function item_stoneofinity:GetIntrinsicModifierName()
    return "item_stoneofinity_passive_modifier"
end
function item_stoneofinity:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function item_stoneofinity:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local duration = self:GetSpecialValueFor ("duration")
            hTarget:AddNewModifier (self:GetCaster (), self, "item_stoneofinity_active_modifier", { duration = 8 } )
            local nFXIndex = ParticleManager:CreateParticle ("particles/econ/events/ti5/dagon_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil);
            ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster ():GetOrigin () + Vector (0, 0, 96), true);
            ParticleManager:SetParticleControlEnt (nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin (), true);
            ParticleManager:SetParticleControl (nFXIndex, 2, Vector (1, 0, 0));
            ParticleManager:ReleaseParticleIndex (nFXIndex);
            EmitSoundOn ("Hero_Bane.Nightmare", self:GetCaster () )
        end
    end
end

--------------------------------------------------------------------------------
if item_stoneofinity_passive_modifier == nil then
    item_stoneofinity_passive_modifier = class ( {})
end

function item_stoneofinity_passive_modifier:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_stoneofinity_passive_modifier:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function item_stoneofinity_passive_modifier:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all_stats_bonus")
end

function item_stoneofinity_passive_modifier:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all_stats_bonus")
end
function item_stoneofinity_passive_modifier:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all_stats_bonus")
end

function item_stoneofinity_passive_modifier:GetModifierBaseAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function item_stoneofinity_passive_modifier:GetModifierConstantManaRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end

------------------------------------------------------------------------------------


if item_stoneofinity_active_modifier == nil then
    item_stoneofinity_active_modifier = class ( {})
end

function item_stoneofinity_active_modifier:GetEffectName ()
    return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end

function item_stoneofinity_active_modifier:GetEffectAttachType ()
    return PATTACH_OVERHEAD_FOLLOW
end

function item_stoneofinity_active_modifier:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function item_stoneofinity_active_modifier:GetOverrideAnimation (params)
    return ACT_DOTA_FLAIL
end

function item_stoneofinity_active_modifier:GetOverrideAnimationRate(params)
    return 0.6
end

function item_stoneofinity_active_modifier:OnTakeDamage(params)
    if params.unit == self:GetParent () and self:GetParent ():HasModifier ("item_stoneofinity_active_modifier") then
        params.attacker:AddNewModifier(self:GetAbility ():GetCaster (), self:GetAbility(), "item_stoneofinity_active_modifier", {duration = 7})
        self:Destroy()
    end

end

function item_stoneofinity_active_modifier:OnCreated()
    if IsServer () then
        local parent = self:GetParent()
        local soundName = "Hero_Bane.Nightmare.Loop"
        StartSoundEvent (soundName, parent)
    end
end
function item_stoneofinity_active_modifier:OnDestroy()
    if IsServer () then
        StopSoundEvent ("Hero_Bane.Nightmare.Loop", self:GetParent ())
    end
end

function item_stoneofinity_active_modifier:CheckState()
    return {[MODIFIER_STATE_NIGHTMARED] = true,
            [MODIFIER_STATE_STUNNED] = true,
    }
end
function item_stoneofinity:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

