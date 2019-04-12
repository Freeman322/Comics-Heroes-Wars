LinkLuaModifier( "modifier_flash_stampede", "abilities/flash_stampede.lua", LUA_MODIFIER_MOTION_NONE )

 flash_stampede = class({})

function flash_stampede:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_flash_stampede", { duration = duration }  )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Centaur.Stampede.Cast", self:GetCaster() )
end

modifier_flash_stampede = class({})

function modifier_flash_stampede:IsPurgable() return false end
function modifier_flash_stampede:GetStatusEffectName() return "particles/status_fx/status_effect_alacrity.vpcf" end
function modifier_flash_stampede:StatusEffectPriority()	return 1000 end

function modifier_flash_stampede:OnCreated( kv )
    self.htable = {}
  	if IsServer() then
  		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
  		self:AddParticle( nFXIndex, false, false, -1, false, true )
      self:StartIntervalThink(0.05)

      if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "flash_custom") == true then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_flash/flash_custom_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
      end
  	end
end

function modifier_flash_stampede:OnIntervalThink()
	 if IsServer() then
     local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false )
     if #units > 0 then
       for _,target in pairs(units) do
          if self.htable[target] then
              return
          end
          local dur = 1
          if target:IsHero() then
            dur = 3
          end
          self:SetDuration(self:GetRemainingTime() + dur, true)
          ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agility_damage"), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PHYSICAL})
          self.htable[target] = true
       end
     end
   end
end

function modifier_flash_stampede:OnDestroy()
	if self.htable then
    self.htable = nil
  end
end

function modifier_flash_stampede:DeclareFunctions()	return { MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE } end
function modifier_flash_stampede:GetModifierMoveSpeed_Absolute() return self:GetAbility():GetSpecialValueFor("speed") end
