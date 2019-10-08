dormammu_larceny_of_life = class ( {})
LinkLuaModifier( "modifier_lacrency_of_life", "abilities/dormammu_larceny_of_life.lua", LUA_MODIFIER_MOTION_NONE )

function dormammu_larceny_of_life:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return 35
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end

function dormammu_larceny_of_life:IsStealable ()
    return false

end

function dormammu_larceny_of_life:OnSpellStart ()

    local caster = self:GetCaster ()
    local spawn_location = caster:GetOrigin ()
    local duration = self:GetSpecialValueFor ("duration")
    local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster () )
    ParticleManager:SetParticleControl (nFXIndex, 0, Vector (0, 0, 0))
    ParticleManager:SetParticleControl (nFXIndex, 1, Vector (250, 250, 250))
    EmitSoundOn ("Hero_FacelessVoid.TimeDilation.Cast", self:GetCaster () )

    local double = CreateUnitByName (caster:GetUnitName (), spawn_location, true, caster, caster:GetOwner (), caster:GetTeamNumber ())
    double:SetControllableByPlayer (caster:GetPlayerID (), false)

    local caster_level = caster:GetLevel ()
    for i=2, caster_level do
        double:HeroLevelUp (false)
    end


    for ability_id=0, 15 do
        local ability = double:GetAbilityByIndex (ability_id)
        if ability then

            ability:SetLevel (caster:GetAbilityByIndex (ability_id):GetLevel ())
            if ability:GetName () == "dormammu_larceny_of_life" then
                ability:SetActivated (false)
            end
        end
    end


    for item_id=0, 5 do
        local item_in_caster = caster:GetItemInSlot (item_id)
        if item_in_caster ~= nil then
            local item_name = item_in_caster:GetName ()
            if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_ward_observer" or item_name == "item_ward_sentry" or item_name == "item_necronomicon_4" or item_name == "item_space_stone") then
                local item_created = CreateItem (item_in_caster:GetName (), double, double)
                double:AddItem (item_created)
                item_created:SetCurrentCharges (item_in_caster:GetCurrentCharges ())
            end
        end
    end

    double:SetMaximumGoldBounty (0)
    double:SetMinimumGoldBounty (0)
    double:SetDeathXP (0)
    double:SetAbilityPoints (0)

    double:SetHasInventory (false)
    double:SetCanSellItems (false)

    double:AddNewModifier (caster, self, "modifier_arc_warden_tempest_double", {["duration"] = duration })
    double:AddNewModifier (caster, self, "modifier_kill", {["duration"] = duration - 1})
    double:AddNewModifier(caster, self, "modifier_lacrency_of_life", {duration = duration})
end
modifier_lacrency_of_life = class({})

function modifier_lacrency_of_life:IsHidden(  )
    return true
end
function modifier_lacrency_of_life:IsPurgable(  )
    return false
end
function modifier_lacrency_of_life:OnDestroy(  )
    if IsServer() then
        --- UTIL_Remove( self:GetParent() )
    end
end

function dormammu_larceny_of_life:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

