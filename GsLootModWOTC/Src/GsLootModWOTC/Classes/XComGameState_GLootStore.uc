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

private function int FindIndex(int ID, out bNewValue)
{
	local int idx;
	local float idxMod;

	idx = int(float(Length) * 0.5f);
	idxMod = float(idx);

	while ( LootStore[idx-1].IDOwner != ID )
	{
		idxMod *= 0.5f;

		if ( LootStore[idx-1].IDOwner > ID )
		{
			if ( idxMod <= 0.5f )
			{
				bNewValue = true;
				break;
			}

			idx -= int(idxMod);
		}
		else
		{
			if ( idxMod <= 0.5f )
			{
				bNewValue = true;
				idx++;
				break;
			}

			idx += int(idxMod);
		}
	}

	return idx-1;
}

public function bool DoesObjectIDHaveEntry(int ID)
{
	local bool bNewValue;

	FindIndex(ID, bNewValue);

	return bNewValue;
}

public function AddToLootStore(LootStruct AddStruct)
{
	local int idx;
	local bool bNewValue;

	idx = FindIndex(AddStruct.OwnerID, bNewValue);

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

	idx = FindIndex(ID, bNewValue);

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

	idx = FindIndex(ID, bNewValue);

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

	idx = FindIndex(ID, bNewValue);

	if ( bNewValue )
	{
		return -1;
	}

	return LootStore[idx].TradingPostValue;
}