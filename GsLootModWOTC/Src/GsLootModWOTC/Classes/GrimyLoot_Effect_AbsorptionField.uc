class GrimyLoot_Effect_AbsorptionField extends X2Effect_BonusArmor;

var float Reduction;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	if ( XComGameState_Unit(TargetDamageable).GetMaxStat(eStat_HP) * Reduction < CurrentDamage )
	{
		return XComGameState_Unit(TargetDamageable).GetMaxStat(eStat_HP) * Reduction - CurrentDamage;
	}

	return 0;
}
