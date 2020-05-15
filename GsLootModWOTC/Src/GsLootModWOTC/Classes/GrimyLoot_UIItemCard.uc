class GrimyLoot_UIItemCard extends UIItemCard;

simulated function PopulateItemCard(optional X2ItemTemplate ItemTemplate, optional StateObjectReference ItemRef)
{
	local string strDesc, strRequirement, strTitle;
	local XComGameState_Item				ItemState;
	local array<X2WeaponUpgradeTemplate>	UpgradeTemplates;
	local X2WeaponUpgradeTemplate			Upgradetemplate;
	
	//`Log("GrimyLoot_UIItemCard.PopulateItemCard starting...");

	if( ItemTemplate == None )
	{
		Hide();
		return;
	}

	bWaitingForImageUpdate = false;

	strDesc = ""; //Description and requirements strings are reversed for item cards, desc appears at the very bottom of the card so not needed here
	strRequirement = class'UIUtilities_Text'.static.GetColoredText(ItemTemplate.GetItemBriefSummary(ItemRef.ObjectID), eUIState_Normal, 20);

	ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));
	if ( ItemState.Nickname != "" ) {
		strTitle = ItemState.Nickname;
	}
	else {
		strTitle = class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(ItemTemplate.GetItemFriendlyName()), eUIState_Header, 24);
	}

	strRequirement = strRequirement $ "\n";
	UpgradeTemplates = ItemState.GetMyWeaponUpgradeTemplates();
	foreach UpgradeTemplates(UpgradeTemplate) {
		strRequirement = strRequirement $ "\n";
		strRequirement = strRequirement $ UpgradeTemplate.GetItemFriendlyNameNoStats();
		strRequirement = strRequirement $ "\n" $ UpgradeTemplate.GetItemBriefSummary();
	}

	PopulateData(strTitle, strDesc, strRequirement, "");
	SetItemImages(ItemTemplate, ItemRef);
	
	//`Log("GrimyLoot_UIItemCard.PopulateItemCard completing...");
}