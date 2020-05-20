//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_GsLootModWOTC.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_GsLootModWOTC extends X2DownloadableContentInfo;

static event OnLoadedSavedGame()
{
	UpdateResearch();
}

static event OnLoadedSavedGameToStrategy()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LootStore Instantiation");

	if ( class'X2Utilities_GsLoot'.static.GetLootStore().ObjectID == 0 )
	{
	    class'X2Utilities_GsLoot'.static.CreateLootStore(NewGameState);
	}

	if ( NewGameState.GetNumGameStateObjects() > 0 ) //this is redundant with the previous conditional, I think? doesn't hurt to be sure
	{
	    `GAMERULES.SubmitGameState(NewGameState);
	}
	else
	{
	    `XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}

	UpdateInventoryCategoryImages();
}

static event InstallNewCampaign(XcomGameState StartState)
{
	class'X2Utilities_GsLoot'.static.CreateLootStore(StartState);
}

static event OnExitPostMissionSequence()
{
	local XComGameState NewGameState;
	local array<int> LootStoreIDs;
	local int LootStoreID;
	local XComGameState_GLootStore LootStoreState;
	local XComGameState_BaseObject ObjectState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LootStore Instantiation");
	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();

	if ( LootStoreState.ObjectID == 0 ) // If it doesn't exist, create it
	{
	    class'X2Utilities_GsLoot'.static.CreateLootStore(NewGameState);

		if ( NewGameState.GetNumGameStateObjects() > 0 ) //this is redundant with the previous conditional, I think? doesn't hurt to be sure
		{
			`GAMERULES.SubmitGameState(NewGameState);
		}
		else
		{
			`XCOMHISTORY.CleanupPendingGameState(NewGameState);
		}
	}
	else // If it does exist, check it for any items that may have been removed
	{
		LootStoreIDs = LootStoreState.GetAllStoreOwnerIDs();

		foreach LootStoreIDs(LootStoreID)
		{
			ObjectState = `XCOMHISTORY.GetGameStateForObjectID(LootStoreID);

			if ( ObjectState.ObjectID == 0 || ObjectState.bRemoved )
				LootStoreState.RemoveIDFromLootStore(LootStoreID);
		}
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}

	UpdateInventoryCategoryImages();
}

static event OnPostTemplatesCreated()
{
	if ( class'GrimyLoot_AbilitiesSpark'.static.HasDLC3() )
	{
		UpdateSparkAbilities();
	}
	UpdatePsiAbilities();
	UpdateItemColors();
	UpdateFragGrenades();
	UpdateSchematics();
	UpdateSpecialistAbilities();

	OnPostLootTablesCreated();

	class'GrimyLoot_UpgradesPrimary'.static.UpdateOldTemplates();
	class'GrimyLoot_Research'.static.EnableAlienRulers();
	class'X2Item_GrimyUpgrades'.static.GenerateAttachmentsForUpgrades();
}

static function UpdateSchematics()
{
	local X2ItemTemplateManager		ItemManager;
	local X2SchematicTemplate		SchematicTemplate;
	local array<X2DataTemplate>		DifficultyTemplates;
	local X2DataTemplate			DifficultyTemplate;
	local name						SchematicName;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	foreach class'GrimyLoot_Research'.default.SCHEMATIC_NAMES(SchematicName) {
		ItemManager.FindDataTemplateAllDifficulties(SchematicName,DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) {
			SchematicTemplate = X2SchematicTemplate(DifficultyTemplate);
			if ( SchematicTemplate != none ) {
				SchematicTemplate.OnBuiltFn = class'GrimyLoot_SchematicOverride'.static.UpgradeItems;
			}
		}
	}
}

static function UpdateSparkAbilities()
{
	local X2AbilityTemplateManager					AbilityManager;
	local X2AbilityTemplate							AbilityTemplate;
	local X2Condition_AbilityProperty				AbilityCondition;
	local X2Effect_PersistentStatChange				PersistentStatChangeEffect;
	local X2Effect_Persistent						MarkedEffect;
	local GrimyLoot_Effect_Resistance				DefenseEffect;
	local X2Effect_Stunned							StunnedEffect;
	local GrimyLoot_AbilityCooldown					GrimyCooldown;
	
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityManager.FindAbilityTemplate('SparkPlasmaBlaster');
	X2AbilityMultiTarget_Line(AbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusWidth('GrimySparkPlasmaBlasterWidthOne', 1);
	X2AbilityMultiTarget_Line(AbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusWidth('GrimySparkPlasmaBlasterWidthTwo', 2);
	AbilityTemplate = AbilityManager.FindAbilityTemplate('SparkFlamethrower');
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkFlamethrowerWidthOne', 1, 0);
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkFlamethrowerWidthTwo', 2, 0);
	AbilityTemplate = AbilityManager.FindAbilityTemplate('SparkFlamethrowerMk2');
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkFlamethrowerWidthOne', 1, 0);
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkFlamethrowerWidthTwo', 2, 0);
	AbilityTemplate = AbilityManager.FindAbilityTemplate('SparkShredderGun');
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkShredderRangeTwo', 0, 2);
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkShredderRangeFour', 0, 4);
	AbilityTemplate = AbilityManager.FindAbilityTemplate('SparkShredstormCannon');
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkShredderRangeTwo', 0, 2);
	X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle).AddBonusConeSize('GrimySparkShredderRangeFour', 0, 4);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('IntimidateTrigger');

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSpotterTwo');
	MarkedEffect = class'X2StatusEffects'.static.CreateMarkedEffect(2, false);
	MarkedEffect.TargetConditions.AddItem(AbilityCondition);
	MarkedEffect.bApplyOnMiss = true;
	AbilityTemplate.AddTargetEffect(MarkedEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSpotterThree');
	MarkedEffect = class'X2StatusEffects'.static.CreateMarkedEffect(3, false);
	MarkedEffect.TargetConditions.AddItem(AbilityCondition);
	MarkedEffect.bApplyOnMiss = true;
	AbilityTemplate.AddTargetEffect(MarkedEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSpotterFour');
	MarkedEffect = class'X2StatusEffects'.static.CreateMarkedEffect(4, false);
	MarkedEffect.TargetConditions.AddItem(AbilityCondition);
	MarkedEffect.bApplyOnMiss = true;
	AbilityTemplate.AddTargetEffect(MarkedEffect);
	
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSurvivalOne');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, 1);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(PersistentStatChangeEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSurvivalTwo');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, 2);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(PersistentStatChangeEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSurvivalThree');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, 3);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(PersistentStatChangeEffect);
	
	AbilityTemplate = AbilityManager.FindAbilityTemplate('Sacrifice');
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSacrificeOne');
	DefenseEffect = new class'GrimyLoot_Effect_Resistance';
	Defenseeffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	DefenseEffect.bApplyOnMiss = true;
	DefenseEffect.Reduction = 0.4;
	DefenseEffect.FriendlyName = AbilityTemplate.LocFriendlyName;
	DefenseEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(DefenseEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSacrificeTwo');
	DefenseEffect = new class'GrimyLoot_Effect_Resistance';
	Defenseeffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	DefenseEffect.bApplyOnMiss = true;
	DefenseEffect.Reduction = 0.5;
	DefenseEffect.FriendlyName = AbilityTemplate.LocFriendlyName;
	DefenseEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(DefenseEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkSacrificeThree');
	DefenseEffect = new class'GrimyLoot_Effect_Resistance';
	Defenseeffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	DefenseEffect.bApplyOnMiss = true;
	DefenseEffect.Reduction = 0.6;
	DefenseEffect.FriendlyName = AbilityTemplate.LocFriendlyName;
	DefenseEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(DefenseEffect);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('Strike');
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkStrangleholdStun');
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100);
	StunnedEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(StunnedEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkStrangleholdDefenseOne');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, 20);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(PersistentStatChangeEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkStrangleholdDefenseTwo');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, 25);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(PersistentStatChangeEffect);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySparkStrangleholdDefenseThree');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, 30);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddShooterEffect(PersistentStatChangeEffect);

	GrimyCooldown = new class'GrimyLoot_AbilityCooldown';
	GrimyCooldown.iNumTurns = AbilityTemplate.AbilityCooldown.iNumTurns;
	GrimyCooldown.AddAbilityBonusCooldown('GrimySparkStrikeCooldownTwo',-2);
	GrimyCooldown.AddAbilityBonusCooldown('GrimySparkStrikeCooldownThree',-3);
	GrimyCooldown.AddAbilityBonusCooldown('GrimySparkStrikeCooldownFour',-4);
	AbilityTemplate.AbilityCooldown = GrimyCooldown;

}

static function UpdateSpecialistAbilities()
{
	local X2AbilityTemplateManager	AbilityTemplateManager;
	local X2AbilityTemplate Template;
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityTemplateManager.FindAbilityTemplate('GrimyShieldProtocolOne');
	UpdateGrimyShieldProtocol(Template, 'GrimyShieldProtocolOne', 3, 3, AbilityTemplateManager);

	Template = AbilityTemplateManager.FindAbilityTemplate('GrimyShieldProtocolTwo');
	UpdateGrimyShieldProtocol(Template, 'GrimyShieldProtocolTwo', 4, 3, AbilityTemplateManager);

	Template = AbilityTemplateManager.FindAbilityTemplate('GrimyShieldProtocolThree');
	UpdateGrimyShieldProtocol(Template, 'GrimyShieldProtocolThree', 5, 3, AbilityTemplateManager);

	Template = AbilityTemplateManager.FindAbilityTemplate('GrimyTargetingProtocolOne');
	UpdateGrimyShieldProtocol(Template, 'GrimyTargetingProtocolOne', 10, 1, AbilityTemplateManager);

	Template = AbilityTemplateManager.FindAbilityTemplate('GrimyTargetingProtocolTwo');
	UpdateGrimyShieldProtocol(Template, 'GrimyTargetingProtocolTwo', 15, 1, AbilityTemplateManager);

	Template = AbilityTemplateManager.FindAbilityTemplate('GrimyTargetingProtocolThree');
	UpdateGrimyShieldProtocol(Template, 'GrimyTargetingProtocolThree', 20, 1, AbilityTemplateManager);
}

static function UpdateGrimyShieldProtocol(out X2AbilityTemplate Template, name TemplateName, int Bonus, int Duration, X2AbilityTemplateManager AbilityTemplateManager)
{
	local X2AbilityTemplate                     EditAbility;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Condition_UnitProperty              UnitCondition;

	EditAbility = AbilityTemplateManager.FindAbilityTemplate('AidProtocol');

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem(TemplateName);
	
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, Bonus);
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitCondition);
	EditAbility.AddTargetEffect(PersistentStatChangeEffect);
}

static function UpdateGrimyTargetingProtocol(out X2AbilityTemplate Template, name TemplateName, int Bonus, int Duration, X2AbilityTemplateManager AbilityTemplateManager) {
	local X2AbilityTemplate                     EditAbility;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Condition_UnitProperty              UnitCondition;

	EditAbility = AbilityTemplateManager.FindAbilityTemplate('AidProtocol');
	
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem(TemplateName);
	
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, Bonus);
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitCondition);
	EditAbility.AddTargetEffect(PersistentStatChangeEffect);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_CritChance, Bonus);
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitCondition);
	EditAbility.AddTargetEffect(PersistentStatChangeEffect);
}

static function UpdatePsiAbilities() {
	local X2AbilityTemplateManager					AbilityManager;
	local X2AbilityTemplate							AbilityTemplate;
	local GrimyLoot_ChargeCost						ChargeCost;
	local X2Condition_AbilityProperty				AbilityCondition;
	local X2Effect_GrantActionPoints				ActionPointEffect;
	local GrimyLoot_DominationCooldown				Cooldown;
	local GrimyLoot_TargetCursor					CursorTarget;
	local X2AbilityMultiTarget_Radius				RadiusMultiTarget;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityManager.FindAbilityTemplate('LaunchGrenade');

	CursorTarget = new class'GrimyLoot_TargetCursor';
	CursorTarget.bRestrictToWeaponRange = true;
	AbilityTemplate.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);
	if ( RadiusMultiTarget != none ) {
		RadiusMultiTarget.AddAbilityBonusRadius('GrimyReduceRadius25', -2.5);
		RadiusMultiTarget.AddAbilityBonusRadius('GrimyBonusRadius20', 2.0);
		RadiusMultiTarget.AddAbilityBonusRadius('GrimyBonusRadius10', 1.0);
		RadiusMultiTarget.AddAbilityBonusRadius('GrimyBonusRadius07', 0.75);
		RadiusMultiTarget.AddAbilityBonusRadius('GrimyBonusRadius05', 0.5);
	}
	AbilityTemplate.AbilityMultiTargetStyle = RadiusMultiTarget;

	AbilityTemplate = AbilityManager.FindAbilityTemplate('Soulfire');
	ChargeCost = new class'GrimyLoot_ChargeCost';
	ChargeCost.NumCharges = 1;
	ChargeCost.ReqAbility = 'GrimyBonusSoulfire';
	AbilityTemplate.AbilityCosts.AddItem(ChargeCost);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('Insanity');
	ChargeCost = new class'GrimyLoot_ChargeCost';
	ChargeCost.NumCharges = 1;
	ChargeCost.ReqAbility = 'GrimyBonusInsanity';
	AbilityTemplate.AbilityCosts.AddItem(ChargeCost);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('VoidRift');
	ChargeCost = new class'GrimyLoot_ChargeCost';
	ChargeCost.NumCharges = 1;
	ChargeCost.ReqAbility = 'GrimyBonusVoidRift';
	AbilityTemplate.AbilityCosts.AddItem(ChargeCost);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('NullLance');
	ChargeCost = new class'GrimyLoot_ChargeCost';
	ChargeCost.NumCharges = 1;
	ChargeCost.ReqAbility = 'GrimyBonusNullLance';
	AbilityTemplate.AbilityCosts.AddItem(ChargeCost);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('Inspire');
	ChargeCost = new class'GrimyLoot_ChargeCost';
	ChargeCost.NumCharges = 1;
	ChargeCost.ReqAbility = 'GrimyBonusInspire';
	AbilityTemplate.AbilityCosts.AddItem(ChargeCost);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyBonusInspire');
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ActionPointEffect.TargetConditions.ADdItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(ActionPointEffect);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('Domination');

	Cooldown = new class'GrimyLoot_DominationCooldown';
	Cooldown.iNumTurns = class'X2Ability_PsiOperativeAbilitySet'.default.DOMINATION_COOLDOWN;
	Cooldown.bDoNotApplyOnHit = true;
	AbilityTemplate.AbilityCooldown = Cooldown;
}

static function UpdateFragGrenades() {
	local X2ItemTemplateManager					ItemManager;
	local X2ItemTemplate						ItemTemplate;
	local array<X2DataTemplate>					DifficultyTemplates;
	local X2DataTemplate						DifficultyTemplate;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemManager.FindDataTemplateAllDifficulties('FragGrenade',DifficultyTemplates);
	foreach DifficultyTemplates(DifficultyTemplate) {
		ItemTemplate = X2ItemTemplate(DifficultyTemplate);
		if ( ItemTemplate != none ) {
			ItemTemplate.HideIfResearched = '';
		}
	}
}

static function UpdateItemColors()
{
	local X2ItemTemplateManager					ItemManager;
	local X2ItemTemplate						ItemTemplate;
	local name									ItemName;
	
	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach class'GrimyLoot_Research'.default.PrimaryAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.PrimaryAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.PrimaryAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.PrimaryAffixFour(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}

	ItemTemplate = ItemManager.FindItemTemplate('GrimyWildcat_Bsc');
	class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	ItemTemplate = ItemManager.FindItemTemplate('GrimyWildcat_Adv');
	class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	ItemTemplate = ItemManager.FindItemTemplate('GrimyWildcat_Sup');
	class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	
	foreach class'GrimyLoot_Research'.default.PistolAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.PistolAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.PistolAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}
	
	foreach class'GrimyLoot_Research'.default.SwordAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.SwordAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.SwordAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}
	
	foreach class'GrimyLoot_Research'.default.GremlinAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.GremlinAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.GremlinAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}

	foreach class'GrimyLoot_Research'.default.GrenadeLauncherAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.GrenadeLauncherAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.GrenadeLauncherAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}
	
	foreach class'GrimyLoot_Research'.default.PsiAmpAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.PsiAmpAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.PsiAmpAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}
	
	foreach class'GrimyLoot_Research'.default.ArmorAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.ArmorAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.ArmorAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.ArmorAffixFour(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}
	
	foreach class'GrimyLoot_Research'.default.BitAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.BitAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.BitAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}
	
	foreach class'GrimyLoot_Research'.default.ChassisAffixOne(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.RARE_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.ChassisAffixTwo(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.EPIC_COLOR);
	}
	foreach class'GrimyLoot_Research'.default.ChassisAffixThree(ItemName) {
		ItemTemplate = ItemManager.FindItemTemplate(ItemName);
		class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(ItemTemplate,class'GrimyLoot_Research'.default.LEGENDARY_COLOR);
	}
}

static function bool IsResearchInHistory(name ResearchName)
{
	// Check if we've already injected the tech templates
	local XComGameState_Tech	TechState;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if ( TechState.GetMyTemplateName() == ResearchName )
		{
			return true;
		}
	}
	return false;
}

static private function UpdateResearch()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2TechTemplate TechTemplate;
	local XComGameState_Tech TechState;
	local X2StrategyElementTemplateManager	StratMgr;
	local array<Name> ResearchNames;
	local Name ResearchName;
	
	//In this method, we demonstrate functionality that will add ExampleWeapon to the player's inventory when loading a saved
	//game. This allows players to enjoy the content of the mod in campaigns that were started without the mod installed.
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	History = `XCOMHISTORY;	

	//Create a pending game state change
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Research GameStates");

	ResearchNames.AddItem('Tech_IdentifyRareLockbox');
	ResearchNames.AddItem('Tech_IdentifyEpicLockbox');
	ResearchNames.AddItem('Tech_IdentifyLegendaryLockbox');
	ResearchNames.AddItem('Tech_IdentifyEpicLockboxInstant');
	ResearchNames.AddItem('Tech_IdentifyLegendaryLockboxInstant');

	foreach ResearchNames(ResearchName) {
		if ( !IsResearchInHistory(ResearchName) ) {
			TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate(ResearchName));
			TechState = XComGameState_Tech(NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate));
			NewGameState.AddStateObject(TechState);
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0) {
		`GAMERULES.SubmitGameState(NewGameState);
	}
	else {
		History.CleanupPendingGameState(NewGameState);
	}
}

exec function GrimyLootOpenLockbox(EGearType GearType, ELockboxRarity Rarity)
{
	class'GrimyLoot_Research'.static.IdentifyByIndex(none, GearType, Rarity);
}

exec function GrimyLootUpdateResearch()
{
	UpdateResearch();
}

exec function GiveItemNickname(string SoldierName, string Nickname, optional string HexColor, optional int SlotNum = 2)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;
	local int idx;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Turn Solier Into Class Cheat");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	for (idx = 0; idx < XComHQ.Crew.Length; idx++) {
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
				
		if (UnitState.GetFullName() == SoldierName ) {
			ItemState = UnitState.GetItemInSlot(EInventorySlot(SlotNum));

			ItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
			NewGameState.AddStateObject(ItemState);

			if ( HexColor == "" ) {
				ItemState.Nickname = NickName;
			}
			else {
				ItemState.Nickname = "<font color='#" $ HexColor $ "'><b>" $ Nickname $ "</b></font>";
			}
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0) {
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else {
		History.CleanupPendingGameState(NewGameState);
	}	
}

exec function UpgradeItemsForSchematic(string SchematicName)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Grimy Upgrade Items Cheat");
	XComHQ.UpgradeItems(NewGameState, name(SchematicName));

	if (NewGameState.GetNumGameStateObjects() > 0) {
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else {
		History.CleanupPendingGameState(NewGameState);
	}	
}

exec function GrimyLootLogLootStore()
{
	local XComGameState_GLootStore LootStoreState;
	local XComGameState_BaseObject ObjectState;

	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();

	if ( LootStoreState.ObjectID == 0 )
	{
		`Log("LootStoreState not created yet!");
		return;
	}

	`Log("Found LootStoreState. ObjectID:" @ LootStoreState.ObjectID);

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_BaseObject', ObjectState,,true)
	{
		if ( LootStoreState.DoesObjectIDHaveEntry(ObjectState.ObjectID) )
			`Log("Found Object ID:" @ ObjectState.ObjectID $ ", NumUpgradeSlots:" @ LootStoreState.GetNumUpgradeSlotsByOwnerID(ObjectState.ObjectID) $ ", TradingPostValue:" @ LootStoreState.GetTradingPostValueByOwnerID(ObjectState.ObjectID));
	}
}

