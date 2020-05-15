class GrimyLoot_Effect_AddAmmo extends X2Effect_Persistent;

var name AmmoTemplate;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameState_Unit					UnitState;
	local XComGameStateHistory					History;
	local GrimyLoot_GameState_Ammo				ContainerState;
	local XComGameState_Item					AmmoState, NewAmmoState, NewWeaponState;
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate;
	local name									AbilityName;
	local X2AmmoTemplate						TempAmmoTemplate;
	
	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit',ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	ContainerState = GrimyLoot_GameState_Ammo(UnitState.FindComponentObject(class'GrimyLoot_GameState_Ammo',false));
	if ( ContainerState == none )
	{
		ContainerState = GrimyLoot_GameState_Ammo(NewGameState.CreateStateObject(class'GrimyLoot_GameState_Ammo'));
		UnitState.AddComponentObject(ContainerState);
	}

	NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', UnitState.GetPrimaryWeapon().ObjectID));

	AmmoState = XComGameState_Item(History.GetGameStateForObjectID(NewWeaponState.LoadedAmmo.ObjectID));
	if ( AmmoState != none )
	{
		TempAmmoTemplate = X2AmmoTemplate(AmmoState.GetMyTemplate());
		foreach TempAmmoTemplate.Abilities(AbilityName)
		{
			UnitState.Abilities.RemoveItem(UnitState.FindAbility(AbilityName));
		}
	}

	AmmoState = ContainerState.AmmoState;
	NewAmmoState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item'));
	NewAmmoState.OnCreation(GetAmmoTemplate());
	ContainerState.AmmoState = NewAmmoState;
	if ( AmmoState != none )
	{
		NewGameState.RemoveStateObject(AmmoState.ObjectID);
	}
	
	NewWeaponState.LoadedAmmo = NewAmmoState.GetReference();
	
	foreach X2AmmoTemplate(NewAmmoState.GetMyTemplate()).Abilities(AbilityName)
	{
		AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState,AmmoState.GetReference());
	}

	NewGameState.AddStateObject(UnitState);
	NewGameState.AddStateObject(ContainerState);
	NewGameState.AddStateObject(NewAmmoState);
	NewGameState.AddStateObject(NewWeaponState);

	return false;
}

simulated function X2AmmoTemplate GetAmmoTemplate()
{
	return X2AmmoTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(AmmoTemplate));
}

simulated function RemoveAmmoAbilities(XComGameState_Item NewWeaponState, XComGameState NewGameState)
{
}