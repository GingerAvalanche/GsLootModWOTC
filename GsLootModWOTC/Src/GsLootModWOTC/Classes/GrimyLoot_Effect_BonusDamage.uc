class GrimyLoot_Effect_BonusDamage extends X2Effect_Persistent;

//var EAbilityHitResult HitResult;
var int Bonus;
var name AbilityName;
var bool bAbilityOnly;
var bool bFlankingOnly;
var bool bConcealedOnly;
var bool bUnflankableOnly;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local bool NoBonus;

	// Return 0 if any of these conditions are not met
	//if ( AppliedData.AbilityResultContext.HitResult != HitResult )	{ NoBonus = true; }
	if ( bAbilityOnly && AbilityName != AbilityState.GetMyTemplateName() )	{ NoBonus = true; }
	if ( bFlankingOnly && !CheckFlanking(Attacker, XComGameState_Unit(TargetDamageable), AbilityState) )	{ NoBonus = true; }
	if ( bConcealedOnly && !CheckConcealment( Attacker ) )	{ NoBonus = true; }
	if ( bUnflankableOnly && XComGameState_Unit(TargetDamageable).GetMyTemplate().bCanTakeCover )	{ NoBonus = true; }
	if ( AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef ) { NoBonus = true; }

	if ( NoBonus ) {
		//`Log("GrimyLoot_Effect_BonusDamage.GetAttackingDamageModifier returning no bonus...");
		return 0;
	}

	// we met all conditions, simply return the bonus
	return Bonus;
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

	if (!AbilityState.IsMeleeAbility() && Target != None ) {
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo)) {
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
//	HitResult = eHit_Success
	Bonus = 0
	bAbilityOnly = false
	bFlankingOnly = false
	bConcealedOnly = false
	bUnflankableOnly = false
}