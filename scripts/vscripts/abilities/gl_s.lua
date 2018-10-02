gl_s = class({})
LinkLuaModifier( "modifier_gl_s", "abilities/gl_s.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gl_s:OnSpellStart()
	print("logging")
	local duration = self:GetSpecialValueFor(  "duration" )

  self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_gl_s", { duration = duration } )

  EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", self:GetCaster() )
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

if modifier_gl_s == nil then modifier_gl_s = class({}) end

function modifier_gl_s:IsHidden()
    return true
end

function modifier_gl_s:IsPurgable()
    return true
end

function modifier_gl_s:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end
function modifier_gl_s:OnCreated(params)
    if IsServer() then
        self.damage = self:GetParent():GetMana()*(self:GetAbility():GetSpecialValueFor("mana_to_damage")/100)
        if self.damage < 50 or not self.damage then
          self:Destroy()
        end
				local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 6, Vector(0, 0, 0) )
				ParticleManager:SetParticleControlEnt( nFXIndex, 7, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
				self:AddParticle( nFXIndex, false, false, -1, false, true )

				EmitSoundOn("Hero_Medusa.ManaShield.On", self:GetParent())
    end
end

function modifier_gl_s:OnDestroy()
    if IsServer() then
				EmitSoundOn("Hero_Medusa.ManaShield.Off", self:GetParent())
    end
end


function modifier_gl_s:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
					for k,v in pairs(params) do
						print(k,v)
					end
            if self.damage then
                self.damage = self.damage - params.damage
                self:GetParent():Heal(params.damage, self:GetAbility())
                if self.damage <= 0 then
                  self:Destroy()
                end
            end
        end
    end
end

function gl_s:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

