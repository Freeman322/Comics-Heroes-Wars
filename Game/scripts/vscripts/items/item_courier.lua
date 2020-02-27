LinkLuaModifier ("modifier_courier_model", "modifiers/modifier_courier.lua", LUA_MODIFIER_MOTION_NONE)

if item_courier == nil then
    item_courier = class ( {})
end

function item_courier:OnSpellStart ()
    if IsServer() then 
        local m_model = "models/items/courier/mighty_chicken/mighty_chicken.vmdl"
        local m_model_flyuing = "models/items/courier/mighty_chicken/mighty_chicken_flying.vmdl"
        local material = "default"

        local unit = CreateUnitByName("npc_dota_courier", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetPlayerOwner(), self:GetCaster():GetTeamNumber())

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "golden_chiken_courier") == true then
            m_model = "models/courier/baby_rosh/babyroshan.vmdl"
            m_model_flyuing = "models/courier/baby_rosh/babyroshan_flying.vmdl"
            material = "2"

            unit:AddNewModifier(self:GetCaster(), nil, "modifier_courier_model", {model = m_model, model_flying = m_model_flyuing})

            unit:SetMaterialGroup(material)

            ParticleManager:CreateParticle( "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        elseif Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "cat_pat") == true then
            m_model = "models/heroes/hero_strange/doremon/doraemon.vmdl"
            m_model_flyuing = "models/heroes/hero_strange/doremon/doraemon.vmdl"

            unit:AddNewModifier(self:GetCaster(), nil, "modifier_courier_model", {model = m_model, model_flying = m_model_flyuing, speed = 1000})

            unit:SetModelScale(2)

            ParticleManager:CreateParticle( "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        elseif Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "golden_baby_roshan") == true then
            m_model = "models/courier/baby_rosh/babyroshan.vmdl"
            m_model_flyuing = "models/courier/baby_rosh/babyroshan_flying.vmdl"
            material = "1"

            unit:AddNewModifier(self:GetCaster(), nil, "modifier_courier_model", {model = m_model, model_flying = m_model_flyuing})

            unit:SetMaterialGroup(material)

            ParticleManager:CreateParticle( "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        elseif Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "onibi") == true then
            m_model = "models/items/courier/onibi_lvl_21/onibi_lvl_21.vmdl"
            m_model_flyuing = "models/items/courier/onibi_lvl_21/onibi_lvl_21_flying.vmdl"
            material = "0"

            unit:AddNewModifier(self:GetCaster(), nil, "modifier_courier_model", {model = m_model, model_flying = m_model_flyuing})

            unit:SetMaterialGroup(material)

            ParticleManager:CreateParticle( "particles/econ/courier/courier_onibi/courier_onibi_black_lvl21_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        end 


        FindClearSpaceForUnit(unit, self:GetCaster():GetAbsOrigin(), true)
        unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

        self:GetCaster():RemoveItem(self)
    end 
end
