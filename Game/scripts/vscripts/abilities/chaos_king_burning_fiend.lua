if chaos_king_burning_fiend == nil then chaos_king_burning_fiend = class({}) end

LinkLuaModifier( "modifier_chaos_king_burning_fiend", "abilities/chaos_king_burning_fiend.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaos_king_burning_fiend_deny", "abilities/chaos_king_burning_fiend.lua", LUA_MODIFIER_MOTION_NONE )

function chaos_king_burning_fiend:IsRefreshable() return true end
function chaos_king_burning_fiend:IsStealable() return false end
 
local CONST_COOLDOWN_NOT_REDUC = 100

function chaos_king_burning_fiend:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel ) - (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_chaos_king") or 0)
end

function chaos_king_burning_fiend:OnSpellStart()
    local duration = self:GetSpecialValueFor(  "duration" )
    
    if self:GetCaster():HasTalent("special_bonus_unique_chaos_king_2") then duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_chaos_king_2") end

	local hTarget = self:GetCursorTarget()

    if hTarget then 
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_chaos_king_burning_fiend_deny", { duration = duration } )

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                if unit ~= hTarget then
                    unit:AddNewModifier( self:GetCaster(), self, "modifier_chaos_king_burning_fiend", { duration = duration, target = hTarget:entindex() } )
                end
            end
        end

        EmitSoundOn("Hero_Grimstroke.InkCreature.Returned", self:GetCaster())
        EmitSoundOn("Hero_Grimstroke.InkCreature.Death", self:GetCaster())
	end
end

if modifier_chaos_king_burning_fiend == nil then modifier_chaos_king_burning_fiend = class({}) end

modifier_chaos_king_burning_fiend.m_hTarget = nil

function modifier_chaos_king_burning_fiend:IsPurgable() return false end
function modifier_chaos_king_burning_fiend:IsHidden() return true end
function modifier_chaos_king_burning_fiend:IsPurgable() return false end
function modifier_chaos_king_burning_fiend:RemoveOnDeath() return true end
function modifier_chaos_king_burning_fiend:GetStatusEffectName() return "particles/status_fx/status_effect_ancestral_spirit.vpcf" end
function modifier_chaos_king_burning_fiend:StatusEffectPriority() return 1000 end
function modifier_chaos_king_burning_fiend:GetHeroEffectName() return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf" end
function modifier_chaos_king_burning_fiend:HeroEffectPriority() return 100 end
function modifier_chaos_king_burning_fiend:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_armor_friend_ring.vpcf" end
function modifier_chaos_king_burning_fiend:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaos_king_burning_fiend:OnCreated(params)
    if IsServer() then
        self.m_hTarget = EntIndexToHScript(params.target)

        self:StartIntervalThink(1)
        self:OnIntervalThink()
  	end
end

function modifier_chaos_king_burning_fiend:OnIntervalThink()
    if IsServer() then
        if not self.m_hTarget or self.m_hTarget:IsNull() or not self.m_hTarget:IsAlive() then
            self:Destroy() return
        end 

        local order_caster =
        {
            UnitIndex = self:GetParent():entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = self.m_hTarget:entindex()
        }

        ExecuteOrderFromTable(order_caster)

        self:GetParent():SetForceAttackTarget(self.m_hTarget)
  	end
end


function modifier_chaos_king_burning_fiend:OnDestroy()
    if IsServer() then
        self:GetParent():Stop()
        self:GetParent():Interrupt()
        
        self:GetParent():SetForceAttackTarget(nil)

    	EmitSoundOn("Hero_Grimstroke.InkSwell.Cast", self:GetParent())
  	end
end

function modifier_chaos_king_burning_fiend:CheckState()
	local state = {
        [MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
        [MODIFIER_STATE_PROVIDES_VISION] = true
	}

	return state
end

modifier_chaos_king_burning_fiend_deny = class({})

function modifier_chaos_king_burning_fiend_deny:IsPurgable() return false end
function modifier_chaos_king_burning_fiend_deny:IsHidden() return true end
function modifier_chaos_king_burning_fiend_deny:IsPurgable() return false end
function modifier_chaos_king_burning_fiend_deny:RemoveOnDeath() return false end


function modifier_chaos_king_burning_fiend_deny:CheckState()
	local state = {
        [MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
        [MODIFIER_STATE_PROVIDES_VISION] = true
	}

	return state
end
