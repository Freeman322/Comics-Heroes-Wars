function ShowDamageTooltip() 
{
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    var damage = (Entities.GetDamageMin( queryUnit ) + Entities.GetDamageMax( queryUnit )) / 2;
	var dmgbonus = Entities.GetDamageBonus( queryUnit );
	var dmgfull = damage + dmgbonus;
    this.element = $("#L_Damage")
    var text = $.Localize("#Damage: ")
    $.DispatchEvent("DOTAShowTextTooltip", this.element, text + dmgfull)
}
function HideDamageTooltip() 
{
    $.DispatchEvent("DOTAHideTextTooltip");
}

function ShowScrollTooltip() 
{
    this.element = $("#TownScroll")
    var text = $.Localize("#scroll")
    $.DispatchEvent("DOTAShowTextTooltip", this.element, text)
}
function HideScrollTooltip() 
{
    $.DispatchEvent("DOTAHideTextTooltip");
}