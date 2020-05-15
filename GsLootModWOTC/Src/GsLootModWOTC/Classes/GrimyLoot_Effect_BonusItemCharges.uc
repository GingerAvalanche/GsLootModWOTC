class GrimyLoot_Effect_BonusItemCharges extends X2Effect_Persistent;

var int AmmoCount;
var array<name> ItemTemplateNames;
var bool bUtilityGrenades;
var bool bPocketGrenades;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameState_Unit			UnitState;
	local array<XComGameState_Item>		ItemStates;
	local XComGameState_Item ItemState, NewItemState;
//	local XComGameState_BattleData		BattleData;
	local XComGameStateHistory			History;
	
	History = `XCOMHISTORY;
//	BattleData = XComGameState_BattleData(HistoryGetSingleGameStateObjectForClass(class'XComGameState_BattleData') );
//	if ( BattleData != none && BattleData.DirectTransferInfo.IsDirectMissionTransfer )
//		return false

	// Check all of the unit's inventory items
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	ItemStates = UnitState.GetAllInventoryItems(NewGameState);

	if ( bUtilityGrenades )
	{
		foreach ItemStates(ItemState)
		{
			// If the item's template name was specified, add ammo
			if ( ItemState.InventorySlot == eInvSlot_Utility && ItemState.GetMyTemplate().IsA('X2GrenadeTemplate') )
			{
				NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
				NewItemState.Ammo = ItemState.Ammo + AmmoCount;
				NewGameState.AddStateObject(NewItemState);
				if ( bPocketGrenades )
				{
					NewItemState.Ammo += AmmoCount * ItemState.MergedItemCount;
				}	
			}
		}
	}

	if ( bPocketGrenades )
	{
		foreach ItemStates(ItemState)
		{
			// If the item's template name was specified, add ammo
			if ( ItemState.InventorySlot == eInvSlot_GrenadePocket && ItemState.GetMyTemplate().IsA('X2GrenadeTemplate') )
			{
				NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
				NewItemState.Ammo = ItemState.Ammo + AmmoCount;
				NewGameState.AddStateObject(NewItemState);
				if ( bUtilityGrenades )
				{
					NewItemState.Ammo += AmmoCount * ItemState.MergedItemCount;
				}
			}
		}
	}

	if ( ItemTemplateNames.length > 0 )
	{
		foreach ItemStates(ItemState)
		{
			// If the item's template name was specified, add ammo
			if (ItemTemplateNames.Find(ItemState.GetMyTemplateName()) != INDEX_NONE)
			{
				NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
				NewItemState.Ammo = ItemState.Ammo + AmmoCount;
				NewGameState.AddStateObject(NewItemState);
			}
		}
	}

	return false;
}

defaultproperties
{
	bUtilityGrenades = false
	bPocketGrenades = false
}