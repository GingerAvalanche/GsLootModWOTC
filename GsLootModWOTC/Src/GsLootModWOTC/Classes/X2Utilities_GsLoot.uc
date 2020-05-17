class X2Utilities_GsLoot extends Object config(GsLootModWOTC);

struct TemplateImage
{
	var name TemplateName;
	var string strImage;
};

var config bool bLogUpgrades;
var config array<TemplateImage> ITEM_IMAGES;

static function XComGameState_GLootStore GetLootStore()
{
	return XComGameState_GLootStore(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_GLootStore', true));
}

static function CreateLootStore(out XComGameState NewGameState)
{
	local XComGameState_GLootStore LootStoreState;

	LootStoreState = XComGameState_GLootStore(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_GLootStore', true));

	if ( LootStoreState.ObjectID == 0 )
	{
		LootStoreState = XComGameState_GLootStore(NewGameState.CreateNewStateObject(class'XComGameState_GLootStore'));
		NewGameState.AddStateObject(LootStoreState);
	}
}

static function AddExistingGameStatesToLootStore()
{
	local LootStruct LootStats;
	local XComGameState_GLootStore LootStoreState;
	local XComGameState_Item ItemState;

	LootStoreState = GetLootStore();

	if ( LootStoreState.ObjectID == 0 )
		return;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Item', ItemState, , true)
	{
	    if ( ItemState.GetMyWeaponUpgradeTemplateNames().Length > X2WeaponTemplate(ItemState.GetMyTemplate()).NumUpgradeSlots && !LootStoreState.DoesObjectIDHaveEntry(ItemState.ObjectID) )
		{
			LootStats.IDOwner = ItemState.ObjectID;
			LootStats.NumUpgradeSlots = ItemState.GetMyWeaponUpgradeTemplateNames().Length;
			switch ( LootStats.NumUpgradeSlots )
			{
				case 1:
				case 2:
					LootStats.TradingPostValue = class'GrimyLoot_Research'.static.GetRareEquipmentPrice();
					break;
				case 3:
					LootStats.TradingPostValue = class'GrimyLoot_Research'.static.GetEpicEquipmentPrice();
					break;
				case 4:
					LootStats.TradingPostValue = class'GrimyLoot_Research'.static.GetLegendaryEquipmentPrice();
			}
			LootStoreState.AddToLootStore(LootStats);
		}
	}

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Item', ItemState,,true)
	{
		if ( LootStoreState.DoesObjectIDHaveEntry(ItemState.ObjectID) )
			`Log("Found! Object ID:" @ ItemState.ObjectID $ ", NumUpgradeSlots:" @ LootStoreState.GetNumUpgradeSlotsByOwnerID(ItemState.ObjectID) $ ", TradingPostValue:" @ LootStoreState.GetTradingPostValueByOwnerID(ItemState.ObjectID));
	}
}