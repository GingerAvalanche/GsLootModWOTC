class GrimyLoot_ChargeCost extends X2AbilityCost;

var int NumCharges;
var array<name> SharedAbilityCharges;       //  names of other abilities which should all have their charges deducted as well. not checked in CanAfford, only modified in ApplyCost.
var bool bOnlyOnHit;                        //  only expend charges when the ability hits the target
var name ReqAbility;

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{

	if ( ActivatingUnit.FindAbility(ReqAbility).ObjectID <= 0 || kAbility.GetCharges() >= NumCharges )
		return 'AA_Success';

	return 'AA_CannotAfford_Charges';
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local name SharedAbilityName;
	local StateObjectReference SharedAbilityRef;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local XComGameState_Ability SharedAbilityState;

	if (bOnlyOnHit && AbilityContext.IsResultContextMiss())
	{
		return;
	}
	
	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (UnitState == None)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	}

	if ( UnitState.FindAbility(ReqAbility).ObjectID <= 0 )
	{
		return;
	}

	kAbility.iCharges -= NumCharges;

	if (SharedAbilityCharges.Length > 0)
	{

		foreach SharedAbilityCharges(SharedAbilityName)
		{
			if (SharedAbilityName != kAbility.GetMyTemplateName())
			{
				SharedAbilityRef = UnitState.FindAbility(SharedAbilityName);
				if (SharedAbilityRef.ObjectID > 0)
				{
					SharedAbilityState = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
					SharedAbilityState.iCharges -= NumCharges;
					NewGameState.AddStateObject(SharedAbilityState);
				}
			}
		}
	}
}

DefaultProperties
{
	NumCharges = 1
}