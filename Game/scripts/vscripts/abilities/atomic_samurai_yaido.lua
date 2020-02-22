atomic_samurai_yaido = class({})
LinkLuaModifier( "modifier_atomic_samurai_yaido", "abilities/atomic_samurai_yaido.lua",LUA_MODIFIER_MOTION_NONE )

function atomic_samurai_yaido:GetIntrinsicModifierName ()
     return "modifier_atomic_samurai_yaido"
end

modifier_atomic_samurai_yaido = class({})

function modifier_atomic_samurai_yaido:IsHidden () return true end
function modifier_atomic_samurai_yaido:IsPurgable()  return false end

function modifier_atomic_samurai_yaido:OnCreated( kv )
    if IsServer() then
        
    end
end

function modifier_atomic_samurai_yaido:OnRefresh(params)
    if IsServer() then
       
    end
end

function modifier_atomic_samurai_yaido:DeclareFunctions()
    local funcs = {
          MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
    }

    return funcs
end

function modifier_atomic_samurai_yaido:GetEffectName() return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff.vpcf" end
function modifier_atomic_samurai_yaido:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_atomic_samurai_yaido:GetModifierPhysical_ConstantBlock(params)
     if IsServer() then
          if params.target == self:GetParent() and params.damage_type	== DAMAGE_TYPE_PHYSICAL then
               local chance = self:GetAbility():GetSpecialValueFor("counter_attack_chance_pct")
               local chance_ranges = self:GetAbility():GetSpecialValueFor("range_block_chance_pct")

               local bonus = 0

               if self:GetParent():HasTalent("special_bonus_unique_atomic_samurai_3") then bonus = self:GetParent():FindTalentValue("special_bonus_unique_atomic_samurai_3") end
               
               chance = chance + bonus
               chance_ranges = chance_ranges + bonus

               if params.attacker then
                    if params.attacker:IsRangedAttacker() then
                         if RollPercentage(chance_ranges) then
                              return params.damage
                         end
                    else 
                         if RollPercentage(chance) then
                              self:GetParent():PerformAttack(params.attacker, true, true, true, true, false, false, true)
                              return params.damage
                         end
                    end
               end
          end
     end

     return 
end
