#include <stdio.h>  
#include <iostream>
#include <string>
#include "CDOTA_Item_Dagon.h"
using namespace std;

std::string CDOTA_Item_Dagon::GetAbilityTextureName()
{
    return this->itemName;
}

void CDOTA_Item_Dagon::OnSpellStart()
{
    /*CDOTA_Base_NPC *hTarget;
    hTarget = this->GetCursorTarget();
    if (hTarget != nullptr)
    {
        ApplyDamage(this->GetOwner(), hTarget, this->GetDamage(), 0, 0);
        Server::PlaySoundOn("Item.Dagon.Cast", this->GetOwner());
    }*/
}

void CDOTA_Item_Dagon::Think(float time)
{
    ///Server::Print(time);
}

void CDOTA_Item_Dagon::OnCreated()
{
    
}