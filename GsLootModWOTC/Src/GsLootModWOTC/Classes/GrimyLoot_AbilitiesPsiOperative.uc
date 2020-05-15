class GrimyLoot_AbilitiesPsiOperative extends X2Ability_PsiOperativeAbilitySet;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(PurePassive('GrimyBonusSoulFire'));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusSoulFireBsc',2,'Soulfire',3));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusSoulFireAdv',2,'Soulfire',4));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusSoulFireSup',2,'Soulfire',5));
	
	Templates.AddItem(PurePassive('GrimyBonusInsanity'));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusInsanityBsc',2,'Insanity',3));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusInsanityAdv',2,'Insanity',4));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusInsanitySup',2,'Insanity',5));
	
	Templates.AddItem(PurePassive('GrimyBonusNullLance'));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusNullLanceBsc',2,'NullLance',1));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusNullLanceAdv',2,'NullLance',2));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusNullLanceSup',2,'NullLance',3));
	
	Templates.AddItem(PurePassive('GrimyBonusVoidRift'));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusVoidRiftBsc',1,'VoidRift',1));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusVoidRiftAdv',1,'VoidRift',2));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusVoidRiftSup',1,'VoidRift',3));
	
	Templates.AddItem(PurePassive('GrimyBonusInspire'));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusInspireBsc',0,'Inspire',2));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusInspireAdv',0,'Inspire',3));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusInspireSup',0,'Inspire',4));
	
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusDominationBsc',0,'Domination',2));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusDominationAdv',0,'Domination',2));
	Templates.Additem(GrimyBonusDamageAbility('GrimyBonusDominationSup',0,'Domination',2));
	
	Templates.AddItem(GrimyChargeFeedback('GrimyChargeFeedbackBsc',1));
	Templates.AddItem(GrimyChargeFeedback('GrimyChargeFeedbackAdv',2));
	Templates.AddItem(GrimyChargeFeedback('GrimyChargeFeedbackSup',3));
	Templates.Additem(GrimyBonusDamageAbilityFeedback('GrimyBonusFeedbackBsc', 'GrimyChargeFeedbackBsc'));
	Templates.Additem(GrimyBonusDamageAbilityFeedback('GrimyBonusFeedbackAdv', 'GrimyChargeFeedbackAdv'));
	Templates.Additem(GrimyBonusDamageAbilityFeedback('GrimyBonusFeedbackSup', 'GrimyChargeFeedbackSup'));
	Templates.AddItem(SolaceCleanseRadius('SolaceCleanseOne',1));
	Templates.AddItem(SolaceCleanseRadius('SolaceCleanseTwo',2));
	Templates.AddItem(SolaceCleanseRadius('SolaceCleanseThree',3));
	Templates.AddItem(GrimySolaceRadiusOne());
	Templates.AddItem(GrimySolaceRadiusTwo());
	Templates.AddItem(GrimySolaceRadiusThree());
	
	Templates.AddItem(GrimyChargeBarrier('GrimyChargeBarrierBsc',5,3,3));
	Templates.AddItem(GrimyChargeBarrier('GrimyChargeBarrierAdv',6,3,3));
	Templates.AddItem(GrimyChargeBarrier('GrimyChargeBarrierSup',7,3,3));

	return Templates;
}

static function X2AbilityTemplate GrimyChargeFeedback(name TemplateName, int BonusCharges)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	if ( BonusCharges > 0 )
	{
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SOULFIRE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'Feedback';
	WeaponDamageEffect.bBypassShields = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulfire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.PostActivationEvents.AddItem(default.SoulStealEventName);

	Template.AssociatedPassives.AddItem('SoulSteal');

	return Template;
}

