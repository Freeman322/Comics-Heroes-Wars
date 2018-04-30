if ironfist_echo_punch == nil then ironfist_echo_punch = class({}) end 

function ironfist_echo_punch:OnSpellStart()
    local caster = self:GetCaster()
    local location = caster:GetAbsOrigin()
    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_iron_fist/ironfist_echo_punch.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl(nFXIndex, 0, location)
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0))
    
    EmitSoundOn( "Hero_EarthShaker.EchoSlam", caster )
    EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", caster )
    EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", caster )

    local damage = self:GetAbilityDamage()
    if self:GetCaster():HasTalent("special_bonus_unique_iron_fist") then 
        damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_iron_fist")
    end

    local targets = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for i = 1, #targets do
        local target = targets[i]
        target:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
 		ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
    end
    caster:Purge(false, true, false, true, true)
end

function ironfist_echo_punch:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

