class GrimyLoot_Effect_AddItem extends X2Effect_Persistent;

var int Bonus;
var name ItemName;
var EInventorySlot SlotType;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Unit TargetUnit;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item ItemState;
	local int i;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	TargetUnit = XComGameState_Unit(kNewTargetState);
	ItemTemplate = ItemTemplateManager.FindItemTemplate(ItemName);
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	for ( i = 0; i < bonus; i++ )
	{
		TargetUnit.AddItemToInventory(ItemState, SlotType, NewGameState);
	}
	NewGameState.AddStateObject(ItemState);
}