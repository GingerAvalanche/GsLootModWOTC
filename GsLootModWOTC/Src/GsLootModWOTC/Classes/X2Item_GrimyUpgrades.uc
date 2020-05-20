class X2Item_GrimyUpgrades extends X2Item
	dependson(GsLootDataStructures)
	config(GsLootUpgradeSetup);

var config array<UpgradeSetup> PRIMARY_UPGRADE_SETUPS;
var config array<UpgradeSetup> PISTOL_UPGRADE_SETUPS;
var config array<UpgradeSetup> SWORD_UPGRADE_SETUPS;
var config array<UpgradeSetup> GREMLIN_UPGRADE_SETUPS;
var config array<UpgradeSetup> BIT_UPGRADE_SETUPS;
var config array<UpgradeSetup> GRENADELAUNCHER_UPGRADE_SETUPS;
var config array<UpgradeSetup> PSIAMP_UPGRADE_SETUPS;
var config array<UpgradeSetup> ARMOR_UPGRADE_SETUPS;
var config array<UpgradeSetup> CHASSIS_UPGRADE_SETUPS;

var config array<name> PRIMARY_WEAPON_CATEGORIES;
var config array<name> PISTOL_WEAPON_CATEGORIES;
var config array<name> SWORD_WEAPON_CATEGORIES;
var config array<name> GREMLIN_WEAPON_CATEGORIES;
var config array<name> BIT_WEAPON_CATEGORIES;
var config array<name> GRENADELAUNCHER_WEAPON_CATEGORIES;
var config array<name> PSIAMP_WEAPON_CATEGORIES;
var config array<name> ARMOR_CATEGORIES;
var config array<name> CHASSIS_CATEGORIES;

var config array<MutualExclusionGroup> EXCLUSION_GROUPS;

delegate UpgradeApply(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	foreach default.PRIMARY_UPGRADE_SETUPS(WeaponSetup)
	{
		Items.additem(CreateUpgrade(WeaponSetup, CanApplyUpgradeToWeapon));
	}

	foreach default.PISTOL_UPGRADE_SETUPS(WeaponSetup)
	{
		Items.additem(CreateUpgrade(WeaponSetup, CanApplyUpgradeToPistol));
	}

	foreach default.SWORD_UPGRADE_SETUPS(WeaponSetup)
	{
		Items.additem(CreateUpgrade(WeaponSetup, CanApplyUpgradeToSword));
	}

	foreach default.GREMLIN_UPGRADE_SETUPS(WeaponSetup)
	{
		Items.additem(CreateUpgrade(WeaponSetup, CanApplyUpgradeToGremlin));
	}

	foreach default.PSIAMP_UPGRADE_SETUPS(WeaponSetup)
	{
		Items.additem(CreateUpgrade(WeaponSetup, CanApplyUpgradeToPsiAmp));
	}

	foreach default.GRENADELAUNCHER_UPGRADE_SETUPS(WeaponSetup)
	{
		Items.additem(CreateUpgrade(WeaponSetup, CanApplyUpgradeToGrenadeLauncher));
	}
	
	foreach default.ARMOR_UPGRADE_SETUPS(ArmorSetup)
	{
		Items.AddItem(CreateUpgrade(ArmorSetup, CanApplyUpgradeToArmor))
	}
	
	if ( class'GrimyLoot_AbilitiesSpark'.static.HasDLC3() )
	{
		foreach default.CHASSIS_UPGRADE_SETUPS(ArmorSetup)
		{
			Items.AddItem(CreateUpgrade(ArmorSetup, CanApplyUpgradeToChassis))
		}

		foreach default.BIT_UPGRADE_SETUPS(WeaponSetup)
		{
			Items.additem(CreateUpgrade(WeaponSetup, CanApplyUpgradeToBit));
		}
	}
	
	return Items;
}

