class GrimyLoot_Effect_BonusDamageConcealed extends X2Effect_Persistent;

var float Bonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int EventChainStartHistoryIndex;
	
	//Only apply the bonus damage on a success
	if (AppliedData.AbilityResultContext.HitResult == eHit_Success || AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		EventChainStartHistoryIndex = `XCOMHISTORY.GetEventChainStartIndex();

		if ( Attacker.IsConcealed() || Attacker.WasConcealed(EventChainStartHistoryIndex) )
		{
			if ( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
			{
				return int(Bonus * CurrentDamage);
			}
		}
	}

	return 0;
}