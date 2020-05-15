class GrimyLoot_Research extends X2StrategyElement config(GsLootModWOTC);

struct ResearchCosts
{
	var name ItemName;
	var int Count;
};

struct AffixStruct
{
	var array<name> AffixesOne;
	var array<name> AffixesTwo;
	var array<name> AffixesThree;
	var array<name> AffixesFour;
};

enum EGearType
{
	eGear_AssaultRifle,
	eGear_Shotgun,
	eGear_MachineGun,
	eGear_SniperRifle,
	eGear_SMG,
	eGear_Vektor,
	eGear_Bullpup,
	eGear_LightArmor,
	eGear_MediumArmor,
	eGear_HeavyArmor,
	eGear_ReaperArmor,
	eGear_SkirmisherArmor,
	eGear_TemplarArmor,
	eGear_Pistol,
	eGear_Sidearm,
	eGear_Sword,
	eGear_WristBlade,
	eGear_ShardGauntlet,
	eGear_Gremlin,
	eGear_GrenadeLauncher,
	eGear_PsiAmp,
	eGear_SparkBit,
	eGear_SparkRifle,
	eGear_SparkChassis,
};

enum ELockboxRarity
{
	eRarity_None,
	eRarity_Rare,
	eRarity_Epic,
	eRarity_Legendary,
};

var config array<ResearchCosts> LW_RARE_RESEARCH_COST, LW_EPIC_RESEARCH_COST, LW_LEGENDARY_RESEARCH_COST;

var config int RARE_RESEARCH_COST, EPIC_RESEARCH_COST, LEGENDARY_RESEARCH_COST;
var config int RARE_RESEARCH_COST_INCREASE, EPIC_RESEARCH_COST_INCREASE, LEGENDARY_RESEARCH_COST_INCREASE;
var config int WEAPON_UNLOCK_CHANCE, ARMOR_UNLOCK_CHANCE;
var config int LIGHT_ARMOR_CHANCE, HEAVY_ARMOR_CHANCE;
var config int RARE_VALUE, EPIC_VALUE, LEGENDARY_VALUE;
var config bool RANDOMIZE_WEAPON_APPEARANCE, RANDOMIZE_NICKNAMES;
var config string RARE_COLOR, EPIC_COLOR, LEGENDARY_COLOR;

var config array<name> SCHEMATIC_NAMES;
var config array<name> PrimaryAffixOne, PrimaryAffixTwo, PrimaryAffixThree, PrimaryAffixFour;
var config array<name> PistolAffixOne, PistolAffixTwo, PistolAffixThree;
var config array<name> SwordAffixOne, SwordAffixTwo, SwordAffixThree, SwordAffixFour;
var config array<name> GremlinAffixOne, GremlinAffixTwo, GremlinAffixThree;
var config array<name> PsiAmpAffixOne, PsiAmpAffixTwo, PsiAmpAffixThree;
var config array<name> GrenadeLauncherAffixOne, GrenadeLauncherAffixTwo, GrenadeLauncherAffixThree;
var config array<name> ArmorAffixOne, ArmorAffixTwo, ArmorAffixThree, ArmorAffixFour;

var config array<name> BitAffixOne, BitAffixTwo, BitAffixThree;
var config array<name> ChassisAffixOne, ChassisAffixTwo, ChassisAffixThree;

var config array<name> AR_T1, SG_T1, LMG_T1, SR_T1, SMG_T1, VR_T1, BP_T1;
var config array<name> Pistol_T1, Sidearm_T1, Sword_T1, SGauntlet_T1, TGauntlet_T1, Gremlin_T1, PA_T1, GL_T1;
var config array<name> MA_T1, LA_T1, LA_T2, LA_T3, HA_T1, HA_T2, HA_T3, RA_T1, SA_T1, TA_T1;
var config array<name> SparkRifle_T1, SparkBit_T1, SparkArmor_T1;

var config array<name> JackpotAchievementItems;

var config bool bEnableAlienRulers;
var config int iAlienRulerMult;

var localized String m_strRareName, m_strEpicName, m_strLegendaryName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;
	
	Techs.AddItem(IdentifyRareLockboxTemplate());
	Techs.AddItem(IdentifyEpicLockboxTemplate());
	Techs.AddItem(IdentifyLegendaryLockboxTemplate());
	
	Techs.AddItem(IdentifyEpicLockboxInstantTemplate());
	Techs.AddItem(IdentifyLegendaryLockboxInstantTemplate());

	return Techs;
}

