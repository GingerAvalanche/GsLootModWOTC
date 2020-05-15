class GrimyLoot_AbilitiesSharpshooter extends X2Ability_SharpshooterAbilitySet;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Sniper abilities
	Templates.AddItem(GrimyBaseKillZone(1,'GrimyKillZoneOne'));
	Templates.AddItem(GrimyBaseSerial(1,'GrimySerialOne'));
	Templates.AddItem(GrimyBaseSerial(2,'GrimySerialTwo'));
	Templates.AddItem(GrimyBaseSerial(3,'GrimySerialThree'));
	// pistol abilities
	Templates.AddItem(GrimyBaseFaceoff(1,'GrimyFaceoffOne'));
	Templates.AddItem(GrimyBaseFaceoff(2,'GrimyFaceoffTwo'));
	Templates.AddItem(GrimyBaseFaceoff(3,'GrimyFaceoffThree'));
	Templates.AddItem(GrimyBaseFanFire(1,'GrimyFanFireOne'));
	Templates.AddItem(GrimyBaseFanFire(2,'GrimyFanFireTwo'));
	Templates.AddItem(GrimyBaseFanFire(3,'GrimyFanFireThree'));
	Templates.AddItem(GrimyBaseLightningHands(0,'GrimyLightningHandsZero'));

	return Templates;
}

// #######################################################################################
// -------------------- SNIPER ABILITY TEMPLATES -----------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyBaseKillZone(int BonusCharges, name TemplateName, bool bDisplayZone=false)
{
	local X2AbilityTemplate             Template;
	local X2AbilityCooldown             Cooldown;
	local X2AbilityCost_Ammo            AmmoCost;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityMultiTarget_Cone     ConeMultiTarget;
	local X2Effect_ReserveActionPoints  ReservePointsEffect;
	local X2Effect_MarkValidActivationTiles MarkTilesEffect;
	local X2Condition_UnitEffects           SuppressedCondition;
	local X2Effect_Persistent			KillZoneEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 2;
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	ActionPointCost.DoNotConsumeAllEffects.Length = 0;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_SkirmisherInterrupt'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = 32 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = 60 * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
	ReservePointsEffect.ReserveType = default.KillZoneReserveType;
	Template.AddShooterEffect(ReservePointsEffect);

	MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
	MarkTilesEffect.AbilityToMark = 'KillZoneShot';
	MarkTilesEffect.bVisualizeFlagsOnCursor = bDisplayZone;
	Template.AddShooterEffect(MarkTilesEffect);

	if (bDisplayZone)
	{
		// Add persistent effect on shooter to be able to have a callback on load, 
		// so the pathing pawn is notified to display a flag on Killzone tiles on load.
		KillZoneEffect = new class'X2Effect_Persistent';
		KillZoneEffect.EffectName = 'KillZoneSource';
		KillZoneEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
		Template.AddShooterEffect(KillZoneEffect);
	}

	Template.AdditionalAbilities.AddItem('KillZoneShot');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_killzone";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Defensive;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.ActivationSpeech = 'KillZone';

	Template.bCrossClassEligible = true;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate GrimyBaseSerial(int BonusCharges, name TemplateName)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_Serial               SerialEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_InTheZone";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 2;
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	class'X2Ability_RangerAbilitySet'.static.SuperKillRestrictions(Template, 'Serial_SuperKillCheck');
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SerialEffect = new class'X2Effect_Serial';
	SerialEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	SerialEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(SerialEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'InTheZone';
	Template.bCrossClassEligible = true;
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// #######################################################################################
// -------------------- PISTOL ABILITY TEMPLATES -----------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyBaseFaceoff(int BonusCharges, name TemplateName)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityMultiTarget_AllUnits		MultiTargetUnits;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_faceoff";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = ToHitCalc;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	//Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetUnits = new class'X2AbilityMultiTarget_AllUnits';
	MultiTargetUnits.bUseAbilitySourceAsPrimaryTarget = true;
	Template.AbilityMultiTargetStyle = MultiTargetUnits;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	//Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Faceoff_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Faceoff'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'Faceoff';
//END AUTOGENERATED CODE: Template Overrides 'Faceoff'

	return Template;
}

static function X2AbilityTemplate GrimyBaseFanFire(int BonusCharges, name TemplateName)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fanfire";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	Template.AddShooterEffectExclusions();

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.CinescriptCameraType = "StandardGunFiring";

	// Voice events
	Template.ActivationSpeech = 'FanFire';

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'FanFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'FanFire'

	return Template;	
}

static function X2AbilityTemplate GrimyBaseLightningHands(int BonusCharges, name TemplateName)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.OverrideAbilities.AddItem('LightningHands');
	
	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightninghands";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'LightningHands'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'LightningHands';
//END AUTOGENERATED CODE: Template Overrides 'LightningHands'

	return Template;
}