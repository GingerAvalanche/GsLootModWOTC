class GrimyLoot_Effect_BonusDamageOnCrit extends X2Effect_Persistent;

var int Bonus;
var int BonusPerVisible;
var int MaxVisible;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{

	//Only apply the bonus damage on a crit
	if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		if ( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
		{
			return Bonus + BonusPerVisible * GetNumVisible(Attacker);
		}
	}

	return 0;
}

function int GetNumVisible(XComGameState_Unit Attacker)
{
	local int NumVisible;

	if ( BonusPerVisible != 0 )
	{
		NumVisible = Attacker.GetNumVisibleEnemyUnits(true, false);

		if ( NumVisible > MaxVisible )
		{
			NumVisible = MaxVisible;
		}
	}
	else
	{
		NumVisible = 0;
	}

	return NumVisible;
}

defaultproperties
{
	Bonus = 0
	BonusPerVisible = 0
	MaxVisible = 0
}