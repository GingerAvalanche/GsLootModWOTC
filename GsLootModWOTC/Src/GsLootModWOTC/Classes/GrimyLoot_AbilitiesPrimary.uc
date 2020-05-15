class GrimyLoot_AbilitiesPrimary extends X2Ability_DefaultAbilitySet dependson (XComGameStateContext_Ability);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(GrimyDodgePierce(10,'GrimyDodgePierce_Bsc'));
	Templates.AddItem(GrimyDodgePierce(20,'GrimyDodgePierce_Adv'));
	Templates.AddItem(GrimyDodgePierce(30,'GrimyDodgePierce_Sup'));

	Templates.AddItem(GrimyScanner(1,'GrimyScanner_Bsc'));
	Templates.AddItem(GrimyScanner(2,'GrimyScanner_Adv'));
	Templates.AddItem(GrimyScanner(3,'GrimyScanner_Sup'));

	Templates.AddItem(GrimyRedDot(5,'GrimyRedDot_Bsc'));
	Templates.AddItem(GrimyRedDot(10,'GrimyRedDot_Adv'));
	Templates.AddItem(GrimyRedDot(15,'GrimyRedDot_Sup'));

	Templates.AddItem(GrimyBonusAim(5,'GrimyVitalPoint_Adv'));
	Templates.AddItem(GrimyBonusAim(10,'GrimyVitalPoint_Sup'));
	Templates.AddItem(GrimyBonusAim(-5,'GrimyDecreaseAim_Bsc')); // keep this empty effect, because it applies text.
	Templates.AddItem(GrimyBonusAim(-10,'GrimyDecreaseAim_Adv'));
	Templates.AddItem(GrimyBonusAim(-15,'GrimyDecreaseAim_Sup'));
	
	Templates.AddItem(GrimyTierBonusDamage(1,'GrimyTierBonusDamage_One'));
	Templates.AddItem(GrimyTierBonusDamage(2,'GrimyTierBonusDamage_Two'));
	Templates.AddItem(GrimyTierBonusDamage(3,'GrimyTierBonusDamage_Three'));
	
	Templates.AddItem(GrimyBonusDamagePercent(-0.30,'GrimyDecreaseDamagePercent30'));
	Templates.AddItem(GrimyBonusDamagePercent(-0.35,'GrimyDecreaseDamagePercent35'));
	Templates.AddItem(GrimyBonusDamagePercent(-0.40,'GrimyDecreaseDamagePercent40'));
	
	Templates.AddItem(GrimyBonusDamagePercent(-0.15,'GrimyDecreaseDamagePercent15'));
	Templates.AddItem(GrimyBonusDamagePercent(-0.20,'GrimyDecreaseDamagePercent20'));
	Templates.AddItem(GrimyBonusDamagePercent(-0.25,'GrimyDecreaseDamagePercent25'));

	Templates.AddItem(GrimyBonusDamagePercent(0.20,'GrimyBonusDamagePercent20'));
	Templates.AddItem(GrimyBonusDamagePercent(0.25,'GrimyBonusDamagePercent25'));
	Templates.AddItem(GrimyBonusDamagePercent(0.30,'GrimyBonusDamagePercent30'));
	Templates.AddItem(GrimyBonusDamagePercent(0.35,'GrimyBonusDamagePercent35'));
	Templates.AddItem(GrimyBonusDamagePercent(0.40,'GrimyBonusDamagePercent40'));
	Templates.AddItem(GrimyBonusDamagePercent(1.0,'GrimyBonusDamagePercent100'));
	
	Templates.AddItem(GrimyBonusDamagePercent(0.30,'GrimyBonusDamagePercent30Primary',,eInvSlot_PrimaryWeapon));
	Templates.AddItem(GrimyBonusDamagePercent(0.35,'GrimyBonusDamagePercent35Primary',,eInvSlot_PrimaryWeapon));
	Templates.AddItem(GrimyBonusDamagePercent(0.40,'GrimyBonusDamagePercent40Primary',,eInvSlot_PrimaryWeapon));
	
	Templates.AddItem(GrimyBonusDamagePercent(0.20,'GrimyDuelist25',true));
	Templates.AddItem(GrimyBonusDamagePercent(0.25,'GrimyDuelist30',true));
	Templates.AddItem(GrimyBonusDamagePercent(0.30,'GrimyDuelist35',true));

	Templates.AddItem(GrimyBonusDamage(1,'GrimyBonusDamage_One'));
	Templates.AddItem(GrimyBonusDamage(2,'GrimyBonusDamage_Two'));
	Templates.AddItem(GrimyBonusDamage(3,'GrimyBonusDamage_Three'));
	Templates.AddItem(GrimyBonusDamage(4,'GrimyBonusDamage_Four'));
	Templates.AddItem(GrimyBonusDamage(-1,'GrimyDecreaseDamage_One'));
	Templates.AddItem(GrimyBonusDamage(-2,'GrimyDecreaseDamage_Two'));
	Templates.AddItem(GrimyBonusDamage(-3,'GrimyDecreaseDamage_Three'));

	Templates.AddItem(GrimyHangfire(1,'GrimyHangfire_Bsc'));
	Templates.AddItem(GrimyHangfire(2,'GrimyHangfire_Adv'));
	Templates.AddItem(GrimyHangfire(3,'GrimyHangfire_Sup'));

	Templates.AddItem(GrimySuppressor(15,'GrimySuppressor_Bsc'));
	Templates.AddItem(GrimySuppressor(20,'GrimySuppressor_Adv'));
	Templates.AddItem(GrimySuppressor(25,'GrimySuppressor_Sup'));

	Templates.AddItem(GrimyBonusMobility(1,'GrimyBonusMobility_One'));
	Templates.AddItem(GrimyBonusMobility(2,'GrimyBonusMobility_Two'));
	Templates.AddItem(GrimyBonusMobility(3,'GrimyBonusMobility_Three'));
	Templates.AddItem(GrimyBonusMobility(-1,'GrimyDecreaseMobility_One'));
	Templates.AddItem(GrimyBonusMobility(-2,'GrimyDecreaseMobility_Two'));
	Templates.AddItem(GrimyBonusMobility(-3,'GrimyDecreaseMobility_Three'));
	Templates.AddItem(GrimyBonusMobility(-4,'GrimyDecreaseMobility_Four'));
	Templates.AddItem(GrimyBonusMobility(-5,'GrimyDecreaseMobility_Five'));
	Templates.AddItem(GrimyBonusMobility(-6,'GrimyDecreaseMobility_Six'));

	Templates.AddItem(GrimyHighCycle(0.3,5,'GrimyHighCycle_Bsc'));
	Templates.AddItem(GrimyHighCycle(0.35,10,'GrimyHighCycle_Adv'));
	Templates.AddItem(GrimyHighCycle(0.4,15,'GrimyHighCycle_Sup'));

	Templates.AddItem(GrimyBonusShred(1,'GrimyBonusShred_Bsc'));
	Templates.AddItem(GrimyBonusShred(2,'GrimyBonusShred_Adv'));
	Templates.AddItem(GrimyBonusShred(3,'GrimyBonusShred_Sup'));

	Templates.AddItem(GrimyUnflankable(15,'GrimyMaxCaliber_Crit'));
	Templates.AddItem(GrimyUnflankable(30,'GrimyBigGameHunter_BscSword'));
	Templates.AddItem(GrimyUnflankable(45,'GrimyBigGameHunter_AdvSword'));
	Templates.AddItem(GrimyUnflankable(60,'GrimyBigGameHunter_SupSword'));

	Templates.AddItem(GrimyFrontload('GrimyFrontload_Bsc',10,10));
	Templates.AddItem(GrimyFrontload('GrimyFrontload_Adv',15,15));
	Templates.AddItem(GrimyFrontload('GrimyFrontload_Sup',20,20));
	Templates.AddItem(GrimyReserve('GrimyReserve_Bsc',40,10));
	Templates.AddItem(GrimyReserve('GrimyReserve_Adv',50,20));
	Templates.AddItem(GrimyReserve('GrimyReserve_Sup',60,30));

	Templates.AddItem(GrimyAddAmmo('GrimyAddDragonRounds','IncendiaryRounds'));
	Templates.AddItem(GrimyAddAmmo('GrimyAddVenomRounds','VenomRounds'));
	Templates.AddItem(GrimyAddAmmo('GrimyAddBluescreenRounds','BluescreenRounds'));

	Templates.AddItem(GrimyBaseOverwatch('GrimySentinelOne',1,2));
	Templates.AddItem(GrimyBaseOverwatch('GrimySentinelTwo',2,2));
	Templates.AddItem(GrimyBaseOverwatch('GrimySentinelThree',3,2));
	
	Templates.AddItem(GrimyUndertaker('GrimyUndertaker3',1,3));
	Templates.AddItem(GrimyUndertaker('GrimyUndertaker4',1,4));
	Templates.AddItem(GrimyUndertaker('GrimyUndertaker5',1,5));

	Templates.AddItem(GrimyVsOverwatch(25,'GrimySeigeBreakerOne'));
	Templates.AddItem(GrimyVsOverwatch(30,'GrimySeigeBreakerTwo'));
	Templates.AddItem(GrimyVsOverwatch(35,'GrimySeigeBreakerThree'));

	Templates.AddItem(GrimyAmmoSynthesizer('GrimyAmmoSynthesizerBsc',1,0));
	Templates.AddItem(GrimyAmmoSynthesizer('GrimyAmmoSynthesizerAdv',1,20));
	Templates.AddItem(GrimyAmmoSynthesizer('GrimyAmmoSynthesizerSup',1,40));

	return Templates;
}

