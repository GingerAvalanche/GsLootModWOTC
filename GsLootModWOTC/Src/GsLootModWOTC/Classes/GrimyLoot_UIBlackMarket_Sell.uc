class GrimyLoot_UIBlackMarket_Sell extends UIBlackMarket_Sell;

simulated function PopulateData()
{
	local XComGameState NewGameState;
	local BlackMarketItemPrice Item;
	local XComGameState_Item InventoryItem;
	local array<BlackMarketItemPrice> Items;
	local XComGameState_BlackMarket BlackMarketState;
	local GrimyLoot_UIBlackMarket_SellItem ListItem;
	local BlackMarketItemPrice PrevItem;
			
	ListItem = GrimyLoot_UIBlackMarket_SellItem(List.GetSelectedItem());
	if(ListItem != None)
		PrevItem = ListItem.ItemPrice;

	// override behavior in child classes
	List.ClearItems();

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Black Market Price List");
	BlackMarketState = XComGameState_BlackMarket(`XCOMHISTORY.GetGameStateForObjectID(BlackMarketReference.ObjectID));

	// Update Black Markets prices if we need to
	BlackMarketState = XComGameState_BlackMarket(NewGameState.ModifyStateObject(class'XComGameState_BlackMarket', BlackMarketState.ObjectID));
	if(BlackMarketState.UpdateBuyPrices())
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		NewGameState.PurgeGameStateForObjectID(BlackMarketState.ObjectID);
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}

	//BlackMarketState = XComGameState_BlackMarket(`XCOMHISTORY.GetGameStateForObjectID(BlackMarketReference.ObjectID));
	//Items = BlackMarketState.BuyPrices;
	Items = GetBuyPrices();
	Items.Sort(SortByInterest);
	
	foreach Items(Item)
	{
		// Don't display if none in your inventory to sell
		InventoryItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Item.ItemRef.ObjectID));
		if( InventoryItem.Quantity > 0 )
		{
			Spawn(class'GrimyLoot_UIBlackMarket_SellItem', List.itemContainer).InitListItem(Item);
			if(Item == PrevItem)
				List.SetSelectedIndex(List.GetItemCount() - 1);
		}
	}

	if(List.ItemCount > 0)
	{
		ListItem = GrimyLoot_UIBlackMarket_SellItem(List.GetItem(0));
		PopulateItemCard(ListItem.ItemTemplate, ListItem.ItemRef, string(ListItem.Price));
		if(List.SelectedIndex < 0)
			List.SetSelectedIndex(0);
	}
	else
	{
		ClearItemCard();
	}
}

simulated function PopulateItemCard(X2ItemTemplate ItemTemplate, StateObjectReference ItemRef, optional string ItemPrice = "")
{
	local string strImage, strTitle, strInterest, strSummary;
	local XComGameState_Item				ItemState;
	local array<X2WeaponUpgradeTemplate>	UpgradeList;
	local X2WeaponUpgradeTemplate			UpgradeTemplate;
	local X2ItemTemplateManager				ItemTemplateManager;
	local X2SchematicTemplate				SchematicTemplate;

	if( ItemTemplate.strImage != "" )
		strImage = ItemTemplate.strImage;
	else
		strImage = "img:///UILibrary_StrategyImages.GeneMods.GeneMods_MimeticSkin"; //Temp cool image

	if ( X2EquipmentTemplate(ItemTemplate).InventorySlot != eInvSlot_PrimaryWeapon ) {
		strImage = ItemTemplate.strImage;
	}
	else if ( ItemTemplate.CreatorTemplateName != '' ) {
		ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		SchematicTemplate = X2SchematicTemplate(ItemTemplateManager.FindItemTemplate(ItemTemplate.CreatorTemplateName));
		strImage = SchematicTemplate.strImage;
	}
	else if ( ItemTemplate.DataName == 'AssaultRifle_CV' ) {
		strImage = "img:///GrimyLootConvWeapons.GrimyConvAssaultRifle";
	}
	else if ( ItemTemplate.DataName == 'Cannon_CV' ) {
		strImage = "img:///GrimyLootConvWeapons.GrimyConvCannon";
	}	
	else if ( ItemTemplate.DataName == 'Shotgun_CV' ) {
		strImage = "img:///GrimyLootConvWeapons.GrimyConvShotgun";
	}
	else if ( ItemTemplate.DataName == 'SniperRifle_CV' ) {
		strImage = "img:///GrimyLootConvWeapons.GrimyConvSniperRifle";
	}
	else if ( ItemTemplate.DataName == 'AlienHunterRifle_CV' ) {
		strImage = "img:///UILibrary_DLC2Images.ConvBoltCaster";
	}

	
	strInterest = IsInterested(ItemTemplate) ? m_strInterestedLabel : "";

	ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));
	UpgradeList = ItemState.GetMyWeaponUpgradeTemplates();
	
	if ( ItemState.Nickname == "" )
		strTitle = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(ItemTemplate.GetItemFriendlyName());
	else
		strTitle = ItemState.Nickname;
	
	
	if ( UpgradeList.length > 0 ) {
		strSummary =  "";
		foreach UpgradeList(UpgradeTemplate) {
			strSummary = strSummary $ UpgradeTemplate.GetItemFriendlyName() $ "\n";
			strSummary = strSummary $ UpgradeTemplate.GetItemBriefSummary() $ "\n";
		}
	}
	else {
		strSummary = ItemTemplate.GetItemBriefSummary(ItemRef.ObjectID);
	}

	MC.BeginFunctionOp("UpdateItemCard");
	MC.QueueString(strImage);
	MC.QueueString(strTitle);
	MC.QueueString(m_strCostLabel);
	MC.QueueString(ItemPrice);
	MC.QueueString(strInterest);
	MC.QueueString(""); // TODO: what warning string goes here? 
	MC.QueueString(strSummary);
	MC.EndOp(); 
}

