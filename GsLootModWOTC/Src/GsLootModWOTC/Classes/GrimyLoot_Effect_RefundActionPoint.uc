class GrimyLoot_Effect_RefundActionPoint extends X2Effect_Persistent;

var int Bonus;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'RefundActionPoint', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory History;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;
	
	//`Log("GrimyLoot_Effect_RefundActionPoint.PostAbilityCostPaid starting...");

	if ( kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
	{
		History = `XCOMHISTORY;

		//  if we have no standard actions left, but we had them before, then this obviously cost us something and we can refund an action point
		if (SourceUnit.NumActionPoints() == 0 && PreCostActionPoints.Length > 0)
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

			if (AbilityState != none)
			{
				SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);

				EventMgr = `XEVENTMGR;
				EventMgr.TriggerEvent('RefundActionPoint', AbilityState, SourceUnit, NewGameState);
				
				return true;
			}
		}
	}

	return false;
}