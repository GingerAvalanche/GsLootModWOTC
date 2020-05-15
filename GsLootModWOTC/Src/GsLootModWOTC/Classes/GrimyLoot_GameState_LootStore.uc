class GrimyLoot_GameState_LootStore extends XComGameState_BaseObject;

var int Length;

struct LootStruct
{
	var int IDOwner;
	var int NumUpgradeSlots;
	var int TradingPostValue;

	structdefaultproperties
	{
		IDOwner = 0;
		NumUpgradeSlots = 1;
	}
};

var private array<LootStruct> LootStore;

public function AddToLootStore(LootStruct AddStruct)
{
	LootStore.AddItem(AddStruct);
	Length = LootStore.Length;
}

public function bool RemoveIDFromLootStore(int ID)
{
	local LootStruct ItemStats;

	foreach LootStore(ItemStats)
	{
		if ( ItemStats.IDOwner == ID )
		{
			LootStore.RemoveItem(ItemStats);
			Length = LootStore.Length;
			return true;
		}
	}

	return false;
}

public function bool DoesObjectIDHaveEntry(int ID)
{
	local LootStruct ItemStats;

	foreach LootStore(ItemStats)
	{
		if ( ItemStats.IDOwner == ID )
			return true;
	}
	return false;
}

public function array<int> GetAllStoreOwnerIDs()
{
	local array<int> OwnerIDs;
	local LootStruct CurrStruct;

	foreach LootStore(CurrStruct)
	{
		OwnerIDs.AddItem(CurrStruct.IDOwner);
	}

	return OwnerIDs;
}

public function int GetNumUpgradeSlotsByOwnerID(int ID)
{
	local LootStruct ItemStats;

	foreach LootStore(ItemStats)
	{
		if ( ItemStats.IDOwner == ID )
			return ItemStats.NumUpgradeSlots;
	}
	return -1;
}

public function int GetTradingPostValueByOwnerId(int ID)
{
	local LootStruct ItemStats;

	foreach LootStore(ItemStats)
	{
		if ( ItemStats.IDOwner == ID )
			return ItemStats.TradingPostValue;
	}
	return -1;
}