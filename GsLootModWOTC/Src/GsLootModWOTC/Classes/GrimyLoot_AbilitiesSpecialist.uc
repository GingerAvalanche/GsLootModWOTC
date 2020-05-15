class GrimyLoot_AbilitiesSpecialist extends X2Ability_SpecialistAbilitySet;

static function array<X2DataTemplate> CreateTemplates() {
	local array<X2DataTemplate> Templates;

	Templates.AddItem(GrimyBlindingProtocol('GrimyBlindingProtocolOne',50,1,1));
	Templates.AddItem(GrimyBlindingProtocol('GrimyBlindingProtocolTwo',50,1,2));
	Templates.AddItem(GrimyBlindingProtocol('GrimyBlindingProtocolThree',50,1,3));
	Templates.AddItem(GrimyTripwireProtocol('GrimyTripwireProtocolOne',4,1,1));
	Templates.AddItem(GrimyTripwireProtocol('GrimyTripwireProtocolTwo',4,1,2));
	Templates.AddItem(GrimyTripwireProtocol('GrimyTripwireProtocolThree',4,1,3));
	Templates.AddItem(GrimyRevivalProtocol('GrimyChargeRevivalOne',1));
	Templates.AddItem(GrimyRevivalProtocol('GrimyChargeRevivalTwo',2));
	Templates.AddItem(GrimyRevivalProtocol('GrimyChargeRevivalThree',3));
	
	//Templates.AddItem(GrimyScanningProtocol('GrimyChargeScanningOne',2,0.0));
	//Templates.AddItem(GrimyScanningProtocol('GrimyChargeScanningTwo',3,10.0));
	//Templates.AddItem(GrimyScanningProtocol('GrimyChargeScanningThree',4,20.0));
	Templates.AddItem(GrimyOverrideProtocol('GrimyChargeOverrideOne',1,1));
	Templates.AddItem(GrimyOverrideProtocol('GrimyChargeOverrideTwo',2,1));
	Templates.AddItem(GrimyOverrideProtocol('GrimyChargeOverrideThree',3,1));
	//Templates.AddItem(GrimyShieldProtocol('GrimyShieldProtocolOne',3,3));
	//Templates.AddItem(GrimyShieldProtocol('GrimyShieldProtocolTwo',4,3));
	//Templates.AddItem(GrimyShieldProtocol('GrimyShieldProtocolThree',5,3));
	Templates.AddItem(GrimyDistortionProtocol('GrimyChargeDistortionOne',1));
	Templates.AddItem(GrimyDistortionProtocol('GrimyChargeDistortionTwo',2));
	Templates.AddItem(GrimyDistortionProtocol('GrimyChargeDistortionThree',3));
	//Templates.AddItem(GrimyTargetingProtocol('GrimyTargetingProtocolOne',10,1));
	//Templates.AddItem(GrimyTargetingProtocol('GrimyTargetingProtocolTwo',15,1));
	//Templates.AddItem(GrimyTargetingProtocol('GrimyTargetingProtocolThree',20,1));

	Templates.AddItem(GrimyMascotProtocol('GrimyChargeMascotOne',1,1));
	Templates.AddItem(GrimyMascotProtocol('GrimyChargeMascotTwo',2,1));
	Templates.AddItem(GrimyMascotProtocol('GrimyChargeMascotThree',3,1));
	//Templates.AddItem(GrimyChargeOverload('GrimyChargeMjolnirOne',2));
	//Templates.AddItem(GrimyChargeOverload('GrimyChargeMjolnirTwo',3));
	//Templates.AddItem(GrimyChargeOverload('GrimyChargeMjolnirThree',4));
	Templates.AddItem(GrimyAegisProtocol('GrimyChargeAegisOne',1,6,4));
	Templates.AddItem(GrimyAegisProtocol('GrimyChargeAegisTwo',2,6,4));
	Templates.AddItem(GrimyAegisProtocol('GrimyChargeAegisThree',3,6,4));
	Templates.Additem(GrimyChargeSquadTargeting('GrimySquadTargetingOne',1,15,1,15));
	Templates.Additem(GrimyChargeSquadTargeting('GrimySquadTargetingTwo',2,15,1,15));
	Templates.Additem(GrimyChargeSquadTargeting('GrimySquadTargetingThree',3,15,1,15));

	return Templates;
}

