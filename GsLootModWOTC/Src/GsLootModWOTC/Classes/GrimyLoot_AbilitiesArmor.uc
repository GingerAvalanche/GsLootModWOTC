class GrimyLoot_AbilitiesArmor extends X2Ability dependson (XComGameStateContext_Ability);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(GrimyOnHitResult('GrimyTacticalSensors5',-5, eHit_Success,8));
	Templates.AddItem(GrimyOnHitResult('GrimyTacticalSensors10',-10, eHit_Success,8));
	Templates.AddItem(GrimyOnHitResult('GrimyTacticalSensors15',-15, eHit_Success,8));
	
	Templates.AddItem(GrimyOnHitResult('GrimyReactiveSensors15',0, eHit_Success,0,-5,3));
	Templates.AddItem(GrimyOnHitResult('GrimyReactiveSensors20',0, eHit_Success,0,-5,4));
	Templates.AddItem(GrimyOnHitResult('GrimyReactiveSensors25',0, eHit_Success,0,-5,5));

	Templates.AddItem(GrimyOnHitResult('GrimyReduceCrit5',-5, eHit_Crit));
	Templates.AddItem(GrimyOnHitResult('GrimyReduceCrit10',-10, eHit_Crit));
	Templates.AddItem(GrimyOnHitResult('GrimyReduceCrit15',-15, eHit_Crit));

	Templates.AddItem(GrimyBonusDodge('GrimyIncreaseDodge10',10));
	Templates.AddItem(GrimyBonusDodge('GrimyIncreaseDodge20',20));

	Templates.AddItem(GrimyBonusArmor('GrimyBonusArmor1',1));

	Templates.AddItem(GrimyResistExplosion('GrimyResistExplosion50',0.5));
	Templates.AddItem(GrimyResistExplosion('GrimyResistExplosion70',0.7));
	Templates.AddItem(GrimyResistExplosion('GrimyResistExplosion90',0.9));

	Templates.AddItem(GrimyResistType('GrimyResistMag20',0.2,'Projectile_MagAdvent'));
	Templates.AddItem(GrimyResistType('GrimyResistMag25',0.25,'Projectile_MagAdvent'));
	Templates.AddItem(GrimyResistType('GrimyResistMag30',0.3,'Projectile_MagAdvent'));

	Templates.AddItem(GrimyResistType('GrimyResistBeam20',0.2,'Projectile_BeamAlien'));
	Templates.AddItem(GrimyResistType('GrimyResistBeam25',0.25,'Projectile_BeamAlien'));
	Templates.AddItem(GrimyResistType('GrimyResistBeam30',0.3,'Projectile_BeamAlien'));

	Templates.AddItem(GrimyBonusHitPoints('GrimyHitPoint1',1));
	Templates.AddItem(GrimyBonusHitPoints('GrimyHitPoint2',2));
	Templates.AddItem(GrimyBonusHitPoints('GrimyHitPoint3',3));

	Templates.AddItem(GrimyBonusShieldPoints('GrimyShieldPoint1',1));
	Templates.AddItem(GrimyBonusShieldPoints('GrimyShieldPoint2',2));
	Templates.AddItem(GrimyBonusShieldPoints('GrimyShieldPoint3',3));
	Templates.AddItem(GrimyBonusShieldPoints('GrimyShieldPoint4',4));

	Templates.AddItem(GrimyBonusDetectionRadius('GrimyDetectionModifier10',0.1));
	Templates.AddItem(GrimyBonusDetectionRadius('GrimyDetectionModifier20',0.2));
	Templates.AddItem(GrimyBonusDetectionRadius('GrimyDetectionModifier30',0.3));

	Templates.AddItem(GrimyChargeCombatStims('GrimyStimplant3', 3, 3, 1, 1));
	Templates.AddItem(GrimyChargeCombatStims('GrimyStimplant4', 3, 4, 1, 1));
	Templates.AddItem(GrimyChargeCombatStims('GrimyStimplant5', 3, 5, 1, 1));

	Templates.AddItem(GrimyReturnStandardShot('GrimyReturnShot'));
	Templates.AddItem(GrimyShieldGate('GrimyShieldGate'));

	Templates.AddItem(GrimyBonusOverwatchAim('GrimyBonusOverwatch5',5));
	Templates.AddItem(GrimyBonusOverwatchAim('GrimyBonusOverwatch10',10));
	Templates.AddItem(GrimyBonusOverwatchAim('GrimyBonusOverwatch15',15));

	Templates.AddItem(GrimyAbsorptionField('GrimyAbsorption30',0.3));
	Templates.AddItem(GrimyAbsorptionField('GrimyAbsorption35',0.35));
	Templates.AddItem(GrimyAbsorptionField('GrimyAbsorption40',0.4));

	Templates.AddItem(GrimyChargeShield('GrimyShieldBattery1',1,5,3));
	Templates.AddItem(GrimyChargeShield('GrimyShieldBattery2',2,5,3));
	Templates.AddItem(GrimyChargeShield('GrimyShieldBattery3',3,5,3));

	Templates.AddItem(GrimyChargeSprinter('GrimyLegServos1',1,3,1));
	Templates.AddItem(GrimyChargeSprinter('GrimyLegServos2',2,3,1));
	Templates.AddItem(GrimyChargeSprinter('GrimyLegServos3',3,3,1));

	Templates.AddItem(GrimyHealthRegen('GrimyHealthRegen6', 2, 6));
	Templates.AddItem(GrimyHealthRegen('GrimyHealthRegen8', 2, 8));
	Templates.AddItem(GrimyHealthRegen('GrimyHealthRegen10', 2, 10));

	Templates.AddItem(GrimyInjuredBonus('GrimyInjuredBonus10',10));
	Templates.AddItem(GrimyInjuredBonus('GrimyInjuredBonus15',15));
	Templates.AddItem(GrimyInjuredBonus('GrimyInjuredBonus20',20));
	
	Templates.Additem(GrimyBonusMedikits('GrimyBonusMedikitsOne',1));
	Templates.Additem(GrimyBonusMedikits('GrimyBonusMedikitsTwo',2));
	Templates.Additem(GrimyBonusMedikits('GrimyBonusMedikitsThree',3));
	Templates.Additem(GrimyBonusSmokes('GrimyBonusSmokesOne',1));
	Templates.Additem(GrimyBonusSmokes('GrimyBonusSmokesTwo',2));
	Templates.Additem(GrimyBonusSmokes('GrimyBonusSmokesThree',3));
	Templates.Additem(GrimyBonusScanners('GrimyBonusScannerOne',1));
	Templates.Additem(GrimyBonusScanners('GrimyBonusScannerTwo',2));
	Templates.Additem(GrimyBonusScanners('GrimyBonusScannerThree',3));
	Templates.Additem(GrimyBonusFlashbangs('GrimyBonusFlashbangsOne',1));
	Templates.Additem(GrimyWeaponDamage('GrimyFlashbangDamageOne',1, 'FlashbangGrenade'));
	Templates.Additem(GrimyWeaponDamage('GrimyFlashbangDamageTwo',2, 'FlashbangGrenade'));
	Templates.Additem(GrimyWeaponDamage('GrimyFlashbangDamageThree',3, 'FlashbangGrenade'));

	Templates.AddItem(GrimyDamageImmunity('GrimyFireImmune','Fire'));
	Templates.AddItem(GrimyDamageImmunity('GrimyPoisonImmune','Poison'));
	Templates.AddItem(GrimyDamageImmunity('GrimyAcidImmune','Acid'));

	return Templates;
}

