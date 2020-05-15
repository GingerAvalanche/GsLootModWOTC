class GrimyLoot_AbilitiesSecondary extends X2Ability dependson (XComGameStateContext_Ability);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(GrimyBonusCrit(10,'GrimyBonusCrit10'));
	Templates.AddItem(GrimyBonusCrit(20,'GrimyBonusCrit20'));
	Templates.AddItem(GrimyBonusCrit(30,'GrimyBonusCrit30'));

	Templates.AddItem(GrimyBonusHacking(5,'GrimyBonusHacking_One'));
	Templates.AddItem(GrimyBonusHacking(10,'GrimyBonusHacking_Two'));
	Templates.AddItem(GrimyBonusHacking(15,'GrimyBonusHacking_Three'));

	Templates.AddItem(GrimyBonusPsiOffense(5,'GrimyBonusPsiOffense_One'));
	Templates.AddItem(GrimyBonusPsiOffense(10,'GrimyBonusPsiOffense_Two'));
	Templates.AddItem(GrimyBonusPsiOffense(15,'GrimyBonusPsiOffense_Three'));

	Templates.AddItem(GrimyBonusWillpower(15,'GrimyBonusWillpower_One'));
	Templates.AddItem(GrimyBonusWillpower(30,'GrimyBonusWillpower_Two'));
	Templates.AddItem(GrimyBonusWillpower(45,'GrimyBonusWillpower_Three'));
	
	Templates.AddItem(GrimyBonusActions(1,'GrimyBonusAction_One'));
	
	Templates.AddItem(GrimyWildcat(1,'GrimyWildcat_Bsc'));
	Templates.AddItem(GrimyWildcat(2,'GrimyWildcat_Adv'));
	Templates.AddItem(GrimyWildcat(3,'GrimyWildcat_Sup'));
	
	Templates.AddItem(GrimyBonusArmorPiercing(1,'GrimyBonusArmorPiercing_Bsc'));
	Templates.AddItem(GrimyBonusArmorPiercing(2,'GrimyBonusArmorPiercing_Adv'));
	Templates.AddItem(GrimyBonusArmorPiercing(3,'GrimyBonusArmorPiercing_Sup'));
	
	Templates.AddItem(GrimyWolfsTooth(40,'GrimyWolfsTooth_BscPistol'));
	Templates.AddItem(GrimyWolfsTooth(50,'GrimyWolfsTooth_AdvPistol'));
	Templates.AddItem(GrimyWolfsTooth(60,'GrimyWolfsTooth_SupPistol'));

	Templates.AddItem(GrimyThunderAndLightning(0.8,'GrimyThunderAndLightning_BscPistol'));
	Templates.AddItem(GrimyThunderAndLightning(0.9,'GrimyThunderAndLightning_AdvPistol'));
	Templates.AddItem(GrimyThunderAndLightning(1.0,'GrimyThunderAndLightning_SupPistol'));
	
	Templates.AddItem(GrimyMomentum(30,'GrimyMomentum_BscSword'));
	Templates.AddItem(GrimyMomentum(45,'GrimyMomentum_AdvSword'));
	Templates.AddItem(GrimyMomentum(60,'GrimyMomentum_SupSword'));
	
	Templates.AddItem(GrimyInquisition(0.8,'GrimyInquisition_BscSword'));
	Templates.AddItem(GrimyInquisition(0.9,'GrimyInquisition_AdvSword'));
	Templates.AddItem(GrimyInquisition(1.0,'GrimyInquisition_SupSword'));

	Templates.AddItem(GrimyParrying(4,'GrimyParrying_BscSword'));
	Templates.AddItem(GrimyParrying(5,'GrimyParrying_AdvSword'));
	Templates.AddItem(GrimyParrying(6,'GrimyParrying_SupSword'));

	Templates.AddItem(GrimyHealingCircle('GrimyBastionOne',1,5.0));
	Templates.AddItem(GrimyHealingCircle('GrimyBastionTwo',2,5.0));
	Templates.AddItem(GrimyHealingCircle('GrimyBastionThree',3,5.0));
	
	Templates.AddItem(GrimyRefundActionGrenadeLauncher('GrimyRefundActionGrenadeLauncherOne',5));
	Templates.AddItem(GrimyRefundActionGrenadeLauncher('GrimyRefundActionGrenadeLauncherTwo',10));
	Templates.AddItem(GrimyRefundActionGrenadeLauncher('GrimyRefundActionGrenadeLauncherThree',15));

	return Templates;
}

