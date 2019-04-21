item_greater_salve = class ( {})
LinkLuaModifier( "item_greater_salve_modifier", "items/item_greater_salve.lua", LUA_MODIFIER_MOTION_NONE )


function item_greater_salve:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local hTarget = self:GetCursorTarget()

    local duration = self:GetSpecialValueFor( "duration" )
    hTarget:AddNewModifier( self:GetCaster(), self, "item_greater_salve_modifier", {duration = duration} )
    EmitSoundOn( "DOTA_Item.HealingSalve.Activate", hTarget )
    local charge = self:GetCurrentCharges()
    if charge > 1 then
        self:SetCurrentCharges(charge - 1)
    else
        self:RemoveSelf()
    end
end
---------------------------------------------------------------------------------

if item_greater_salve_modifier == nil then
    item_greater_salve_modifier = class({})
end

--------------------------------------------------------------------------------

function item_greater_salve_modifier:IsAura()
    return false
end

function item_greater_salve_modifier:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti4/bottle_ti4.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin" , self:GetParent():GetOrigin(), true )

        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

--------------------------------------------------------------------------------

function item_greater_salve_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end
                                   
function item_greater_salve_modifier:GetModifierConstantHealthRegen( params )
    return 40
end

function item_greater_salve_modifier:GetModifierIncomingDamage_Percentage( params )
   return -20
end

function item_greater_salve_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end


function item_greater_salve:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