static function X2AbilityTemplate GrimyDamageImmunity(name TemplateName, name DamageType)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_DamageImmunity           DamageImmunity;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.ImmuneTypes.AddItem(DamageType);

	if ( DamageType == 'Poison' )
		DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);

	DamageImmunity.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyOnHitResult(name TemplateName, int Bonus, EAbilityHitResult HitResult, optional int MaxDistance = 0, optional int BonusPerVisible = 0, optional int MaxVisible = 0)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_BonusOnHitResult		DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_BonusOnHitResult';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.Bonus = Bonus;
	DefenseEffect.MaxDistance = MaxDistance;
	DefenseEffect.HitResult = HitResult;
	DefenseEffect.BonusPerVisible = BonusPerVisible;
	DefenseEffect.MaxVisible = MaxVisible;
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyInjuredBonus(name TemplateName, int Bonus)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusHitResult     AimEffect;
	local GrimyLoot_Effect_BonusHitResult    CritEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	AimEffect = new class'GrimyLoot_Effect_BonusHitResult';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = Bonus;
	AimEffect.HitResult = eHit_Success;
	AimEffect.bInjuredOnly = true;
	AimEffect.bAnyWeaponType = true;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(AimEffect);
	
	CritEffect = new class'GrimyLoot_Effect_BonusHitResult';
	CritEffect.BuildPersistentEffect(1, true, false, false);
	CritEffect.Bonus = Bonus;
	CritEffect.HitResult = eHit_Crit;
	CritEffect.bInjuredOnly = true;
	CritEffect.bAnyWeaponType = true;
	CritEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(CritEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusArmor(name TemplateName, int Bonus)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_BonusArmor					DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_BonusArmor';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.BonusArmor = Bonus;
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, Bonus);

	return Template;
}

