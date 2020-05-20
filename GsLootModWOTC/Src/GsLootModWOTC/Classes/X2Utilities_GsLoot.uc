class X2Utilities_GsLoot extends Object
	dependson(GsLootDataStructures)
	config(GsLootModWOTC);

var config bool bLogUpgrades, bDropLockboxes, bDropUpgrades;
var config array<TemplateImage> ITEM_IMAGES;
var config float CHANCE_MOD_PER_EXISTING_UPGRADE;
var config int PRIMARY_UPGRADE_DROP_CHANCE;
var config int PISTOL_UPGRADE_DROP_CHANCE;
var config int SWORD_UPGRADE_DROP_CHANCE;
var config int GREMLIN_UPGRADE_DROP_CHANCE;
var config int BIT_UPGRADE_DROP_CHANCE;
var config int GRENADELAUNCHER_UPGRADE_DROP_CHANCE;
var config int PSIAMP_UPGRADE_DROP_CHANCE;
var config int ARMOR_UPGRADE_DROP_CHANCE;
var config int CHASSIS_UPGRADE_DROP_CHANCE;
var config int EARLY_LOCKBOX_CHANCE, MID_LOCKBOX_CHANCE, LATE_LOCKBOX_CHANCE;
var config LootTable EARLY_LOCKBOXES, MID_LOCKBOXES, LATE_LOCKBOXES;

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