LinkLuaModifier( "modifier_pennywise_macroverse_of_madness", "abilities/pennywise_macroverse_of_madness.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pennywise_macroverse_of_madness_caster", "abilities/pennywise_macroverse_of_madness.lua", LUA_MODIFIER_MOTION_NONE )

if pennywise_macroverse_of_madness == nil then pennywise_macroverse_of_madness = class({}) end 

function pennywise_macroverse_of_madness:IsStealable()
	return false
end

function pennywise_macroverse_of_madness:OnSpellStart()
	if IsServer() then 
        local duration = self:GetSpecialValueFor("duration")

        local unit = self:GetCursorTarget()

        if unit then
            local double = CreateUnitByName( unit:GetUnitName(), self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
            double:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

            local caster_level = unit:GetLevel()
            for i = 2, caster_level do
                double:HeroLevelUp(false)
            end


            for ability_id = 0, 15 do
                local ability = double:GetAbilityByIndex(ability_id)
                if ability then	
                    ability:SetLevel(unit:GetAbilityByIndex(ability_id):GetLevel())
                end
            end


            for item_id = 0, 5 do
                local item_in_caster = unit:GetItemInSlot(item_id)
                if item_in_caster ~= nil and not item_in_caster:IsDroppableAfterDeath() then
                    local item_name = item_in_caster:GetName()
                    if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_ward_observer" or item_name == "item_ward_sentry") then
                        local item_created = CreateItem( item_in_caster:GetName(), double, double)
                        double:AddItem(item_created)
                    end
                end
            end

            double:SetMaximumGoldBounty(0)
            double:SetMinimumGoldBounty(0)
            double:SetDeathXP(0)
            double:SetAbilityPoints(0)
            
            double:SetHealth(unit:GetHealth())
            double:SetMana(unit:GetMana())

            double:SetHasInventory(false)
            double:SetCanSellItems(false)

            double:AddNewModifier(self:GetCaster(), self, "modifier_pennywise_macroverse_of_madness", nil)
            double:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_tempest_double", nil)
            double:AddNewModifier(self:GetCaster(), self, "modifier_kill", {["duration"] = duration})

            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pennywise_macroverse_of_madness_caster", {["duration"] = duration, unit = double:entindex()})

            EmitSoundOn("Visage_Familar.StoneForm.Cast.Tolling", double)

            FindClearSpaceForUnit(double, double:GetAbsOrigin(), false)

            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() );
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(200, 200, 1));
            ParticleManager:ReleaseParticleIndex( nFXIndex );

            EmitSoundOn("Visage_Familar.StoneForm.Cast.Tolling", self:GetCaster())
        end
    end
end

modifier_pennywise_macroverse_of_madness = class({})

function modifier_pennywise_macroverse_of_madness:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_pennywise_macroverse_of_madness:IsHidden()
	return true
end

function modifier_pennywise_macroverse_of_madness:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_pennywise_macroverse_of_madness:GetModifierIncomingDamage_Percentage( params )
    return self:GetAbility():GetSpecialValueFor( "double_incoming_damage" )
end

function modifier_pennywise_macroverse_of_madness:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_pennywise_macroverse_of_madness:IsPurgable()
	return false
end

function modifier_pennywise_macroverse_of_madness:OnDestroy()
    if IsServer() then
        self:GetCaster():SetAbsOrigin(self:GetParent():GetAbsOrigin())
        self:GetCaster():FindModifierByName("modifier_pennywise_macroverse_of_madness_caster"):Destroy()
    end
end

function modifier_pennywise_macroverse_of_madness:OnCreated(table)
	if IsServer() then 
		local nFXIndex = ParticleManager:CreateParticle( "particles/dormammu/dormammu_tempest_double.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 7, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
end


if modifier_pennywise_macroverse_of_madness_caster == nil then modifier_pennywise_macroverse_of_madness_caster = class({}) end

function modifier_pennywise_macroverse_of_madness_caster:IsPurgable() return false end
function modifier_pennywise_macroverse_of_madness_caster:IsHidden() return false end

modifier_pennywise_macroverse_of_madness_caster.m_hUnit = nil

function modifier_pennywise_macroverse_of_madness_caster:OnCreated(params)
    if IsServer() then
        self.m_hUnit = EntIndexToHScript(params.unit)

        self:GetParent():AddEffects(EF_NODRAW)
    end
end


function modifier_pennywise_macroverse_of_madness_caster:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveEffects(EF_NODRAW)
    end
end

function modifier_pennywise_macroverse_of_madness_caster:CheckState()
	local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end