class GrimyLoot_Effect_AmmoSynthesizer extends X2Effect_Persistent;

var int BaseAmmo, BonusChance;
var bool bSidearm;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameState_Unit					UnitState;
	local XComGameState_Item					WeaponState;
	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if ( bSidearm ) {
		WeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', UnitState.GetSecondaryWeapon().ObjectID));
	}
	else {
		WeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', UnitState.GetPrimaryWeapon().ObjectID));
	}

	if ( WeaponState.Ammo < WeaponState.GetClipSize() ) {;
		WeaponState.Ammo += BaseAmmo;
		if ( WeaponState.Ammo < WeaponState.GetClipSize() && `SYNC_RAND(100) < BonusChance ) {
			WeaponState.Ammo += 1;
		}
		
	}
	NewGameState.AddStateObject(WeaponState);

	return true;
}

defaultproperties
{
	BaseAmmo = 1
	BonusChance = 0
	bSidearm = false;
}