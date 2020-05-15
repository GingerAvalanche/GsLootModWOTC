class GrimyLoot_Effect_BonusDamagePercent extends X2Effect_Persistent;

var float Bonus;
var bool bLastStanding;
var EInventorySlot ItemSlot;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item WeaponState;

	//Only apply the bonus damage on a success
	if (AppliedData.AbilityResultContext.HitResult == eHit_Success || AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));

		if ( ItemSlot != eInvSlot_Unknown )
		{
			if ( WeaponState.InventorySlot != ItemSlot )
			{
				return 0;
			}
		}
		else if ( AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef )
		{
			return 0;
		}

		if ( bLastStanding && !IsOneOnOne(Attacker, TargetDamageable) )
		{
			return 0;
		}

		return int(Bonus * CurrentDamage);
	}

	return 0;
}

function bool IsOneOnOne(XComGameState_Unit Attacker, Damageable TargetDamageable)
{
	local array<StateObjectReference> Viewers;

	class'X2TacticalVisibilityHelpers'.static.GetEnemyViewersOfTarget(Attacker.ObjectID,Viewers);

	if ( Viewers.length > 1 || Viewers[0].ObjectID != XComGameState_Unit(TargetDamageable).ObjectID )
	{
		return false;
	}

	return true;
}

defaultproperties
{
	Bonus = 0.0
	bLastStanding = false
	Itemslot = eInvSlot_Unknown
}