static function X2AbilityTemplate GrimyResistExplosion(name TemplateName, float Reduction)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_Resistance					DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_Resistance';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.Reduction = Reduction;
	DefenseEffect.bExplosiveOnly = true;
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyResistType(name TemplateName, float Reduction, name DamageType)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_Resistance					DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_Resistance';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.Reduction = Reduction;
	DefenseEffect.DamageType = DamageType;
	DefenseEffect.bDamageTypeOnly = true;
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusDodge(name TemplateName, int Bonus)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, Bonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusHitpoints(name TemplateName, int Bonus)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, Bonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusShieldPoints(name TemplateName, int Bonus)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusDetectionRadius(name TemplateName, float Bonus)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyHealthRegen(name TemplateName, int BonusPerTurn, int MaxBonus)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Regeneration				RegenerationEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Build the regeneration effect
	RegenerationEffect = new class'X2Effect_Regeneration';
	RegenerationEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	RegenerationEffect.HealAmount = BonusPerTurn;
	RegenerationEffect.MaxHealAmount = MaxBonus;
	RegenerationEffect.HealthRegeneratedName = 'StasisVestHealthRegenerated';
	Template.AddTargetEffect(RegenerationEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyAbsorptionField(name TemplateName, float Bonus)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_AbsorptionField					DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_AbsorptionField';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.Reduction = Bonus;
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyShieldGate(name TemplateName)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_ShieldGate					DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_ShieldGate';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusOverwatchAim(name TemplateName, int Bonus)
{
	local X2AbilityTemplate				Template;
	local GrimyLoot_Effect_BonusHitResult     AimEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	AimEffect = new class'GrimyLoot_Effect_BonusHitResult';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = Bonus;
	AimEffect.bOverwatchOnly = true;
	AimEffect.HitResult = eHit_Success;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(AimEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


// #######################################################################################
// -------------------- ACTIVE ARMOR ABILITY TEMPLATES -----------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyChargeSprinter(Name TemplateName, int BonusCharges, int Bonus, int Duration)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargesCost;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	if ( BonusCharges > 0 )
	{
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargesCost = new class'X2AbilityCost_Charges';
		ChargesCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargesCost);
	}

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_runandgun";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'RunAndGun';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = true;
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	return Template;
}

static function X2AbilityTemplate GrimyChargeShield(Name TemplateName, int BonusCharges, int Bonus, int Duration)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargesCost;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	if ( BonusCharges > 0 )
	{
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargesCost = new class'X2AbilityCost_Charges';
		ChargesCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargesCost);
	}

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = true;
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	return Template;
}

