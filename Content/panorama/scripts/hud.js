ABILITY_SOUL = 0;
ABILITY_MIND = 1;
ABILITY_SPACE = 2;
ABILITY_REALITY = 3;
ABILITY_TIME = 4;
ABILITY_POWER = 5;
ABILITY_SNAP = 6;

function GauntletMenu()
{
    if (Entities.HasItemInInventory( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), "item_glove_of_the_creator" ))
    {
        if (GameUI.IsControlDown()) { $("#Hud").visible = true; }else{ $("#Hud").visible = false; }
    }


    $.Schedule( 0.05, GauntletMenu );
}

function OnGemSelected(ability)
{
    var data = {
        playerID: Game.GetLocalPlayerID(),
        hero: Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ),
        ability: ability
    }

    GameEvents.SendCustomGameEventToServer("on_gauntlet_ability_selected", data);
}

(function()
{
    $("#Hud").visible = false;
    GauntletMenu()
})();
