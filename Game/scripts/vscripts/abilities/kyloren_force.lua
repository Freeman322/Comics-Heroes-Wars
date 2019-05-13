LinkLuaModifier ("modifier_kyloren_force", "abilities/kyloren_force.lua", LUA_MODIFIER_MOTION_NONE)

if kyloren_force == nil then kyloren_force = class({}) end

function kyloren_force:OnSpellStart()
    if IsServer() then
        local duration = self:GetSpecialValueFor("tooltip_duration")
        if self:GetCaster():HasTalent("special_bonus_unique_kyloren_4") then
            duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_kyloren_4") or 0)
        end

        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_kyloren_force", { duration = duration })

        EmitSoundOn("Kyloren.Force", self:GetCaster())
    end
end

if modifier_kyloren_force == nil then modifier_kyloren_force = class ( {}) end
function modifier_kyloren_force:IsHidden() return true end
function modifier_kyloren_force:IsPurgable() return false end

function modifier_kyloren_force:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_kyloren_force:OnCreated(params)
    if IsServer () then
        self._flDamage = 0

        self._iMult = self:GetAbility():GetSpecialValueFor("outgoing_damage_mult")
        if self:GetCaster():HasTalent("special_bonus_unique_kyloren_5") then
            self._iMult = self._iMult + (self:GetCaster():FindTalentValue("special_bonus_unique_kyloren_5") or 0)
        end
    end

    return 0
end


function modifier_kyloren_force:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent() then
            local hAbility = self:GetAbility()
            if not params.target:IsBuilding() then
                self._flDamage = self._flDamage + (params.damage * self:GetAbility():GetSpecialValueFor("outgoing_damage_mult"))

                ApplyDamage ( {
                    victim = params.target,
                    attacker = self:GetParent(),
                    damage = self._flDamage,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    ability = self:GetAbility(),
                    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_HPLOSS,
                })

                EmitSoundOn("Kyloren.Force_Attack", self:GetParent())
            end
        end
    end

    return 0
end