static function X2AbilityTemplate GrimySolaceRadiusOne()
{
	local X2AbilityTemplate             Template;
	local GrimyLoot_Effect_Solace               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GrimySolaceOne');

	Template.OverrideAbilities.additem('Solace');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_solace";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'GrimyLoot_Effect_Solace';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Effect.Bonus = 9;
	Template.AddMultiTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('SolaceCleanseOne');
	Template.AdditionalAbilities.AddItem('SolacePassive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate GrimySolaceRadiusTwo()
{
	local X2AbilityTemplate             Template;
	local GrimyLoot_Effect_Solace               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GrimySolaceTwo');

	Template.OverrideAbilities.additem('Solace');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_solace";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'GrimyLoot_Effect_Solace';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Effect.Bonus = 20;
	Template.AddMultiTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('SolaceCleanseTwo');
	Template.AdditionalAbilities.AddItem('SolacePassive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate GrimySolaceRadiusThree()
{
	local X2AbilityTemplate             Template;
	local GrimyLoot_Effect_Solace               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GrimySolaceThree');

	Template.OverrideAbilities.additem('Solace');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_solace";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'GrimyLoot_Effect_Solace';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Effect.Bonus = 33;
	Template.AddMultiTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('SolaceCleanseThree');
	Template.AdditionalAbilities.AddItem('SolacePassive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate GrimyChargeBarrier(name TemplateName, int Bonus, int Duration, int ThisCooldown)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	local X2Condition_UnitProperty      TargetCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_AbilityProperty	AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Inspire');
	Template.AbilityShooterConditions.AddItem(AbilityCondition);

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_inspire";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = ThisCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'GrimyBarrierEffect';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.ActivationSpeech = 'Inspire';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	return Template;
}

// #######################################################################################
// -------------------- Utility Functions ---------------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyBonusDamageAbility(name TemplateName, int Bonus, name AbilityName, optional int BonusCharges = 0)
{
	local X2AbilityTemplate							Template;
	local GrimyLoot_Effect_BonusDamageAbility		BonusDamageEffect;
	local GrimyLoot_Effect_SetAbilityCharges		AbilityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	if ( Bonus != 0 ) {
		BonusDamageEffect = new class'GrimyLoot_Effect_BonusDamageAbility';
		BonusDamageEffect.BuildPersistentEffect(1, true, false, false);
		BonusDamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
		BonusDamageEffect.Bonus = Bonus;
		BonusDamageEffect.AbilityName = AbilityName;
		BonusDamageEffect.FriendlyName = Template.LocFriendlyName;
		Template.AddTargetEffect(BonusDamageEffect);
	}

	if ( BonusCharges > 0 ) {
		AbilityEffect = new class'GrimyLoot_Effect_SetAbilityCharges';
		AbilityEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
		AbilityEffect.AbilityName = AbilityName;
		AbilityEffect.NumCharges = BonusCharges;
		Template.AddTargetEffect(AbilityEffect);
	}

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusDamageAbilityFeedback(name TemplateName, name AbilityName)
{
	local X2AbilityTemplate								Template;
	local GrimyLoot_Effect_BonusDamageAbilityFeedback	BonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	BonusDamageEffect = new class'GrimyLoot_Effect_BonusDamageAbilityFeedback';
	BonusDamageEffect.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	BonusDamageEffect.AbilityName = AbilityName;
	BonusDamageEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// #######################################################################################
// -------------------- Solace Utility Functions ---------------------------------------
// #######################################################################################

static function X2AbilityTemplate SolaceCleanseRadius(name TemplateName,int BonusRadius)
{
	local X2AbilityTemplate                     Template;
	local X2AbilityTrigger_EventListener        EventListener;
	local X2Condition_UnitProperty              DistanceCondition;
	local X2Effect_RemoveEffects                MentalEffectRemovalEffect;
	local X2Effect_RemoveEffects                MindControlRemovalEffect;
	local X2Condition_UnitProperty              EnemyCondition;
	local X2Condition_UnitProperty              FriendCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_solace";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SolaceCleanseListener;
	Template.AbilityTriggers.AddItem(EventListener);

	//Naming confusion: CreateMindControlRemoveEffects removes everything _except_ mind control, and is used when mind-controlling an enemy.
	//We want to remove all those other status effects on friendly units; we want to remove mind-control itself from enemy units.
	//(Enemy units with mind-control will be back on our team once it's removed.)
	MentalEffectRemovalEffect = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	MentalEffectRemovalEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(MentalEffectRemovalEffect);

	MindControlRemovalEffect = new class'X2Effect_RemoveEffects';
	MindControlRemovalEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;
	MindControlRemovalEffect.TargetConditions.AddItem(EnemyCondition);
	Template.AddTargetEffect(MindControlRemovalEffect);


	DistanceCondition = new class'X2Condition_UnitProperty';
	DistanceCondition.RequireWithinRange = true;
	DistanceCondition.WithinRange = (Sqrt(default.SOLACE_DISTANCE_SQ) + BonusRadius) *  class'XComWorldData'.const.WORLD_StepSize;
	DistanceCondition.ExcludeFriendlyToSource = false;
	DistanceCondition.ExcludeHostileToSource = false;
	Template.AbilityTargetConditions.AddItem(DistanceCondition);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}