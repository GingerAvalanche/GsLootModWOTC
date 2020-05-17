class X2EventListener_GsLootWOTC extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplate_OnOverrideNumUpgradeSlots());
	Templates.AddItem(CreateListenerTemplate_OnItemUpgraded());
	Templates.AddItem(CreateListenerTemplate_OnBlackMarketBuyPricesUpdated());
	Templates.AddItem(CreateListenerTemplate_OnBlackMarketItemCardPopulated());
	Templates.AddItem(CreateListenerTemplate_OnBlackMarketGoodsSold());

	return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnOverrideNumUpgradeSlots()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GsLootOverrideNumUpgradeSlots');

	Template.RegisterInTactical = False;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OverrideNumUpgradeSlots', OnOverrideNumUpgradeSlots, ELD_Immediate);
	`log("Register Event OverrideNumUpgradeSlots", X2DownloadableContentInfo_GsLootModWOTC.default.bEnableLogs, 'GsLootModWOTC');
}

static function EventListenerReturn OnOverrideNumUpgradeSlots(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Item ItemState;
	local XComGameState_GLootStore LootStoreState;
	local int ItemID, NumUpgradeSlots;

	Tuple = XComLWTuple(EventData);
	ItemState = XComGameState_Item(EventSource);
	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();
	ItemID = ItemState.ObjectID;

	if ( LootStoreState.DoesObjectIDHaveEntry(ItemID) )
	{
		NumUpgradeSlots = LootStoreState.GetNumUpgradeSlotsByOwnerID(ItemID)
		if (Tuple.Data[0].i < NumUpgradeSlots)
		}
			Tuple.Data[0].i = NumUpgradeSlots;
		}
	}

	return ELR_NoInterrupt;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnItemUpgraded()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GsLootItemUpgraded');

	Template.RegisterInTactical = False;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('ItemUpgraded', OnItemUpgraded, ELD_Immediate);
	`log("Register Event ItemUpgraded", X2DownloadableContentInfo_GsLootModWOTC.default.bEnableLogs, 'GsLootModWOTC');
}

static function EventListenerReturn OnItemUpgraded(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Item NewItemState, OldItemState;
	local XComGameState_GLootStore LootStoreState;

	if (EventSource == none)
		return ELR_NoInterrupt;

	NewItemState = XComGameState_Item(EventData);
	OldItemState = XComGameState_Item(EventSource);
	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();

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

static function CHEventListenerTemplate CreateListenerTemplate_OnBlackMarketBuyPricesUpdated()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GsLootBlackMarketBuyPricesUpdated');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('BlackMarketBuyPricesUpdated', OnBlackMarketBuyPricesUpdated, ELD_Immediate);
	`log("Register Event BlackMarketBuyPricesUpdated", X2DownloadableContentInfo_GsLootModWOTC.default.bEnableLogs, 'GsLootModWOTC');
}

static function EventListenerReturn OnBlackMarketBuyPricesUpdated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple					Tuple;
	local XComGameState_GLootStore		LootStoreState;
	local array<int>					StoreIDs;
	local int							idx, ObjectID;

	Tuple = XComLWTuple(EventData);
	BlackMarketState = XComGameState_BlackMarket(EventData);
	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();
	StoreIDs = LootStoreState.GetAllStoreOwnerIDs();

	for (idx = 0; idx < Tuple.Data[0].ai.Length; ++idx)
	{
		ObjectID = Tuple.Data[0].ai[idx];
		if (StoreIDs.Find(ObjectID) != INDEX_NONE)
		{
			StoreIDs.RemoveItem(ObjectID);
			Tuple.Data[1].ai[idx] = LootStoreState.GetTradingPostValueByOwnerId(ObjectID);
		}
	}

	foreach StoreIDs(ObjectID)
	{
		Tuple.Data[0].ai.AddItem(ObjectID);
		Tuple.Data[1].ai.AddItem(LootStoreState.GetTradingPostValueByOwnerId(ObjectID));
	}

	return ELR_NoInterrupt;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnBlackMarketItemCardPopulated()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GsLootBlackMarketItemCardPopulated');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('BlackMarketItemCardPopulated', OnBlackMarketItemCardPopulated, ELD_Immediate);
	`log("Register Event BlackMarketItemCardPopulated", X2DownloadableContentInfo_GsLootModWOTC.default.bEnableLogs, 'GsLootModWOTC');
}

static function EventListenerReturn OnBlackMarketItemCardPopulated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple						Tuple;
	local X2EquipmentTemplate				EquipmentTemplate;
	local XComGameState_Item				ItemState;
	local array<X2WeaponUpgradeTemplate>	UpgradeList;
	local X2WeaponUpgradeTemplate			Upgrade;
	local string							strSummary;

	Tuple = XComLWTuple(EventData);
	EquipmentTemplate = X2EquipmentTemplate(Tuple.Data[2].o);
	ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Tuple.Data[1].i));
	UpgradeList = ItemState.GetMyWeaponUpgradeTemplates();

	if (EquipmentTemplate.InventorySlot == eInvSlot_PrimaryWeapon)
	{
		Tuple.Data[0].as[0] = class'X2Utilities_GsLoot'.default.ITEM_IMAGES.Find('TemplateName', EquipmentTemplate.DataName).strImage;
	}
	
	if (ItemState.Nickname != "")
	{
		Tuple.Data[0].as[1] = ItemState.Nickname;
	}

	if (UpgradeList.Length > 0)
	{
		strSummary = Tuple.Data[0].as[5] $ "\n";

		foreach UpgradeList(Upgrade)
		{
			strSummary = strSummary $ UpgradeTemplate.GetItemFriendlyName() $ "\n";
			strSummary = strSummary $ UpgradeTemplate.GetItemBriefSummary() $ "\n";
		}

		Tuple.Data[0].as[5] = strSummary;
	}

	return ELR_NoInterrupt;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnBlackMarketGoodsSold()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GsLootBlackMarketGoodsSold');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('BlackMarketGoodsSold', OnBlackMarketGoodsSold, ELD_Immediate);
	`log("Register Event BlackMarketGoodsSold", X2DownloadableContentInfo_GsLootModWOTC.default.bEnableLogs, 'GsLootModWOTC');
}

static function EventListenerReturn OnBlackMarketGoodsSold(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState						PreviousGameState;
	local XComGameState_HeadquartersXCom	PreviousXComHQ, XComHQ;
	local XComGameState_GLootStore			LootStoreState;
	local StateObjectReference				InventoryRef;

	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();
	PreviousGameState = `XCOMHISTORY.GetGameStateFromHistory();

	foreach PreviousGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', PreviousXComHQ)
	{
		break;
	}
	foreach GameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	foreach PreviousXComHQ.Inventory(InventoryRef)
	{
		if (XComHQ.Inventory.Find(InventoryRef) != INDEX_NONE)
		{
			LootStoreState.RemoveIDFromLootStore(InventoryRef.ObjectID);
		}
	}

	return ELR_NoInterrupt;
}