static function AddCharges(X2AbilityTemplate Template, int BonusCharges)
{
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;

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
}

static function X2AbilityTemplate GrimyAddAmmo(name TemplateName, name AmmoName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_AddAmmo				AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	AmmoEffect = new class'GrimyLoot_Effect_AddAmmo';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.AmmoTemplate = AmmoName;
	Template.AddTargetEffect(AmmoEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyAmmoSynthesizer(name TemplateName, int Bonus, int BonusChance)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_AmmoSynthesizer		AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	Template.OverrideAbilities.AddItem('Reload');

	AmmoEffect = new class'GrimyLoot_Effect_AmmoSynthesizer';
	AmmoEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin); 
	AmmoEffect.BaseAmmo = Bonus;
	AmmoEffect.BonusChance = BonusChance;
	Template.AddTargetEffect(AmmoEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyDodgePierce(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusHitResult        DodgePiercingEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	DodgePiercingEffect = new class'GrimyLoot_Effect_BonusHitResult';
	DodgePiercingEffect.BuildPersistentEffect(1, true, false, false);
	DodgePiercingEffect.Bonus = -Bonus;
	DodgePiercingEffect.HitResult = eHit_Graze;
	DodgePiercingEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DodgePiercingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyScanner(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_SightRadius, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyRedDot(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusHitResult     AimEffect;
	local GrimyLoot_Effect_BonusHitResult    CritEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);
	
	AimEffect = new class'GrimyLoot_Effect_BonusHitResult';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = Bonus;
	AimEffect.HitResult = eHit_Success;
	AimEffect.bFlankingOnly = true;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(AimEffect);
	
	CritEffect = new class'GrimyLoot_Effect_BonusHitResult';
	CritEffect.BuildPersistentEffect(1, true, false, false);
	CritEffect.Bonus = Bonus;
	CritEffect.HitResult = eHit_Crit;
	CritEffect.bFlankingOnly = true;
	CritEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(CritEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusAim(int Bonus, name TemplateName)
{
	local X2AbilityTemplate				Template;
	local GrimyLoot_Effect_BonusHitResult     AimEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);
	
	AimEffect = new class'GrimyLoot_Effect_BonusHitResult';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = Bonus;
	AimEffect.HitResult = eHit_Success;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(AimEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusDamagePercent(float Bonus, name TemplateName, optional bool blastStanding = false, optional eInventorySlot ItemSlot = eInvSlot_Unknown)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamagePercent	BonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	BonusDamageEffect = new class'GrimyLoot_Effect_BonusDamagePercent';
	BonusDamageEffect.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffect.Bonus = Bonus;
	BonusDamageEffect.ItemSlot = ItemSlot;
	BonusDamageEffect.bLastStanding = bLastStanding;
	BonusDamageEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusDamage(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamageOnHit     BonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	BonusDamageEffect = new class'GrimyLoot_Effect_BonusDamageOnHit';
	BonusDamageEffect.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffect.Bonus = Bonus;
	BonusDamageEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyTierBonusDamage(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamageTierMult	BonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	BonusDamageEffect = new class'GrimyLoot_Effect_BonusDamageTierMult';
	BonusDamageEffect.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffect.Bonus = Bonus;
	BonusDamageEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyHangfire(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamageOnHit     BonusDamageEffect;
	local GrimyLoot_Effect_BonusHitResult				AimEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	BonusDamageEffect = new class'GrimyLoot_Effect_BonusDamageOnHit';
	BonusDamageEffect.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffect.Bonus = Bonus;
	BonusDamageEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffect);
	
	AimEffect = new class'GrimyLoot_Effect_BonusHitResult';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = -5*Bonus;
	AimEffect.HitResult = eHit_Success;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(AimEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimySuppressor(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_ToHitModifier		Effect;
	local X2Condition_Visibility                VisCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_ToHitModifier';
	Effect.EffectName = 'Suppressor';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.AddEffectHitModifier(eHit_Success, Bonus, Template.LocFriendlyName);
	Effect.AddEffectHitModifier(eHit_Crit, Bonus, Template.LocFriendlyName);
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bExcludeGameplayVisible = true;
	Effect.ToHitConditions.AddItem(VisCondition);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusMobility(int Bonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, Bonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyHighCycle(float DamageBonus, int AimBonus, name TemplateName)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamagePercent     BonusDamageEffect;
	local GrimyLoot_Effect_BonusHitResult				AimEffect;
	local GrimyLoot_Effect_BonusHitResult			CritEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	BonusDamageEffect = new class'GrimyLoot_Effect_BonusDamagePercent';
	BonusDamageEffect.BuildPersistentEffect(1, true, false, false);
	BonusDamageEffect.Bonus = DamageBonus;
	BonusDamageEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(BonusDamageEffect);
	
	AimEffect = new class'GrimyLoot_Effect_BonusHitResult';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = AimBonus;
	AimEffect.HitResult = eHit_Success;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(AimEffect);

	CritEffect = new class'GrimyLoot_Effect_BonusHitResult';
	CritEffect.BuildPersistentEffect(1, true, false, false);
	CritEffect.Bonus = -100;
	CritEffect.HitResult = eHit_Crit;
	CritEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(CritEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBonusShred(int Bonus, name TemplateName)
{
	local X2AbilityTemplate					Template;
	local GrimyLoot_Effect_BonusShred		ShredEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	ShredEffect = new class'GrimyLoot_Effect_BonusShred';
	ShredEffect.BuildPersistentEffect(1, true, false, false);
	ShredEffect.Bonus = Bonus;
	Template.AddShooterEffect(ShredEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyUnflankable(int Bonus, name TemplateName)
{
	local X2AbilityTemplate							Template;
	local GrimyLoot_Effect_BonusHitResult		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_BonusHitResult';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Effect.HitResult = eHit_Crit;
	Effect.bUnflankableOnly = true;
	Effect.FriendlyName = Template.LocFriendlyName;
	Template.AddShooterEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyFrontload(name TemplateName, int CritBonus, int Bonus)
{
	local X2AbilityTemplate							Template;
	local GrimyLoot_Effect_BonusAimFrontload		AimEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	AimEffect = new class'GrimyLoot_Effect_BonusAimFrontload';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = Bonus;
	AimEffect.HitResult = eHit_Success;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddShooterEffect(AimEffect);

	AimEffect = new class'GrimyLoot_Effect_BonusAimFrontload';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = CritBonus;
	AimEffect.HitResult = eHit_Crit;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddShooterEffect(AimEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyReserve(name TemplateName, int Bonus, int CritBonus)
{
	local X2AbilityTemplate							Template;
	local GrimyLoot_Effect_BonusAimReserve		AimEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	AimEffect = new class'GrimyLoot_Effect_BonusAimReserve';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = Bonus;
	AimEffect.HitResult = eHit_Success;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddShooterEffect(AimEffect);

	AimEffect = new class'GrimyLoot_Effect_BonusAimReserve';
	AimEffect.BuildPersistentEffect(1, true, false, false);
	AimEffect.Bonus = CritBonus;
	AimEffect.HitResult = eHit_Crit;
	AimEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddShooterEffect(AimEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyBaseOverwatch(name TemplateName, int BonusCharges, optional int NumPoints = 2)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;
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
	
	Template.bDontDisplayInAbilitySummary = true;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	ActionPointCost.DoNotConsumeAllEffects.Length = 0;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	ReserveActionPointsEffect.NumPoints = NumPoints;
	Template.AddTargetEffect(ReserveActionPointsEffect);

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = 'OverwatchShot';
	CoveringFireEffect.MaxPointsPerTurn = NumPoints;
	CoveringFireEffect.GrantActionPoint = class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint;
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('LongWatch');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sentinel";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	return Template;	
}

static function X2AbilityTemplate GrimyUndertaker(name TemplateName, int BonusPerVisible, int MaxVisible)
{
	local X2AbilityTemplate						Template;
	local GrimyLoot_Effect_BonusDamageOnCrit	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	class'GrimyLoot_AbilitiesPrimary'.static.InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_BonusDamageOnCrit';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.BonusPerVisible = BonusPerVisible;
	Effect.MaxVisible = MaxVisible;
	Template.AddShooterEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyVsOverwatch(int Bonus, name TemplateName)
{
	local X2AbilityTemplate							Template;
	local GrimyLoot_Effect_BonusHitResult		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	InitializeAbilityTemplate(Template);

	Effect = new class'GrimyLoot_Effect_BonusHitResult';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Effect.HitResult = eHit_Crit;
	Effect.bVsOverwatchOnly = true;
	Effect.FriendlyName = Template.LocFriendlyName;
	Template.AddShooterEffect(Effect);

	Effect = new class'GrimyLoot_Effect_BonusHitResult';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Bonus = Bonus;
	Effect.HitResult = eHit_Success;
	Effect.bVsOverwatchOnly = true;
	Effect.FriendlyName = Template.LocFriendlyName;
	Template.AddShooterEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// #######################################################################################
// -------------------- Utility Functions ---------------------------------------------
// #######################################################################################
static function InitializeAbilityTemplate(X2AbilityTemplate Template)
{

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bDisplayInUITacticalText = false;
}