// #######################################################################################
// -------------------- GREMLIN ABILITY TEMPLATES ----------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyShieldProtocol(name TemplateName, int Bonus, int Duration)
{
	local X2AbilityTemplate                     Template;
	
	Template = PurePassive(TemplateName,,,'eAbilitySource_Item',false);
	
	// Moved to OnPostTemplatesCreated because instantiating a template manager now crashes the game

	return Template;
}

static function X2AbilityTemplate GrimyBlindingProtocol(name TemplateName, int Bonus, int Duration, int BonusCharges)
{
	local X2AbilityTemplate                     Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	
	Template = GrimyBaseCombatProtocol(TemplateName, BonusCharges);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, -Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	return Template;
}

static function X2AbilityTemplate GrimyTripwireProtocol(name TemplateName, int Bonus, int Duration, int BonusCharges)
{
	local X2AbilityTemplate                     Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	
	Template = GrimyBaseCombatProtocol(TemplateName, BonusCharges);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	return Template;
}

static function X2AbilityTemplate GrimyRevivalProtocol(name TemplateName, int BonusCharges)
{
	local X2AbilityTemplate                 Template;

	Template = GrimyBaseRevivalProtocol(TemplateName, BonusCharges);
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');

	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	return Template;
}

static function X2AbilityTemplate GrimyOverrideProtocol(name TemplateName, int BonusCharges, int Duration) {
	local X2AbilityTemplate                     Template;
	local X2AbilityCooldown						AbilityCooldown;
	local X2Effect_DamageImmunity				DamageImmunityEffect;
	
	Template = GrimyBaseAidProtocol(TemplateName, BonusCharges);

	AbilityCooldown = new class'X2AbilityCooldown';
	AbilityCooldown.iNumTurns = 1;
	Template.AbilityCooldown = AbilityCooldown;

	DamageImmunityEffect = new class'X2Effect_DamageImmunity';
	DamageImmunityEffect.DuplicateResponse = eDupe_Refresh;
	DamageImmunityEffect.BuildPersistentEffect(Duration, true, true, , eGameRule_PlayerTurnBegin);
	DamageImmunityEffect.SetDisplayInfo(ePerkBuff_Bonus, class'X2Ability_HackRewards'.default.DamageImmunityName, class'X2Ability_HackRewards'.default.DamageImmunityDesc, "img:///UILibrary_PerkIcons.UIPerk_immunities");
	DamageImmunityEffect.VisualizationFn = class'X2Ability_HackRewards'.static.StatModVisualizationApplied;
	DamageImmunityEffect.EffectRemovedVisualizationFn = class'X2Ability_HackRewards'.static.StatModVisualizationRemoved;
	DamageImmunityEffect.bRemoveWhenTargetDies = true;
	DamageImmunityEffect.RemoveAfterAttackCount = class'X2Ability_HackRewards'.default.Override_Charges;
	DamageImmunityEffect.ImmueTypesAreInclusive = false; // all types of damage prevented

	Template.AddTargetEffect(DamageImmunityEffect);

	return Template;
}

static function X2AbilityTemplate GrimyDistortionProtocol(name TemplateName, int BonusCharges)
{
	local X2AbilityTemplate                     Template;
	
	Template = GrimyBaseCombatProtocol(TemplateName, BonusCharges);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePanickedStatusEffect());

	return Template;
}

static function X2AbilityTemplate GrimyTargetingProtocol(name TemplateName, int Bonus, int Duration)
{
	local X2AbilityTemplate                     Template;

	Template = PurePassive(TemplateName,,,'eAbilitySource_Item',false);
	
	// Moved to OnPostTemplatesCreated because instantiating a template manager now crashes the game

	return Template;
}

