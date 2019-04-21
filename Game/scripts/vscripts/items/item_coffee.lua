LinkLuaModifier ("modifier_item_coffee", "items/item_coffee.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_coffee_active", "items/item_coffee.lua", LUA_MODIFIER_MOTION_NONE)

if item_coffee == nil then 
    item_coffee = class ( {})
end

function item_coffee:GetIntrinsicModifierName ()
    return "modifier_item_coffee"
end

function item_coffee:OnSpellStart ()
    EmitSoundOn("DOTA_Item.ClarityPotion.Activate", self:GetCaster ())
    local duration = self:GetSpecialValueFor ("buff_duration")
    local particle = "particles/items/coffe.vpcf"
    local fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster ())
    ParticleManager:SetParticleControl(fx, 0, self:GetCaster ():GetAbsOrigin())
    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_coffee_active", { duration = duration, hp_regen = self:GetSpecialValueFor ("hp_regen"), mana_regen = self:GetSpecialValueFor ("mana_regen") })
    self:RemoveSelf()
end

if modifier_item_coffee == nil then
    modifier_item_coffee = class ( {})
end

function modifier_item_coffee:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_coffee:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_coffee:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("hp_regen_passive")
end

if modifier_item_coffee_active == nil then
    modifier_item_coffee_active = class ( {})
end

function modifier_item_coffee_active:IsPurgable()
    return false 
end

function modifier_item_coffee_active:GetTexture()
    return "coffee"
end


function modifier_item_coffee_active:OnCreated(htable)
    self.hp = htable.hp_regen
    self.mana = htable.mana_regen
end

function modifier_item_coffee_active:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_coffee_active:GetModifierConstantHealthRegen (params)
    return self.hp
end

function modifier_item_coffee_active:GetModifierConstantManaRegen (params)
    return self.mana
end

function modifier_item_coffee_active:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            if target == self:GetParent() then
                return
            end
            if self:GetParent():HasModifier("modifier_item_coffee_active") then 
                self:Destroy()
            end
        end 
    end
end

function item_coffee:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

