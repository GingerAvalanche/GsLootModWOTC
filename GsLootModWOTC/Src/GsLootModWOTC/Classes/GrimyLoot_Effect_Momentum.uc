class GrimyLoot_Effect_Momentum extends X2Effect_Persistent;

var int Bonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	if ( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef ) {
		if ( Attacker.TileDistanceBetween(Target) > 10 ) {
			ModInfo.ModType = eHit_Crit;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = Bonus;
			ShotModifiers.AddItem(ModInfo);
		}
	}
}