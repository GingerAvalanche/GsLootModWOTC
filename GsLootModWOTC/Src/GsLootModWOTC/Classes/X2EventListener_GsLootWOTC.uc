class X2EventListener_GsLootWOTC extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplate_OnOverrideNumUpgradeSlots());
	Templates.AddItem(CreateListenerTemplate_OnItemUpgraded());

	return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnOverrideNumUpgradeSlots()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GrimyLootOverrideNumUpgradeSlots');

	Template.RegisterInTactical = False;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OverrideNumUpgradeSlots', OnOverrideNumUpgradeSlots, ELD_Immediate);
	`log("Register Event OverrideNumUpgradeSlots", X2DownloadableContentInfo_GsLootModWOTC.default.bEnableLogs, 'X2GsLootModWOTC');
}

static function EventListenerReturn OnOverrideNumUpgradeSlots(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Item ItemState;
	local GrimyLoot_GameState_LootStore LootStoreState;
	local int ItemID;

	Tuple = XComLWTuple(EventData);
	ItemState = XComGameState_Item(EventSource);
	LootStoreState = class'GrimyLootUtilities'.static.GetLootStore();
	ItemID = ItemState.ObjectID;

	if ( LootStoreState.DoesObjectIDHaveEntry(ItemID) )
	{
		Tuple.Data[0] = LootStoreState.GetNumUpgradeSlotsByOwnerID(ItemID);
	}

	return ELR_NoInterrupt;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnItemUpgraded()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GrimyLootItemUpgraded');

	Template.RegisterInTactical = False;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('ItemUpgraded', OnItemUpgraded, ELD_Immediate);
	`log("Register Event ItemUpgraded", X2DownloadableContentInfo_GsLootModWOTC.default.bEnableLogs, 'X2GsLootModWOTC');
}

static function EventListenerReturn OnItemUpgraded(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Item NewItemState, OldItemState;
	local GrimyLoot_GameState_LootStore LootStoreState;

	if (EventSource == none)
		return ELR_NoInterrupt;

	NewItemState = XComGameState_Item(EventData);
	OldItemState = XComGameState_Item(EventSource);
	LootStoreState = class'GrimyLootUtilities'.static.GetLootStore();

	if (LootStoreState.DoesObjectIDHaveEntry(OldItemState.ObjectID))
	{
		// Loot Store Stuff
		NewLoot.IDOwner = NewItemState.ObjectID;
		NewLoot.NumUpgradeSlots = LootStoreState.GetNumUpgradeSlotsByOwnerID(OldItemState.ObjectID);
		NewLoot.TradingPostValue = LootStoreState.GetTradingPostValueByOwnerId(OldItemState.ObjectID);
		LootStoreState.AddToLootStore(NewLoot);
		LootStoreState.RemoveIDFromLootStore(OldItemState.ObjectID);
		
		// Other State Stuff
		NewItemState.WeaponAppearance = OldItemState.WeaponAppearance;
		NewItemState.Nickname = Repl(OldItemState.Nickname, OldItemState.GetMyTemplate().GetItemFriendlyNameNoStats(), NewItemState.GetMyTemplate().GetItemFriendlyNameNoStats(), false);
		
		WeaponUpgrades = OldItemState.GetMyWeaponUpgradeTemplates();
		foreach WeaponUpgrades(WeaponUpgradeTemplate)
		{
			NewItemState.ApplyWeaponUpgradeTemplate(WeaponUpgradeTemplate);
		}
	}

	return ELR_NoInterrupt;
}