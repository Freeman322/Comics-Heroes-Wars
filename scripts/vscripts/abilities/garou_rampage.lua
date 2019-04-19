if garou_rampage == nil then garou_rampage = class({}) end 
LinkLuaModifier( "modifier_garou_rampage", "abilities/garou_rampage.lua", LUA_MODIFIER_MOTION_NONE )

function garou_rampage:OnSpellStart()
    local caster = self:GetCaster()
    local location = caster:GetAbsOrigin()

    --TODO sounds and particles

    local targets = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    
    for _, target in pairs(targets) do
        target:AddNewModifier(caster, self, "modifier_garou_rampage", {duration = self:GetSpecialValueFor("slowind_duration")})
 		ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbilityDamage(), damage_type = self:GetAbilityDamageType(), ability = self})
    end
end

function garou_rampage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

if modifier_garou_rampage == nil then modifier_garou_rampage = class ( {}) end

function modifier_garou_rampage:GetEffectName() return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf" end
function modifier_garou_rampage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_garou_rampage:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_garou_rampage:DeclareFunctions ()
     local funcs = {
       MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
     }

     return funcs
 end

function modifier_garou_rampage:GetDisableHealing(params) return 1 end
function modifier_garou_rampage:GetModifierMoveSpeedBonus_Percentage(params) return self:GetAbility():GetSpecialValueFor("slowing") end

function modifier_garou_rampage:CheckState()
	local state = {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true
	}

	return state
end