static function X2AbilityTemplate GrimyMascotProtocol(name TemplateName, int BonusCharges, int Bonus)
{
	local X2AbilityTemplate                     Template;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_GrantActionPoints			ActionPointEffect;
	
	Template = GrimyBaseAidProtocol(TemplateName, BonusCharges);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = Bonus;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	return Template;
}

static function X2AbilityTemplate GrimyAegisProtocol(name TemplateName, int BonusCharges, int Bonus, int Duration)
{
	local X2AbilityTemplate Template;
	local X2Effect_EnergyShield ShieldedEffect;
	local X2Condition_UnitProperty          HealTargetCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local X2AbilityCharges                  Charges;

	Template = GrimyBaseRestorativeMist(TemplateName);
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');

	// EFFECTS
	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(Duration, false, true, , eGameRule_PlayerTurnEnd);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, Bonus);

	Template.AddShooterEffect(ShieldedEffect);
	Template.AddMultiTargetEffect(ShieldedEffect);
	
	// CONDITIONS
	Template.AbilityMultiTargetConditions.length = 0;

	HealTargetCondition = new class'X2Condition_UnitProperty';
	HealTargetCondition.ExcludeHostileToSource = true;
	HealTargetCondition.ExcludeFriendlyToSource = false;
	HealTargetCondition.ExcludeFullHealth = false;
	HealTargetCondition.RequireSquadmates = true;
	HealTargetCondition.ExcludeDead = false; //See comment below...
	Template.AbilityMultiTargetConditions.AddItem(HealTargetCondition);

	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityMultiTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityMultiTargetConditions.AddItem(UnitEffectsCondition);

	// CHARGES
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = BonusCharges;
	Template.AbilityCharges = Charges;

	return Template;
}

static function X2DataTemplate GrimyChargeSquadTargeting(name TemplateName, int BonusCharges, int Bonus, int Duration, int Radius)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCharges				Charges;
	local X2AbilityCost_Charges			ChargeCost;
	local X2AbilityCooldown				Cooldown;
	local X2Condition_UnitProperty		UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput	InputTrigger;
	local X2Effect_PersistentStatChange	PersistentStatChangeEffect;
	local X2AbilityMultiTarget_Radius	MultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Defensive;

	// This ability is a free action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if ( BonusCharges > 0 ) {
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Multi target
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = Radius;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// The Targets must be within the AOE, LOS, and friendly
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, Bonus);
	Template.AddShooterEffect(PersistentStatChangeEffect);
	Template.AddMultiTargetEffect(PersistentStatChangeEffect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_CritChance, Bonus);
	Template.AddShooterEffect(PersistentStatChangeEffect);
	Template.AddMultiTargetEffect(PersistentStatChangeEffect);
	
	Template.ActivationSpeech = 'ScanningProtocol';
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = SendGremlinToOwnerLocation_BuildGameState;
	Template.BuildVisualizationFn = GremlinScanningProtocol_BuildVisualization;
	Template.CinescriptCameraType = "Specialist_ScanningProtocol";
	
	return Template;
}

// UTILITY FUNCTIONS

