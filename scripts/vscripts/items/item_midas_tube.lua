item_midas_tube = class ( {})

function item_midas_tube:GetIntrinsicModifierName ()
    return "modifier_item_hand_of_midas"
end

function item_midas_tube:CastFilterResultTarget (hTarget)
    if IsServer () then
        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

function item_midas_tube:OnSpellStart ()
    local caster = self:GetCaster ()
    local target = self:GetCursorTarget ()

    local BonusGold = self:GetSpecialValueFor ("bonus_gold")
    local XPMultiplier = self:GetSpecialValueFor ("xp_multiplier")

    if not self.bonus then
      self.bonus = self:GetSpecialValueFor ("bonus_gold_per_cast")
    end
    self.bonus = self.bonus + self:GetSpecialValueFor ("bonus_gold_per_cast")

    caster:ModifyGold (BonusGold + self.bonus, true, 0)  --Give the player a flat amount of reliable gold.
    caster:AddExperience (target:GetDeathXP() * XPMultiplier, false, false)  --Give the player some XP.

    target:EmitSound ("DOTA_Item.Hand_Of_Midas")
    local midas_particle = ParticleManager:CreateParticle ("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt (midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin (), false)

    target:Kill(self, caster) --Kill the creep.  This increments the caster's last hit counter.
end

function item_midas_tube:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

