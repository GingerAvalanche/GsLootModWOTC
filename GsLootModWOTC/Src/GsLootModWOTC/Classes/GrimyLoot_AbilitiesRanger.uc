class GrimyLoot_AbilitiesRanger extends X2Ability_RangerAbilitySet;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// ranger abilities, placed here for convenience
	Templates.AddItem(GrimyBaseRapidFire(1,'GrimyRapidFireOne'));
	Templates.AddItem(GrimyBaseRapidFire(2,'GrimyRapidFireTwo'));
	Templates.AddItem(GrimyBaseRapidFire(3,'GrimyRapidFireThree'));
	Templates.AddItem(GrimyChargeRunAndGun(1,'GrimyRunAndGunOne'));
	Templates.AddItem(GrimyChargeRunAndGun(2,'GrimyRunAndGunTwo'));
	Templates.AddItem(GrimyChargeRunAndGun(3,'GrimyRunAndGunThree'));

	// sword abilities
	Templates.AddItem(GrimyAbilityCharges(1,'GrimyChargeConcealOne', 'Stealth'));
	Templates.AddItem(GrimyAbilityCharges(2,'GrimyChargeConcealTwo', 'Stealth'));
	Templates.AddItem(GrimyAbilityCharges(3,'GrimyChargeConcealThree', 'Stealth'));

	// gremlin abilities, placed here for convenience
	Templates.AddItem(GrimyAbilityCharges(1,'GrimyChargeCombatProtocolOne', 'CombatProtocol'));
	Templates.AddItem(GrimyAbilityCharges(2,'GrimyChargeCombatProtocolTwo', 'CombatProtocol'));
	Templates.AddItem(GrimyAbilityCharges(3,'GrimyChargeCombatProtocolThree', 'CombatProtocol'));
	Templates.AddItem(GrimyAbilityCharges(1,'GrimyChargeMjolnirOne', 'CapacitorDischarge'));
	Templates.AddItem(GrimyAbilityCharges(2,'GrimyChargeMjolnirTwo', 'CapacitorDischarge'));
	Templates.AddItem(GrimyAbilityCharges(3,'GrimyChargeMjolnirThree', 'CapacitorDischarge'));
	Templates.AddItem(GrimyAbilityCharges(1,'GrimyChargeScanningOne', 'ScanningProtocol'));
	Templates.AddItem(GrimyAbilityCharges(2,'GrimyChargeScanningTwo', 'ScanningProtocol'));
	Templates.AddItem(GrimyAbilityCharges(3,'GrimyChargeScanningThree', 'ScanningProtocol'));

	Templates.AddItem(GrimyChargeRapidSlash(1,'GrimyRapidSlashOne'));
	Templates.AddItem(GrimyChargeRapidSlash(2,'GrimyRapidSlashTwo'));
	Templates.AddItem(GrimyChargeRapidSlash(3,'GrimyRapidSlashThree'));
	Templates.AddItem(GrimyChargeReaper(0,2,'GrimyReaperOne'));
	Templates.AddItem(GrimyChargeReaper(1,2,'GrimyReaperTwo'));
	Templates.AddItem(GrimyChargeReaper(2,2,'GrimyReaperThree'));
	Templates.AddItem(GrimyConviction('GrimyConviction'));
	Templates.AddItem(GrimyArmorUp(2,2,'GrimyLongCrusade_BscSword'));
	Templates.AddItem(GrimyArmorUp(3,2,'GrimyLongCrusade_AdvSword'));
	Templates.AddItem(GrimyArmorUp(4,2,'GrimyLongCrusade_SupSword'));

	return Templates;
}

// #######################################################################################
// -------------------- PRIMARY ABILITY TEMPLATES ----------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyChargeRunAndGun(int BonusCharges, name TemplateName)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;

	Template = RunAndGunAbility(TemplateName);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	return Template;
}

// #######################################################################################
// -------------------- SWORD ABILITY TEMPLATES ------------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyChargeRapidSlash(int BonusCharges, name TemplateName)
{
	local X2AbilityTemplate                 Template;
	local GrimyLoot_AbilityCost_Rapid		ActionPointCost;

	Template = AddSwordSliceAbility(TemplateName);

	Template.AbilityCosts.length = 0;

	ActionPointCost = new class'GrimyLoot_AbilityCost_Rapid';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.RefundActionPoint = 'standard';
	Template.AbilityCosts.AddItem(ActionPointCost);

	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	return Template;
}

static function X2AbilityTemplate GrimyArmorUp(int Bonus, int MaxBonus, name TemplateName)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	Template = AddSwordSliceAbility(TemplateName);
	
	Template.OverrideAbilities.additem(default.SwordSliceName);
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Bonus, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, MaxBonus);
	Template.AddShooterEffect(PersistentStatChangeEffect);

	return Template;
}

static function X2AbilityTemplate GrimyChargeReaper(int bonusDamage, int Bonus, name TemplateName)
{
	local X2AbilityTemplate				Template;
	local GrimyLoot_Effect_DeathsHand	ReaperEffect;
	
	Template = GrimyBaseReaper(TemplateName);

	Template.OverrideAbilities.additem('Reaper');

	ReaperEffect = new class'GrimyLoot_Effect_DeathsHand';
	ReaperEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	ReaperEffect.Bonus = Bonus;
	ReaperEffect.BonusDamage = BonusDamage;
	ReaperEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(ReaperEffect);

	return Template;
}

static function X2AbilityTemplate GrimyAbilityCharges(int BonusCharges, name TemplateName, name AbilityName) {
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_SetAbilityCharges	AbilityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	AbilityEffect = new class'GrimyLoot_Effect_SetAbilityCharges';
	AbilityEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	AbilityEffect.AbilityName = AbilityName;
	AbilityEffect.BonusCharges = BonusCharges;
	Template.AddTargetEffect(AbilityEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyConviction(name TemplateName)
{
	local X2AbilityTemplate                 Template;
	local GrimyLoot_AbilityCost_Stunned		ActionPointCost;

	Template = AddSwordSliceAbility(TemplateName);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Template.OverrideAbilities.additem(default.SwordSliceName);

	Template.AbilityCosts.length = 0;

	ActionPointCost = new class'GrimyLoot_AbilityCost_Stunned';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.RefundActionPoint = 'standard';
	Template.AbilityCosts.AddItem(ActionPointCost);

	return Template;
}

// UTILITY FUNCTIONS

static function X2AbilityTemplate GrimyBaseRapidFire(int BonusCharges, name TemplateName)
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//  require 2 ammo to be present so that both shots can be taken
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	//  actually charge 1 ammo for this shot. the 2nd shot will charge the extra ammo.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.RAPIDFIRE_AIM;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_rapidfire";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('RapidFire2');
	Template.PostActivationEvents.AddItem('RapidFire2');

	Template.bCrossClassEligible = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'RapidFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'RapidFire'

	return Template;
}

static function X2AbilityTemplate GrimyBaseReaper(name TemplateName)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_Reaper               ReaperEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reaper";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.REAPER_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	SuperKillRestrictions(Template, 'Reaper_SuperKillCheck');
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'Reaper';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}