function array<BlackMarketItemPrice> GetBuyPrices()
{
	local XComGameState_Item ItemState;
	local XComGameState_BlackMarket BlackMarketState;
	local array<XComGameState_Item> Interests;
	local array<BlackMarketItemPrice> BuyPrices;
	local BlackMarketItemPrice TempItemPrice;
	local int idx;
	local GrimyLoot_GameState_LootStore LootStoreState;

	BuyPrices.Length = 0;
	
	BlackMarketState = XComGameState_BlackMarket(`XCOMHISTORY.GetGameStateForObjectID(BlackMarketReference.ObjectID));
	Interests = BlackMarketState.GetInterests();
	for(idx = 0; idx < XComHQ.Inventory.Length; idx++)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(XComHQ.Inventory[idx].ObjectID));

		if(ItemState != none)
		{
			LootStoreState = class'GrimyLootUtilities'.static.GetLootStore();
			if(ItemState.GetMyTemplate().TradingPostValue > 0 && !ItemState.GetMyTemplate().StartingItem && 
			   !ItemState.GetMyTemplate().bInfiniteItem && !ItemState.IsNeededForGoldenPath())
			{
				TempItemPrice.ItemRef = ItemState.GetReference();
				if ( Interests.find(ItemState) == INDEX_NONE )
				{
					TempItemPrice.Price = ItemState.GetMyTemplate().TradingPostValue;
				}
				else
				{
					TempItemPrice.Price = ItemState.GetMyTemplate().TradingPostValue * BlackMarketState.default.InterestPriceMultiplier[`CAMPAIGNDIFFICULTYSETTING];
				}
				BuyPrices.AddItem(TempItemPrice);
			}
			else if ( LootStoreState.DoesObjectIDHaveEntry(ItemState.ObjectID) )
			{
				TempItemPrice.ItemRef = ItemState.GetReference();
				TempItemPrice.Price = LootStoreState.GetTradingPostValueByOwnerID(ItemState.ObjectID);
				BuyPrices.AddItem(TempItemPrice);
			}
		}
	}

	return BuyPrices;
}

function int SortByInterest(BlackMarketItemPrice BuyPriceA, BlackMarketItemPrice BuyPriceB)
{
	local XComGameState_BlackMarket BlackMarketState;
	local XComGameState_Item ItemA, ItemB;

	History = `XCOMHISTORY;
	BlackMarketState = XComGameState_BlackMarket(History.GetGameStateForObjectID(BlackMarketReference.ObjectID));
	ItemA = XComGameState_Item(History.GetGameStateForObjectID(BuyPriceA.ItemRef.ObjectID));
	ItemB = XComGameState_Item(History.GetGameStateForObjectID(BuyPriceB.ItemRef.ObjectID));
		
	if ( ItemB.GetMyWeaponUpgradeTemplates().length > 0 && ItemA.GetMyWeaponUpgradeTemplates().length == 0 ||
		(BlackMarketState.InterestTemplates.Find(ItemB.GetMyTemplateName()) != INDEX_NONE &&
		 BlackMarketState.InterestTemplates.Find(ItemA.GetMyTemplateName()) == INDEX_NONE) ) 
	{
		return -1;
	}
	
	return 0;
}

simulated function OnConfirmButtonClicked(UIButton Button)
{
	local int i;
	local XComGameState NewGameState;
	local XComGameState_BlackMarket BlackMarketState;
	local GrimyLoot_UIBlackMarket_SellItem UIItem;
	local bool bSold;

	if(ConfirmButton.isDisabled)
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClose);
		return;
	}

	BlackMarketState = XComGameState_BlackMarket(`XCOMHISTORY.GetGameStateForObjectID(BlackMarketReference.ObjectID));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trading Post Exchange");
	bSold = false;

	for(i = 0; i < List.itemCount; ++i)
	{
		UIItem = GrimyLoot_UIBlackMarket_SellItem(List.GetItem(i));
		
		if(UIItem.NumSelling > 0)
		{
			bSold = true;
			BlackMarketState = XComGameState_BlackMarket(NewGameState.GetGameStateForObjectID(BlackMarketReference.ObjectID));
			
			if(BlackMarketState == none)
			{
				BlackMarketState = XComGameState_BlackMarket(NewGameState.CreateStateObject(class'XComGameState_BlackMarket', BlackMarketReference.ObjectID));
				NewGameState.AddStateObject(BlackMarketState);
			}

			//changed the following line of code:
			//class'X2StrategyGameRulesetDataStructures'.static.TradingPostTransaction(NewGameState, BlackMarketState, UIItem.GetItem(), UIItem.Price, UIItem.NumSelling);
			TradingPostTransaction(NewGameState, BlackMarketState, UIItem.GetItem(), UIItem.Price, UIItem.NumSelling);
		}
	}

	if(bSold)
	{
		`XEVENTMGR.TriggerEvent('BlackMarketGoodsSold', , , NewGameState);
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("StrategyUI_Sell_Item");
	}

	if(NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	
	`HQPRES.m_kAvengerHUD.UpdateResources();

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	SaleAmount = 0;
	PopulateData();
	UpdateTotalValue();

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);
}

