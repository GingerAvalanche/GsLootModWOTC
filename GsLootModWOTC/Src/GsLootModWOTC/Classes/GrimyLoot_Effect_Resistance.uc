class GrimyLoot_Effect_Resistance extends X2Effect_BonusArmor;

var float Reduction;
var name DamageType;
var bool bDamageTypeOnly;
var bool bExplosiveOnly;
var bool bShockAbsorbent;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{	
	local bool NoMod;

	if ( bDamageTypeOnly && !MatchDamageTypes(DamageType, WeaponDamageEffect, X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()) ) )	{ NoMod = true; }
	if ( bExplosiveOnly && !WeaponDamageEffect.bExplosiveDamage)	{ NoMod = true; }
	if ( bShockAbsorbent && XComGameState_Unit(TargetDamageable).TileDistancebetween(Attacker) > 4 ) { NoMod = true; }

	if ( NoMod )
	{
		return 0;
	}
	
	return -int(CurrentDamage * Reduction + 0.5);
}

function bool MatchDamageTypes(name TypeName, X2Effect_ApplyWeaponDamage WeaponDamageEffect, X2WeaponTemplate SourceWeapon)
{
	return SourceWeapon.BaseDamage.DamageType == TypeName || (WeaponDamageEffect.EffectDamageValue.DamageType == TypeName) || (WeaponDamageEffect.DamageTypes.Find(TypeName) != INDEX_NONE);
}

defaultproperties
{
	Reduction = 0.0;
	bDamageTypeOnly = false;
	bExplosiveOnly = false;
	bShockAbsorbent = false;
}