static function X2AbilityTemplate GrimyBonusCrit(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusHitResult			CritEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	CritEffect = new class'GrimyLoot_Effect_BonusHitResult';
	CritEffect.BuildPersistentEffect(1, true, false, false);
	CritEffect.Bonus = Bonus;
	CritEffect.HitResult = eHit_Crit;
	CritEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(CritEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusHacking(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Hacking, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, Bonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusPsiOffense(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_PsiOffense, Bonus);
	PersistentStatChangeEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseBonusLabel, eStat_PsiOffense, Bonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusWillpower(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Will, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, Bonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusActions(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_TurnStartActionPoints ThreeActionPoints;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	ThreeActionPoints = new class'X2Effect_TurnStartActionPoints';
	ThreeActionPoints.BuildPersistentEffect(1, true, false, false);
	ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ThreeActionPoints.NumActionPoints = Bonus;
	Template.AddTargetEffect(ThreeActionPoints);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyWildcat(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamageOnCrit	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_BonusDamageOnCrit';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Template.AddShooterEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusArmorPiercing(int Bonus, name TemplateName)
{
	local X2AbilityTemplate					Template;
	local GrimyLoot_Effect_ArmorPiercing	APEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	APEffect = new class'GrimyLoot_Effect_ArmorPiercing';
	APEffect.BuildPersistentEffect(1, true, false, false);
	APEffect.Bonus = Bonus;
	Template.AddShooterEffect(APEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyWolfsTooth(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_InTheZonePistol		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_InTheZonePistol';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyThunderAndLightning(float Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamagePercent     BonusDamageEffectSniper;
	local GrimyLoot_Effect_BonusDamageOnHit     BonusDamageEffectPistol;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);
	
	Template.OverrideAbilities.additem('Reload');

	BonusDamageEffectSniper = new class'GrimyLoot_Effect_BonusDamagePercent';
	BonusDamageEffectSniper.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffectSniper.Bonus = Bonus;
	BonusDamageEffectSniper.ItemSlot = eInvSlot_PrimaryWeapon;
	BonusDamageEffectSniper.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffectSniper);
	
	BonusDamageEffectPistol = new class'GrimyLoot_Effect_BonusDamageOnHit';
	BonusDamageEffectPistol.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffectPistol.Bonus = 1;
	BonusDamageEffectPistol.ItemSlot = eInvSlot_SecondaryWeapon;
	BonusDamageEffectPistol.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffectPistol);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyMomentum(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_Momentum				Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_Momentum';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Effect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyInquisition(float Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamageConcealed		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_BonusDamageConcealed';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Effect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyParrying(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_ReduceMeleeDamage	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_ReduceMeleeDamage';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Effect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// #######################################################################################
// -------------------- Gremlin Functions ---------------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyHealingCircle(name TemplateName, int Bonus, float Distance)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_HealingCircle		HealingEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	HealingEffect = new class'GrimyLoot_Effect_HealingCircle';
	HealingEffect.BuildPersistentEffect(1, true, false, false);
	HealingEffect.Bonus = Bonus;
	HealingEffect.Distance = Distance;
	HealingEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(HealingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// #######################################################################################
// -------------------- Grenade Launcher Functions ---------------------------------------
// #######################################################################################

static function X2AbilityTemplate GrimyRefundActionGrenadeLauncher(name TemplateName, int Bonus)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_RefundActionGrenade	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_RefundActionGrenade';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Effect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}