function TradingPostTransaction(XComGameState NewGameState, XComGameState_BlackMarket BlackMarketState, XComGameState_Item ItemState, int Price, optional int Quantity = 1)
{
	local XComGameState_HeadquartersXCom NewXComHQ;
	local int SupplyAmount;
	local bool bNeedToAddHQ;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', NewXComHQ)
	{
		break;
	}

	bNeedToAddHQ = false;

	if(NewXComHQ == none)
	{
		NewXComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

		bNeedToAddHQ = true;
	}

	if(RemoveItemFromInventory(NewGameState, ItemState.GetReference(), Quantity) && bNeedToAddHQ)
	{
		NewXComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', NewXComHQ.ObjectID));
		NewGameState.AddStateObject(NewXComHQ);
	}

	if(ItemState.GetMyTemplate().TradingPostBatchSize > 1)
	{
		SupplyAmount = ((Price * Quantity) / ItemState.GetMyTemplate().TradingPostBatchSize);
	}
	else
	{
		SupplyAmount = (Price * Quantity);
	}

	`XPROFILESETTINGS.Data.m_BlackMarketSuppliesReceived = `XPROFILESETTINGS.Data.m_BlackMarketSuppliesReceived + SupplyAmount;
	NewXComHQ.AddResource(NewGameState, 'Supplies', SupplyAmount);
	//BlackMarketState.SupplyReserve -= SupplyAmount;
}

function bool RemoveItemFromInventory(XComGameState AddToGameState, StateObjectReference ItemRef, int Quantity)
{
	local XComGameState_Item InventoryItemState, NewInventoryItemState;
	local bool HQModified;
	local XComGameState_HeadquartersXCom NewXComHQ;
	local GrimyLoot_GameState_LootStore LootStoreState;

	NewXComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	InventoryItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));

	if(InventoryItemState != none)
	{
		LootStoreState = class'GrimyLootUtilities'.static.GetLootStore();
		if(!InventoryItemState.IsStartingItem() && !InventoryItemState.GetMyTemplate().bInfiniteItem)
		{
			if (class'XComGameState_HeadquartersXCom'.default.ResourceItems.Find(InventoryItemState.GetMyTemplateName()) != INDEX_NONE) // If this item is a resource, use the AddResource method instead
			{
				NewXComHQ.AddResource(AddToGameState, InventoryItemState.GetMyTemplateName(), -1*Quantity);
			}
			else if(InventoryItemState.Quantity > Quantity)
			{
				HQModified = false;
				NewInventoryItemState = XComGameState_Item(AddToGameState.CreateStateObject(class'XComGameState_Item', InventoryItemState.ObjectID));
				NewInventoryItemState.Quantity -= Quantity;
				AddToGameState.AddStateObject(NewInventoryItemState);
			}
			else
			{	
				HQModified = true;
				NewXComHQ.Inventory.RemoveItem(ItemRef);
			}
		}
		else if ( LootStoreState.RemoveIDFromLootStore(InventoryItemState.ObjectID) ) // This function returns true if it is removed, so we don't have to remove it inside the block
		{
			//HQModified = false;
			//NewInventoryItemState = XComGameState_Item(AddToGameState.CreateStateObject(class'XComGameState_Item', InventoryItemState.ObjectID));
			//NewInventoryItemState.WipeUpgradeTemplates();
			//AddToGameState.AddStateObject(NewInventoryItemState);
			AddToGameState.RemoveStateObject(ItemRef.ObjectID);
			HQModified = true;
			NewXComHQ.Inventory.RemoveItem(ItemRef);
		}	
		else
		{
			return false;
		}
	}

	return HQModified;
}