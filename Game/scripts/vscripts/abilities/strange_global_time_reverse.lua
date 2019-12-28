LinkLuaModifier( "modifier_strange_global_time_reverse", "abilities/strange_global_time_reverse.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_strange_global_time_reverse_aura", "abilities/strange_global_time_reverse.lua", LUA_MODIFIER_MOTION_NONE )

strange_global_time_reverse = class({})

function strange_global_time_reverse:GetIntrinsicModifierName()
    return "modifier_strange_global_time_reverse_aura"
end

function strange_global_time_reverse:OnInventoryContentsChanged()
    self:SetHidden(not self:GetCaster():HasTimeStone())
    self:SetLevel(1)
end

function strange_global_time_reverse:OnSpellStart(  )
    if IsServer() then   
        EmitSoundOn("Strange.Global_time_reverse.Cast", self:GetCaster())

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD, 0, false )
        if units and #units > 0 then 
            for _, unit in pairs(units) do
                if unit:HasModifier("modifier_strange_global_time_reverse") then 
                    local modifier = unit:FindModifierByName("modifier_strange_global_time_reverse")
                    modifier:Return()
                end 
            end
        end 

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "cat") then
            EmitSoundOn( "Strange.CastReverse", self:GetCaster() )
        end
    end
end

if modifier_strange_global_time_reverse_aura == nil then modifier_strange_global_time_reverse_aura = class({}) end

function modifier_strange_global_time_reverse_aura:IsAura()
	return true
end

function modifier_strange_global_time_reverse_aura:IsHidden()
	return true
end

function modifier_strange_global_time_reverse_aura:IsPurgable()
	return false
end

function modifier_strange_global_time_reverse_aura:GetAuraRadius()
	return 99999
end

function modifier_strange_global_time_reverse_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_strange_global_time_reverse_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_strange_global_time_reverse_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD
end

function modifier_strange_global_time_reverse_aura:GetModifierAura()
	return "modifier_strange_global_time_reverse"
end

if modifier_strange_global_time_reverse == nil then modifier_strange_global_time_reverse = class({}) end

function modifier_strange_global_time_reverse:IsPurgable(  )
    return false
end

function modifier_strange_global_time_reverse:RemoveOnDeath()
    return false
end

function modifier_strange_global_time_reverse:IsHidden()
    return true
end

function modifier_strange_global_time_reverse:OnCreated(htable)
    if IsServer() then
        self._iDelay = self:GetAbility():GetSpecialValueFor("return_back")

        self._hParams 				= self._hParams 			or {}
        self._hParams[0] 			= self._hParams[0] 		    or {}
        self._hParams[0].pos 		= self._hParams[0].pos 	    or self:GetParent():GetAbsOrigin()
        self._hParams[0].health 	= self._hParams[0].health 	or self:GetParent():GetHealth()
        self._hParams[0].mana		= self._hParams[0].mana 	or self:GetParent():GetMana()

        self:StartIntervalThink(1)
	end
end

function modifier_strange_global_time_reverse:OnIntervalThink()
    if IsServer() then
        for i = 0, #self._hParams do
            if self._hParams[i + 1] then
                self._hParams[i] = self._hParams[i + 1]
            end
        end

        local need_time = #self._hParams + 1

        if need_time > self._iDelay then need_time = self._iDelay end

        self._hParams[need_time] 			= {}
        self._hParams[need_time].pos 		= self:GetParent():GetAbsOrigin()
        self._hParams[need_time].health 	= self:GetParent():GetHealth()
        self._hParams[need_time].mana 		= self:GetParent():GetMana()
    end 
end

function modifier_strange_global_time_reverse:Return()
    if IsServer() then 
        if self._hParams then 
            if not self:GetParent():IsAlive() then self:GetParent():RespawnUnit() end 
            if self._hParams[0].health == 0 then self._hParams[0].health = 1 end 

            self:GetParent():SetAbsOrigin(self._hParams[0].pos) 
            self:GetParent():SetHealth(self._hParams[0].health)
            self:GetParent():SetMana(self._hParams[0].mana)

            EmitSoundOn("Strange.Global_time_reverse.Unit", self:GetParent())
           
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
    end 
end
