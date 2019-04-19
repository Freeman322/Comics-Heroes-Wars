if garou_monster_form == nil then garou_monster_form = class({}) end

LinkLuaModifier("modifier_garou_monster_form", "abilities/garou_monster_form.lua", LUA_MODIFIER_MOTION_NONE)

---fields:

garou_monster_form.m_iMaxDamage = 0
garou_monster_form.m_flCurrentDamage = 0
garou_monster_form.m_dSpeedSizeModCoff = 0.2 

local CONST_DEF_SIZE = 50
----

function garou_monster_form:OnSpellStart()
    if IsServer() then 
        local duration = self:GetSpecialValueFor(  "duration" )

        if self:GetCaster():HasTalent("special_bonus_unique_garou_1") then duration = self:GetCaster():FindTalentValue("special_bonus_unique_garou_1") + duration end
        
        self.m_iMaxDamage = self:GetSpecialValueFor(  "max_damage" )
        self.m_flCurrentDamage = 0

        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_garou_monster_form", { duration = duration } )

        EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Cancel", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_6 );
    end
end

if modifier_garou_monster_form == nil then modifier_garou_monster_form = class({}) end

function modifier_garou_monster_form:RemoveOnDeath() return true end
function modifier_garou_monster_form:IsPurgable() return false end
function modifier_garou_monster_form:IsHidden() return true end

function modifier_garou_monster_form:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_garou_monster_form:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_garou_monster_form:OnCreated(table)
	if IsServer() then
		local caster = self:GetParent()
        
        
	end
end

function modifier_garou_monster_form:OnDestroy()
	if IsServer() then
		
	end
end

function modifier_garou_monster_form:DeclareFunctions ()
	return {MODIFIER_PROPERTY_MODEL_SCALE, MODIFIER_PROPERTY_MODEL_CHANGE, MODIFIER_PROPERTY_MIN_HEALTH, MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
end

function modifier_garou_monster_form:GetModifierModelScale(params)
    return CONST_DEF_SIZE + ((self:GetAbility().m_flCurrentDamage / self:GetAbility().m_iMaxDamage) * 100)
end

function modifier_garou_monster_form:GetModifierModelChange(params)
    return ""
end

function modifier_garou_monster_form:OnTakeDamage( params )
    if self:GetParent () == params.unit then
        local RemovePositiveBuffs = false
        local RemoveDebuffs = true
        local BuffsCreatedThisFrameOnly = false
        local RemoveStuns = true
        local RemoveExceptions = true

        self:GetParent():Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
        
        self:GetAbility().m_flCurrentDamage = self:GetAbility().m_flCurrentDamage + params.original_damage

        self:SetStackCount(self:GetAbility().m_flCurrentDamage - self:GetAbility().m_iMaxDamage)

        if self:GetAbility().m_flCurrentDamage >= self:GetAbility().m_iMaxDamage then
            self:Destroy()
        end
    end
end

function modifier_garou_monster_form:GetMinHealth() return self:GetParent():GetHealth() end

function modifier_garou_monster_form:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_garou_monster_form:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_garou_monster_form:StatusEffectPriority() return 1000 end
function modifier_garou_monster_form:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
function modifier_garou_monster_form:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_garou_monster_form:GetModifierPreAttack_BonusDamage( params ) return self:GetStackCount() end
