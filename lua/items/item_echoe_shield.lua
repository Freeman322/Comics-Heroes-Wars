LinkLuaModifier ("modifier_echoe_shield", "items/item_echoe_shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_echoe_shield", "items/item_echoe_shield.lua", LUA_MODIFIER_MOTION_NONE)

if item_echoe_shield == nil then
    item_echoe_shield = class ( {})
end

function item_echoe_shield:GetIntrinsicModifierName ()
    return "modifier_item_echoe_shield"
end

--------------------------------------------------------------------------------

function item_echoe_shield:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("echoe_shield_duration")
    local caster = self:GetCaster ()

    caster:AddNewModifier(caster, self, "modifier_echoe_shield", {duration = duration})
end


if modifier_echoe_shield == nil then
    modifier_echoe_shield = class({})
end

function modifier_echoe_shield:GetTexture()
    return "item_echoe_shield"
end

function modifier_echoe_shield:IsPurgable()
    return false
end

function modifier_echoe_shield:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/echo_shield/echo_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(100, 100, 100))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1))
        ParticleManager:SetParticleControl( nFXIndex, 3, Vector(100, 100, 100))
        ParticleManager:SetParticleControl( nFXIndex, 4, Vector(100, 100, 100))
        ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn ("Hero_Antimage.ManaVoid", self:GetParent())
    end
end


function modifier_echoe_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_echoe_shield:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            if target == self:GetParent() then
                return
            end
            local damage = params.damage
            local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
            ParticleManager:SetParticleControl(pop_pfx, 0, target:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex( pop_pfx );
            EmitSoundOn("Hero_Pugna.NetherWard.Target", self:GetParent())

            local nFXIndex = ParticleManager:CreateParticle("particles/echo_shield/echo_shield_reflect.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex );
            if target:GetClassname() == "ent_dota_fountain" then
               return
            end
            ApplyDamage ( {
                victim = target,
                attacker = self:GetParent(),
                damage = params.damage,
                damage_type = params.damage_type,
                ability = self:GetAbility(),
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
            })
        end
    end
end

if modifier_item_echoe_shield == nil then
    modifier_item_echoe_shield = class({})
end

function modifier_item_echoe_shield:IsHidden()
    return true
end

function modifier_item_echoe_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end
function modifier_item_echoe_shield:OnCreated(params)
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_aether_lens", nil)
    end
end

function modifier_item_echoe_shield:OnDestroy(params)
    if IsServer() then
        if self:GetParent():HasModifier("modifier_item_aether_lens") then
            self:GetParent():RemoveModifierByName("modifier_item_aether_lens")
        end
    end
end

function modifier_item_echoe_shield:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function modifier_item_echoe_shield:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end

function modifier_item_echoe_shield:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end


function modifier_item_echoe_shield:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            if not self:GetParent():HasModifier("modifier_echoe_shield") then
                local chance = self:GetAbility():GetSpecialValueFor ("block_chance" )
                local random = math.random(100)
                local target = params.attacker
                local damage = params.damage
                if random <= chance then
                    ApplyDamage({attacker = self:GetParent(), victim = target, ability = self:GetAbility(), damage = damage*2, damage_type = DAMAGE_TYPE_PURE})
                    self:GetParent():SetHealth( self:GetParent():GetHealth() + damage)
                    ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_POINT_FOLLOW, target)
                    EmitSoundOn( "Hero_Oracle.FalsePromise.Damaged", target )
                end
            end
        end
    end
end

function item_echoe_shield:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

