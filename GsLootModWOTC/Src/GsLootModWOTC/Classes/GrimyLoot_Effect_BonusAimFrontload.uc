class GrimyLoot_Effect_BonusAimFrontload extends X2Effect_Persistent;

var int Bonus;
var EAbilityHitResult HitResult;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item SourceWeapon;
	local ShotModifierInfo ModInfo;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if ( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef ) {
		ModInfo.ModType = HitResult;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = ( 1 + SourceWeapon.Ammo - SourceWeapon.GetClipSize() ) * Bonus;
		ShotModifiers.AddItem(ModInfo);
	}
}