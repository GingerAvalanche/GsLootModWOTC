class GrimyLootUtilities extends Object;

var config bool bLogUpgrades;

static function GrimyLoot_GameState_LootStore GetLootStore()
{
	return GrimyLoot_GameState_LootStore(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'GrimyLoot_GameState_LootStore', true));
}

static function CreateLootStore(out XComGameState NewGameState)
{
	local GrimyLoot_GameState_LootStore LootStoreState;

	LootStoreState = GrimyLoot_GameState_LootStore(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'GrimyLoot_GameState_LootStore', true));

	if ( LootStoreState.ObjectID == 0 )
	{
		LootStoreState = GrimyLoot_GameState_LootStore(NewGameState.CreateNewStateObject(class'GrimyLoot_GameState_LootStore'));
		NewGameState.AddStateObject(LootStoreState);
	}
}

static function AddExistingGameStatesToLootStore()
{
	local LootStruct LootStats;
	local GrimyLoot_GameState_LootStore LootStoreState;
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