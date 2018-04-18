pudge_essence_shift = class({})
LinkLuaModifier( "modifier_essence_strike", "abilities/pudge_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pudge_essence_shift", "abilities/pudge_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pudge_essence_shift_dummy", "abilities/pudge_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )

function pudge_essence_shift:GetIntrinsicModifierName()
     return "modifier_pudge_essence_shift"
end

function pudge_essence_shift:GetCooldown( nLevel )
    if self:GetCaster():HasModifier("modifier_pudge_essence_shift_dummy") then
        return 0
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function pudge_essence_shift:OnSpellStart()
	local duration = 12

  self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_essence_strike", { duration = duration } )

  EmitSoundOn ("Item.CrimsonGuard.Cast", hTarget)

  local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_pudge/pudge_loadout.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster());
  ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin (), true);
  ParticleManager:SetParticleControl(nFXIndex, 1, self:GetCaster():GetOrigin ());
  ParticleManager:SetParticleControl(nFXIndex, 3, self:GetCaster():GetOrigin ());
  ParticleManager:SetParticleControl(nFXIndex, 4, self:GetCaster():GetOrigin ());
  ParticleManager:ReleaseParticleIndex (nFXIndex);
  local player_id = self:GetCaster():GetPlayerOwnerID()
	local htable = CustomNetTables:GetTableValue("rating", "rating_pre_game")
	if htable[tostring(player_id)] and htable[tostring(player_id)].premium == "1" then
    local nFXIndex = ParticleManager:CreateParticle ("particles/units/heroes/hero_pudge/pudge_loadout.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster());
    ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin (), true);
    ParticleManager:ReleaseParticleIndex (nFXIndex);
	end


  EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

  self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );

  if self:GetCaster():HasTalent("special_bonus_unique_pudge") and self:GetCaster():HasModifier("modifier_pudge_essence_shift_dummy") == false then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pudge_essence_shift_dummy", nil)
    self:EndCooldown()
  end
end

if modifier_essence_strike == nil then modifier_essence_strike = class({}) end

function modifier_essence_strike:IsHidden()
    return false
end

function modifier_essence_strike:IsPurgable()
    return false
end

function modifier_essence_strike:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_essence_strike:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hTarget = params.target
            ApplyDamage({attacker = self:GetCaster(), victim = hTarget, damage = self:GetAbility():GetSpecialValueFor("damage_bonus") + ((self:GetAbility():GetSpecialValueFor("damage")/100)*self:GetCaster():GetMaxHealth()), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PHYSICAL})
            EmitSoundOn("Hero_Spirit_Breaker.GreaterBash.Creep", hTarget)
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor("tick_interval") } )
            self:Destroy()
        end
    end
    return 0
end

if modifier_pudge_essence_shift == nil then modifier_pudge_essence_shift = class({}) end

function modifier_pudge_essence_shift:IsHidden()
    return false
end

function modifier_pudge_essence_shift:IsPurgable()
    return false
end

function modifier_pudge_essence_shift:OnCreated(htable)
   if IsServer() then
     self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval"))
   end
end

function modifier_pudge_essence_shift:OnIntervalThink()
   if IsServer() then
      self:GetParent():Purge(false, false, false, true, false)
   end
end


if modifier_pudge_essence_shift_dummy == nil then modifier_pudge_essence_shift_dummy = class({}) end

function modifier_pudge_essence_shift_dummy:IsHidden()
    return false
end

function modifier_pudge_essence_shift_dummy:IsPurgable()
    return false
end

function modifier_pudge_essence_shift_dummy:RemoveOnDeath()
    return false
end

function pudge_essence_shift:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

