class GrimyLoot_Effect_BonusArmor extends X2Effect_BonusArmor;

var int BonusArmor;

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	return BonusArmor;
}

defaultproperties
{
	BonusArmor = 1;
}