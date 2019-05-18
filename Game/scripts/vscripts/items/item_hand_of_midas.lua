item_hand_of_midas = class ( {})

--------------------------------------------------------------------------------
function item_hand_of_midas:GetIntrinsicModifierName ()
    return "modifier_item_hand_of_midas"
end

function item_hand_of_midas:CastFilterResultTarget (hTarget)
    if IsServer () then

        if hTarget ~= nil and hTarget:IsMagicImmune () and ( not self:GetCaster ():HasScepter () ) then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end

function item_hand_of_midas:GetAOERadius ()
    return 0
end

function item_hand_of_midas:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end
--------------------------------------------------------------------------------

function item_hand_of_midas:OnSpellStart ()
    local caster = self:GetCaster ()
    local target = self:GetCursorTarget ()
    local ability = self
    local BonusGold = self:GetSpecialValueFor ("bonus_gold")
    local XPMultiplier = self:GetSpecialValueFor ("xp_multiplier")

    caster:ModifyGold (BonusGold, true, 0)  --Give the player a flat amount of reliable gold.
    caster:AddExperience (target:GetDeathXP () * XPMultiplier, false, false)  --Give the player some XP.

    --Start the particle and sound.
    target:EmitSound ("DOTA_Item.Hand_Of_Midas")
    local midas_particle = ParticleManager:CreateParticle ("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt (midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin (), false)

    --Remove default gold/XP on the creep before killing it so the caster does not receive anything more.
    target:SetDeathXP (0)
    target:SetMinimumGoldBounty (0)
    target:SetMaximumGoldBounty (0)
    target:Kill (ability, caster) --Kill the creep.  This increments the caster's last hit counter.
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function item_hand_of_midas:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

