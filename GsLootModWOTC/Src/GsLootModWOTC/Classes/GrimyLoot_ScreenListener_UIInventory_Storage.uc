class GrimyLoot_ScreenListener_UIInventory_Storage extends UIScreenListener;

var UIInventory_Storage MyScreen;
var UIButton Choice;
var bool bShowEncyclopedia;

var localized string kToggle, kCompletion;

event OnInit(UIScreen Screen)
{
	//`Log("GrimyLoot_ScreenListener_UIInventory_Storage.OnInit starting...");

	bShowEncyclopedia = true;

	MyScreen = UIInventory_Storage(Screen);
	
	Choice = MyScreen.Spawn(class'UIButton', MyScreen);
	Choice.bAnimateOnInit = false;
	Choice.SetResizeToText(false);
	Choice.InitButton('Choice', kToggle, ShowLootEncyclopedia);
	Choice.AnchorCenter();
	Choice.SetStyle(eUIButtonStyle_BUTTON_WHEN_MOUSE);
	Choice.SetFontSize(20);
	Choice.SetHeight(25);
	Choice.SetWidth(340);
	Choice.SetX(-190);
	Choice.SetY(-350);
	
	//`Log("GrimyLoot_ScreenListener_UIInventory_Storage.OnInit completing...");
}

event OnRemoved(UIScreen Screen) {
	//`Log("GrimyLoot_ScreenListener_UIInventory_Storage.OnRemoved starting...");

	Choice.Remove();
	Choice = none;
	MyScreen = none;
	
	//`Log("GrimyLoot_ScreenListener_UIInventory_Storage.OnRemoved completing...");
}

function ShowLootEncyclopedia(UIButton button) {
	local X2ItemTemplateManager				ItemManager;
	local array<X2WeaponUpgradeTemplate>	UpgradeTemplates;
	local X2WeaponUpgradeTemplate			UpgradeTemplate;
	local int								Found, Total;
	
	//`Log("GrimyLoot_ScreenListener_UIInventory_Storage.ShowLootEncyclopedia starting...");

	if ( MyScreen == none ) { return; }
	
	if ( bShowEncyclopedia ) {
		bShowEncyclopedia = false;
	
		MyScreen.List.ClearItems();
		MyScreen.PopulateItemCard();

		if( MyScreen.List.ItemCount == 0 && MyScreen.m_strEmptyListTitle  != "" )
		{
			MyScreen.TitleHeader.SetText(MyScreen.m_strTitle, MyScreen.m_strEmptyListTitle);
			MyScreen.SetCategory("");
		}

		ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		UpgradeTemplates = ItemManager.GetAllUpgradeTemplates();
		Found = 0;
		Total = UpgradeTemplates.length;
		
		foreach UpgradeTemplates(UpgradeTemplate) {
			if ( class'GrimyLoot_Screenlistener_MCM'.default.FoundUpgrades.Find(UpgradeTemplate.DataName) != INDEX_NONE ) {
				MyScreen.Spawn(class'UIInventory_ListItem', MyScreen.List.itemContainer).InitInventoryListItem(UpgradeTemplate, 0);
				Found++;
			}
		}

		Choice.SetText(default.kToggle $ Found $ " / " $ Total $ kCompletion);
	
		MyScreen.TitleHeader.SetText(MyScreen.m_strTitle, "");
		MyScreen.PopulateItemCard(UpgradeTemplates[0]);

		MyScreen.List.SetSelectedIndex(0, true);
	}
	else {
		bShowEncyclopedia = true;
		MyScreen.PopulateData();
		MyScreen.List.SetSelectedIndex(0, true);
	}
	
	//`Log("GrimyLoot_ScreenListener_UIInventory_Storage.ShowLootEncyclopedia completing...");
}

defaultproperties
{
	ScreenClass=class'UIInventory_Storage'
}