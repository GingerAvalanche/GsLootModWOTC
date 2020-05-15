class GrimyLoot_AbilitiesGrenades extends X2Ability_Grenades;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PurePassive('GrimyReduceRadius25'));

	Templates.AddItem(PurePassive('GrimyBonusRadius05'));
	Templates.AddItem(PurePassive('GrimyBonusRadius07'));
	Templates.AddItem(PurePassive('GrimyBonusRadius10'));

	Templates.AddItem(PurePassive('GrimyBonusRadius20'));

	Templates.AddItem(PurePassive('GrimyBonusRange20'));
	Templates.AddItem(PurePassive('GrimyBonusRange25'));
	Templates.AddItem(PurePassive('GrimyBonusRange30'));

	Templates.AddItem(PurePassive('GrimyBonusRangeBsc'));
	Templates.AddItem(PurePassive('GrimyBonusRangeAdv'));
	Templates.AddItem(PurePassive('GrimyBonusRangeSup'));

	Templates.AddItem(PurePassive('GrimyReduceRangeBsc'));
	Templates.AddItem(PurePassive('GrimyReduceRangeAdv'));
	Templates.AddItem(PurePassive('GrimyReduceRangeSup'));

	Templates.AddItem(GrimyBonusGrenades('GrimyBonusUtilityGrenadeOne',1,true,false));
	Templates.AddItem(GrimyBonusGrenades('GrimyBonusUtilityGrenadeTwo',2,true,false));
	Templates.AddItem(GrimyBonusGrenades('GrimyBonusUtilityGrenadeThree',3,true,false));

	Templates.AddItem(GrimyBonusGrenades('GrimyBonusPocketGrenadeOne',1,false,true));
	Templates.AddItem(GrimyBonusGrenades('GrimyBonusPocketGrenadeTwo',2,false,true));
	Templates.AddItem(GrimyBonusGrenades('GrimyBonusPocketGrenadeThree',3,false,true));

	Templates.AddItem(GrimyBonusFrags('GrimyBonusFrag1',1));
	Templates.AddItem(GrimyBonusFrags('GrimyBonusFrag2',2));
	Templates.AddItem(GrimyBonusFrags('GrimyBonusFrag3',3));

	Templates.AddItem(GrimyBonusSmokes('GrimyBonusSmoke1',1));
	Templates.AddItem(GrimyBonusSmokes('GrimyBonusSmoke2',2));
	Templates.AddItem(GrimyBonusSmokes('GrimyBonusSmoke3',3));

	Templates.AddItem(GrimyBonusPoisons('GrimyBonusPoison1',1));
	Templates.AddItem(GrimyBonusPoisons('GrimyBonusPoison2',2));
	Templates.AddItem(GrimyBonusPoisons('GrimyBonusPoison3',3));

	Templates.AddItem(GrimyBonusFires('GrimyBonusFire1',1));
	Templates.AddItem(GrimyBonusFires('GrimyBonusFire2',2));
	Templates.AddItem(GrimyBonusFires('GrimyBonusFire3',3));

	Templates.AddItem(GrimyBonusFlashes('GrimyBonusFlash1',1));
	Templates.AddItem(GrimyBonusFlashes('GrimyBonusFlash2',2));
	Templates.AddItem(GrimyBonusFlashes('GrimyBonusFlash3',3));

	Templates.AddItem(GrimyBonusGrenadePocket('GrimyBonusGrenadePocket1',1));
	Templates.AddItem(GrimyBonusGrenadePocket('GrimyBonusGrenadePocket2',2));
	Templates.AddItem(GrimyBonusGrenadePocket('GrimyBonusGrenadePocket3',3));

	Templates.AddItem(GrimyBonusGrenadePocket('GrimyBonusGrenadePocket8',8));
	Templates.AddItem(GrimyBonusGrenadePocket('GrimyBonusGrenadePocket9',9));
	Templates.AddItem(GrimyBonusGrenadePocket('GrimyBonusGrenadePocket10',10));

	return Templates;
}

static function X2AbilityTemplate GrimyBonusGrenades(name TemplateName, int Bonus, bool bUtility, bool bPocket)
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
	AmmoEffect.bUtilityGrenades = bUtility;
	AmmoEffect.bPocketGrenades = bPocket;
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusFrags(name TemplateName, int Bonus)
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
	AmmoEffect.ItemTemplateNames.AddItem('FragGrenade');
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

static function X2AbilityTemplate GrimyBonusPoisons(name TemplateName, int Bonus)
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
	AmmoEffect.ItemTemplateNames.AddItem('GasGrenade');
	AmmoEffect.ItemTemplateNames.AddItem('GasGrenadeMk2');
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusFires(name TemplateName, int Bonus)
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
	AmmoEffect.ItemTemplateNames.AddItem('Firebomb');
	AmmoEffect.ItemTemplateNames.AddItem('FirebombMk2');
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusFlashes(name TemplateName, int Bonus)
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

static function X2AbilityTemplate GrimyBonusGrenadePocket(name TemplateName, int Bonus)
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
	AmmoEffect.bPocketGrenades = true;
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}