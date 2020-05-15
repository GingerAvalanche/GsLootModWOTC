class GrimyLoot_AbilitiesSpark extends X2Ability_DefaultAbilitySet dependson (XComGameStateContext_Ability);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	if ( HasDLC3() ) {
		Templates.AddItem(GrimyOverdrive('GrimyOverdriveOne',2,1,0));
		Templates.AddItem(GrimyOverdrive('GrimyOverdriveTwo',2,2,0));
		Templates.AddItem(GrimyOverdrive('GrimyOverdriveThree',2,3,0));

		Templates.AddItem(class'GrimyLoot_AbilitiesRanger'.static.GrimyAbilityCharges(1,'GrimyChargeBombardOne', 'Bombard'));
		Templates.AddItem(class'GrimyLoot_AbilitiesRanger'.static.GrimyAbilityCharges(2,'GrimyChargeBombardTwo', 'Bombard'));
		Templates.AddItem(class'GrimyLoot_AbilitiesRanger'.static.GrimyAbilityCharges(3,'GrimyChargeBombardThree', 'Bombard'));
		Templates.AddItem(class'GrimyLoot_AbilitiesRanger'.static.GrimyAbilityCharges(1,'GrimyChargeRepairOne', 'Repair'));
		Templates.AddItem(class'GrimyLoot_AbilitiesRanger'.static.GrimyAbilityCharges(2,'GrimyChargeRepairTwo', 'Repair'));
		Templates.AddItem(class'GrimyLoot_AbilitiesRanger'.static.GrimyAbilityCharges(3,'GrimyChargeRepairThree', 'Repair'));
		Templates.AddItem(class'GrimyLoot_AbilitiesSecondary'.static.GrimyBonusHacking(50,'GrimyBonusHacking_50'));
		Templates.AddItem(class'GrimyLoot_AbilitiesSecondary'.static.GrimyBonusHacking(70,'GrimyBonusHacking_70'));
		Templates.AddItem(class'GrimyLoot_AbilitiesSecondary'.static.GrimyBonusHacking(90,'GrimyBonusHacking_90'));
		
		Templates.AddItem(GrimyBonusWeaponAmmo('GrimyRocketAmmo', 1,'RocketLauncher'));
		Templates.AddItem(GrimyBonusWeaponAmmo('GrimyBlasterAmmo', 1,'BlasterLauncher'));
		Templates.AddItem(GrimyBonusWeaponAmmo('GrimyPlasmaAmmo', 1,'PlasmaBlaster'));
		Templates.AddItem(GrimyBonusWeaponAmmo('GrimyFlamethrowerAmmo', 1,'Flamethrower','FlamethrowerMk2'));
		Templates.AddItem(GrimyBonusWeaponAmmo('GrimyShredderAmmo', 1,'ShredderGun','ShredstormCannon'));

		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkRocketLauncherOne',1,'SparkRocketLauncher'));
		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkRocketLauncherTwo',2,'SparkRocketLauncher'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkShredderGunOne',1,'SparkShredderGun'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkShredderGunTwo',2,'SparkShredderGun'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkShredstormCannonOne',1,'SparkShredstormCannon'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkShredstormCannonTwo',2,'SparkShredstormCannon'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkFlamethrowerOne',1,'SparkFlamethrower'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkFlamethrowerTwo',2,'SparkFlamethrower'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkFlamethrowerMk2One',1,'SparkFlamethrowerMk2'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkFlamethrowerMk2Two',2,'SparkFlamethrowerMk2'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkBlasterLauncherOne',1,'SparkBlasterLauncher'));
		//Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkBlasterLauncherTwo',2,'SparkBlasterLauncher'));
		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkPlasmaBlasterOne',1,'SparkPlasmaBlaster'));
		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkPlasmaBlasterTwo',2,'SparkPlasmaBlaster'));

		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkNovaOne',3,'Nova'));
		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkNovaTwo',4,'Nova'));
		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimySparkNovaThree',5,'Nova'));

		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimyStrikeDamageOne',1,'Strike'));
		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimyStrikeDamageTwo',2,'Strike'));
		Templates.AddItem(class'GrimyLoot_AbilitiesPsiOperative'.static.GrimyBonusDamageAbility('GrimyStrikeDamageThree',3,'Strike'));

		Templates.AddItem(PurePassive('GrimySparkPlasmaBlasterWidthOne',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkPlasmaBlasterWidthTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkFlamethrowerWidthOne',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkFlamethrowerWidthTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkShredderRangeTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkShredderRangeFour',,,'eAbilitySource_Item',false));

		Templates.AddItem(PurePassive('GrimySparkSpotterTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkSpotterThree',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkSpotterFour',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkSurvivalOne',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkSurvivalTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkSurvivalThree',,,'eAbilitySource_Item',false));

		Templates.AddItem(PurePassive('GrimySparkSacrificeOne',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkSacrificeTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkSacrificeThree',,,'eAbilitySource_Item',false));
		
		Templates.AddItem(PurePassive('GrimySparkStrangleholdStun',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkStrangleholdDefenseOne',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkStrangleholdDefenseTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkStrangleholdDefenseThree',,,'eAbilitySource_Item',false));

		Templates.AddItem(PurePassive('GrimySparkStrikeCooldownTwo',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkStrikeCooldownThree',,,'eAbilitySource_Item',false));
		Templates.AddItem(PurePassive('GrimySparkStrikeCooldownFour',,,'eAbilitySource_Item',false));

		Templates.Additem(GrimyResistShockAbsorbent('GrimyShockAbsorbent30',0.3));
		Templates.Additem(GrimyResistShockAbsorbent('GrimyShockAbsorbent35',0.35));
		Templates.Additem(GrimyResistShockAbsorbent('GrimyShockAbsorbent40',0.4));
		Templates.AddItem(GrimyOnHitResultBodyShield('GrimyBodyShield15',-15, eHit_Success));
		Templates.AddItem(GrimyOnHitResultBodyShield('GrimyBodyShield20',-20, eHit_Success));
		Templates.AddItem(GrimyOnHitResultBodyShield('GrimyBodyShield25',-25, eHit_Success));

	return Templates;
}

static function bool HasDLC3()
{
	local array<X2DownloadableContentInfo> DLCInfos;
	local X2DownloadableContentInfo DLCInfo;

	DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
	foreach DLCInfos(DLCInfo) {
		if ( DLCInfo.DLCIdentifier == "DLC_3" ) {
			return true;
		}
	}
	
	return false;
}

static function X2AbilityTemplate GrimyBonusWeaponAmmo(name TemplateName, int Bonus, name WeaponAmmo, optional name WeaponAmmo2 = '')
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusItemCharges		AmmoEffect;

	Template = PurePassive(TemplateName,,,'eAbilitySource_Item',false);

	AmmoEffect = new class'GrimyLoot_Effect_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = Bonus;
	AmmoEffect.ItemTemplateNames.AddItem(WeaponAmmo);

	if ( WeaponAmmo2 != '' )
		AmmoEffect.ItemTemplateNames.AddItem(WeaponAmmo2);

	Template.AddTargetEffect(AmmoEffect);
	
	//`Log("GrimyLoot_AbilitiesSpark.GrimyBonusWeaponAmmo returning...");

	return Template;
}

static function X2AbilityTemplate GrimyResistShockAbsorbent(name TemplateName, float Reduction)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_Resistance					DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_Resistance';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.Reduction = Reduction;
	DefenseEffect.bShockAbsorbent = true;
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyOnHitResultBodyShield(name TemplateName, int Bonus, EAbilityHitResult HitResult)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_BonusOnHitResult		DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	DefenseEffect = new class'GrimyLoot_Effect_BonusOnHitResult';
	DefenseEffect.BuildPersistentEffect(1, true, false, false);
	DefenseEffect.Bonus = Bonus;
	DefenseEffect.HitResult = HitResult;
	DefenseEffect.bBodyShield = true;
	DefenseEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyOverdrive(name TemplateName, int Bonus, int BonusCharges, int BonusCooldown)
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown                     Cooldown;
	local X2Effect_GrantActionPoints            PointEffect;
	local X2Effect_Persistent			        ActionPointPersistEffect;
	local GrimyLoot_Effect_Overdrive               OverdriveEffect;
	local X2Condition_AbilityProperty           AbilityCondition;
	local X2Effect_PersistentTraversalChange    WallbreakEffect;
	local X2Effect_PerkAttachForFX              PerkAttachEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	if ( BonusCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = BonusCooldown;
		Template.AbilityCooldown = Cooldown;
	}
	
	class'GrimyLoot_AbilitiesPrimary'.static.AddCharges(Template, BonusCharges);
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_overdrive";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	PointEffect = new class'X2Effect_GrantActionPoints';
	PointEffect.NumActionPoints = Bonus;
	PointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(PointEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'OverdrivePerk';
	ActionPointPersistEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	Template.AddTargetEffect(ActionPointPersistEffect);

	OverdriveEffect = new class'GrimyLoot_Effect_Overdrive';
	OverdriveEffect.EffectName = 'DLC_3Overdrive';
	OverdriveEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	OverdriveEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, , , Template.AbilitySourceName);
	Template.AddTargetEffect(OverdriveEffect);

	// A persistent effect for the effects code to attach a duration to
	PerkAttachEffect = new class'X2Effect_PerkAttachForFX';
	PerkAttachEffect.EffectName = 'AdaptiveAimPerk';
	PerkAttachEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('AdaptiveAim');
	PerkAttachEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(PerkAttachEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('WreckingBall');
	WallbreakEffect = new class'X2Effect_PersistentTraversalChange';
	WallbreakEffect.AddTraversalChange(eTraversal_BreakWall, true);
	WallbreakEffect.EffectName = 'WreckingBallTraversal';
	WallbreakEffect.DuplicateResponse = eDupe_Ignore;
	WallbreakEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	WallbreakEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WallbreakEffect);

	Template.CustomFireAnim = 'FF_Overdrive';
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PostActivationEvents.AddItem('OverdriveActivated');
	
	return Template;
}