LinkLuaModifier ("modifier_raiden_elecro_mine_thinker", "abilities/raiden_elecro_mine.lua", LUA_MODIFIER_MOTION_NONE)

raiden_elecro_mine = class({})

function raiden_elecro_mine:GetAOERadius() return self:GetSpecialValueFor("radius") end
function raiden_elecro_mine:GetBehavior () return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT end

function raiden_elecro_mine:OnSpellStart ()
    if IsServer() then
        local duration = self:GetSpecialValueFor("duration")
        
        self.m_hThinker = CreateModifierThinker (self:GetCaster(), self, "modifier_raiden_elecro_mine_thinker", {duration = duration }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
        
        GridNav:DestroyTreesAroundPoint (self:GetCursorPosition(), 500, false)
    end 
end

modifier_raiden_elecro_mine_thinker = class({})

function modifier_raiden_elecro_mine_thinker:OnCreated (event)
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
       
        EmitSoundOn("Hero_ArcWarden.SparkWraith.Cast", self:GetParent())

        self:StartIntervalThink(FrameTime()) --- ??? Optimizing critical context
    end
end

function modifier_raiden_elecro_mine_thinker:OnIntervalThink()
     if IsServer() then
        local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        if units ~= nil then
            if #units > 0 then
                for _, unit in pairs(units) do
                    unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
                    
                    EmitSoundOn("Hero_AbyssalUnderlord.Pit.TargetHero", unit)
                    EmitSoundOn("Hero_AbyssalUnderlord.Pit.Target", unit)
                    EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", unit)
                    
                    local iDamage = self:GetAbility():GetSpecialValueFor("spark_damage")
                   
                    if self:GetCaster():HasTalent("special_bonus_unique_raiden_2") then iDamage = iDamage + self:GetCaster():FindTalentValue("special_bonus_unique_raiden_2") end
                    
                    ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = unit, ability = self:GetAbility(), damage = iDamage, damage_type = DAMAGE_TYPE_MAGICAL})
                    
                    self:StartIntervalThink(-1)
                    self:Destroy()
                end
            end
        end
     end
end

function modifier_raiden_elecro_mine_thinker:CheckState() return {[MODIFIER_STATE_PROVIDES_VISION] = true} end
