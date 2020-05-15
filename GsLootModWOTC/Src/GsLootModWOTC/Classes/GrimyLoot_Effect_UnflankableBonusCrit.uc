class GrimyLoot_Effect_UnflankableBonusCrit extends X2Effect_Persistent;

var int Bonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	if ( !Target.GetMyTemplate().bCanTakeCover )
	{
		if ( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
		{
			ModInfo.ModType = eHit_Crit;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = Bonus;
			ShotModifiers.AddItem(ModInfo);
		}
	}
}