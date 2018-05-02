#include <stdio.h>  
#include <iostream>
#include <string>
using namespace std;

class CDOTA_Item_Dagon
{
    ///modifier_dagon_1 *modifier;
    double creationTime;
    private:
        std::string itemName;
        ////VTexture abilityTexture;
        int itemLevel;
    public:
        std::string GetAbilityTextureName();
        void OnSpellStart();
        void OnCreated();
        void Think(float deltaTime);   
};

