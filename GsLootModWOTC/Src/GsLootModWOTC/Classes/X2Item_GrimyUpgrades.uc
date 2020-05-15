class GrimyLoot_UpgradesPrimary extends X2Item dependson GrimyLootUtilities config(GsLootModWOTC);

var config array<UpgradeSetup> PRIMARY_WEAPON_SETUPS;
var config array<UpgradeSetup> PISTOL_WEAPON_SETUPS;
var config array<UpgradeSetup> SWORD_WEAPON_SETUPS;
var config array<UpgradeSetup> GREMLIN_WEAPON_SETUPS;
var config array<UpgradeSetup> BIT_WEAPON_SETUPS;
var config array<UpgradeSetup> PSIAMP_WEAPON_SETUPS;
var config array<UpgradeSetup> GRENADELAUNCHER_WEAPON_SETUPS;
var config array<UpgradeSetup> SOLDIER_ARMOR_SETUPS;
var config array<UpgradeSetup> SPARK_ARMOR_SETUPS;

var config array<name> PRIMARY_WEAPON_TEMPLATE_NAMES;
var config array<name> PISTOL_WEAPON_TEMPLATE_NAMES;
var config array<name> SWORD_WEAPON_TEMPLATE_NAMES;
var config array<name> GREMLIN_WEAPON_TEMPLATE_NAMES;
var config array<name> BIT_WEAPON_TEMPLATE_NAMES;
var config array<name> PSIAMP_WEAPON_TEMPLATE_NAMES;
var config array<name> GRENADELAUNCHER_WEAPON_TEMPLATE_NAMES;
var config array<name> SOLDIER_ARMOR_TEMPLATE_NAMES;
var config array<name> SPARK_ARMOR_TEMPLATE_NAMES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	foreach default.PRIMARY_WEAPON_SETUPS(WeaponSetup)
	{
		Items.additem(class'GrimyLootUtilities'.static.CreateUpgrade(WeaponSetup, default.PRIMARY_WEAPON_TEMPLATE_NAMES, CanApplyUpgradeToWeapon));
	}

	foreach default.PISTOL_WEAPON_SETUPS(WeaponSetup)
	{
		Items.additem(class'GrimyLootUtilities'.static.CreateUpgrade(WeaponSetup, default.PISTOL_WEAPON_TEMPLATE_NAMES, CanApplyUpgradeToPistol));
	}

	foreach default.SWORD_WEAPON_SETUPS(WeaponSetup)
	{
		Items.additem(class'GrimyLootUtilities'.static.CreateUpgrade(WeaponSetup, default.SWORD_WEAPON_TEMPLATE_NAMES, CanApplyUpgradeToSword));
	}

	foreach default.GREMLIN_WEAPON_SETUPS(WeaponSetup)
	{
		Items.additem(class'GrimyLootUtilities'.static.CreateUpgrade(WeaponSetup, default.GREMLIN_WEAPON_TEMPLATE_NAMES, CanApplyUpgradeToGremlin));
	}

	foreach default.PSIAMP_WEAPON_SETUPS(WeaponSetup)
	{
		Items.additem(class'GrimyLootUtilities'.static.CreateUpgrade(WeaponSetup, default.PSIAMP_WEAPON_TEMPLATE_NAMES, CanApplyUpgradeToPsiAmp));
	}

	foreach default.GRENADELAUNCHER_WEAPON_SETUPS(WeaponSetup)
	{
		Items.additem(class'GrimyLootUtilities'.static.CreateUpgrade(WeaponSetup, default.GRENADELAUNCHER_WEAPON_TEMPLATE_NAMES, CanApplyUpgradeToGrenadeLauncher));
	}
	
	foreach default.SOLDIER_ARMOR_SETUPS(ArmorSetup)
	{
		Items.AddItem(class'GrimyLootUtilities'.static.CreateUpgrade(ArmorSetup, default.SOLDIER_ARMOR_TEMPLATE_NAMES, CanApplyUpgradeToArmor))
	}
	
	if ( class'GrimyLoot_AbilitiesSpark'.static.HasDLC3() )
	{
		foreach default.SPARK_ARMOR_SETUPS(ArmorSetup)
		{
			Items.AddItem(class'GrimyLootUtilities'.static.CreateUpgrade(ArmorSetup, default.SPARK_ARMOR_TEMPLATE_NAMES, CanApplyUpgradeToArmor))
		}

		foreach default.BIT_WEAPON_SETUPS(WeaponSetup)
		{
			Items.additem(class'GrimyLootUtilities'.static.CreateUpgrade(WeaponSetup, default.BIT_WEAPON_TEMPLATE_NAMES, CanApplyUpgradeToBit));
		}
	}
	
	return Items;
}

// #######################################################################################
// -------------------- GENERIC SETUP FUNCTIONS ------------------------------------------
// #######################################################################################

static function SetUpWeaponUpgradePrimary(out X2WeaponUpgradeTemplate Template, optional bool bSidearmOnly=false)
{
	if ( bSidearmOnly )
	{
		Template.CanApplyUpgradeToWeaponFn = class'GrimyLoot_UpgradesSecondary'.static.CanApplyUpgradeToWeaponPistol;
	}
	else
	{
		Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPrimary;
	}

	Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
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

	if ( Weapon.GetWeaponCategory() == 'grenade_launcher' )
	{
		return false;
	}
	if ( Weapon.InventorySlot != eInvSlot_PrimaryWeapon )
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
	
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();

	if ( Weapon.InventorySlot != eInvSlot_PrimaryWeapon &&
		Weapon.GetWeaponCategory() != 'pistol' &&
		Weapon.GetWeaponCategory() != 'sidearm' )
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

	if ( Weapon.GetWeaponCategory() != 'pistol' && Weapon.GetWeaponCategory() != 'sidearm' )
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
	
	if ( Weapon.GetWeaponCategory() != 'sword' && Weapon.GetWeaponCategory() != 'wristblade' && Weapon.GetWeaponCategory() != 'gauntlet' )
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
	
	if ( !Weapon.GetMyTemplate().IsA('X2GremlinTemplate') )
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
	
	if ( Weapon.GetWeaponCategory() != 'psiamp' )
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
	
	if ( Weapon.GetWeaponCategory() != 'grenade_launcher' )
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

	if ( Weapon.InventorySlot != eInvSlot_Armor )
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
	
	if ( Weapon.GetWeaponCategory() != 'sparkbit' )
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