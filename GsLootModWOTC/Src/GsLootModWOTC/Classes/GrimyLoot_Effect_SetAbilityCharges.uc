class GrimyLoot_Effect_SetAbilityCharges extends X2Effect_Persistent;

var int BonusCharges;
var int NumCharges;
var name AbilityName;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
			
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(UnitState.FindAbility(AbilityName).ObjectID ));
	
	if ( AbilityState != none )
	{
		if ( NumCharges >= 0 )
		{
			AbilityState.iCharges = NumCharges;
		}
		if ( BonusCharges > 0 )
		{
			AbilityState.iCharges += BonusCharges;
		}
	}
	
	return false;
}

defaultproperties
{
	BonusCharges = 0
	NumCharges = -1
}