exec function GrimyLootBuildLootStoreFromHistory()
{
	class'X2Utilities_GsLoot'.static.AddExistingGameStatesToLootStore();
}

static function UpdateInventoryCategoryImages()
{
	local X2ItemTemplateManager ItemMgr;
	local array<X2WeaponTemplate> AllWeaponTemplates;
	local array<X2EquipmentTemplate> AllArmorTemplates;
	local array<X2WeaponUpgradeTemplate> AllUpgradeTemplates;
	local X2WeaponTemplate ThisWeaponTemplate;
	local X2EquipmentTemplate ThisArmorTemplate;
	local X2WeaponUpgradeTemplate ThisUpgradeTemplate;
	local string InventoryImage, InventoryCategoryIcon, CreationClassName;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	AllWeaponTemplates = ItemMgr.GetAllWeaponTemplates();
	AllArmorTemplates = ItemMgr.GetAllArmorTemplates();
	AllUpgradeTemplates = ItemMgr.GetAllUpgradeTemplates();
	
	InventoryCategoryIcon = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery";

	foreach AllUpgradeTemplates(ThisUpgradeTemplate)
	{
		CreationClassName = string(ThisUpgradeTemplate.ClassThatCreatedUs.class);

		if ( InStr(CreationClassName, "GrimyLoot_") == -1)
		{
			continue;
		}

		InventoryImage = ThisUpgradeTemplate.UpgradeAttachments[0].InventoryIconName;

		if ( InStr(CreationClassName, "Armor") > -1)
		{
			foreach AllArmorTemplates(ThisArmorTemplate)
			{
				if (X2ArmorTemplate(ThisArmorTemplate) != none)
				{
					ThisUpgradeTemplate.AddUpgradeAttachment('', '', "", "", ThisArmorTemplate.DataName, , "", InventoryImage, InventoryCategoryIcon);
				}
			}
		}

		else if ( InStr(CreationClassName, "Secondary") > -1)
		{
			foreach AllWeaponTemplates(ThisWeaponTemplate)
			{
				// only give secondary upgrades images for their respective secondaries
				// lump sword and psi-amp together because tearing them apart would require more checks and this is convoluted enough already
				if ((X2GremlinTemplate(ThisWeaponTemplate) != none && (InStr(string(ThisUpgradeTemplate.DataName), "Gremlin") > -1 || InStr(string(ThisUpgradeTemplate.DataName), "Bit") > -1))
					|| (ThisWeaponTemplate.iRange == 0 && (InStr(string(ThisUpgradeTemplate.DataName), "Sword") > -1 || InStr(string(ThisUpgradeTemplate.DataName), "PsiAmp") > -1))
					|| (X2GrenadeLauncherTemplate(ThisWeaponTemplate) != none && InStr(string(ThisUpgradeTemplate.DataName), "GrenadeLauncher") > -1)
					|| ((ThisWeaponTemplate.WeaponCat == 'pistol' || ThisWeaponTemplate.WeaponCat == 'sidearm') && InStr(string(ThisUpgradeTemplate.DataName), "Pistol") > -1))
				{
					ThisUpgradeTemplate.AddUpgradeAttachment('', '', "", "", ThisWeaponTemplate.DataName, , "", InventoryImage, InventoryCategoryIcon);
				}
			}
		}

		else
		{
			// primary weapons don't discriminate amongst each other for upgrade availability on primaries, but they don't want to be put on non-primaries
			// theres other things like the sawn-off shotguns that shouldn't accept ammo upgrades, but i honestly don't care anymore. these are just images
			foreach AllWeaponTemplates(ThisWeaponTemplate)
			{
				if ((X2GremlinTemplate(ThisWeaponTemplate) != none && (InStr(string(ThisUpgradeTemplate.DataName), "Gremlin") > -1 || InStr(string(ThisUpgradeTemplate.DataName), "Bit") > -1))
					|| (ThisWeaponTemplate.iRange == 0 && (InStr(string(ThisUpgradeTemplate.DataName), "Sword") > -1 || InStr(string(ThisUpgradeTemplate.DataName), "PsiAmp") > -1))
					|| (X2GrenadeLauncherTemplate(ThisWeaponTemplate) != none && InStr(string(ThisUpgradeTemplate.DataName), "GrenadeLauncher") > -1)
					|| ((ThisWeaponTemplate.WeaponCat == 'pistol' || ThisWeaponTemplate.WeaponCat == 'sidearm') && InStr(string(ThisUpgradeTemplate.DataName), "Pistol") > -1))
				{
					continue;
				}

				ThisUpgradeTemplate.AddUpgradeAttachment('', '', "", "", ThisWeaponTemplate.DataName, , "", InventoryImage, InventoryCategoryIcon);
			}
		}
	}
}

