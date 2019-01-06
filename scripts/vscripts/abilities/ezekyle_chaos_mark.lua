ezekyle_chaos_mark = class ( {})

LinkLuaModifier ("modifier_ezekyle_chaos_mark", "abilities/ezekyle_chaos_mark.lua", LUA_MODIFIER_MOTION_NONE)

function ezekyle_chaos_mark:GetCooldown (nLevel) return self.BaseClass.GetCooldown (self, nLevel) end
function ezekyle_chaos_mark:GetCastRange (vLocation, hTarget) return self.BaseClass.GetCastRange (self, vLocation, hTarget) end

--------------------------------------------------------------------------------

local cast_sounds = {
    "doom_bringer_doom_cast_01",
    "doom_bringer_doom_cast_02",
    "doom_bringer_doom_cast_03",
    "doom_bringer_doom_ability_doom_04"

}

function ezekyle_chaos_mark:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local duration = self:GetSpecialValueFor ("duration")

            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_ezekyle_chaos_mark", { duration = duration } )
            EmitSoundOn ("Hero_DoomBringer.Devour", hTarget)
        end

        local sound = cast_sounds[ math.random( #cast_sounds ) ]

        EmitSoundOn (sound, self:GetCaster () )
    end
end


modifier_ezekyle_chaos_mark = class({})

function modifier_ezekyle_chaos_mark:GetEffectName () return "particles/items4_fx/spirit_vessel_damage_spirit.vpcf" end
function modifier_ezekyle_chaos_mark:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_ezekyle_chaos_mark:IsPurgable() return true end

function modifier_ezekyle_chaos_mark:OnCreated( kv )
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink() 
    end 
end

function modifier_ezekyle_chaos_mark:OnIntervalThink()
    if IsServer() then
        local damage = self:GetAbility():GetSpecialValueFor("damage")
        if self:GetCaster():HasTalent("special_bonus_unique_ezekyle_3") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_ezekyle_3") end
        
        ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function modifier_ezekyle_chaos_mark:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST 
    }

    return funcs
end


function modifier_ezekyle_chaos_mark:GetModifierMagicalResistanceBonus( params )
    return self:GetAbility():GetSpecialValueFor("magical_armor_bonus")
end

function modifier_ezekyle_chaos_mark:OnAbilityFullyCast( params )
    if IsServer() then 
        if self:GetParent() == params.unit then 
            local mana_cost = params.cost or 1
            
            ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = mana_cost, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    end 
end
