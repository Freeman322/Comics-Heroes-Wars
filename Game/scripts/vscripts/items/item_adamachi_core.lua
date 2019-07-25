LinkLuaModifier ("modifier_item_adamachi_core", "items/item_adamachi_core.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_adamachi_core_active", "items/item_adamachi_core.lua", LUA_MODIFIER_MOTION_NONE)

if item_adamachi_core == nil then
    item_adamachi_core = class({})
end

function item_adamachi_core:GetIntrinsicModifierName ()
    return "modifier_item_adamachi_core"
end

function item_adamachi_core:OnSpellStart ()
    if IsServer() then 
        self:GetCaster():AddNewModifier (self:GetCaster(), self, "modifier_item_adamachi_core_active", { duration = self:GetSpecialValueFor ("active_duration") })
    end
end

if modifier_item_adamachi_core_active == nil then
    modifier_item_adamachi_core_active = class({})
end

function modifier_item_adamachi_core_active:IsPurgable()
    return false
end

function modifier_item_adamachi_core_active:IsPurgeException()
     return true
end

function modifier_item_adamachi_core_active:IsDebuff()
    return false
end

function modifier_item_adamachi_core_active:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
    }

    return funcs
end

function modifier_item_adamachi_core_active:OnTakeDamageKillCredit( params )
    if IsServer() then
        if params.inflictor and params.attacker == self:GetParent()	then 
			local damage = (params.damage * (self:GetAbility():GetSpecialValueFor("active_lifesteale") / 100))

			self:GetParent():Heal(damage, self:GetAbility())

			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
			ParticleManager:ReleaseParticleIndex( nFXIndex );

            SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_HEAL , self:GetParent(), math.floor( damage ), nil )
        end
    end
end

function modifier_item_adamachi_core_active:OnCreated(table)
    if IsServer() then 
        EmitSoundOn("Hero_Bane.Enfeeble", self:GetParent())
        local pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_hermit_crab/hermit_crab_octarine_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt( pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetAbsOrigin(), true )
        self:AddParticle(pfx, false, false, -1, false, false)
    end
end

function modifier_item_adamachi_core_active:OnDestroy()
    if IsServer() then 
        EmitSoundOn("Item.LotusOrb.Destroy", self:GetParent())
    end
end

if modifier_item_adamachi_core == nil then
    modifier_item_adamachi_core = class({})
end

function modifier_item_adamachi_core:IsHidden()
    return true
end

function modifier_item_adamachi_core_active:IsPurgable()
    return false
end


function modifier_item_adamachi_core:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
    }

    return funcs
end

function modifier_item_adamachi_core:OnTakeDamageKillCredit( params )
    if IsServer() then
        if params.inflictor and params.attacker == self:GetParent()	then 
			local damage = (params.damage * (self:GetAbility():GetSpecialValueFor("bonus_lifesteal") / 100))

			self:GetParent():Heal(damage, self:GetAbility())

			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			SendOverheadEventMessage( self:GetParent(), OVERHEAD_ALERT_HEAL , self:GetParent(), math.floor( damage ), nil )
        end 
    end 
end

function modifier_item_adamachi_core:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intelligence" )
end

function modifier_item_adamachi_core:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end

function modifier_item_adamachi_core:GetModifierManaBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana" )
end

function modifier_item_adamachi_core:GetModifierPercentageCooldown( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_cooldown" )
end

function modifier_item_adamachi_core:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
