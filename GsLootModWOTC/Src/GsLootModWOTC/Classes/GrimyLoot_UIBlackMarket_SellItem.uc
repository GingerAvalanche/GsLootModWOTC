class GrimyLoot_UIBlackMarket_SellItem extends UIBlackMarket_SellItem;

simulated function PopulateData(BlackMarketItemPrice BuyPrice)
{
	local XComGameState_Item Item;
	local string ItemName, InventoryQuantity, SellQuantity, TotalValue, ItemValue;
	local int ItemCost;
	
	//`Log("GrimyLoot_GrimyLoot_UIBlackMarket_SellItem.PopulateData starting...");

	ItemPrice = BuyPrice;
	ItemRef = BuyPrice.ItemRef;
	Price = BuyPrice.Price + BuyPrice.Price * (class'UIUtilities_Strategy'.static.GetBlackMarket().BuyPricePercentIncrease / 100.0f);
	Item = GetItem();
	ItemTemplate = Item.GetMyTemplate();
	
	ItemCost = class'UIUtilities_Strategy'.static.GetCostQuantity(ItemTemplate.Cost, 'Supplies');
	if (ItemCost > 0) // Ensure that the sell price of the item is not more than its cost from engineering
	{
		Price = Min(Price, ItemCost);
	}

	if ( Item.Nickname == "" )
	{
		ItemName = ItemTemplate.GetItemFriendlyName();
	}
	else
	{
		ItemName = Item.Nickname;
	}

	ItemName = class'UIUtilities_Text'.static.GetColoredText(ItemName, eUIState_Normal, 24);
	InventoryQuantity = class'UIUtilities_Text'.static.GetColoredText(string(Item.Quantity - NumSelling), eUIState_Normal, 24);
	ItemValue = class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Strategy'.default.m_strCreditsPrefix $ string(Price), eUIState_Cash, 24);

	if(NumSelling > 0)
	{
		SellQuantity = class'UIUtilities_Text'.static.GetColoredText(string(NumSelling), eUIState_Normal, 24);
		TotalValue = class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Strategy'.default.m_strCreditsPrefix $ string(Price * NumSelling), eUIState_Cash, 24);
	}
	else
	{
		SellQuantity = class'UIUtilities_Text'.static.GetColoredText("-", eUIState_Normal, 24);
		TotalValue = "";
	}

	MC.BeginFunctionOp("populateData");
	MC.QueueString(ItemName);
	MC.QueueString(InventoryQuantity);
	MC.QueueString(ItemValue);
	MC.QueueString(SellQuantity);
	MC.QueueString(TotalValue);
	MC.EndOp();
	
	//`Log("GrimyLoot_GrimyLoot_UIBlackMarket_SellItem.PopulateData completing...");
}