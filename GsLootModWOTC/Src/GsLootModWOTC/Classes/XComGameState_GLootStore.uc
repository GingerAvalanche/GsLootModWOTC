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

private function int FindIndex(int ID, bNewValue)
{
	local int idx;
	local float idxMod;

	idx = Length * 0.5f;
	idxMod = float(idx);

	while ( LootStore[idx-1].IDOwner != ID )
	{
		idxMod *= 0.5f;

		if ( LootStore[idx-1].IDOwner > ID )
		{
			if (idxMod == 0.5f)
			{
				if (bNewValue)
				{
					break; // effectively return idx-1
				}
				return -1;
			}

			idx -= int(idxMod);
		}
		else
		{
			if (idxMod == 0.5f)
			{
				if (bNewValue)
				{
					return idx;
				}
				return -1;
			}

			idx += int(idxMod);
		}
	}

	return idx-1;
}

public function bool DoesObjectIDHaveEntry(int ID)
{
	return FindIndex(ID, false) > -1;
}

public function AddToLootStore(LootStruct AddStruct)
{
	local int idx;

	idx = FindIndex(AddStruct.OwnerID, true);
	LootStore.Add(idx, 1);
	LootStore[idx] = AddStruct;
	Length++;
}

public function bool RemoveIDFromLootStore(int ID)
{
	local int idx;

	idx = FindIndex(ID, false);

	if (idx != INDEX_NONE)
	{
		LootStore.Remove(idx, 1);
		Length--;
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
	local int idx;

	idx = FindIndex(ID, false);

	if (idx != INDEX_NONE)
	{
		return LootStore[idx].NumUpgradeSlots;
	}

	return -1;
}

public function int GetTradingPostValueByOwnerId(int ID)
{
	local int idx;

	idx = FindIndex(ID, false);

	if (idx != INDEX_NONE)
	{
		return LootStore[idx].TradingPostValue;
	}
	return -1;
}