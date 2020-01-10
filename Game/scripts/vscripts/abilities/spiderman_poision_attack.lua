LinkLuaModifier ("spiderman_adaptation_thinker",  "abilities/spiderman_poision_attack.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_spiderman_adaptation_buff",  "abilities/spiderman_poision_attack.lua", LUA_MODIFIER_MOTION_NONE)

if spiderman_poision_attack == nil then
    spiderman_poision_attack = class ( {})
end

function spiderman_poision_attack:OnSpellStart ()
    local hTarget = self:GetCaster()
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5 } )
    EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())

    local point = hTarget:GetAbsOrigin()
    local team_id = hTarget:GetTeamNumber ()
    local duration = self:GetSpecialValueFor ("web_duration")
    local thinker = CreateModifierThinker (hTarget, self, "spiderman_adaptation_thinker", {duration = duration }, point, team_id, false)

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "lee") then EmitSoundOn( "Lee.Cast3", self:GetCaster() ) end
    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
end

spiderman_adaptation_thinker = class ( {})

function spiderman_adaptation_thinker:OnCreated (event)
    if IsServer() then
        local thinker = self:GetParent ()
        local ability = self:GetAbility ()
        local point = self:GetCaster():GetCursorPosition ()
        self.team_number = thinker:GetTeamNumber ()
        self.radius = ability:GetSpecialValueFor ("radius")
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_web.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, point)
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(200, 0, 150))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function spiderman_adaptation_thinker:IsAura ()
    return true
end

function spiderman_adaptation_thinker:GetAuraRadius ()
    return 200
end

function spiderman_adaptation_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function spiderman_adaptation_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_HERO
end

function spiderman_adaptation_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function spiderman_adaptation_thinker:GetModifierAura ()
    return "modifier_spiderman_adaptation_buff"
end

modifier_spiderman_adaptation_buff = class ( {})

function modifier_spiderman_adaptation_buff:IsBuff ()
    return false
end

function modifier_spiderman_adaptation_buff:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_spiderman_adaptation_buff:GetModifierMoveSpeedBonus_Percentage ()
    local ability = self:GetAbility ()
    return ability:GetSpecialValueFor("web_slowing")
end

function modifier_spiderman_adaptation_buff:OnCreated(params)
    if IsServer() then 
         self:StartIntervalThink(1) self:OnIntervalThink()
    end 
end

function modifier_spiderman_adaptation_buff:OnIntervalThink()
    if IsServer() then 
        local flDamage = self:GetAbility():GetSpecialValueFor("web_damage")
        if self:GetCaster():HasTalent("special_bonus_unique_spiderman_2") then flDamage = flDamage + self:GetCaster():FindTalentValue("special_bonus_unique_spiderman_2") end

        local damage = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = flDamage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility()
        } 
        
        ApplyDamage( damage )
    end 
end

function spiderman_poision_attack:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

