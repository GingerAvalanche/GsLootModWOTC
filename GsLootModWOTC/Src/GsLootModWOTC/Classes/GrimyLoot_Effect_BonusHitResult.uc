class GrimyLoot_Effect_BonusHitResult extends X2Effect_Persistent;

var EAbilityHitResult HitResult;
var int Bonus;
var bool bAnyWeaponType;
var bool bFlankingOnly;
var bool bConcealedOnly;
var bool bUnflankableOnly;
var bool bInjuredOnly;
var bool bOverwatchOnly;
var bool bVsOverwatchOnly;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local bool NoBonus;
	
	// Return if any of these conditions are not met
	if ( bFlankingOnly && !CheckFlanking(Attacker, Target, AbilityState) )	{ NoBonus = true; }
	if ( bConcealedOnly && !CheckConcealment( Attacker ) )	{ NoBonus = true; }
	if ( bUnflankableOnly && Target.GetMyTemplate().bCanTakeCover )	{ NoBonus = true; }
	if ( AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef && !bAnyWeaponType ) { NoBonus = true; }
	if ( bInjuredOnly && Attacker.GetCurrentStat(eStat_HP) >= Attacker.GetMaxStat(eStat_HP) )	{ NoBonus = true; }
	if ( bOverwatchOnly && AbilityState.GetMyTemplateName() != 'OverwatchShot' )	{ NoBonus = true; }
	if ( bVsOverwatchOnly && Target.ReserveActionPoints.Find('Overwatch') == INDEX_NONE ) { NoBonus = true; }
	
	if (NoBonus)
	{
		return;
	}

	// we met all conditions, simply return the bonus
	ModInfo.ModType = HitResult; // eHit_Success; eHit_Crit; eHit_Graze;
	ModInfo.Reason = FriendlyName;
	ModInfo.Value = Bonus;
	ShotModifiers.AddItem(ModInfo);
}

function bool CheckConcealment( XComGameState_Unit Attacker )
{
	local int EventChainStartHistoryIndex;
	
	EventChainStartHistoryIndex = `XCOMHISTORY.GetEventChainStartIndex();
	if ( Attacker.IsConcealed() || Attacker.WasConcealed(EventChainStartHistoryIndex) )
	{
		return true;
	}

	return false;
}

function bool CheckFlanking( XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState )
{
	local GameRulesCache_VisibilityInfo VisInfo;

	if (!AbilityState.IsMeleeAbility() && Target != None )
	{
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
		{
			if (Attacker.CanFlank() && Target.GetMyTemplate().bCanTakeCover && VisInfo.TargetCover == CT_None)
			{
				return true;
			}
		}
	}

	return false;
}

defaultproperties
{
	HitResult = eHit_Success
	Bonus = 0
	bAnyWeaponType = false
	bFlankingOnly = false
	bConcealedOnly = false
	bUnflankableOnly = false
	bInjuredOnly = false
	bOverwatchOnly = false
	bVsOverwatchOnly = false
}