static function X2DataTemplate IdentifyRareLockboxTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Tech_IdentifyRareLockbox');
	Template.DisplayName = "<font color='#" $ class'GrimyLoot_Research'.default.RARE_COLOR $ "'><b>" $ Template.DisplayName $ "</b></font>";
	Template.PointsToComplete = GetRareResearchCost();
	Template.RepeatPointsIncrease = GetRareResearchCostIncrease();
	Template.bRepeatable = true;
	Template.strImage = "img:///GrimyLootPackage.Inv_Storage_Module";
	Template.SortingTier = 4;
	//Template.ResearchCompletedFn = IdentifyLockboxCompletedRare;

	// Requirements
	Template.Requirements.RequiredItems.AddItem('GrimyUnidentifiedLockboxRare');

	// Cost
	Artifacts.ItemTemplateName = 'GrimyUnidentifiedLockboxRare';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate IdentifyEpicLockboxTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Tech_IdentifyEpicLockbox');
	Template.DisplayName = "<font color='#" $ class'GrimyLoot_Research'.default.EPIC_COLOR $ "'><b>" $ Template.DisplayName $ "</b></font>";
	Template.PointsToComplete = GetEpicResearchCost();
	Template.RepeatPointsIncrease = GetEpicResearchCostIncrease();
	Template.bRepeatable = true;
	Template.strImage = "img:///GrimyLootPackage.LockboxAL";
	Template.SortingTier = 4;
	//Template.ResearchCompletedFn = IdentifyLockboxCompletedEpic;

	// Requirements
	Template.Requirements.RequiredItems.AddItem('GrimyUnidentifiedLockboxEpic');

	// Cost
	Artifacts.ItemTemplateName = 'GrimyUnidentifiedLockboxEpic';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate IdentifyLegendaryLockboxTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Tech_IdentifyLegendaryLockbox');
	Template.DisplayName = "<font color='#" $ class'GrimyLoot_Research'.default.LEGENDARY_COLOR $ "'><b>" $ Template.DisplayName $ "</b></font>";
	Template.PointsToComplete = GetLegendaryResearchCost();
	Template.RepeatPointsIncrease = GetLegendaryResearchCostIncrease();
	Template.bRepeatable = true;
	Template.strImage = "img:///GrimyLootPackage.LockboxER";
	Template.SortingTier = 4;
	//Template.ResearchCompletedFn = IdentifyLockboxCompletedLegendary;

	// Requirements
	Template.Requirements.RequiredItems.AddItem('GrimyUnidentifiedLockboxLegendary');

	// Cost
	Artifacts.ItemTemplateName = 'GrimyUnidentifiedLockboxLegendary';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate IdentifyEpicLockboxInstantTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Tech_IdentifyEpicLockboxInstant');
	Template.DisplayName = "<font color='#" $ class'GrimyLoot_Research'.default.EPIC_COLOR $ "'><b>" $ Template.DisplayName $ "</b></font>";
	Template.PointsToComplete = 1;
	Template.bRepeatable = true;
	Template.strImage = "img:///GrimyLootPackage.LockboxAL";
	Template.SortingTier = 4;
	//Template.ResearchCompletedFn = IdentifyLockboxCompletedEpic;

	// Requirements
	Template.Requirements.RequiredItems.AddItem('GrimyUnidentifiedLockboxEpic');
	Template.Requirements.RequiredItems.AddItem('AdventDatapad');

	// Cost
	Artifacts.ItemTemplateName = 'GrimyUnidentifiedLockboxEpic';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'AdventDatapad';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate IdentifyLegendaryLockboxInstantTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Tech_IdentifyLegendaryLockboxInstant');
	Template.DisplayName = "<font color='#" $ class'GrimyLoot_Research'.default.LEGENDARY_COLOR $ "'><b>" $ Template.DisplayName $ "</b></font>";
	Template.PointsToComplete = 1;
	Template.bRepeatable = true;
	Template.strImage = "img:///GrimyLootPackage.LockboxER";
	Template.SortingTier = 4;
	//Template.ResearchCompletedFn = IdentifyLockboxCompletedLegendary;

	// Requirements
	Template.Requirements.RequiredItems.AddItem('GrimyUnidentifiedLockboxLegendary');
	Template.Requirements.RequiredItems.AddItem('AlienDatapad');

	// Cost
	Artifacts.ItemTemplateName = 'GrimyUnidentifiedLockboxLegendary';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'AlienDatapad';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	return Template;
}

