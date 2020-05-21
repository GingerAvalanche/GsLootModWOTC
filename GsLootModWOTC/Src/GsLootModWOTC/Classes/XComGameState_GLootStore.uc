class XComGameState_GLootStore extends XComGameState_BaseObject;

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

private function int FindIndex(int s, int e, int ID, out bNewValue)
{
	local int mid;

	if (e >= s)
	{
		mid = s + ((e - s) / 2);

		if (LootStore[mid] == ID)
			return mid;
		else if (LootStore[mid] > ID)
			return FindIndex(s, mid-1, ID, bNewValue);
		else
			return FindIndex(mid+1, e, ID, bNewValue);
	}
	else
	{
		bNewValue = true;
		return s;
	}
}

public function bool DoesObjectIDHaveEntry(int ID)
{
	local bool bNewValue;

	FindIndex(0, Length-1, ID, bNewValue);

	return !bNewValue;
}

public function AddToLootStore(LootStruct AddStruct)
{
	local int idx;
	local bool bNewValue;

	idx = FindIndex(0, Length-1, AddStruct.OwnerID, bNewValue);

	if ( bNewValue )
	{
		LootStore.Add(idx, 1);
	}

	LootStore[idx] = AddStruct;
	Length++;
}

public function bool RemoveIDFromLootStore(int ID)
{
	local int idx;
	local bool bNewValue;

	idx = FindIndex(0, Length-1, ID, bNewValue);

	if ( bNewValue )
	{
		return false;
	}

	LootStore.Remove(idx, 1);
	Length--;
	return true;
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
	local int idx;
	local bool bNewValue;

	idx = FindIndex(0, Length-1, ID, bNewValue);

	if ( bNewValue )
	{
		return -1;
	}
	
	return LootStore[idx].NumUpgradeSlots;
}

public function int GetTradingPostValueByOwnerId(int ID)
{
	local int idx;
	local bool bNewValue;

	idx = FindIndex(0, Length-1, ID, bNewValue);

	if ( bNewValue )
	{
		return -1;
	}

	return LootStore[idx].TradingPostValue;
}