class GrimyLoot_ScreenListener extends UIScreenListener
	dependson(GrimyLoot_Research);

event OnInit(UIScreen Screen)
{
	local UIAlert AlertScreen;
	local ELockboxRarity LockboxRarity;
	local XComGameState_Tech TechState;

	AlertScreen = UIAlert(Screen);
	if ( AlertScreen.eAlertName == 'eAlert_ResearchComplete' )
	{
		TechState = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(AlertScreen.DisplayPropertySet, 'TechRef')));
		LockboxRarity = GetLockboxRarity(TechState);
		
		if ( LockboxRarity != eRarity_None )
		{
			GrimyLoot_UIScreen(`SCREENSTACK.Push(`PRESBASE.Spawn(class'GrimyLoot_UIScreen', Screen.Owner), `PRESBASE.Get2DMovie())).InitLoot(AlertScreen, LockboxRarity, TechState);
		}
	}
}

function ELockboxRarity GetLockboxRarity(XComGameState_Tech TechState)
{
	switch ( TechState.GetMyTemplateName() ) {
		case 'Tech_IdentifyRareLockbox':
			return eRarity_Rare;
		case 'Tech_IdentifyEpicLockbox':
		case 'Tech_IdentifyEpicLockboxInstant':
			return eRarity_Epic;
		case 'Tech_IdentifyLegendaryLockbox':
		case 'Tech_IdentifyLegendaryLockboxInstant':
			return eRarity_Legendary;
		default:
			return eRarity_None;
	}
}

defaultproperties
{
	ScreenClass=class'UIAlert';
}