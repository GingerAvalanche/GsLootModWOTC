class GrimyLoot_AbilityCooldown extends X2AbilityCooldown;

struct CooldownData
{
	var name AbilityName;
	var int CooldownBonus;
};

var array<CooldownData> CooldownAbilities;

function AddAbilityBonusCooldown(name AbilityName, int CooldownBonus) {
	local CooldownData CooldownEntry;

	CooldownEntry.AbilityName = AbilityName;
	CooldownEntry.CooldownBonus = CooldownBonus;

	CooldownAbilities.AddItem(CooldownEntry);
}

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState) {
	local int kCooldown;
	local CooldownData CooldownIndex;
	local XComGameState_Unit UnitState;

	kCooldown = iNumTurns;

	UnitState = XComGameState_Unit(AffectState);
	if(UnitState != none) {
		foreach CooldownAbilities(CooldownIndex) {
			if ( UnitState.FindAbility(CooldownIndex.AbilityName).ObjectID > 0 ) {
				kCooldown += CooldownIndex.CooldownBonus;
				kCooldown = max(kCooldown,0);
			}
		}
	}

	return kCooldown;
}