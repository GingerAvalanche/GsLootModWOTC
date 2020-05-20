class GrimyLoot_PCS_HackRewards extends X2HackReward config(GrimyLootPCS_WOTC);

var config array<name> PCSRewards, PCSUpgrades;
var config bool bEnablePCS;
var config int iNumUpgradeSlots_Rare, iNumUpgradeSlots_Epic, iNumUpgradeSlots_Legendary;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	if ( default.bEnablePCS )
	{
		Templates.AddItem(CreateCommonPCSReward('GrimyCommonPCSReward'));
		Templates.AddItem(CreateRarePCSReward('GrimyRarePCSReward'));
		Templates.AddItem(CreateEpicPCSReward('GrimyEpicPCSReward'));
		Templates.AddItem(CreateLegendaryPCSReward('GrimyLegendaryPCSReward'));
	}

	return Templates;
}

static function X2HackRewardTemplate CreateCommonPCSReward(Name TemplateName)
{
	local X2HackRewardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2HackRewardTemplate', Template, TemplateName);
	Template.ApplyHackRewardFn = GiveCommonPCS;

	return Template;
}

static function X2HackRewardTemplate CreateRarePCSReward(Name TemplateName)
{
	local X2HackRewardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2HackRewardTemplate', Template, TemplateName);
	Template.ApplyHackRewardFn = GiveRarePCS;

	return Template;
}

static function X2HackRewardTemplate CreateEpicPCSReward(Name TemplateName)
{
	local X2HackRewardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2HackRewardTemplate', Template, TemplateName);
	Template.ApplyHackRewardFn = GiveEpicPCS;

	return Template;
}

static function X2HackRewardTemplate CreateLegendaryPCSReward(Name TemplateName)
{
	local X2HackRewardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2HackRewardTemplate', Template, TemplateName);
	Template.ApplyHackRewardFn = GiveLegendaryPCS;

	return Template;
}

function GiveCommonPCS(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local MAS_API_AchievementName AchNameObj;
	
	//Create a new item instance
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateManager.FindItemTemplate(default.PCSRewards[`SYNC_RAND_STATIC(default.PCSRewards.length)]);
	
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.OnCreation(ItemTemplate);

	ItemState.OnItemBuilt(NewGameState);
	Hacker.AddLoot(ItemState.GetReference(), NewGameState);
	
	AchNameObj = new class'MAS_API_AchievementName';
	AchNameObj.AchievementName = 'MAS_GrimyLootCommonPCS';
	`XEVENTMGR.TriggerEvent('UnlockAchievement', AchNameObj);
}

function GiveRarePCS(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local MAS_API_AchievementName AchNameObj;
	local XComGameState_GLootStore LootStoreState;
	local LootStruct LootStats;
	
	//Create a new item instance
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateManager.FindItemTemplate(default.PCSRewards[`SYNC_RAND_STATIC(default.PCSRewards.length)]);
	
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.OnCreation(ItemTemplate);

	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();
	if ( LootStoreState.ObjectID > 0 )
	{
		LootStats.IDOwner = ItemState.ObjectID;
		LootStats.NumUpgradeSlots = default.iNumUpgradeSlots_Rare;
		LootStats.TradingPostValue = class'X2Research_GsLoot'.static.GetRareEquipmentPrice();
		LootStoreState.AddToLootStore(LootStats);
	}

	if ( class'X2Research_GsLoot'.default.RANDOMIZE_NICKNAMES )
	{
		ItemState.Nickname = class'X2Research_GsLoot'.static.GenerateMissionNickname(0);
	}
	else
	{
		ItemState.Nickname = class'X2Research_GsLoot'.static.GetRarityPrefix(0) @ ItemTemplate.GetItemFriendlyNameNoStats();
	}
	class'X2Research_GsLoot'.static.ApplyNovelUpgrade(ItemState, default.PCSUpgrades);
	ItemState.OnItemBuilt(NewGameState);
	Hacker.AddLoot(ItemState.GetReference(), NewGameState);
	
	AchNameObj = new class'MAS_API_AchievementName';
	AchNameObj.AchievementName = 'MAS_GrimyLootRarePCS';
	`XEVENTMGR.TriggerEvent('UnlockAchievement', AchNameObj);
}

function GiveEpicPCS(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local MAS_API_AchievementName AchNameObj;
	local XComGameState_GLootStore LootStoreState;
	local LootStruct LootStats;
	
	//Create a new item instance
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateManager.FindItemTemplate(default.PCSRewards[`SYNC_RAND_STATIC(default.PCSRewards.length)]);
	
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.OnCreation(ItemTemplate);

	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();
	if ( LootStoreState.ObjectID > 0 )
	{
		LootStats.IDOwner = ItemState.ObjectID;
		LootStats.NumUpgradeSlots = default.iNumUpgradeSlots_Epic;
		LootStats.TradingPostValue = class'X2Research_GsLoot'.static.GetEpicEquipmentPrice();
		LootStoreState.AddToLootStore(LootStats);
	}

	if ( class'X2Research_GsLoot'.default.RANDOMIZE_NICKNAMES )
	{
		ItemState.Nickname = class'X2Research_GsLoot'.static.GenerateMissionNickname(1);
	}
	else
	{
		ItemState.Nickname = class'X2Research_GsLoot'.static.GetRarityPrefix(1) @ ItemTemplate.GetItemFriendlyNameNoStats();
	}
	class'X2Research_GsLoot'.static.ApplyNovelUpgrade(ItemState, default.PCSUpgrades);
	class'X2Research_GsLoot'.static.ApplyNovelUpgrade(ItemState, default.PCSUpgrades);

	ItemState.OnItemBuilt(NewGameState);
	Hacker.AddLoot(ItemState.GetReference(), NewGameState);
	
	AchNameObj = new class'MAS_API_AchievementName';
	AchNameObj.AchievementName = 'MAS_GrimyLootEpicPCS';
	`XEVENTMGR.TriggerEvent('UnlockAchievement', AchNameObj);
}

function GiveLegendaryPCS(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_GLootStore LootStoreState;
	local LootStruct LootStats;
	
	//Create a new item instance
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateManager.FindItemTemplate(default.PCSRewards[`SYNC_RAND_STATIC(default.PCSRewards.length)]);
	
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.OnCreation(ItemTemplate);

	LootStoreState = class'X2Utilities_GsLoot'.static.GetLootStore();
	if ( LootStoreState.ObjectID > 0 )
	{
		LootStats.IDOwner = ItemState.ObjectID;
		LootStats.NumUpgradeSlots = default.iNumUpgradeSlots_Legendary;
		LootStats.TradingPostValue = class'X2Research_GsLoot'.static.GetLegendaryEquipmentPrice();
		LootStoreState.AddToLootStore(LootStats);
	}

	if ( class'X2Research_GsLoot'.default.RANDOMIZE_NICKNAMES )
	{
		ItemState.Nickname = class'X2Research_GsLoot'.static.GenerateMissionNickname(2);
	}
	else
	{
		ItemState.Nickname = class'X2Research_GsLoot'.static.GetRarityPrefix(2) @ ItemTemplate.GetItemFriendlyNameNoStats();
	}
	class'X2Research_GsLoot'.static.ApplyNovelUpgrade(ItemState, default.PCSUpgrades);
	class'X2Research_GsLoot'.static.ApplyNovelUpgrade(ItemState, default.PCSUpgrades);
	class'X2Research_GsLoot'.static.ApplyNovelUpgrade(ItemState, default.PCSUpgrades);

	ItemState.OnItemBuilt(NewGameState);
	Hacker.AddLoot(ItemState.GetReference(), NewGameState);
}