static function X2AbilityTemplate GrimyChargeCombatStims(name TemplateName, int Mobility, int BonusArmor, int Duration, int BonusCharges)
{
	local X2AbilityTemplate             Template;
	local GrimyLoot_Effect_BonusArmor          StimEffect;
	local X2Effect_PersistentStatChange StatEffect;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargesCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	if ( BonusCharges > 0 )
	{
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargesCost = new class'X2AbilityCost_Charges';
		ChargesCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargesCost);
	}

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.Hostility = eHostility_Defensive;
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.COMBAT_STIMS_PRIORITY;
	Template.ActivationSpeech = 'CombatStim';
	Template.bShowActivation = true;
	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	StimEffect = new class'GrimyLoot_Effect_BonusArmor';
	StimEffect.BonusArmor = BonusArmor;
	StimEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(StimEffect);

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.EffectName = 'StimStats';
	StatEffect.DuplicateResponse = eDupe_Refresh;
	StatEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	StatEffect.AddPersistentStatChange(eStat_Mobility, Mobility, MODOP_Multiplication);
	Template.AddTargetEffect(StatEffect);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	return Template;
}

static function X2AbilityTemplate GrimyReturnStandardShot(name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFire                   FireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFire';
	FireEffect.AbilityToActivate = 'StandardShot';
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = false;       //  this can only work with pistols, which only sharpshooters have

	return Template;
}

static function X2AbilityTemplate GrimyBonusScanners(name TemplateName, int Bonus)
{
	local X2AbilityTemplate									Template;
	local GrimyLoot_Effect_BonusItemCharges					AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'GrimyLoot_Effect_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = Bonus;
	AmmoEffect.ItemTemplateNames.AddItem('BattleScanner');
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusSmokes(name TemplateName, int Bonus)
{
	local X2AbilityTemplate									Template;
	local GrimyLoot_Effect_BonusItemCharges					AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'GrimyLoot_Effect_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = Bonus;
	AmmoEffect.ItemTemplateNames.AddItem('SmokeGrenade');
	AmmoEffect.ItemTemplateNames.AddItem('SmokeGrenadeMk2');
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusFlashbangs(name TemplateName, int Bonus)
{
	local X2AbilityTemplate									Template;
	local GrimyLoot_Effect_BonusItemCharges					AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'GrimyLoot_Effect_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = Bonus;
	AmmoEffect.ItemTemplateNames.AddItem('FlashbangGrenade');
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusMedikits(name TemplateName, int Bonus)
{
	local X2AbilityTemplate									Template;
	local GrimyLoot_Effect_BonusItemCharges					AmmoEffect;
	local GrimyLoot_Effect_SetAbilityCharges				AbilityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'GrimyLoot_Effect_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = Bonus;
	AmmoEffect.ItemTemplateNames.AddItem('Medikit');
	AmmoEffect.ItemTemplateNames.AddItem('NanoMedikit');
	Template.AddTargetEffect(AmmoEffect);
	
	AbilityEffect = new class'GrimyLoot_Effect_SetAbilityCharges';
	AbilityEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	AbilityEffect.DuplicateResponse = eDupe_Allow;
	AbilityEffect.AbilityName = 'GremlinHeal';
	AbilityEffect.BonusCharges = Bonus;
	Template.AddTargetEffect(AbilityEffect);
	
	AbilityEffect = new class'GrimyLoot_Effect_SetAbilityCharges';
	AbilityEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	AbilityEffect.DuplicateResponse = eDupe_Allow;
	AbilityEffect.AbilityName = 'GremlinStabilize';
	AbilityEffect.BonusCharges = Bonus;
	Template.AddTargetEffect(AbilityEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyWeaponDamage(name TemplateName, int Bonus, name WeaponName)
{
	local X2AbilityTemplate									Template;
	local GrimyLoot_Effect_BonusDamageWeapon				DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	DamageEffect = new class'GrimyLoot_Effect_BonusDamageWeapon';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.DuplicateResponse = eDupe_Allow;
	DamageEffect.Bonus = Bonus;
	DamageEffect.WeaponName = WeaponName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}