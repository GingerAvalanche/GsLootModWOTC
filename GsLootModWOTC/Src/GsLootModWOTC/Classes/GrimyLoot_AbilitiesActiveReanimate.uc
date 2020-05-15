class GrimyLoot_AbilitiesActiveReanimate extends X2Ability_Sectoid;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(GrimyPsiReanimation('GrimyChargeReanimationOne',1));
	Templates.AddItem(GrimyPsiReanimation('GrimyChargeReanimationTwo',2));
	Templates.AddItem(GrimyPsiReanimation('GrimyChargeReanimationThree',3));

	return Templates;
}

static function X2AbilityTemplate GrimyPsiReanimation(name TemplateName, int BonusCharges)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown Cooldown;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_Visibility TargetVisibilityCondition;
	local X2Effect_SpawnPsiZombie SpawnZombieEffect;
	local X2Condition_UnitValue UnitValue;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2Condition_UnitType UnitTypeCondition;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate";

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

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;

	// Cost of the ability
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Cooldown on the ability
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);// Prevent ability from being available when dead
	Template.AddShooterEffectExclusions();

	// Units of these types may not be turned into a zombie
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes = default.SECTOID_REANIMATION_EXCLUDE_UNIT_TYPES;
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	// This ability is only valid if the target has not yet been turned into a zombie
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(UnitValue);

	// the target's tile must be clear of obstruction. Functionally this is the same as the
	// unburrow condition, but it can't renamed now that we've launched the game
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_ValidUnburrowTile');

	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_UnitIsImmune');
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(ExcludeEffects);

	// The unit must be organic, dead, and not an alien
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.ExcludeCivilian = false;
	UnitPropertyCondition.ExcludeCosmetic = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Must be able to see the dead unit to reanimate it
	TargetVisibilityCondition = new class'X2Condition_Visibility';	
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Add dead eye to guarantee the reanimation occurs
	Template.AbilityToHitCalc = default.DeadEye;

	// The target will now be turned into a zombie
	SpawnZombieEffect = new class'X2Effect_SpawnPsiZombie';
	SpawnZombieEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(SpawnZombieEffect);

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'PsiReanimation'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'PsiReanimation'

	return Template;
}