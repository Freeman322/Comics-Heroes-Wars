LinkLuaModifier ("modifier_deadpool_omniverse", "abilities/deadpool_omniverse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_deadpool_omniverse_thinker", "abilities/deadpool_omniverse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_deadpool_omniverse_illusion", "abilities/deadpool_omniverse.lua", LUA_MODIFIER_MOTION_NONE)

deadpool_omniverse = class ({})

function deadpool_omniverse:GetCastRange(vLocation, hTarget) return self.BaseClass.GetCastRange (self, vLocation, hTarget) end
function deadpool_omniverse:GetAOERadius() return self:GetSpecialValueFor("radius") end
function deadpool_omniverse:GetCooldown (nLevel) return self.BaseClass.GetCooldown (self, nLevel) end
function deadpool_omniverse:GetManaCost (hTarget) return self.BaseClass.GetManaCost (self, hTarget) end
function deadpool_omniverse:GetBehavior() return DOTA_ABILITY_BEHAVIOR_AOE +  DOTA_ABILITY_BEHAVIOR_POINT end


function deadpool_omniverse:OnSpellStart ()
    if IsServer() then 
        local thinker = CreateModifierThinker (self:GetCaster(), self, "modifier_deadpool_omniverse_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
        AddFOWViewer (self:GetCaster():GetTeam (), self:GetCursorPosition(), 450, 4, false)
        GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), 500, false)
    end 
end

modifier_deadpool_omniverse_thinker = class ( {})

function modifier_deadpool_omniverse_thinker:OnCreated(event)
    if IsServer() then
        EmitSoundOn("Hero_Clinkz.BurningArmy.SpellStart", self:GetParent())
        EmitSoundOn("Hero_Clinkz.BurningArmy.Cast", self:GetParent())

        local nFXIndex = ParticleManager:CreateParticle ("particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_crimson_ti8_immortal_pitofmalice.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), 22, 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("duration"), 1, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function modifier_deadpool_omniverse_thinker:IsAura() return true end
function modifier_deadpool_omniverse_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_deadpool_omniverse_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_deadpool_omniverse_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_deadpool_omniverse_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_deadpool_omniverse_thinker:GetModifierAura() return "modifier_deadpool_omniverse" end


if modifier_deadpool_omniverse == nil then modifier_deadpool_omniverse = class({}) end

function modifier_deadpool_omniverse:IsHidden() return false end
function modifier_deadpool_omniverse:IsPurgable() return false end
function modifier_deadpool_omniverse:IsDebuff() return true end
function modifier_deadpool_omniverse:IsStunDebuff() return true end
function modifier_deadpool_omniverse:GetStatusEffectName() return "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_omni.vpcf" end
function modifier_deadpool_omniverse:StatusEffectPriority() return 1000 end
function modifier_deadpool_omniverse:GetEffectName() return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf" end
function modifier_deadpool_omniverse:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_deadpool_omniverse:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_deadpool_omniverse:GetModifierMoveSpeed_Absolute() return 150 end
function modifier_deadpool_omniverse:CheckState () return { [MODIFIER_STATE_SILENCED] = true } end
function modifier_deadpool_omniverse:OnCreated( kv ) if IsServer() then self:CreateIllusion(self:GetCaster(), self:GetParent():GetAbsOrigin()) end end
function modifier_deadpool_omniverse:CreateIllusion(caster, location )
	local ability = self:GetAbility()
	local modifyIllusion = function ( illusion )
        illusion:SetForwardVector( caster:GetForwardVector() )
        
		while illusion:GetLevel() < caster:GetLevel() do
			illusion:HeroLevelUp( false )
        end
        
        illusion:SetAbilityPoints( 0 )
        
		local abilityCount = caster:GetAbilityCount()
		for i=0,abilityCount-1 do
			local ability = caster:GetAbilityByIndex(i)
			if ability and illusion:GetAbilityByIndex(i) then
				illusion:GetAbilityByIndex(i):SetLevel( ability:GetLevel() )
			end
        end
        
        for item_id = 0, 5 do
            local item_in_caster = self:GetCaster():GetItemInSlot(item_id)
            if item_in_caster ~= nil and not item_in_caster:IsDroppableAfterDeath() then
                local item_name = item_in_caster:GetName()
                if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_ward_observer" or item_name == "item_ward_sentry") then
                    local item_created = CreateItem( item_in_caster:GetName(), double, double)
                    illusion:AddItem(item_created)
                end
            end
        end

		-- make illusion
		illusion:MakeIllusion()
		illusion:SetOwner( self:GetCaster() )
        illusion:SetPlayerID( self:GetCaster():GetPlayerID() )
        illusion:SetForceAttackTarget(self:GetParent())

        FindClearRandomPositionAroundUnit(illusion, self:GetParent(), 30)

		illusion:AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_illusion",
			{
				duration = self:GetAbility():GetSpecialValueFor("duration"),
				outgoing_damage = 100,
				incoming_damage = 0,
			}
        )
        
        illusion:AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_deadpool_omniverse_illusion",
			{
				duration = self:GetAbility():GetSpecialValueFor("duration"),
				outgoing_damage = 0,
				incoming_damage = 0,
			}
        )
        
        self.unit = illusion
	end

	-- Create unit
	CreateUnitByNameAsync(
		caster:GetUnitName(), 
		location, 
		false, 
		self:GetCaster(),
		nil, 
		self:GetCaster():GetTeamNumber(), 
		modifyIllusion
    )
end
function modifier_deadpool_omniverse:OnDestroy()
    if IsServer() then
        if self.unit then 
            pcall(function()
                UTIL_Remove(self.unit)
            end)
        end  
    end 
end
if not modifier_deadpool_omniverse_illusion then modifier_deadpool_omniverse_illusion = class({}) end 

function modifier_deadpool_omniverse_illusion:GetStatusEffectName() return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_wm16_dire.vpcf" end
function modifier_deadpool_omniverse_illusion:StatusEffectPriority() return 1000 end
function modifier_deadpool_omniverse_illusion:IsHidden() return true end
function modifier_deadpool_omniverse_illusion:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_CANNOT_MISS] = true
    }

    return state
end
function modifier_deadpool_omniverse_illusion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_deadpool_omniverse_illusion:GetModifierMoveSpeed_Absolute() return 550 end
function modifier_deadpool_omniverse_illusion:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_deadpool_omniverse_illusion:IsPurgable() return false end