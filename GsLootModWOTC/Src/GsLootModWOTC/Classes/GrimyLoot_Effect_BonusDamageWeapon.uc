class GrimyLoot_Effect_BonusDamageWeapon extends X2Effect_Persistent;

var int Bonus;
var name WeaponName;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{

	if ( AbilityState.GetSourceWeapon().GetMyTemplateName() == WeaponName || AbilityState.GetSourceAmmo().GetMyTemplateName() == WeaponName )
	{
		return Bonus;
	}

	return 0;
}