static function X2AbilityTemplate GrimyBaseAidProtocol(name TemplateName, int BonusCharges)
{
	local X2AbilityTemplate                     Template;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2Condition_UnitProperty              TargetProperty;
	local X2Condition_UnitEffects               EffectsCondition;
	local X2AbilityCooldown_AidProtocol         Cooldown;
	local X2Effect_ThreatAssessment             CoveringFireEffect;
	local X2Condition_AbilityProperty           AbilityCondition;
	local X2Condition_UnitProperty              UnitCondition;
	local X2AbilityCharges						Charges;
	local X2AbilityCost_Charges					ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	if ( BonusCharges > 0 ) {
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aidprotocol";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown_AidProtocol';
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect('AidProtocol', 'AA_UnitIsImmune');
	EffectsCondition.AddExcludeEffect('MimicBeaconEffect', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.bShowActivation = true;
	
	Template.CustomSelfFireAnim = 'NO_DefenseProtocol';

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'AidProtocol'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'AidProtocol'

	return Template;
}

static function X2AbilityTemplate GrimyBaseCombatProtocol(name TemplateName, int BonusCharges)
{
	local X2AbilityTemplate                     Template;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2Effect_ApplyWeaponDamage            RobotDamage;
	local X2Condition_UnitProperty              RobotProperty;
	local X2Condition_Visibility                VisCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatprotocol";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	
	if ( BonusCharges > 0 ) {
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'CombatProtocol'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'CombatProtocol'

	return Template;
}

static function X2AbilityTemplate GrimyBaseRevivalProtocol(name TemplateName, int BonusCharges)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges                  Charges;
	
	//`Log("GrimyLoot_AbilitiesSpecialist.GrimyBaseRevivalProtocol starting...");

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if ( BonusCharges > 0 ) {
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(new class'X2Condition_RevivalProtocol');

	Template.AddTargetEffect(RemoveAdditionalEffectsForRevivalProtocolAndRestorativeMist());
	Template.AddTargetEffect(new class'X2Effect_RestoreActionPoints');      //  put the unit back to full actions

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_revivalprotocol";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = GremlinSingleTarget_BuildVisualization;

	Template.CustomSelfFireAnim = 'NO_RevivalProtocol';

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'RevivalProtocol'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'RevivalProtocol'

	return Template;
}

static function X2AbilityTemplate GrimyBaseRestorativeMist(name TemplateName)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          HealTargetCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local X2Effect_ApplyMedikitHeal         MedikitHeal;
	local X2AbilityCharges                  Charges;
	local X2AbilityCost_Charges             ChargeCost;
	local X2Effect_RestoreActionPoints      RestoreEffect;
	local X2AbilityMultiTarget_AllAllies	MultiTargetingStyle;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.bLimitTargetIcons = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	//This ability self-targets the specialist, and pulls in everyone on the squad (including the specialist) as multi-targets
	Template.AbilityTargetStyle = default.SelfTarget;
	MultiTargetingStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetingStyle.bAllowSameTarget = true;
	MultiTargetingStyle.NumTargetsRequired = 1; //At least someone must need healing
	Template.AbilityMultiTargetStyle = MultiTargetingStyle;

	//Targets must need healing
	HealTargetCondition = new class'X2Condition_UnitProperty';
	HealTargetCondition.ExcludeHostileToSource = true;
	HealTargetCondition.ExcludeFriendlyToSource = false;
	HealTargetCondition.ExcludeFullHealth = true;
	HealTargetCondition.RequireSquadmates = true;
	HealTargetCondition.ExcludeDead = false; //See comment below...
	HealTargetCondition.ExcludeRobotic = true;      //  restorative mist can't affect robots
	Template.AbilityMultiTargetConditions.AddItem(HealTargetCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityMultiTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityMultiTargetConditions.AddItem(UnitEffectsCondition);


	//Healing effects follow...
	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = class'X2Ability_DefaultAbilitySet'.default.MEDIKIT_PERUSEHP;
	Template.AddMultiTargetEffect(MedikitHeal);	

	RestoreEffect = new class'X2Effect_RestoreActionPoints';
	RestoreEffect.TargetConditions.AddItem(new class'X2Condition_RevivalProtocol');
	Template.AddMultiTargetEffect(RestoreEffect);

	Template.AddMultiTargetEffect(RemoveAdditionalEffectsForRevivalProtocolAndRestorativeMist());
	

	//Typical path to build gamestate, but a (very crazy) special-case visualization
	Template.BuildNewGameStateFn = SendGremlinToOwnerLocation_BuildGameState;
	Template.BuildVisualizationFn = GremlinRestoration_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_restorative_mist";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.HideErrors.AddItem('AA_ValueCheckFailed');
	Template.Hostility = eHostility_Defensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';

	Template.ActivationSpeech = 'RestorativeMist';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'RestorativeMist'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'RestorativeMist'

	return Template;
}