// ------------------------
// Identification Functions
// ------------------------
static function EGearType IdentifyIndex(bool bAllowArmorVariants)
{
	local int RandInt;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<EGearType> RollPool;
	
	XComHQ = `XCOMHQ;
	RandInt = `SYNC_RAND_STATIC(100);
	if ( RandInt < GetWeaponUnlockChance() )
	{
		RollPool.AddItem(eGear_AssaultRifle);
		RollPool.AddItem(eGear_Shotgun);
		RollPool.AddItem(eGear_MachineGun);
		RollPool.AddItem(eGear_SniperRifle);
		if ( XComHQ.HasItemByName('SMG_CV') )
		{
			RollPool.AddItem(eGear_SMG);
		}
		if ( XComHQ.MeetsSoldierClassGates('Reaper') )
		{
			RollPool.AddItem(eGear_Vektor);
		}
		if ( XComHQ.MeetsSoldierClassGates('Skirmisher') )
		{
			RollPool.AddItem(eGear_Bullpup);
		}
		if ( XComHQ.MeetsSoldierClassGates('Spark') )
		{
			RollPool.AddItem(eGear_SparkRifle);
		}
		return RollPool[`SYNC_RAND_STATIC(RollPool.Length)];
	}
	else if ( RandInt < GetWeaponUnlockChance() + GetArmorUnlockChance() )
	{
		if ( !bAllowArmorVariants ) { return eGear_MediumArmor; }
		if ( `SYNC_RAND_STATIC(100) < 30 ) {
			if ( XComHQ.MeetsSoldierClassGates('Reaper') )
			{
				RollPool.AddItem(eGear_ReaperArmor);
			}
			if ( XComHQ.MeetsSoldierClassGates('Skirmisher') )
			{
				RollPool.AddItem(eGear_SkirmisherArmor);
			}
			if ( XComHQ.MeetsSoldierClassGates('Templar') )
			{
				RollPool.AddItem(eGear_TemplarArmor);
			}
			if ( XComHQ.MeetsSoldierClassGates('Spark') )
			{
				RollPool.AddItem(eGear_SparkChassis);
			}
			if ( RollPool.Length > 0 )
			{
				return RollPool[`SYNC_RAND_STATIC(RollPool.Length)];
			}
		}
		RandInt = `SYNC_RAND_STATIC(100);
		if ( RandInt < GetLightArmorChance() && HasItem(XComHQ, 'LightPlatedArmor') )
		{
			return eGear_LightArmor;
		}
		else if ( RandInt < GetHeavyArmorChance() + GetLightArmorChance() && HasItem(XComHQ, 'HeavyPlatedArmor') )
		{
			return eGear_HeavyArmor;
		}
		else
		{
			return eGear_MediumArmor;
		}
	}
	else
	{
		RollPool.AddItem(eGear_Pistol);
		RollPool.AddItem(eGear_Sword);
		RollPool.AddItem(eGear_Gremlin);
		RollPool.AddItem(eGear_GrenadeLauncher);
		if ( XComHQ.MeetsSoldierClassGates('Skirmisher') )
		{
			RollPool.AddItem(eGear_WristBlade);
		}
		if ( XComHQ.MeetsSoldierClassGates('Templar') )
		{
			RollPool.AddItem(eGear_Sidearm);
			RollPool.AddItem(eGear_ShardGauntlet);
		}
		if ( XComHQ.HasFacilityByName('PsiChamber') )
		{
			RollPool.AddItem(eGear_PsiAmp);
		}
		if ( XComHQ.MeetsSoldierClassGates('Spark') )
		{
			RollPool.AddItem(eGear_SparkBit);
		}
		return RollPool[`SYNC_RAND_STATIC(RollPool.Length)];
	}
}

static function XComGameState_Item IdentifyByIndex(XComGameState_Tech TechState, EGearType GearType, ELockboxRarity Rarity)
{
	local XComGameState NewGameState;
	local XComGameState_Item LootState;
	local AffixStruct Affixes;
	local array<name> ConfigArray;
	local int BonusSlots;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Grimy Loot");

	switch ( GearType ) {
		case eGear_AssaultRifle:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.AR_T1;
			BonusSlots = 1;
			break;
		case eGear_Shotgun:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.SG_T1;
			BonusSlots = 1;
			break;
		case eGear_MachineGun:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.LMG_T1;
			BonusSlots = 1;
			break;
		case eGear_SniperRifle:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.SR_T1;
			BonusSlots = 1;
			break;
		case eGear_SMG:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.SMG_T1;
			BonusSlots = 1;
			break;
		case eGear_Vektor:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.VR_T1;
			BonusSlots = 1;
			break;
		case eGear_Bullpup:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.BP_T1;
			BonusSlots = 1;
			break;
		case eGear_LightArmor:
			Affixes.AffixesOne = default.ArmorAffixOne;
			Affixes.AffixesTwo = default.ArmorAffixTwo;
			Affixes.AffixesThree = default.ArmorAffixThree;
			Affixes.AffixesFour = default.ArmorAffixFour;
			ConfigArray = DetermineConfigArrayByArmorTierOwned(default.LA_T1, default.LA_T2, default.LA_T3);
			BonusSlots = 1;
			break;
		case eGear_MediumArmor:
			Affixes.AffixesOne = default.ArmorAffixOne;
			Affixes.AffixesTwo = default.ArmorAffixTwo;
			Affixes.AffixesThree = default.ArmorAffixThree;
			Affixes.AffixesFour = default.ArmorAffixFour;
			ConfigArray = default.MA_T1;
			BonusSlots = 1;
			break;
		case eGear_HeavyArmor:
			Affixes.AffixesOne = default.ArmorAffixOne;
			Affixes.AffixesTwo = default.ArmorAffixTwo;
			Affixes.AffixesThree = default.ArmorAffixThree;
			Affixes.AffixesFour = default.ArmorAffixFour;
			ConfigArray = DetermineConfigArrayByArmorTierOwned(default.HA_T1, default.HA_T2, default.HA_T3);
			BonusSlots = 1;
			break;
		case eGear_ReaperArmor:
			Affixes.AffixesOne = default.ArmorAffixOne;
			Affixes.AffixesTwo = default.ArmorAffixTwo;
			Affixes.AffixesThree = default.ArmorAffixThree;
			Affixes.AffixesFour = default.ArmorAffixFour;
			ConfigArray = default.RA_T1;
			BonusSlots = 1;
			break;
		case eGear_SkirmisherArmor:
			Affixes.AffixesOne = default.ArmorAffixOne;
			Affixes.AffixesTwo = default.ArmorAffixTwo;
			Affixes.AffixesThree = default.ArmorAffixThree;
			Affixes.AffixesFour = default.ArmorAffixFour;
			ConfigArray = default.SA_T1;
			BonusSlots = 1;
			break;
		case eGear_TemplarArmor:
			Affixes.AffixesOne = default.ArmorAffixOne;
			Affixes.AffixesTwo = default.ArmorAffixTwo;
			Affixes.AffixesThree = default.ArmorAffixThree;
			Affixes.AffixesFour = default.ArmorAffixFour;
			ConfigArray = default.TA_T1;
			BonusSlots = 1;
			break;
		case eGear_Pistol:
			Affixes.AffixesOne = default.PistolAffixOne;
			Affixes.AffixesTwo = default.PistolAffixTwo;
			Affixes.AffixesThree = default.PistolAffixThree;
			//Affixes.AffixesFour = default.PistolAffixFour;
			ConfigArray = default.Pistol_T1;
			break;
		case eGear_Sidearm:
			Affixes.AffixesOne = default.PistolAffixOne;
			Affixes.AffixesTwo = default.PistolAffixTwo;
			Affixes.AffixesThree = default.PistolAffixThree;
			//Affixes.AffixesFour = default.PistolAffixFour;
			ConfigArray = default.Sidearm_T1;
			break;
		case eGear_Sword:
			Affixes.AffixesOne = default.SwordAffixOne;
			Affixes.AffixesTwo = default.SwordAffixTwo;
			Affixes.AffixesThree = default.SwordAffixThree;
			//Affixes.AffixesFour = default.SwordAffixFour;
			ConfigArray = default.Sword_T1;
			break;
		case eGear_WristBlade:
			Affixes.AffixesOne = default.SwordAffixOne;
			Affixes.AffixesTwo = default.SwordAffixTwo;
			Affixes.AffixesThree = default.SwordAffixThree;
			//Affixes.AffixesFour = default.SwordAffixFour;
			ConfigArray = default.SGauntlet_T1;
			break;
		case eGear_ShardGauntlet:
			Affixes.AffixesOne = default.SwordAffixOne;
			Affixes.AffixesTwo = default.SwordAffixTwo;
			Affixes.AffixesThree = default.SwordAffixThree;
			Affixes.AffixesFour = default.SwordAffixFour;
			ConfigArray = default.TGauntlet_T1;
			BonusSlots = 1;
			break;
		case eGear_Gremlin:
			Affixes.AffixesOne = default.GremlinAffixOne;
			Affixes.AffixesTwo = default.GremlinAffixTwo;
			Affixes.AffixesThree = default.GremlinAffixThree;
			//Affixes.AffixesFour = default.GremlinAffixFour;
			ConfigArray = default.Gremlin_T1;
			break;
		case eGear_GrenadeLauncher:
			Affixes.AffixesOne = default.GrenadeLauncherAffixOne;
			Affixes.AffixesTwo = default.GrenadeLauncherAffixTwo;
			Affixes.AffixesThree = default.GrenadeLauncherAffixThree;
			//Affixes.AffixesFour = default.GrenadeLauncherAffixFour;
			ConfigArray = default.GL_T1;
			break;
		case eGear_PsiAmp:
			Affixes.AffixesOne = default.PsiAmpAffixOne;
			Affixes.AffixesTwo = default.PsiAmpAffixTwo;
			Affixes.AffixesThree = default.PsiAmpAffixThree;
			//Affixes.AffixesFour = default.PsiAmpAffixFour;
			ConfigArray = default.PA_T1;
			break;
		case eGear_SparkBit:
			Affixes.AffixesOne = default.BitAffixOne;
			Affixes.AffixesTwo = default.BitAffixTwo;
			Affixes.AffixesThree = default.BitAffixThree;
			//Affixes.AffixesFour = default.BitAffixFour;
			ConfigArray = default.SparkBit_T1;
			break;
		case eGear_SparkRifle:
			Affixes.AffixesOne = default.PrimaryAffixOne;
			Affixes.AffixesTwo = default.PrimaryAffixTwo;
			Affixes.AffixesThree = default.PrimaryAffixThree;
			//Affixes.AffixesFour = default.PrimaryAffixFour;
			ConfigArray = default.SparkRifle_T1;
			BonusSlots = 1;
			break;
		case eGear_SparkChassis:
			Affixes.AffixesOne = default.ChassisAffixOne;
			Affixes.AffixesTwo = default.ChassisAffixTwo;
			Affixes.AffixesThree = default.ChassisAffixThree;
			//Affixes.AffixesFour = default.ChassisAffixFour;
			ConfigArray = default.SparkArmor_T1;
			BonusSlots = 1;
			break;
	}
	
	LootState = Identify(NewGameState, Rarity, BonusSlots, ConfigArray, Affixes);
	
	TechState.ItemRewards.AddItem(LootState.GetMyTemplate()); // Needed for UI Alert display info
	TechState.bSeenResearchCompleteScreen = true; // Reset the research report for techs that are repeatable

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	return LootState;
}

static function XComGameState_Item Identify(XComGameState NewGameState, ELockboxRarity Rarity, int BonusSlots, array<name> ConfigArray, AffixStruct Affixes)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local name ItemName;
	local GrimyLoot_GameState_LootStore LootStoreState;
	local LootStruct LootStats;
	local int NumSlots;
	
	XComHQ = `XCOMHQ;
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemName = ConfigArray[`SYNC_RAND_STATIC(ConfigArray.length)];
	
	while ( !HasItem(XComHQ,ItemName) )
	{
		ConfigArray.RemoveItem(ItemName);
		if (ConfigArray.length == 0)
		{
			`redscreen("GrimyLoot_Research::Identify cannot find a real template!");
			return none;
		}
		ItemName = ConfigArray[`SYNC_RAND_STATIC(ConfigArray.length)];
	}
	
	ItemTemplate = ItemTemplateManager.FindItemTemplate(ItemName);

	UpdateItemTemplateToHighestAvailableUpgrade(XComHQ, ItemTemplate);
	
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);

	LootStoreState = class'GrimyLootUtilities'.static.GetLootStore();
	NumSlots = Rarity + BonusSlots;
	if ( LootStoreState.ObjectID > 0 )
	{
		LootStats.IDOwner = ItemState.ObjectID;
		LootStats.NumUpgradeSlots = NumSlots;
		switch ( Rarity )
		{
			case eRarity_Rare:
				LootStats.TradingPostValue = GetRareEquipmentPrice();
				break;
			case eRarity_Epic:
				LootStats.TradingPostValue = GetEpicEquipmentPrice();
				break;
			case eRarity_Legendary:
				LootStats.TradingPostValue = GetLegendaryEquipmentPrice();
		}
		LootStoreState.AddToLootStore(LootStats);
	}

	if ( default.RANDOMIZE_NICKNAMES )
	{
		ItemState.Nickname = GenerateNickname(Rarity);
	}
	else
	{
		ItemState.Nickname = GetRarityPrefix(Rarity) @ ItemTemplate.GetItemFriendlyNameNoStats();
	}
	
	if ( default.RANDOMIZE_WEAPON_APPEARANCE )
	{
		ItemState.WeaponAppearance.iWeaponTint = `SYNC_RAND_STATIC(`CONTENT.GetColorPalette(ePalette_ArmorTint).Entries.length);
		ItemState.WeaponAppearance.iWeaponDeco = `SYNC_RAND_STATIC(`CONTENT.GetColorPalette(ePalette_ArmorTint).Entries.length);
		ItemState.WeaponAppearance.nmWeaponPattern = GetRandPatternName();
	}
	
	switch ( NumSlots )
	{
		case 4:
			ApplyNovelUpgrade(ItemState, Affixes.AffixesFour);
		case 3:
			ApplyNovelUpgrade(ItemState, Affixes.AffixesThree);
		case 2:
			ApplyNovelUpgrade(ItemState, Affixes.AffixesTwo);
		case 1:
		default:
			ApplyNovelUpgrade(ItemState, Affixes.AffixesOne);
	}
	
	ItemState.OnItemBuilt(NewGameState);
	XComHQ.PutItemInInventory(NewGameState, ItemState);
	`XEVENTMGR.TriggerEvent('ItemConstructionCompleted', ItemState, ItemState, NewGameState);

	return ItemState;
}

static function array<name> DetermineConfigArrayByArmorTierOwned(array<name> ArrayOne, array<name> ArrayTwo, array<name> ArrayThree)
{
	local XComGameState_HeadquartersXCom XComHQ;
	
	XComHQ = `XCOMHQ;
	
	if ( XComHQ.HasItemByName('MediumPoweredArmor') )
	{
		return ArrayThree;
	}
	else if ( XComHQ.HasItemByName('MediumPlatedArmor') )
	{
		return ArrayTwo;
	}
	else
	{
		return ArrayOne;
	}
}

//#############################################################################################
//----------------   UPGRADE MANAGEMENT   -----------------------------------------------------
//#############################################################################################
static function UpdateItemTemplateToHighestAvailableUpgrade(XComGameState_HeadquartersXCom XComHQ, out X2ItemTemplate ItemTemplate)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate UpgradedItemTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	// Get the item template which has this item as a base (should be only one)
	UpgradedItemTemplate = ItemTemplateManager.GetUpgradedItemTemplateFromBase(ItemTemplate.DataName);
	while ( UpgradedItemTemplate != none )
	{
		if ( XComHQ.HasItemByName(UpgradedItemTemplate.DataName) || XComHQ.HasItemByName(UpgradedItemTemplate.CreatorTemplateName) )
		{
			ItemTemplate = UpgradedItemTemplate;
		}
		
		UpgradedItemTemplate = ItemTemplateManager.GetUpgradedItemTemplateFromBase(UpgradedItemTemplate.DataName);
	}
}

static function string GenerateNickname(ELockboxRarity rarity)
{
	local X2SoldierClassTemplateManager		SoldierManager;
	local array<X2SoldierClassTemplate>		SoldierArray;
	local X2SoldierClassTemplate			SoldierTemplate;
	local string							RetName, AlertName;

	SoldierManager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	SoldierArray = SoldierManager.GetAllSoldierClassTemplates();
	SoldierTemplate = SoldierArray[`SYNC_RAND_STATIC(SoldierArray.length)];
	Switch ( `SYNC_RAND_STATIC(3) )
	{
		case 0:
			Retname = SoldierTemplate.RandomNicknames[`SYNC_RAND_STATIC(SoldierTemplate.RandomNicknames.length)];
			break;
		case 1:
			Retname = SoldierTemplate.RandomNicknames_Female[`SYNC_RAND_STATIC(SoldierTemplate.RandomNicknames_Female.length)];
			break;
		case 2:
			Retname = SoldierTemplate.RandomNicknames_Male[`SYNC_RAND_STATIC(SoldierTemplate.RandomNicknames_Male.length)];
			break;
	}
	if ( Retname == "" )
	{
		return GenerateNickname(rarity);
	}

	AlertName = "<font size='50'><b>" $ RetName $ "</b></font>";
	switch ( rarity )
	{
		case eRarity_Rare:
			RetName = "<font color='#" $ default.RARE_COLOR $ "'><b>" $ RetName $ "</b></font>";
			break;
		case eRarity_Epic:
			RetName = "<font color='#" $ default.EPIC_COLOR $ "'><b>" $ RetName $ "</b></font>";
			break;
		case eRarity_Legendary:
			RetName = "<font color='#" $ default.LEGENDARY_COLOR $ "'><b>" $ RetName $ "</b></font>";
			break;
	}
	class'GrimyLoot_UIScreen'.static.SetRecentName(AlertName);

	return RetName;
}

static function string GenerateMissionNickname(ELockboxRarity rarity)
{
	local string	RetName, AlertName;

	RetName = class'XGMission'.static.GenerateOpName() $ " Simulation";

	AlertName = "<font size='50'><b>" $ RetName $ "</b></font>";
	switch ( rarity ) {
		case eRarity_Rare:
			RetName = "<font color='#" $ default.RARE_COLOR $ "'><b>" $ RetName $ "</b></font>";
			break;
		case eRarity_Epic:
			RetName = "<font color='#" $ default.EPIC_COLOR $ "'><b>" $ RetName $ "</b></font>";
			break;
		case eRarity_Legendary:
			RetName = "<font color='#" $ default.LEGENDARY_COLOR $ "'><b>" $ RetName $ "</b></font>";
			break;
	}
	class'GrimyLoot_UIScreen'.static.SetRecentName(AlertName);

	return RetName;
}

static function string GetRarityPrefix(ELockboxRarity Tier)
{
	switch ( Tier )
	{
		case eRarity_Rare:
			return default.m_strRareName;
		case eRarity_Epic:
			return default.m_strEpicName;
		case eRarity_Legendary:
			return default.m_strLegendaryName;
		default:
			return "";
	}
}

static function ApplyNovelUpgrade(XComGameState_Item ItemState, array<name> UpgradeList) {
	local X2WeaponUpgradeTemplate TestUpgrade;
	local int UpgradeIndex;
	local X2ItemTemplateManager ItemTemplateManager;

	//Create a new item instance
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	UpgradeIndex = `SYNC_RAND_STATIC( UpgradeList.Length );
	TestUpgrade = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(UpgradeList[UpgradeIndex]));
	
	if ( TestUpgrade == none || HasUpgrade(ItemState, TestUpgrade) || ( HasProwlersProfit() && TestUpgrade.Tier == 0 ) )
	{
		ApplyNovelUpgrade(ItemState, UpgradeList);
	}
	else
	{
		if ( testUpgrade == X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate('GrimyProcessor_Bsc')) )
		{
			ItemState.ApplyWeaponUpgradeTemplate(X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate('GrimyWildcat_Bsc')));
		}
		else if ( testUpgrade == X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate('GrimyProcessor_Adv')) )
		{
			ItemState.ApplyWeaponUpgradeTemplate(X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate('GrimyWildcat_Adv')));
		}
		else if ( testUpgrade == X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate('GrimyProcessor_Sup')) )
		{
			ItemState.ApplyWeaponUpgradeTemplate(X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate('GrimyWildcat_Sup')));
		}
		else
		{
			ItemState.ApplyWeaponUpgradeTemplate(TestUpgrade);
		}
	}
	if ( class'GrimyLoot_ScreenListener_MCM'.default.FoundUpgrades.Find(UpgradeList[UpgradeIndex]) == INDEX_NONE )
	{
		class'GrimyLoot_ScreenListener_MCM'.default.FoundUpgrades.AddItem(UpgradeList[UpgradeIndex]);
	}
}

static function bool HasUpgrade(XComGameState_Item ItemState, X2WeaponUpgradeTemplate TestUpgrade)
{
	local array<name> UpgradeList;
	local name ReadTemplate;

	UpgradeList = ItemState.GetMyWeaponUpgradeTemplateNames();

	foreach UpgradeList(ReadTemplate)
	{
		if ( TestUpgrade.MutuallyExclusiveUpgrades.Find(ReadTemplate) != INDEX_NONE )
		{
			return true;
		}
	}

	return false;
}

static function name GetRandPatternName()
{
	local int i;
	local array<X2BodyPartTemplate> BodyParts;
	local X2BodyPartTemplateManager PartManager;

	PartManager = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();
	PartManager.GetFilteredUberTemplates("Patterns", PartManager, `XCOMGAME.SharedBodyPartFilter.FilterAny, BodyParts);
	i = `SYNC_RAND_STATIC(BodyParts.Length);

	if(BodyParts[i].DisplayName != "")
		return BodyParts[i].DataName;
	else 
		return '';
}

static function bool HasItem(XComGameState_HeadquartersXCom XComHQ, name ItemName)
{
	local array<XComGameState_Unit> Soldiers;
	local int iSoldier;

	if ( XComHQ.HasItemByName(ItemName) )
	{
		return true;
	}

	Soldiers = XComHQ.GetSoldiers();
	for (iSoldier = 0; iSoldier < Soldiers.Length; iSoldier++)
	{
		if (Soldiers[iSoldier].HasItemOfTemplateType(ItemName))
		{
			return true;
		}
	}

	return false;
}

//#############################################################################################
//-----------------   CONTINENT SCANNER   -----------------------------------------------------
//#############################################################################################
static function bool HasProwlersProfit()
{
	local XComGameState_Continent ContinentState;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Continent', ContinentState)
	{
		if ( ContinentState.ContinentBonus == 'ContinentBonus_ProwlersProfit' && ContinentState.bContinentBonusActive )
		{
			return true;
		}
	}
	return false;
}

//#############################################################################################
//----------------------   ALIEN RULERS   -----------------------------------------------------
//#############################################################################################

static function EnableAlienRulers()
{
	local int i, j, NumItems;
	
	if ( default.bEnableAlienRulers )
	{
		NumItems = default.AR_T1.length;
		for ( i = 0; i < NumItems; i++ )
		{
			for ( j = 1; j < default.iAlienRulerMult; j++ )
			{
				default.AR_T1.AddItem(default.AR_T1[i]);
			}
			default.AR_T1.AddItem('AlienHunterRifle_CV');
		}
		
		NumItems = default.Pistol_T1.length;
		for ( i = 0; i < NumItems; i++ )
		{
			for ( j = 1; j < default.iAlienRulerMult; j++ )
			{
				default.Pistol_T1.AddItem(default.Pistol_T1[i]);
			}
			default.Pistol_T1.AddItem('AlienHunterPistol_CV');
		}
		
		NumItems = default.Sword_T1.length;
		for ( i = 0; i < NumItems; i++ )
		{
			for ( j = 1; j < default.iAlienRulerMult; j++ )
			{
				default.Sword_T1.AddItem(default.Sword_T1[i]);
			}
			default.Sword_T1.AddItem('AlienHunterAxe_CV');
		}
		
		NumItems = default.MA_T1.length;
		for ( i = 0; i < NumItems; i++ )
		{
			for ( j = 1; j < default.iAlienRulerMult; j++ )
			{
				default.MA_T1.AddItem(default.MA_T1[i]);
			}
			default.MA_T1.AddItem('MediumAlienArmor');
		}
		
		NumItems = default.LA_T2.length;
		for ( i = 0; i < NumItems; i++ )
		{
			for ( j = 1; j < default.iAlienRulerMult; j++ )
			{
				default.LA_T2.AddItem(default.LA_T2[i]);
			}
			default.LA_T2.AddItem('LightAlienArmor');
		}
		
		NumItems = default.HA_T2.length;
		for ( i = 0; i < NumItems; i++ )
		{
			for ( j = 1; j < default.iAlienRulerMult; j++ )
			{
				default.HA_T2.AddItem(default.HA_T2[i]);
			}
			default.HA_T2.AddItem('HeavyAlienArmor');
		}
	}
}

//#############################################################################################
//----------------------   MCM FUNCTIONS   ----------------------------------------------------
//#############################################################################################

static function int GetRareEquipmentPrice()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.RARE_VALUE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.RARE_VALUE;
	}
	else
	{
		return default.RARE_VALUE;
	}
}

static function int GetEpicEquipmentPrice()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.EPIC_VALUE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.EPIC_VALUE;
	}
	else
	{
		return default.EPIC_VALUE;
	}
}

static function int GetLegendaryEquipmentPrice()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_VALUE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_VALUE;
	}
	else 
	{
		return default.LEGENDARY_VALUE;
	}
}

static function int GetRareResearchCost()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.RARE_RESEARCH_COST > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.RARE_RESEARCH_COST;
	}
	else
	{
		return default.RARE_RESEARCH_COST;
	}
}

static function int GetEpicResearchCost()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.EPIC_RESEARCH_COST > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.EPIC_RESEARCH_COST;
	}
	else
	{
		return default.EPIC_RESEARCH_COST;
	}
}

static function int GetLegendaryResearchCost()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_RESEARCH_COST > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_RESEARCH_COST;
	}
	else
	{
		return default.LEGENDARY_RESEARCH_COST;
	}
}

static function int GetRareResearchCostIncrease()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.RARE_RESEARCH_COST_INCREASE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.RARE_RESEARCH_COST_INCREASE;
	}
	else
	{
		return default.RARE_RESEARCH_COST_INCREASE;
	}
}

static function int GetEpicResearchCostIncrease()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.EPIC_RESEARCH_COST_INCREASE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.EPIC_RESEARCH_COST_INCREASE;
	}
	else
	{
		return default.EPIC_RESEARCH_COST_INCREASE;
	}
}

static function int GetLegendaryResearchCostIncrease()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_RESEARCH_COST_INCREASE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_RESEARCH_COST_INCREASE;
	}
	else
	{
		return default.LEGENDARY_RESEARCH_COST_INCREASE;
	}
}

static function int GetLightArmorChance()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.LIGHT_ARMOR_CHANCE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.LIGHT_ARMOR_CHANCE;
	}
	else
	{
		return default.LIGHT_ARMOR_CHANCE;
	}
}

static function int GetHeavyArmorChance()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.HEAVY_ARMOR_CHANCE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.HEAVY_ARMOR_CHANCE;
	}
	else
	{
		return default.HEAVY_ARMOR_CHANCE;
	}
}

static function int GetWeaponUnlockChance()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.WEAPON_UNLOCK_CHANCE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.WEAPON_UNLOCK_CHANCE;
	}
	else
	{
		return default.WEAPON_UNLOCK_CHANCE;
	}
}

static function int GetArmorUnlockChance()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.ARMOR_UNLOCK_CHANCE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.ARMOR_UNLOCK_CHANCE;
	}
	else
	{
		return default.ARMOR_UNLOCK_CHANCE;
	}
}