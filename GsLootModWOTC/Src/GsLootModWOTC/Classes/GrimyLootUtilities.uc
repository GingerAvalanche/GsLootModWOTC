class GrimyLootUtilities extends Object config(GrimyLootUpgradeSetup);

struct UpgradeSetup
{
	var name				UpgradeName;
	var string				ImagePath;
	var string				MeshPath;
	var string				IconPath;
	var int					Tier;
	var int					UpgradeValue;
	var int					AimBonus;
	var int					CritChanceBonus;
	var int					ClipSizeBonus;
	var array<ArtifactCost>	ResourceCosts;
	var array<ArtifactCost>	ArtifactCosts;
	var array<name>			RequiredTechs;
	var WeaponDamageValue	DamageValue;
	var WeaponDamageValue	MissDamageValue;
	var array<name>			BonusAbilities;
	var array<name>			MutuallyExclusiveUpgrades;
	var bool				MaxClipSizeOne;
};

struct MutualExclusionGroup
{
	var array<name>		ExclusionGroupMembers;
};

delegate UpgradeApply(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex);

var config bool bLogUpgrades;
var config array<MutualExclusionGroup> EXCLUSION_GROUPS;

static function GrimyLoot_GameState_LootStore GetLootStore()
{
	return GrimyLoot_GameState_LootStore(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'GrimyLoot_GameState_LootStore', true));
}

static function CreateLootStore(out XComGameState NewGameState)
{
	local GrimyLoot_GameState_LootStore LootStoreState;

	LootStoreState = GrimyLoot_GameState_LootStore(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'GrimyLoot_GameState_LootStore', true));

	if ( LootStoreState.ObjectID == 0 )
	{
		LootStoreState = GrimyLoot_GameState_LootStore(NewGameState.CreateNewStateObject(class'GrimyLoot_GameState_LootStore'));
		NewGameState.AddStateObject(LootStoreState);
	}
}

