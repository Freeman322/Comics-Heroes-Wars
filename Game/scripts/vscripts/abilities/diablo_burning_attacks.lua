LinkLuaModifier("modifier_diablo_burning_attacks",	"abilities/diablo_burning_attacks.lua", 0)
LinkLuaModifier("modifier_diablo_burning_target", "abilities/diablo_burning_attacks.lua", 0)

diablo_burning_attacks = class({GetIntrinsicModifierName = function() return "modifier_diablo_burning_attacks" end})
modifier_diablo_burning_attacks = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER} end
})

function modifier_diablo_burning_attacks:OnCreated() self.attack = false end
function modifier_diablo_burning_attacks:OnAttackLanded (params)
    if not IsServer () then return end
    if params.attacker == self:GetParent() and params.attacker:IsRealHero() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and (self:GetAbility():GetAutoCastState() or self.attack) and not (params.target:IsMagicImmune() or params.target:IsAncient() or params.target:IsBuilding()) then
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_diablo_burning_target", {duration = self:GetAbility():GetSpecialValueFor("burn_duration")})
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_diablo_1") or 0)})

        self:GetAbility():UseResources(true, false, true)

        if Util:PlayerEquipedItem(self:GetParent():GetPlayerOwnerID(), "freeza") == true then 
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_blur_crit.vpcf", PATTACH_CUSTOMORIGIN, params.attacker );
            ParticleManager:SetParticleControl( nFXIndex, 0, params.target:GetOrigin());
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            EmitSoundOn("Freeza.Cast2", params.target)
        end 
        
        EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)
        EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", params.target)
        EmitSoundOn("Hero_DoomBringer.InfernalBlade.Target", params.target)
        self.attack = false
    end
end

function modifier_diablo_burning_attacks:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.attack = true
        else
            self.attack = false
        end
    end
end
modifier_diablo_burning_target = class({
    IsPurgable = function() return true end,
    GetEffectName = function() return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_diablo_burning_target:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.1)
    self:OnIntervalThink()
end

function modifier_diablo_burning_target:OnIntervalThink()
    if not IsServer() then return end
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        ability = self:GetAbility(),
        damage = (self:GetAbility():GetSpecialValueFor("burn_damage") + 0.01 * self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("burn_damage_pct") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_diablo") or 0))) / 10,
        damage_type = self:GetAbility():GetAbilityDamageType()
    })
end
