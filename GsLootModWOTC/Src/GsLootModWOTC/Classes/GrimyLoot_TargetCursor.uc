class GrimyLoot_TargetCursor extends X2AbilityTarget_Cursor;

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
	local float Range;
	local XComGameState_Unit OwnerState;

	OwnerState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	Range = super.GetCursorRangeMeters(AbilityState);

	if ( OwnerState.FindAbility('GrimyLongShot').ObjectID > 0 )
	{
		Range *= 1.5;
	}
	if ( OwnerState.FindAbility('GrimyBonusRangeSup').ObjectID > 0 )
	{
		Range *= 1.6;
	}
	else if ( OwnerState.FindAbility('GrimyBonusRangeAdv').ObjectID > 0 )
	{
		Range *= 1.5;
	}
	else if ( OwnerState.FindAbility('GrimyBonusRangeBsc').ObjectID > 0 )
	{
		Range *= 1.4;
	}
	else if ( OwnerState.FindAbility('GrimyBonusRange30').ObjectID > 0 )
	{
		Range *= 1.3;
	}
	else if ( OwnerState.FindAbility('GrimyBonusRange25').ObjectID > 0 )
	{
		Range *= 1.25;
	}
	else if ( OwnerState.FindAbility('GrimyBonusRange20').ObjectID > 0 )
	{
		Range *= 1.2;
	}
	else if ( OwnerState.FindAbility('GrimyReduceRangeSup').ObjectID > 0 )
	{
		Range *= 0.6;
	}
	else if ( OwnerState.FindAbility('GrimyReduceRangeAdv').ObjectID > 0 )
	{
		Range *= 0.5;
	}
	else if ( OwnerState.FindAbility('GrimyReduceRangeBsc').ObjectID > 0 )
	{
		Range *= 0.4;
	}

	return Range;
}