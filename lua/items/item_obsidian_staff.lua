if item_obsidian_staff == nil then item_obsidian_staff = class({}) end
LinkLuaModifier( "modifier_item_obsidian_staff", "items/item_obsidian_staff.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_obsidian_staff", "items/item_obsidian_staff.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function item_obsidian_staff:GetIntrinsicModifierName()
	return "modifier_item_obsidian_staff"
end

function item_obsidian_staff:OnSpellStart()
  local hTarget = self:GetCursorTarget()
  local hCaster = self:GetCaster()
  self.units = self:GetSpecialValueFor("hex_max_targets")
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
            local target_teams = self:GetAbilityTargetTeam()
            local target_types = self:GetAbilityTargetType()
            local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
            local start_pos = hTarget:GetAbsOrigin(  )

            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            EmitSoundOn( "Hero_ArcWarden.Flux.Cast", self:GetCaster() )

            local unit_table = FindUnitsInRadius(hCaster:GetTeamNumber(), start_pos, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            for index, unit in pairs(unit_table) do
               unit.dest = ( start_pos - unit:GetAbsOrigin() ):Length2D()
            end

            table.sort(unit_table,
            function(i, j)
                if i.dest < j.dest then
                    return true
                else
                    return false
                end
            end)
            if IsServer() then
                for index, unit in pairs(unit_table) do
                    Timers:CreateTimer(index * 0.2, function()
                        self.units = self.units - 1
                        if self.units <= 0 then
                          return nil
                        end
                        EmitSoundOn( "DOTA_Item.Bloodthorn.Activate", unit )
                        local duration = self:GetSpecialValueFor ("hex_duration")
                  	    unit:AddNewModifier (self:GetCaster (), self, "modifier_obsidian_staff", { duration = duration } )

                        local next_unit = unit_table[index + 1]
                        if next_unit == nil then
                            next_unit = unit
                        end

                        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf", PATTACH_CUSTOMORIGIN, unit );
                        ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetOrigin(), true );
                        ParticleManager:SetParticleControlEnt( nFXIndex, 1, next_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", next_unit:GetOrigin(), true );
                        ParticleManager:ReleaseParticleIndex( nFXIndex );

                    end)
                    -- Damage an npc.
                    unit.dest = nil
                end
            end
        end
    end
end

if modifier_obsidian_staff == nil then modifier_obsidian_staff = class({}) end

function modifier_obsidian_staff:IsPurgable()
    return false
end


function modifier_obsidian_staff:GetStatusEffectName()
    return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end


function modifier_obsidian_staff:StatusEffectPriority()
    return 1
end


function modifier_obsidian_staff:GetEffectName()
    return "particles/world_shrine/dire_shrine_regen.vpcf"
end


function modifier_obsidian_staff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_obsidian_staff:OnCreated( kv )
    self.bonus_damage = 0
end

function modifier_obsidian_staff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE

    }

    return funcs
end

function modifier_obsidian_staff:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    }

    return state
end

function modifier_obsidian_staff:GetModifierIncomingDamage_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("hex_bonus_damage")
end

function modifier_obsidian_staff:OnTakeDamage( params )
	if self:GetParent() == params.unit then
		self.bonus_damage = self.bonus_damage + params.damage
	end
	return 0
end

function modifier_obsidian_staff:GetModifierMoveSpeedBonus_Percentage( params )
	return -500
end

function modifier_obsidian_staff:OnDestroy()
	if IsServer() then
		  local hTarget = self:GetParent()
		  EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)

      EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetAbility():GetCaster())
      EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetAbility():GetCaster())

      ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = hTarget, ability = self:GetAbility(), damage = self.bonus_damage*0.3, damage_type = DAMAGE_TYPE_MAGICAL})

  		local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
  		ParticleManager:SetParticleControl(pop_pfx, 0, hTarget:GetAbsOrigin())
  		ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
  		ParticleManager:ReleaseParticleIndex(pop_pfx)

    	self.bonus_damage = 0
	end
end

if modifier_item_obsidian_staff == nil then
    modifier_item_obsidian_staff = class ( {})
end

function modifier_item_obsidian_staff:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_obsidian_staff:IsPurgable()
    return false
end

function modifier_item_obsidian_staff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_item_obsidian_staff:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_obsidian_staff:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end
function modifier_item_obsidian_staff:GetModifierPercentageManaRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end
function modifier_item_obsidian_staff:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end
function modifier_item_obsidian_staff:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_obsidian_staff:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_obsidian_staff:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function item_obsidian_staff:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

