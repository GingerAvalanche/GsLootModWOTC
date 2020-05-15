class GrimyLoot_Effect_BonusDamageAbility extends X2Effect_Persistent;

var int Bonus;
var name AbilityName;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	//Only apply the bonus damage on a success
	if (AppliedData.AbilityResultContext.HitResult == eHit_Success || AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		if ( AbilityName == AbilityState.GetMyTemplateName() )
		{
			return Bonus;
		}
	}

	return 0;
}