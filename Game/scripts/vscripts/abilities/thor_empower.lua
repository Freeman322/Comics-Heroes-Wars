thor_empower = class({})
LinkLuaModifier( "modifier_thor_empower", "abilities/thor_empower.lua", LUA_MODIFIER_MOTION_NONE )

function thor_empower:GetIntrinsicModifierName()
	return "modifier_thor_empower"
end

if modifier_thor_empower == nil then modifier_thor_empower = class({}) end

function modifier_thor_empower:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_thor_empower:IsHidden()
	return true
end

function modifier_thor_empower:IsPurgable()
	return false
end

function modifier_thor_empower:OnIntervalThink()
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor( "radius" ) 
        local chance = self:GetAbility():GetSpecialValueFor(  "trigger_chance" )
        local damage = self:GetAbility():GetSpecialValueFor(  "damage" )

        if self:GetCaster():HasTalent("special_bonus_unique_thor_3") then
            damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_thor_3")
        end

        if self:GetCaster():HasTalent("special_bonus_unique_thor_2") then
            chance = chance + self:GetCaster():FindTalentValue("special_bonus_unique_thor_2")
        end

        if self:GetCaster():IsAlive() == false then
            return 
        end

        if self:GetCaster():IsRealHero() == false then
            return 
        end

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
        if #units > 0 then
            for _,unit in pairs(units) do
               if self:GetAbility():IsCooldownReady() and RollPercentage(chance) then 
                    if not unit:IsMagicImmune() then 
                        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil );
                        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
                        ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true );
                        ParticleManager:ReleaseParticleIndex( nFXIndex );

                        EmitSoundOn( "Item.Maelstrom.Chain_Lightning", self:GetCaster() )
                        EmitSoundOn( "Item.Maelstrom.Chain_Lightning.Jump", unit )

                        ApplyDamage({victim = unit, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

                        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
                    end
               end
            end
        end
	end
end