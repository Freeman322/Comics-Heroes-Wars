iron_rearm = class({})

function iron_rearm:GetConceptRecipientType()
    return DOTA_SPEECH_USER_ALL
end

function iron_rearm:SpeakTrigger()
    return DOTA_ABILITY_SPEAK_CAST
end

function iron_rearm:IsStealable()
    return false
end

function iron_rearm:GetManaCost(iLevel)
    return self.BaseClass.GetManaCost( self, iLevel )
end

function iron_rearm:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end


function iron_rearm:OnSpellStart()
    local caster = self:GetCaster()
    local nFXIndex = ParticleManager:CreateParticle( "particles/refresh_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl( nFXIndex, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1))

    local sound = "DOTA_Item.SoulRing.Activate"

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "iron_devil") == true then 
		sound = "IronDevil.CastRearm"
    end
    
    caster:EmitSound(sound)

    self.cooldown_channel = self:GetSpecialValueFor( "channel_tooltip" )

    for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
        local current_ability = self:GetCaster ():GetAbilityByIndex (i)
        if current_ability ~= nil then
            if current_ability:GetMaxLevel() > 3 then
                current_ability:EndCooldown ()
            end
        end
    end
    for i=0, 5, 1 do
        local current_item = self:GetCaster ():GetItemInSlot(i)
        if current_item ~= nil then
            if current_item:GetName () == "item_blink" --[[or current_item:GetName () == "item_blink_2"]]  then
                current_item:EndCooldown()
            end
        end
    end
end

function iron_rearm:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

