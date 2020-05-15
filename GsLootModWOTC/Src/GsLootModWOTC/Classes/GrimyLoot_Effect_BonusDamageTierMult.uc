class GrimyLoot_Effect_BonusDamageTierMult extends X2Effect_Persistent;

var int Bonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;

	//Only apply the bonus damage on a success
	if (AppliedData.AbilityResultContext.HitResult == eHit_Success || AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		//Attempt to scale damage to weapon tier
		SourceWeapon = AbilityState.GetSourceWeapon();

		if ( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
		{
			//Beam weapons are tier 4 and 5
			//Mag weapons are tier 2 and 3
			//Conv weapons are tier 0
			switch ( SourceWeapon.GetMyTemplate().Tier )
			{
				case 5:
				case 4:
					return Bonus + 2;
				case 3:
				case 2:
					return Bonus + 1;
				default:
					return Bonus;
			}
		}
	}

	return 0;
}