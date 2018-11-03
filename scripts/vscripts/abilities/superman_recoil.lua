if not superman_recoil then superman_recoil = class({}) end 
LinkLuaModifier ("modifier_superman_recoil", "abilities/superman_recoil.lua", LUA_MODIFIER_MOTION_NONE)

function superman_recoil:GetIntrinsicModifierName()
    return "modifier_superman_recoil"
end

if not modifier_superman_recoil then modifier_superman_recoil = class({}) end 

function modifier_superman_recoil:IsHidden() return true end 
function modifier_superman_recoil:IsPurgable() return false end 

function modifier_superman_recoil:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_superman_recoil:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker

            if target == self:GetParent() then
                return
            end
            
            local chance = self:GetAbility():GetSpecialValueFor("dodge_chance_pct")
            if self:GetParent():HasTalent("special_bonus_unique_superman_4") then chance = chance + self:GetParent():FindTalentValue("special_bonus_unique_superman_4") end 

            if RollPercentage(chance) then 
                if target:GetClassname() == "ent_dota_fountain" then return end 
                
                self:GetParent():Heal(params.damage, self:GetAbility())

                ApplyDamage ( {
                    victim = target,
                    attacker = self:GetParent(),
                    damage = params.damage,
                    damage_type = params.damage_type,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                })

                EmitSoundOn("DOTA_Item.BladeMail.Damage", target)
            end 
        end
    end
end