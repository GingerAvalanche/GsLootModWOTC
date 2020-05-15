class GrimyLoot_DominationCooldown extends X2AbilityCooldown;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local int NumTurns;

	NumTurns = iNumTurns;
	UnitState = XComGameState_Unit(AffectState);

	if ( UnitState.FindAbility('GrimyBonusDominationSup').ObjectID > 0 )
	{
		NumTurns -= 2;
	}
	else if ( UnitState.FindAbility('GrimyBonusDominationAdv').ObjectID > 0 )
	{
		NumTurns -= 1;
	}

	return NumTurns;
}