static function AddExistingGameStatesToLootStore()
{
	local LootStruct LootStats;
	local GrimyLoot_GameState_LootStore LootStoreState;
	local XComGameState_Item ItemState;

	LootStoreState = GetLootStore();

	if ( LootStoreState.ObjectID == 0 )
		return;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Item', ItemState, , true)
	{
	    if ( ItemState.GetMyWeaponUpgradeTemplateNames().Length > X2WeaponTemplate(ItemState.GetMyTemplate()).NumUpgradeSlots && !LootStoreState.DoesObjectIDHaveEntry(ItemState.ObjectID) )
		{
			LootStats.IDOwner = ItemState.ObjectID;
			LootStats.NumUpgradeSlots = ItemState.GetMyWeaponUpgradeTemplateNames().Length;
			switch ( LootStats.NumUpgradeSlots )
			{
				case 1:
				case 2:
					LootStats.TradingPostValue = class'GrimyLoot_Research'.static.GetRareEquipmentPrice();
					break;
				case 3:
					LootStats.TradingPostValue = class'GrimyLoot_Research'.static.GetEpicEquipmentPrice();
					break;
				case 4:
					LootStats.TradingPostValue = class'GrimyLoot_Research'.static.GetLegendaryEquipmentPrice();
			}
			LootStoreState.AddToLootStore(LootStats);
		}
	}

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Item', ItemState,,true)
	{
		if ( LootStoreState.DoesObjectIDHaveEntry(ItemState.ObjectID) )
			`Log("Found! Object ID:" @ ItemState.ObjectID $ ", NumUpgradeSlots:" @ LootStoreState.GetNumUpgradeSlotsByOwnerID(ItemState.ObjectID) $ ", TradingPostValue:" @ LootStoreState.GetTradingPostValueByOwnerID(ItemState.ObjectID));
	}
}

static function X2DataTemplate CreateUpgrade(UpgradeSetup ThisUpgradeSetup, array<name> ItemTemplateNames, delegate<UpgradeApply> ApplyFunction)
{
	local X2WeaponUpgradeTemplate	Template;
	local name						AbilityName, SaberName;
	local UpgradeSetup				TypeSetup;
	local ArtifactCost				Cost;
	local name						Tech;
	local DamageValue				NoneDamageValue, NoneMissDamageValue;

	NoneMissDamageValue.Tag = 'MISS';
	
	`log("-------------------------------------------------------------------------", default.bLogUpgrades, 'GsLootModWOTC');
	`log(default.class @ GetFuncName() @ "setting up" @ ThisUpgradeSetup.UpgradeName, default.bLogUpgrades, 'GsLootModWOTC');
	
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, ThisUpgradeSetup.UpgradeName);
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.strImage = ThisUpgradeSetup.ImagePath;
	Template.TradingPostValue = ThisUpgradeSetup.UpgradeValue;
	Template.Tier = ThisUpgradeSetup.Tier;
	Template.ItemCat = 'utility';

	if (ThisUpgradeSetup.MissDamageValue != NoneMissDamageValue)
	{
		Template.BonusDamage = ThisUpgradeSetup.DamageValue;
		Template.GetBonusAmountFn = class'X2Item_DefaultUpgrades'.static.GetDamageBonusAmount;
	}

	if (ThisUpgradeSetup.DamageValue != NoneDamageValue)
	{
		Template.CHBonusDamage = ThisUpgradeSetup.DamageValue;
		Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	}

	`log(default.class @ GetFuncName() @ "AimBonus" @ ThisUpgradeSetup.AimBonus, default.bLogUpgrades, 'GsLootModWOTC');

	if (ThisUpgradeSetup.AimBonus != 0)
	{
		Template.AimBonus = ThisUpgradeSetup.AimBonus;
		Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	}
	
	`log(default.class @ GetFuncName() @ "CritBonus" @ ThisUpgradeSetup.CritChanceBonus, default.bLogUpgrades, 'GsLootModWOTC');
	
	if (ThisUpgradeSetup.CritChanceBonus != 0)
	{
		Template.CritBonus = ThisUpgradeSetup.CritChanceBonus;
		Template.AddCritChanceModifierFn = CritUpgradeModifier;
	}

	`log(default.class @ GetFuncName() @ "ClipSizeBonus" @ ThisUpgradeSetup.ClipSizeBonus, default.bLogUpgrades, 'GsLootModWOTC');
	
	if (ThisUpgradeSetup.ClipSizeBonus != 0)
	{
		Template.ClipSizeBonus = ThisUpgradeSetup.ClipSizeBonus;
		Template.AdjustClipSizeFn = AdjustClipSize;
		Template.GetBonusAmountFn = GetClipBonus;
	}

	`log(default.class @ GetFuncName() @ "MaxClipSizeOne" @ ThisUpgradeSetup.MaxClipSizeOne, default.bLogUpgrades, 'GsLootModWOTC');
	
	if (ThisUpgradeSetup.MaxClipSizeOne)
	{
		Template.AdjustClipSizeFn = MaxOneClipSize;
	}

	foreach ThisUpgradeSetup.BonusAbilities(AbilityName)
	{
		`log(default.class @ GetFuncName() @ "Bonus Ability" @ AbilityName, default.bLogUpgrades, 'GsLootModWOTC');
		Template.BonusAbilities.AddItem(AbilityName);
	}

	foreach default.EXCLUSION_GROUPS(ExclusionGroup)
	{
		if (ExclusionGroup.ExclusionGroupMembers.find(ThisUpgradeSetup.UpgradeName) != INDEX_NONE)
		{
			foreach ExclusionGroup.ExclusionGroupMembers(MemberName)
			{
				Template.MutuallyExclusiveUpgrades.AddItem(MemberName);
			}
		}
	}

	foreach ItemTemplateNames(ItemName)
	{
		Template.AddUpgradeAttachment(SocketName, 'UIPawnLocation_WeaponUpgrade_Shotgun', ThisUpgradeSetup.MeshPath, "", ItemName, , "", ThisUpgradeSetup.ImagePath, ThisUpgradeSetup.IconPath);
	}
	
	`log(default.class @ GetFuncName() @ "ResourceCosts 0 index check" @ ThisUpgradeSetup.ResourceCosts[0].ItemTemplateName, default.bLogUpgrades, 'GsLootModWOTC');
	`log(default.class @ GetFuncName() @ "ArtifactCosts 0 index check" @ ThisUpgradeSetup.ArtifactCosts[0].ItemTemplateName, default.bLogUpgrades, 'GsLootModWOTC');
	`log(default.class @ GetFuncName() @ "RequiredTechs 0 index check" @ ThisUpgradeSetup.RequiredTechs[0], default.bLogUpgrades, 'GsLootModWOTC');

	// even if you specify an empty array in the ini, it'll give you an array of length 1
	if (ThisUpgradeSetup.ResourceCosts[0].ItemTemplateName != '')
	{
		foreach ThisUpgradeSetup.ResourceCosts(Cost)
		{
			if (Cost.ItemTemplateName != '')
			{
				Template.CanBeBuilt = true;
				Template.PointsToComplete = 0;
				Template.Cost.ResourceCosts.AddItem(Cost);
			}
		}
	}

	if (ThisUpgradeSetup.ArtifactCosts[0].ItemTemplateName != '')
	{
		foreach ThisUpgradeSetup.ArtifactCosts(Cost)
		{
			if (Cost.ItemTemplateName != '')
			{
				Template.CanBeBuilt = true;
				Template.PointsToComplete = 0;
				Template.Cost.ArtifactCosts.AddItem(Cost);
			}
		}
	}

	if (ThisUpgradeSetup.RequiredTechs[0] != '')
	{
		foreach ThisUpgradeSetup.RequiredTechs(Tech)
		{
			Template.Requirements.RequiredTechs.AddItem(Tech);
		}
	}

	Template.CanApplyUpgradeToWeaponFn = ApplyFunction;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
	Template.UpgradeCats.AddItem('lightsaber');
	
	`log(default.class @ GetFuncName() @ "finished setting up" @ ThisUpgradeSetup.UpgradeName, default.bLogUpgrades, 'GsLootModWOTC');

	return Template;
}

