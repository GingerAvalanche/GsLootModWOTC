class GrimyLoot_Effect_BonusShred extends X2Effect_Persistent;

var int Bonus;

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	if ( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
	{
		return Bonus;
	}

	return 0;
}