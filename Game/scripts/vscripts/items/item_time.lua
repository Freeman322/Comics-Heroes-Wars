LinkLuaModifier( "item_time_gem", "items/item_time.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_time_gem_cooldown", "items/item_time.lua", LUA_MODIFIER_MOTION_NONE )

if item_time == nil then item_time = class({}) end

function item_time:GetIntrinsicModifierName()
	return "item_time_gem"
end

function item_time:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_heart_timegem") then return "custom/heart_timegem" end
	return self.BaseClass.GetAbilityTextureName(self)
end

function item_time:OnSpellStart ()
    if IsServer() then
        local sound = "DOTA_Item.Refresher.Activate"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "heart_timegem") then
            local nFXIndex = ParticleManager:CreateParticle ("particles/stygian/heart_timegem.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
            ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
            ParticleManager:ReleaseParticleIndex (nFXIndex);
            sound = "Heart_Timegem.Cast" 
        else
        
        local nFXIndex = ParticleManager:CreateParticle ("particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
        ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
        ParticleManager:ReleaseParticleIndex (nFXIndex);
        end

        EmitSoundOn (sound, self:GetCaster () )
        
        for i=0, 15, 1 do  
            local current_ability = self:GetCaster ():GetAbilityByIndex (i)
            if current_ability ~= nil then
                if current_ability:IsRefreshable() then 
                    current_ability:EndCooldown ()
                end
            end
        end

        for i=0, 5, 1 do
            local current_item = self:GetCaster ():GetItemInSlot (i)
            if current_item ~= nil and current_item:IsRefreshable() then
                if current_item ~= self and current_item:GetSharedCooldownName() ~= "refresher" then current_item:EndCooldown() end 
            end
        end
    end
end

item_time_gem = class({})

function item_time_gem:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
function item_time_gem:IsHidden() return true end

function item_time_gem:DeclareFunctions()
local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_EVASION_CONSTANT,
    MODIFIER_EVENT_ON_DEATH
}

return funcs
end

function item_time_gem:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_time_gem:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_time_gem:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_time_gem:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function item_time_gem:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end

function item_time_gem:GetModifierConstantManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end

function item_time_gem:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_armor" )
end

function item_time_gem:GetModifierEvasion_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_evasion")
end

function item_time_gem:OnTime(hAttacker, hVictim)
    if IsServer() then
        local sound = "Hero_Weaver.TimeLapse" 
        if self:GetCaster() == nil then
            return false
        end

        if self:GetCaster():PassivesDisabled() then
            return false
        end

        if self:GetCaster() ~= self:GetParent() then
            return false
        end

        if self:GetParent():HasModifier("modifier_item_time_gem_cooldown") then 
            return false
        end

        if hVictim ~= nil and hAttacker ~= nil and hVictim == self:GetCaster() and hAttacker:GetTeamNumber() ~= hVictim:GetTeamNumber() then
            self:GetParent():SetAbsOrigin( self.tStates[0].pos )
            self:GetParent():SetHealth( self.tStates[0].health )
            self:GetParent():SetMana( self.tStates[0].mana )

            if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "heart_timegem") then
                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/wisp/wisp_death_ti7_model_heart.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1))
                ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 6, self:GetParent():GetOrigin())
                ParticleManager:SetParticleControl( nFXIndex, 10,self:GetParent():GetOrigin())
                ParticleManager:ReleaseParticleIndex( nFXIndex )
            sound = "Heart_Timegem.Cast"
            else
            local nFXIndex = ParticleManager:CreateParticle( "particles/effects/time_lapse_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1))
            ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 6, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 10,self:GetParent():GetOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex )
            end

            EmitSoundOn( sound, self:GetParent() )

            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_time_gem_cooldown", {duration = self:GetAbility():GetSpecialValueFor("time_cooldown")})

            return true
        end
    end

    return false
end

function item_time_gem:OnIntervalThink()
    if IsServer() then 
       for i = 0, #self.tStates do
            if self.tStates[i + 1] then
                self.tStates[i] = self.tStates[i + 1]
            end
        end

        local need_time = #self.tStates + 1

        if need_time > 5 then need_time = 5 end

        self.tStates[need_time]           = {}
        self.tStates[need_time].pos       = self:GetParent():GetAbsOrigin()
        self.tStates[need_time].health    = self:GetParent():GetHealth()
        self.tStates[need_time].mana      = self:GetParent():GetMana()

        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_weaver_timelapse", {duration = 1})
    end
end

function item_time_gem:OnCreated(params)
    if IsServer() then 
        self.tStates              = self.tStates            or {}
        self.tStates[0]           = self.tStates[0]         or {}
        self.tStates[0].pos       = self.tStates[0].pos     or self:GetParent():GetAbsOrigin()
        self.tStates[0].health    = self.tStates[0].health  or self:GetParent():GetHealth()
        self.tStates[0].mana      = self.tStates[0].mana    or self:GetParent():GetMana()

        self:StartIntervalThink(1)
    end
end

modifier_item_time_gem_cooldown = ({})

function modifier_item_time_gem_cooldown:IsHidden() return false end
function modifier_item_time_gem_cooldown:IsPurgable() return false end
function modifier_item_time_gem_cooldown:RemoveOnDeath() return false end

function item_time:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_heart_timegem") then return "custom/heart_timegem" end
	return self.BaseClass.GetAbilityTextureName(self)
end