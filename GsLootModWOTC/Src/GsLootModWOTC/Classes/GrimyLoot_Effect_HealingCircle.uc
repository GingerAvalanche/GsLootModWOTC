class GrimyLoot_Effect_HealingCircle extends X2Effect_Persistent;

var int Bonus;
var float Distance;

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit;
	local int i;

	History = `XCOMHISTORY;
	//  When the source moves, check all other targets and update them
	for (i = 0; i < EffectState.ApplyEffectParameters.AbilityInputContext.MultiTargets.Length; ++i)
	{
		if (EffectState.ApplyEffectParameters.AbilityInputContext.MultiTargets[i].ObjectID != UnitState.ObjectID)
		{
			TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityInputContext.MultiTargets[i].ObjectID));

			if ( class'Helpers'.static.IsTileInRange(UnitState.TileLocation, TargetUnit.TileLocation, Distance) )
			{
				TargetUnit.ModifyCurrentStat(eStat_HP, Bonus);
			}
		}
	}
}