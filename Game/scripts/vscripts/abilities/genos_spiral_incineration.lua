-- первый ульт (руки вместе и бдыщь)

genos_spiral_incineration = class ({})


function genos_spiral_incineration:OnUpgrade()
    if self:GetCaster():HasAbility("genos_incineration_max") then
        self:GetCaster():RemoveAbility("genos_incineration_max")
    end
end

function genos_spiral_incineration:GetCastRange()
  return self:GetSpecialValueFor("cast_range")
end

function genos_spiral_incineration:GetManaCost(iLevel)
    return self:GetCaster():GetMaxMana() * 0.5
end

function genos_spiral_incineration:OnSpellStart()
    local point = self:GetCursorPosition()
    local caster = self:GetCaster()
    local width = self:GetSpecialValueFor("width")
    local startpoint = caster:GetAbsOrigin()
    local endpoint = startpoint + (point - startpoint):Normalized() * self:GetCastRange()
    local enemies = FindUnitsInLine(caster:GetTeam(), startpoint, endpoint, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE)
    for _,idiots in ipairs(enemies) do
        local info = {
            victim = idiots,
            attacker = caster,
            damage = self:GetSpecialValueFor("damage"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }
        ApplyDamage(info)
    end

    local pfx = ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, Vector(startpoint.x,startpoint.y,endpoint.z+70))
    ParticleManager:SetParticleControl(pfx, 1, Vector(endpoint.x,endpoint.y,endpoint.z+70))
    ParticleManager:SetParticleControl(pfx, 4, Vector(width))
    self:GetCaster():EmitSound("Hero_Phoenix.SunRay.Beam")

    Timers:CreateTimer(0.2, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
end
