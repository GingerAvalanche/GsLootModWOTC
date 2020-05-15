class GrimyLoot_Effect_ReduceMeleeDamage extends X2Effect_Persistent;

var int Bonus;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	if ( AbilityState.IsMeleeAbility() )
	{
		if ( Bonus > CurrentDamage )
		{
			return -CurrentDamage;
		}
		else
		{
			return -Bonus;
		}
	}

	return 0;
}