static function bool DamageUpgradeModifier(X2WeaponUpgradeTemplate UpgradeTemplate, out int DamageMod, name StatType)
{
	switch (StatType)
	{
		case 'Damage':
			DamageMod = UpgradeTemplate.CHBonusDamage.Damage;
			return true;
		case 'Spread':
			DamageMod = UpgradeTemplate.CHBonusDamage.Spread;
			return true;
		case 'Crit':
			DamageMod = UpgradeTemplate.CHBonusDamage.Crit;
			return true;
		case 'Pierce':
			DamageMod = UpgradeTemplate.CHBonusDamage.Pierce;
			return true;
		case 'Rupture':
			DamageMod = UpgradeTemplate.CHBonusDamage.Rupture;
			return true;
		case 'Shred':
			DamageMod = UpgradeTemplate.CHBonusDamage.Shred;
			return true;
		default:
			return false;
	}
}

static function bool AimUpgradeHitModifier(X2WeaponUpgradeTemplate UpgradeTemplate, const GameRulesCache_VisibilityInfo VisInfo, out int HitChanceMod)
{
	HitChanceMod = UpgradeTemplate.AimBonus;
	return true;
}

static function bool CritUpgradeModifier(X2WeaponUpgradeTemplate UpgradeTemplate, out int CritChanceMod)
{
	CritChanceMod = UpgradeTemplate.CritBonus;
	return true;
}

static function int GetClipBonus(X2WeaponUpgradeTemplate UpgradeTemplate)
{
	return UpgradeTemplate.ClipSizeBonus;
}

static function bool AdjustClipSize(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, const int CurrentClipSize, out int AdjustedClipSize)
{
	AdjustedClipSize = CurrentClipSize+UpgradeTemplate.ClipSizeBonus;
	return true;
}

static function bool MaxOneClipSize(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, const int CurrentClipSize, out int AdjustedClipSize)
{
	AdjustedClipSize = 1;
	return true;
}