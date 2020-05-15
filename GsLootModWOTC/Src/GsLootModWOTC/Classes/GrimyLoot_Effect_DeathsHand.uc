class GrimyLoot_Effect_DeathsHand extends X2Effect_Persistent;

var int Bonus;
var int BonusDamage;
var name ReaperActivatedName;
var name ReaperKillName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', EffectGameState.ReaperKillCheck, ELD_OnStateSubmitted);
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.ReaperActivatedCheck, ELD_OnStateSubmitted);
}

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue UnitVal;

	//  change any miss into a hit, if we haven't already done that this turn
	if (AbilityState.GetMyTemplate().IsMelee() && class'XComGameStateContext_Ability'.static.IsHitResultMiss(CurrentResult))
	{
		Attacker.GetUnitValue(default.ReaperActivatedName, UnitVal);
		if (UnitVal.fValue == 0)
		{
			NewHitResult = eHit_Success;
			
			return true;
		}
	}

	return false;
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local UnitValue UnitVal;

	if (AbilityState.GetMyTemplate().IsMelee())
	{
		Attacker.GetUnitValue(default.ReaperKillName, UnitVal);
		
		return UnitVal.fValue * Bonus + BonusDamage;
	}
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	ReaperActivatedName = "ReaperActivated"
	ReaperKillName = "ReaperKillCount"
}