static function OnPostLootTablesCreated()
{
	local LootTable				CurrentLoot, EmptyLoot;
	local array<LootTableEntry>	CurrentEntries;
	local LootTableEntry		CurrentEntry, DefaultItemEntry;
	local array<name>			CurrentList, CurrentListBsc, CurrentListAdv, CurrentListSup;
	local name					CurrentUpgradeName, CurrentLootName, TableToAddTo;
	local array<UpgradeSetup>	CurrentSetups;
	local UpgradeSetup			CurrentSetup;
	local int					idx, jdx, TableChance, CurrentLootChance;
	local int					PrimaryChance, PistolChance, SwordChance;
	local int					GremlinChance, BitChance, GrenadeLauncherChance;
	local int					PsiAmpChance, ArmorChance, ChassisChance;

	DefaultEntry.Chance = 1;
	DefaultEntry.ChanceModPerExistingItem = class'X2Utilities_GsLoot'.default.CHANCE_MOD_PER_EXISTING_UPGRADE;
	DefaultEntry.MinCount = 1;
	DefaultEntry.MaxCount = 1;
	DefaultEntry.RollGroup = 1; //upgrades have their own tables, upgrade tables should use same group as vanilla upgrades
	TableChance = class'X2Utilities_GsLoot'.default.TABLE_CHANCE;
	PrimaryChance = class'X2Utilities_GsLoot'.default.PRIMARY_UPGRADE_DROP_CHANCE;
	PistolChance = class'X2Utilities_GsLoot'.default.PISTOL_UPGRADE_DROP_CHANCE;
	SwordChance = class'X2Utilities_GsLoot'.default.SWORD_UPGRADE_DROP_CHANCE;
	GremlinChance = class'X2Utilities_GsLoot'.default.GREMLIN_UPGRADE_DROP_CHANCE;
	BitChance = class'X2Utilities_GsLoot'.default.BIT_UPGRADE_DROP_CHANCE;
	GrenadeLauncherChance = class'X2Utilities_GsLoot'.default.GRENADELAUNCHER_UPGRADE_DROP_CHANCE;
	PsiAmpChance = class'X2Utilities_GsLoot'.default.PSIAMP_UPGRADE_DROP_CHANCE;
	ArmorChance = class'X2Utilities_GsLoot'.default.ARMOR_UPGRADE_DROP_CHANCE;
	ChassisChance = class'X2Utilities_GsLoot'.default.CHASSIS_UPGRADE_DROP_CHANCE;

	for (idx = 0; idx < 9, ++idx) // 9 categories of upgrades
	{
		if (idx == 0)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.PRIMARY_UPGRADE_SETUPS;
			CurrentLootName = 'PrimaryUpgrades';
			CurrentLootChance = PrimaryChance;
		}
		else if (idx == 1)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.PISTOL_UPGRADE_SETUPS;
			CurrentLootName = 'PistolUpgrades';
			CurrentLootChance = PistolChance;
		}
		else if (idx == 2)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.SWORD_UPGRADE_SETUPS;
			CurrentLootName = 'SwordUpgrades';
			CurrentLootChance = SwordChance;
		}
		else if (idx == 3)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.GREMLIN_UPGRADE_SETUPS;
			CurrentLootName = 'GremlinUpgrades';
			CurrentLootChance = GremlinChance;
		}
		else if (idx == 4)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.BIT_UPGRADE_SETUPS;
			CurrentLootName = 'BitUpgrades';
			CurrentLootChance = BitChance;
		}
		else if (idx == 5)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.GRENADELAUNCHER_UPGRADE_SETUPS;
			CurrentLootName = 'GrenadeLauncherUpgrades';
			CurrentLootChance = GrenadeLauncherChance;
		}
		else if (idx == 6)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.PSIAMP_UPGRADE_SETUPS;
			CurrentLootName = 'PsiAmpUpgrades';
			CurrentLootChance = PsiAmpChance;
		}
		else if (idx == 7)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.ARMOR_UPGRADE_SETUPS;
			CurrentLootName = 'ArmorUpgrades';
			CurrentLootChance = ArmorChance;
		}
		else if (idx == 8)
		{
			CurrentSetups = class'X2Item_GrimyUpgrades'.default.CHASSIS_UPGRADE_SETUPS;
			CurrentLootName = 'ChassisUpgrades';
			CurrentLootChance = ChassisChance;
		}

		foreach CurrentSetups(CurrentSetup)
		{
			if (InStr(string(CurrentSetup.UpgradeName), "_Bsc") != INDEX_NONE)
				CurrentListBsc.AddItem(CurrentSetup.UpgradeName);
			else if (InStr(string(CurrentSetup.UpgradeName), "_Adv") != INDEX_NONE)
				CurrentListAdv.AddItem(CurrentSetup.UpgradeName);
			else if (InStr(string(CurrentSetup.UpgradeName), "_Sup") != INDEX_NONE)
				CurrentListSup.AddItem(CurrentSetup.UpgradeName);
		}

		for (jdx = 0; jdx < 3; ++jdx) // 3 tiers of upgrades
		{
			TablesToAddTo.Length = 0;

			if (jdx == 0)
			{
				CurrentList = CurrentListBsc;
				CurrentLootName = name(string(CurrentLootName) $ "Basic");
				TableToAddTo = 'BasicWeaponUpgrades';
			}
			else if (jdx == 1)
			{
				CurrentList = CurrentListAdv;
				CurrentLootName = name(string(CurrentLootName) $ "Advanced");
				TableToAddTo = 'AdvancedWeaponUpgrades';
			}
			else if (jdx == 2)
			{
				CurrentList = CurrentListSup;
				CurrentLootName = name(string(CurrentLootName) $ "Superior");
				TableToAddTo = 'SuperiorWeaponUpgrades';
			
			}

			CurrentLoot = EmptyLoot;
			CurrentLoot.TableName = CurrentLootName;

			foreach CurrentList(CurrentUpgradeName)
			{
				CurrentEntry = DefaultEntry;
				CurrentEntry.TemplateName = CurrentUpgradeName;
				CurrentLoot.Loots.AddItem(CurrentEntry);
			}
			
			class'X2LootTableManager'.static.RecalculateLootTableChanceStatic(CurrentLootName);
			CurrentEntry = DefaultEntry;
			CurrentEntry.Chance = CurrentLootChance;
			CurrentEntry.ChanceModPerExistingItem = 1.0f;
			CurrentEntry.TableRef = CurrentLootName;
			class'X2LootTableManager'.static.AddEntryStatic(TableToAddTo, CurrentEntry, false);
		}
	}
	
	class'X2LootTableManager'.static.RecalculateLootTableChanceStatic('BasicWeaponUpgrades');
	class'X2LootTableManager'.static.RecalculateLootTableChanceStatic('AdvancedWeaponUpgrades');
	class'X2LootTableManager'.static.RecalculateLootTableChanceStatic('SuperiorWeaponUpgrades');
	
	CurrentEntry = DefaultEntry;
	CurrentEntry.Chance = class'X2Utilities_GsLoot'.default.EARLY_LOCKBOX_CHANCE;
	CurrentEntry.RollGroup = 5;
	CurrentEntry.TableRef = class'X2Utilities_GsLoot'.default.EARLY_LOCKBOXES;
	class'X2LootTableManager'.static.AddEntryStatic('ADVENTEarlyTimedLoot', CurrentEntry, false);

	CurrentEntry = DefaultEntry;
	CurrentEntry.Chance = class'X2Utilities_GsLoot'.default.MID_LOCKBOX_CHANCE;
	CurrentEntry.RollGroup = 6;
	CurrentEntry.TableRef = class'X2Utilities_GsLoot'.default.MID_LOCKBOXES;
	class'X2LootTableManager'.static.AddEntryStatic('ADVENTMidTimedLoot', CurrentEntry, false);

	CurrentEntry = DefaultEntry;
	CurrentEntry.Chance = class'X2Utilities_GsLoot'.default.LATE_LOCKBOX_CHANCE;
	CurrentEntry.RollGroup = 6;
	CurrentEntry.TableRef = class'X2Utilities_GsLoot'.default.LATE_LOCKBOXES;
	class'X2LootTableManager'.static.AddEntryStatic('ADVENTLateTimedLoot', CurrentEntry, false);
}