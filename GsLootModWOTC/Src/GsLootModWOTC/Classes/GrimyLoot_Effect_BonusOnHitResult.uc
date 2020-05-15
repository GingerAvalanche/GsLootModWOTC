class GrimyLoot_Effect_BonusOnHitResult extends X2Effect_Persistent;

var EAbilityHitResult HitResult;
var int Bonus;
var int MaxDistance; // 0 to not check for proximity
var int BonusPerVisible;
var int MaxVisible;
var bool bBodyShield;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local int NumVisible;

	if ( MaxDistance > 0 && Attacker.TileDistanceBetween(Target) > MaxDistance )	{ return; }
	if ( bBodyShield && !IsNearest(Attacker,Target) ) { return; }
	if ( BonusPerVisible != 0 ) {
		NumVisible = Target.GetNumVisibleEnemyUnits(true, false);
		if ( NumVisible > 0 ) {
			if ( NumVisible > MaxVisible ) {
				NumVisible = MaxVisible;
			}

			ModInfo.ModType = HitResult;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = BonusPerVisible * NumVisible;
			ShotModifiers.AddItem(ModInfo);
		}
	}

	ModInfo.ModType = HitResult;
	ModInfo.Reason = FriendlyName;
	ModInfo.Value = Bonus;
	ShotModifiers.AddItem(ModInfo);
}

function bool IsNearest(XComGameState_Unit Attacker, XComGameState_Unit Target)
{
	local GameRulesCache_VisibilityInfo kEnemyInfo;

	class'X2TacticalVisibilityHelpers'.static.GetClosestVisibleEnemy(Attacker.ObjectID, kEnemyInfo );

	if( kEnemyInfo.TargetID == Target.ObjectID )
	{
		return true;
	}

	return false;
}

defaultproperties
{
	HitResult = eHit_Success
	Bonus = 0
	MaxDistance = 0
	BonusPerVisible = 0
	MaxVisible = 0
	bBodyShield = false;
}