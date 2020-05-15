class GrimyLoot_Effect_BonusDamageOnHit extends X2Effect_Persistent;

var int Bonus;
var EInventorySlot ItemSlot;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item WeaponState;

	//Only apply the bonus damage on a success
	if (AppliedData.AbilityResultContext.HitResult == eHit_Success || AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));

		if ( !( (ItemSlot != eInvSlot_Unknown && WeaponState.InventorySlot != ItemSlot) || AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef ) )
		{
			return Bonus;
		}
	}

	return 0;
}

defaultproperties
{
	Bonus = 0
	Itemslot = eInvSlot_Unknown
}