// #######################################################################################
// -------------------- GENERIC SETUP FUNCTIONS ------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateUpgrade(UpgradeSetup ThisUpgradeSetup, delegate<UpgradeApply> ApplyFunction)
{
	local X2WeaponUpgradeTemplate	Template;
	local name						AbilityName, SaberName;
	local UpgradeSetup				TypeSetup;
	local ArtifactCost				Cost;
	local name						Tech;
	local DamageValue				NoneDamageValue, NoneMissDamageValue;

	NoneMissDamageValue.Tag = 'MISS';
	
	`log("-------------------------------------------------------------------------", class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
	`log(default.class @ GetFuncName() @ "setting up" @ ThisUpgradeSetup.UpgradeName, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
	
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

	`log(default.class @ GetFuncName() @ "AimBonus" @ ThisUpgradeSetup.AimBonus, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');

	if (ThisUpgradeSetup.AimBonus != 0)
	{
		Template.AimBonus = ThisUpgradeSetup.AimBonus;
		Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	}
	
	`log(default.class @ GetFuncName() @ "CritBonus" @ ThisUpgradeSetup.CritChanceBonus, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
	
	if (ThisUpgradeSetup.CritChanceBonus != 0)
	{
		Template.CritBonus = ThisUpgradeSetup.CritChanceBonus;
		Template.AddCritChanceModifierFn = CritUpgradeModifier;
	}

	`log(default.class @ GetFuncName() @ "ClipSizeBonus" @ ThisUpgradeSetup.ClipSizeBonus, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
	
	if (ThisUpgradeSetup.ClipSizeBonus != 0)
	{
		Template.ClipSizeBonus = ThisUpgradeSetup.ClipSizeBonus;
		Template.AdjustClipSizeFn = AdjustClipSize;
		Template.GetBonusAmountFn = GetClipBonus;
	}

	`log(default.class @ GetFuncName() @ "MaxClipSizeOne" @ ThisUpgradeSetup.MaxClipSizeOne, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
	
	if (ThisUpgradeSetup.MaxClipSizeOne)
	{
		Template.AdjustClipSizeFn = MaxOneClipSize;
	}

	foreach ThisUpgradeSetup.BonusAbilities(AbilityName)
	{
		`log(default.class @ GetFuncName() @ "Bonus Ability" @ AbilityName, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
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
	
	`log(default.class @ GetFuncName() @ "ResourceCosts 0 index check" @ ThisUpgradeSetup.ResourceCosts[0].ItemTemplateName, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
	`log(default.class @ GetFuncName() @ "ArtifactCosts 0 index check" @ ThisUpgradeSetup.ArtifactCosts[0].ItemTemplateName, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');
	`log(default.class @ GetFuncName() @ "RequiredTechs 0 index check" @ ThisUpgradeSetup.RequiredTechs[0], class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');

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
	//Template.UpgradeCats.AddItem('lightsaber'); //TODO: Remember what I made UpgradeCats for, and set this if necessary
	
	`log(default.class @ GetFuncName() @ "finished setting up" @ ThisUpgradeSetup.UpgradeName, class'X2Utilities_GsLoot'.default.bLogUpgrades, 'GsLootModWOTC');

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

// #######################################################################################
// -------------------- UPGRADE FUNCTIONS ------------------------------------------------
// #######################################################################################

static function bool CanApplyUpgradeToWeapon(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.PRIMARY_WEAPON_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

// Leave here for the function that updates the base game upgrades
static function bool CanApplyUpgradeToWeaponOrPistol(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
	local string WeaponCat;
	
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	WeaponCat = X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat;
	
	if ( default.PRIMARY_WEAPON_CATEGORIES.Find(WeaponCat) == INDEX_NONE &&
		default.PISTOL_WEAPON_CATEGORIES.Find(WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToPistol(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.PISTOL_WEAPON_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToSword(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.SWORD_WEAPON_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToGremlin(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.GREMLIN_WEAPON_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToPsiAmp(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.PSIAMP_WEAPON_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToGrenadeLauncher(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.GRENADELAUNCHER_WEAPON_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToArmor(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade;
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.ARMOR_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToChassis(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade;
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();

	if ( default.CHASSIS_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool CanApplyUpgradeToBit(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( default.BIT_WEAPON_CATEGORIES.Find(X2WeaponTemplate(Weapon.GetMyTemplate()).WeaponCat) == INDEX_NONE )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

// #######################################################################################
// ------------------------ OLD TEMPLATE ADJUSTER ----------------------------------------
// #######################################################################################

static function UpdateOldTemplates()
{
	local X2ItemTemplateManager ItemManager;
	local X2WeaponUpgradeTemplate ItemTemplate;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('CritUpgrade_Bsc'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('CritUpgrade_Adv'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('CritUpgrade_Sup'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;

	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('AimUpgrade_Bsc'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('AimUpgrade_Adv'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('AimUpgrade_Sup'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('ClipSizeUpgrade_Bsc'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('ClipSizeUpgrade_Adv'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('ClipSizeUpgrade_Sup'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('FreeFireUpgrade_Bsc'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('FreeFireUpgrade_Adv'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('FreeFireUpgrade_Sup'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('MissDamageUpgrade_Bsc'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('MissDamageUpgrade_Adv'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('MissDamageUpgrade_Sup'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('FreeKillUpgrade_Bsc'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('FreeKillUpgrade_Adv'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('FreeKillUpgrade_Sup'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimaryOrPistol;
	
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('ReloadUpgrade_Bsc'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('ReloadUpgrade_Adv'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
	ItemTemplate = X2WeaponUpgradeTemplate(ItemManager.FindItemTemplate('ReloadUpgrade_Sup'));
	ItemTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeapon;
}

// #######################################################################################
// -------------------- ATTACHMENT GENERATOR ---------------------------------------------
// #######################################################################################

static function GenerateAttachmentsForUpgrades()
{
	local X2ItemTemplateManager			ItemMgr;
	local X2ItemTemplate				UpgradeTemplate, ItemTemplate;
	local array<X2WeaponTemplate>		WeaponTemplates;
	local X2WeaponTemplate				WeaponTemplate;
	local array<X2EquipmentTemplate>	ArmorTemplates;
	local X2EquipmentTemplate			EquipmentTemplate;
	local X2ArmorTemplate				ArmorTemplate;
	local X2WeaponUpgradeTemplate		UpgradeTemplate;
	local UpgradeSetup					Setup;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	WeaponTemplates = ItemMgr.GetAllWeaponTemplates();
	ArmorTemplates = ItemMgr.GetAllArmorTemplates();

	foreach WeaponTemplates(WeaponTemplate)
	{
		if (default.PRIMARY_WEAPON_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			foreach default.PRIMARY_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
		if (default.PISTOL_WEAPON_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			foreach default.PISTOL_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
		if (default.SWORD_WEAPON_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			foreach default.SWORD_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
		if (default.GREMLIN_WEAPON_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			foreach default.GREMLIN_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
		if (default.BIT_WEAPON_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			foreach default.BIT_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
		if (default.GRENADELAUNCHER_WEAPON_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			foreach default.GRENADELAUNCHER_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
		if (default.PSIAMP_WEAPON_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			foreach default.PSIAMP_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
	}
	
	foreach ArmorTemplates(EquipmentTemplate)
	{
		ArmorTemplate = X2ArmorTemplate(EquipmentTemplate)

		if (default.ARMOR_CATEGORIES.Find(ArmorTemplate.ArmorCat) != INDEX_NONE)
		{
			foreach default.ARMOR_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
		if (default.CHASSIS_CATEGORIES.Find(ArmorTemplate.ArmorCat) != INDEX_NONE)
		{
			foreach default.CHASSIS_UPGRADE_SETUPS(Setup)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(Setup.UpgradeName));
				UpgradeTemplate.AddUpgradeAttachment(Setup.SocketName, Setup.UIArmoryCameraPointTag, Setup.MeshPath, Setup.ProjectilePath, WeaponTemplate.DataName, Setup.AttachToPawn, Setup.IconPath, Setup.InventoryIconPath, Setup.InventoryCategoryIcon);
			}
		}
	}
}