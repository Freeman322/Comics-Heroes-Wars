if not gorr_necrostrike then gorr_necrostrike = class({}) end
LinkLuaModifier( "modifier_gorr_necrostrike", "abilities/gorr_necrostrike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gorr_necrostrike_target", "abilities/gorr_necrostrike.lua", LUA_MODIFIER_MOTION_NONE )

function gorr_necrostrike:GetIntrinsicModifierName() return "modifier_gorr_necrostrike" end

modifier_gorr_necrostrike = class({})

modifier_gorr_necrostrike.m_hLastTarget = nil

function modifier_gorr_necrostrike:IsHidden() return true end
function modifier_gorr_necrostrike:IsPurgable() return false end
function modifier_gorr_necrostrike:RemoveOnDeath() return false end
function modifier_gorr_necrostrike:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_gorr_necrostrike:OnAttackLanded (params)
    if IsServer() then
        if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() and not params.attacker:IsSilenced() and not params.target:IsBuilding() then
            local hits = self:GetAbility():GetSpecialValueFor("hits")

            if self.m_hLastTarget ~= params.target then
                self.m_hLastTarget = params.target
                self:SetStackCount(1)
            end

            self:IncrementStackCount()

            if self:GetStackCount() > hits then
                self:SetStackCount(hits)
            end

            if params.target:IsHero() then
                params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gorr_necrostrike_target", {duration = self:GetAbility():GetSpecialValueFor("debuff_duration")})
            end

            ApplyDamage( {
                victim = params.target,
                attacker = self:GetCaster(),
                damage = self:GetAbility():GetSpecialValueFor("damage_per_hit") * self:GetStackCount(),
                damage_type = DAMAGE_TYPE_PHYSICAL,
                ability = self:GetAbility()
            })

            self:GetParent():Heal((params.damage * ((self:GetAbility():GetSpecialValueFor("lifesteal_per_hit") * self:GetStackCount()) / 100) ), self:GetAbility())

            local lifesteal_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
            ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(lifesteal_fx)

            EmitSoundOn("DOTA_Item.MKB.Minibash", params.target)
        end
    end
end


if not modifier_gorr_necrostrike_target then modifier_gorr_necrostrike_target = class({}) end
function modifier_gorr_necrostrike_target:IsHidden() return false end
function modifier_gorr_necrostrike_target:IsPurgable() return false end
function modifier_gorr_necrostrike_target:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_ambient_glow.vpcf" end
function modifier_gorr_necrostrike_target:GetEffectAttachType() return PATTACH_ABSORIGIN end

function modifier_gorr_necrostrike_target:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_gorr_necrostrike_target:GetModifierMoveSpeedBonus_Percentage()
    return -50
end