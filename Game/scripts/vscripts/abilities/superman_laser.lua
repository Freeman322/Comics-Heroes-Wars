LinkLuaModifier("modifier_superman_laser", "abilities/superman_laser.lua", 0)

superman_laser = class({GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_NO_TARGET end})
function superman_laser:OnInventoryContentsChanged() self:SetHidden(not self:GetCaster():HasScepter()) self:SetLevel(1) end
function superman_laser:OnSpellStart() if IsServer() then self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_superman_laser", {duration = self:GetSpecialValueFor("duration")}) end end

modifier_superman_laser = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND, MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS, MODIFIER_EVENT_ON_ATTACK, MODIFIER_EVENT_ON_ATTACK_START} end,
    GetModifierAttackRangeBonus = function() return 472 end,
    GetModifierProjectileSpeedBonus = function() return 3000 end,
    CheckState = function() return {[MODIFIER_STATE_FLYING] = true} end

})

function modifier_superman_laser:OnCreated() if IsServer() then self:GetParent():SetMoveCapability(2) self:StartIntervalThink(FrameTime()) self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK) end end
function modifier_superman_laser:OnDestroy() if IsServer() then self:GetParent():SetMoveCapability(1) self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK) self:GetParent():RemoveGesture(ACT_DOTA_RUN_ALT)end end
function modifier_superman_laser:OnIntervalThink() self:GetParent():StartGesture(ACT_DOTA_SWIM) end

function modifier_superman_laser:OnAttackStart(params)
    if params.attacker == self:GetParent() then
        self:GetParent():RemoveGesture(ACT_DOTA_ATTACK)
        self:GetParent():RemoveGesture(ACT_DOTA_ATTACK2)
        self:GetParent():RemoveGesture(ACT_DOTA_IDLE)
        self:GetParent():RemoveGesture(ACT_DOTA_IDLE_RARE)
    end
end

function modifier_superman_laser:OnAttack(params)
    if params.attacker == self:GetParent() then
        local particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_CUSTOMORIGIN, params.attacker)
        ParticleManager:SetParticleControlEnt(particle , 0, params.attacker, PATTACH_POINT, "attach_head", params.attacker:GetOrigin(), true)
        ParticleManager:SetParticleControl(particle, 1 , params.target:GetAbsOrigin())
    end
end


function modifier_superman_laser:GetAttackSound( params ) return "Hero_Tinker.Laser" end
function modifier_superman_laser:GetModifierMoveSpeed_Absolute( params ) return 600 end
