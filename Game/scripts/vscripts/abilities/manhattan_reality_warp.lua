LinkLuaModifier("modifier_manhattan_reality_warp", "abilities/manhattan_reality_warp.lua", 0)

manhattan_reality_warp = ({IsStealable = function() return false end})

function manhattan_reality_warp:OnSpellStart()
    if IsServer() then
        local target = self:GetCursorTarget()
        
        if ( not target:TriggerSpellAbsorb (self) ) then
            target:AddNewModifier(self:GetCaster(), self, "modifier_manhattan_reality_warp", {duration = self:GetSpecialValueFor("duration")})
        end
    end
end

modifier_manhattan_reality_warp = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    IsDebuff = function() return true end,
    CheckState = function() return {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = false
    } end
})

if IsServer() then
    function modifier_manhattan_reality_warp:OnCreated()
        EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.Cast", self:GetParent())
        self:GetParent():AddNoDraw()

    end

    function modifier_manhattan_reality_warp:OnDestroy()
        EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.Cast", self:GetParent())

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "uganda") then
            EmitSoundOn("Uganda.CastUlti", self:GetParent())
        end

        self:GetParent():RemoveNoDraw()

        for abilities = 0, 15 do
            local ability = self:GetParent():GetAbilityByIndex(abilities)
            if ability then
                if ability:IsCooldownReady() == false then
                    ability:StartCooldown(ability:GetCooldownTimeRemaining() * self:GetAbility():GetSpecialValueFor("cooldown_multplier"))
                else
                    ability:StartCooldown(self:GetAbility():GetSpecialValueFor("bonus_cooldown"))
                end
            end
        end

        if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_manhattan_reality_warp") then
            for items = 0, 15 do
                local item = self:GetParent():GetItemInSlot(items)
                if item then
                    if item:IsCooldownReady() == false then
                        item:StartCooldown(item:GetCooldownTimeRemaining() * self:GetAbility():GetSpecialValueFor("cooldown_multplier"))
                    else
                        item:StartCooldown(self:GetAbility():GetSpecialValueFor("bonus_cooldown"))
                    end
                end
            end
        end

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)

        self:GetParent():SpendMana(self:GetParent():GetMaxMana() / 100 * self:GetAbility():GetSpecialValueFor("mana_spend_pct"), self:GetAbility())

        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self:GetCaster():GetMana() * self:GetAbility():GetSpecialValueFor("damage_per_mana") / 100,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility()
        })
    end
end
