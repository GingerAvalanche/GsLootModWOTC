class GrimyLoot_Screenlistener_MCM extends Object config(GrimyLootWOTC_NullConfig);

`include(GrimyLootModWOTC/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(GrimyLootModWOTC/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

var config bool CFG_CLICKED;
var config int CONFIG_VERSION;

//================================
//========Slider Parameters=======
//================================
var config array<name> FoundUpgrades;

var config int RARE_ARTIFACT_VALUE, EPIC_ARTIFACT_VALUE, LEGENDARY_ARTIFACT_VALUE;
var MCM_API_Slider ArtifactSlider1, ArtifactSlider2, ArtifactSlider3;

var config int BASIC_UPGRADE_VALUE, ADVANCED_UPGRADE_VALUE, SUPERIOR_UPGRADE_VALUE;
var MCM_API_Slider UpgradeSlider1, UpgradeSlider2, UpgradeSlider3;

var config int RARE_VALUE, EPIC_VALUE, LEGENDARY_VALUE;
var MCM_API_Slider EquipmentSlider1, EquipmentSlider2, EquipmentSlider3;

var config int RARE_RESEARCH_COST, EPIC_RESEARCH_COST, LEGENDARY_RESEARCH_COST;
var config int RARE_RESEARCH_COST_INCREASE, EPIC_RESEARCH_COST_INCREASE, LEGENDARY_RESEARCH_COST_INCREASE;
var MCM_API_Slider ResearchSlider1, ResearchSlider2, ResearchSlider3;
var MCM_API_Slider ResearchIncSlider1, ResearchIncSlider2, ResearchIncSlider3;

var config int LIGHT_ARMOR_CHANCE, HEAVY_ARMOR_CHANCE, WEAPON_UNLOCK_CHANCE, ARMOR_UNLOCK_CHANCE;
var MCM_API_Slider ArmorSlider1, ArmorSlider2, UnlockSlider1, UnlockSlider2;

var localized string MOD_NAME;
var localized string ARTIFACTS_HEADER, ARTIFACTS_DESCRIPTION, ARTIFACTS_TITLE1, ARTIFACTS_TITLE2, ARTIFACTS_TITLE3;
var localized string UPGRADES_HEADER, UPGRADES_DESCRIPTION, UPGRADES_TITLE1, UPGRADES_TITLE2, UPGRADES_TITLE3;
var localized string EQUIPMENT_HEADER, EQUIPMENT_DESCRIPTION, EQUIPMENT_TITLE1, EQUIPMENT_TITLE2, EQUIPMENT_TITLE3;
var localized string RESEARCH_HEADER, RESEARCH_DESCRIPTION, RESEARCH_TITLE1, RESEARCH_TITLE2, RESEARCH_TITLE3;
var localized string RESEARCH_INC_DESCRIPTION, RESEARCH_INC_TITLE1, RESEARCH_INC_TITLE2, RESEARCH_INC_TITLE3;
var localized string ARMOR_HEADER, ARMOR_DESCRIPTION1, ARMOR_DESCRIPTION2, ARMOR_TITLE1, ARMOR_TITLE2;
var localized string UNLOCK_HEADER, UNLOCK_DESCRIPTION1, UNLOCK_DESCRIPTION2, UNLOCK_TITLE1, UNLOCK_TITLE2;

`MCM_CH_VersionChecker(class'GrimyLoot_Artifacts'.default.Version,CONFIG_VERSION)

function OnInit(UIScreen Screen)
{
	`MCM_API_Register(Screen, ClientModCallback);
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup ArtifactGroup, UpgradeGroup, EquipmentGroup, ResearchGroup, ArmorGroup, UnlockGroup;

	// Workaround that's needed in order to be able to "save" files.
	LoadInitialValues();

	Page = ConfigAPI.NewSettingsPage(MOD_NAME);
	Page.SetPageTitle(MOD_NAME);
	Page.SetSaveHandler(SaveButtonClicked);
	Page.SetCancelHandler(RevertButtonClicked);
	Page.EnableResetButton(ResetButtonClicked);
	
	ArmorGroup = Page.AddGroup('MCDT1', ARMOR_HEADER);
	UnlockGroup = Page.AddGroup('MCDT1', UNLOCK_HEADER);
	ResearchGroup = Page.AddGroup('MCDT1', RESEARCH_HEADER);
	ArtifactGroup = Page.AddGroup('MCDT1', ARTIFACTS_HEADER);
	UpgradeGroup = Page.AddGroup('MCDT1', UPGRADES_HEADER);
	EquipmentGroup = Page.AddGroup('MCDT1', EQUIPMENT_HEADER);

	ArtifactSlider1 = ArtifactGroup.AddSlider('slider', ARTIFACTS_TITLE1, ARTIFACTS_DESCRIPTION, 5.0, 500.0, 1.0, RARE_ARTIFACT_VALUE, Artifact1SaveLogger);
	ArtifactSlider2 = ArtifactGroup.AddSlider('slider', ARTIFACTS_TITLE2, ARTIFACTS_DESCRIPTION, 5.0, 500.0, 1.0, EPIC_ARTIFACT_VALUE, Artifact2SaveLogger);
	ArtifactSlider3 = ArtifactGroup.AddSlider('slider', ARTIFACTS_TITLE3, ARTIFACTS_DESCRIPTION, 5.0, 500.0, 1.0, LEGENDARY_ARTIFACT_VALUE, Artifact3SaveLogger);

	UpgradeSlider1 = UpgradeGroup.AddSlider('slider', UPGRADES_TITLE1, UPGRADES_DESCRIPTION, 5.0, 500.0, 1.0, BASIC_UPGRADE_VALUE, Upgrade1SaveLogger);
	UpgradeSlider2 = UpgradeGroup.AddSlider('slider', UPGRADES_TITLE2, UPGRADES_DESCRIPTION, 5.0, 500.0, 1.0, ADVANCED_UPGRADE_VALUE, Upgrade2SaveLogger);
	UpgradeSlider3 = UpgradeGroup.AddSlider('slider', UPGRADES_TITLE3, UPGRADES_DESCRIPTION, 5.0, 500.0, 1.0, SUPERIOR_UPGRADE_VALUE, Upgrade3SaveLogger);

	EquipmentSlider1 = EquipmentGroup.AddSlider('slider', EQUIPMENT_TITLE1, EQUIPMENT_DESCRIPTION, 5.0, 500.0, 1.0, RARE_VALUE, Equipment1SaveLogger);
	EquipmentSlider2 = EquipmentGroup.AddSlider('slider', EQUIPMENT_TITLE2, EQUIPMENT_DESCRIPTION, 5.0, 500.0, 1.0, EPIC_VALUE, Equipment2SaveLogger);
	EquipmentSlider3 = EquipmentGroup.AddSlider('slider', EQUIPMENT_TITLE3, EQUIPMENT_DESCRIPTION, 5.0, 500.0, 1.0, LEGENDARY_VALUE, Equipment3SaveLogger);

	ResearchSlider1 = ResearchGroup.AddSlider('slider', RESEARCH_TITLE1, RESEARCH_DESCRIPTION, 240.0, 24000.0, 1.0, RARE_RESEARCH_COST, Research1SaveLogger);
	ResearchSlider2 = ResearchGroup.AddSlider('slider', RESEARCH_TITLE2, RESEARCH_DESCRIPTION, 240.0, 24000.0, 1.0, EPIC_RESEARCH_COST, Research2SaveLogger);
	ResearchSlider3 = ResearchGroup.AddSlider('slider', RESEARCH_TITLE3, RESEARCH_DESCRIPTION, 240.0, 24000.0, 1.0, LEGENDARY_RESEARCH_COST, Research3SaveLogger);

	ResearchIncSlider1 = ResearchGroup.AddSlider('slider', RESEARCH_INC_TITLE1, RESEARCH_INC_DESCRIPTION, 24.0, 2400.0, 1.0, RARE_RESEARCH_COST_INCREASE, ResearchInc1SaveLogger);
	ResearchIncSlider2 = ResearchGroup.AddSlider('slider', RESEARCH_INC_TITLE2, RESEARCH_INC_DESCRIPTION, 24.0, 2400.0, 1.0, EPIC_RESEARCH_COST_INCREASE, ResearchInc2SaveLogger);
	ResearchIncSlider3 = ResearchGroup.AddSlider('slider', RESEARCH_INC_TITLE3, RESEARCH_INC_DESCRIPTION, 24.0, 2400.0, 1.0, LEGENDARY_RESEARCH_COST_INCREASE, ResearchInc3SaveLogger);

	ArmorSlider1 = ArmorGroup.AddSlider('slider', ARMOR_TITLE1, ARMOR_DESCRIPTION1, 0.0, 100.0, 100.0 / 101.0, LIGHT_ARMOR_CHANCE, Armor1SaveLogger);
	ArmorSlider2 = ArmorGroup.AddSlider('slider', ARMOR_TITLE2, ARMOR_DESCRIPTION2, 0.0, 100.0, 100.0 / 101.0, HEAVY_ARMOR_CHANCE, Armor2SaveLogger);

	UnlockSlider1 = UnlockGroup.AddSlider('slider', UNLOCK_TITLE1, UNLOCK_DESCRIPTION1, 0.0, 100.0, 100.0 / 101.0, WEAPON_UNLOCK_CHANCE, Unlock1SaveLogger);
	UnlockSlider2 = UnlockGroup.AddSlider('slider', UNLOCK_TITLE2, UNLOCK_DESCRIPTION2, 0.0, 100.0, 100.0 / 101.0, ARMOR_UNLOCK_CHANCE, Unlock2SaveLogger);

	Page.ShowSettings();
}

`MCM_API_BasicSliderSaveHandler(Artifact1SaveLogger, RARE_ARTIFACT_VALUE)
`MCM_API_BasicSliderSaveHandler(Artifact2SaveLogger, EPIC_ARTIFACT_VALUE)
`MCM_API_BasicSliderSaveHandler(Artifact3SaveLogger, LEGENDARY_ARTIFACT_VALUE)
`MCM_API_BasicSliderSaveHandler(Upgrade1SaveLogger, BASIC_UPGRADE_VALUE)
`MCM_API_BasicSliderSaveHandler(Upgrade2SaveLogger, ADVANCED_UPGRADE_VALUE)
`MCM_API_BasicSliderSaveHandler(Upgrade3SaveLogger, SUPERIOR_UPGRADE_VALUE)
`MCM_API_BasicSliderSaveHandler(Equipment1SaveLogger, RARE_VALUE)
`MCM_API_BasicSliderSaveHandler(Equipment2SaveLogger, EPIC_VALUE)
`MCM_API_BasicSliderSaveHandler(Equipment3SaveLogger, LEGENDARY_VALUE)
`MCM_API_BasicSliderSaveHandler(Research1SaveLogger, RARE_RESEARCH_COST)
`MCM_API_BasicSliderSaveHandler(Research2SaveLogger, EPIC_RESEARCH_COST)
`MCM_API_BasicSliderSaveHandler(Research3SaveLogger, LEGENDARY_RESEARCH_COST)
`MCM_API_BasicSliderSaveHandler(ResearchInc1SaveLogger, RARE_RESEARCH_COST_INCREASE)
`MCM_API_BasicSliderSaveHandler(ResearchInc2SaveLogger, EPIC_RESEARCH_COST_INCREASE)
`MCM_API_BasicSliderSaveHandler(ResearchInc3SaveLogger, LEGENDARY_RESEARCH_COST_INCREASE)
`MCM_API_BasicSliderSaveHandler(Armor1SaveLogger, LIGHT_ARMOR_CHANCE)
`MCM_API_BasicSliderSaveHandler(Armor2SaveLogger, HEAVY_ARMOR_CHANCE)
`MCM_API_BasicSliderSaveHandler(Unlock1SaveLogger, WEAPON_UNLOCK_CHANCE)
`MCM_API_BasicSliderSaveHandler(Unlock2SaveLogger, ARMOR_UNLOCK_CHANCE)

`MCM_API_BasicButtonHandler(ButtonClickedHandler)
{
	// Tests the slider positioning error.
	ArtifactSlider1.SetBounds(5.0, 500.0, 1.0, ArtifactSlider1.GetValue(), true);
	ArtifactSlider2.SetBounds(5.0, 500.0, 1.0, ArtifactSlider2.GetValue(), true);
	ArtifactSlider3.SetBounds(5.0, 500.0, 1.0, ArtifactSlider3.GetValue(), true);
	UpgradeSlider1.SetBounds(5.0, 500.0, 1.0, UpgradeSlider1.GetValue(), true);
	UpgradeSlider2.SetBounds(5.0, 500.0, 1.0, UpgradeSlider2.GetValue(), true);
	UpgradeSlider3.SetBounds(5.0, 500.0, 1.0, UpgradeSlider3.GetValue(), true);
	EquipmentSlider1.SetBounds(5.0, 500.0, 1.0, EquipmentSlider1.GetValue(), true);
	EquipmentSlider2.SetBounds(5.0, 500.0, 1.0, EquipmentSlider2.GetValue(), true);
	EquipmentSlider3.SetBounds(5.0, 500.0, 1.0, EquipmentSlider3.GetValue(), true);
	ResearchSlider1.SetBounds(240.0, 24000.0, 1.0, ResearchSlider1.GetValue(), true);
	ResearchSlider2.SetBounds(240.0, 24000.0, 1.0, ResearchSlider2.GetValue(), true);
	ResearchSlider3.SetBounds(240.0, 24000.0, 1.0, ResearchSlider3.GetValue(), true);
	ResearchIncSlider1.SetBounds(24.0, 2400.0, 1.0, ResearchIncSlider1.GetValue(), true);
	ResearchIncSlider2.SetBounds(24.0, 2400.0, 1.0, ResearchIncSlider2.GetValue(), true);
	ResearchIncSlider3.SetBounds(24.0, 2400.0, 1.0, ResearchIncSlider3.GetValue(), true);
	ArmorSlider1.SetBounds(0.0, 100.0, 100.0 / 101.0, ArmorSlider1.GetValue(), true);
	ArmorSlider2.SetBounds(0.0, 100.0, 100.0 / 101.0, ArmorSlider2.GetValue(), true);
	UnlockSlider1.SetBounds(0.0, 100.0, 100.0 / 101.0, UnlockSlider1.GetValue(), true);
	UnlockSlider2.SetBounds(0.0, 100.0, 100.0 / 101.0, UnlockSlider2.GetValue(), true);

	CFG_CLICKED = true;
}

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	self.CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
	self.SaveConfig();
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	CFG_CLICKED = false;
	RARE_ARTIFACT_VALUE = class'GrimyLoot_Artifacts'.default.RARE_ARTIFACT_VALUE;
	EPIC_ARTIFACT_VALUE = class'GrimyLoot_Artifacts'.default.EPIC_ARTIFACT_VALUE;
	LEGENDARY_ARTIFACT_VALUE = class'GrimyLoot_Artifacts'.default.LEGENDARY_ARTIFACT_VALUE;
	BASIC_UPGRADE_VALUE = class'GrimyLoot_UpgradesPrimary'.default.BASIC_UPGRADE_VALUE;
	ADVANCED_UPGRADE_VALUE = class'GrimyLoot_UpgradesPrimary'.default.ADVANCED_UPGRADE_VALUE;
	SUPERIOR_UPGRADE_VALUE = class'GrimyLoot_UpgradesPrimary'.default.SUPERIOR_UPGRADE_VALUE;
	RARE_VALUE = class'GrimyLoot_Research'.default.RARE_VALUE;
	EPIC_VALUE = class'GrimyLoot_Research'.default.EPIC_VALUE;
	LEGENDARY_VALUE = class'GrimyLoot_Research'.default.LEGENDARY_VALUE;
	RARE_RESEARCH_COST = class'GrimyLoot_Research'.default.RARE_RESEARCH_COST;
	EPIC_RESEARCH_COST = class'GrimyLoot_Research'.default.EPIC_RESEARCH_COST;
	LEGENDARY_RESEARCH_COST = class'GrimyLoot_Research'.default.LEGENDARY_RESEARCH_COST;
	RARE_RESEARCH_COST_INCREASE = class'GrimyLoot_Research'.default.RARE_RESEARCH_COST_INCREASE;
	EPIC_RESEARCH_COST_INCREASE = class'GrimyLoot_Research'.default.EPIC_RESEARCH_COST_INCREASE;
	LEGENDARY_RESEARCH_COST_INCREASE = class'GrimyLoot_Research'.default.LEGENDARY_RESEARCH_COST_INCREASE;
	LIGHT_ARMOR_CHANCE = class'GrimyLoot_Research'.default.LIGHT_ARMOR_CHANCE;
	HEAVY_ARMOR_CHANCE = class'GrimyLoot_Research'.default.HEAVY_ARMOR_CHANCE;
	WEAPON_UNLOCK_CHANCE = class'GrimyLoot_Research'.default.WEAPON_UNLOCK_CHANCE;
	ARMOR_UNLOCK_CHANCE = class'GrimyLoot_Research'.default.ARMOR_UNLOCK_CHANCE;
	ArtifactSlider1.SetValue(RARE_ARTIFACT_VALUE, true);
	ArtifactSlider2.SetValue(EPIC_ARTIFACT_VALUE, true);
	ArtifactSlider3.SetValue(LEGENDARY_ARTIFACT_VALUE, true);
	UpgradeSlider1.SetValue(BASIC_UPGRADE_VALUE, true);
	UpgradeSlider2.SetValue(ADVANCED_UPGRADE_VALUE, true);
	UpgradeSlider3.SetValue(SUPERIOR_UPGRADE_VALUE, true);
	EquipmentSlider1.SetValue(RARE_VALUE, true);
	EquipmentSlider2.SetValue(EPIC_VALUE, true);
	EquipmentSlider3.SetValue(LEGENDARY_VALUE, true);
	ResearchSlider1.SetValue(RARE_RESEARCH_COST, true);
	ResearchSlider2.SetValue(EPIC_RESEARCH_COST, true);
	ResearchSlider3.SetValue(LEGENDARY_RESEARCH_COST, true);
	ResearchIncSlider1.SetValue(RARE_RESEARCH_COST_INCREASE, true);
	ResearchIncSlider2.SetValue(EPIC_RESEARCH_COST_INCREASE, true);
	ResearchIncSlider3.SetValue(LEGENDARY_RESEARCH_COST_INCREASE, true);
	ArmorSlider1.SetValue(LIGHT_ARMOR_CHANCE, true);
	ArmorSlider2.SetValue(HEAVY_ARMOR_CHANCE, true);
	UnlockSlider1.SetValue(WEAPON_UNLOCK_CHANCE, true);
	UnlockSlider2.SetValue(ARMOR_UNLOCK_CHANCE, true);
}

simulated function RevertButtonClicked(MCM_API_SettingsPage Page)
{
	// Don't need to do anything since values aren't written until at save-time when you use save handlers.
}

// This shows how to either pull default values from a source config, or to use more user-defined values, gated by a version number mechanism.
simulated function LoadInitialValues()
{
	CFG_CLICKED = false; 
	if ( RARE_ARTIFACT_VALUE > 0 ) {
		RARE_ARTIFACT_VALUE = `MCM_CH_GetValue(class'GrimyLoot_Artifacts'.default.RARE_ARTIFACT_VALUE,RARE_ARTIFACT_VALUE);
	}
	else {
		RARE_ARTIFACT_VALUE = class'GrimyLoot_Artifacts'.default.RARE_ARTIFACT_VALUE;
	}
	if ( EPIC_ARTIFACT_VALUE > 0 ) {
		EPIC_ARTIFACT_VALUE = `MCM_CH_GetValue(class'GrimyLoot_Artifacts'.default.EPIC_ARTIFACT_VALUE,EPIC_ARTIFACT_VALUE);
	}
	else {
		EPIC_ARTIFACT_VALUE = class'GrimyLoot_Artifacts'.default.EPIC_ARTIFACT_VALUE;
	}
	if ( LEGENDARY_ARTIFACT_VALUE > 0 ) {
		LEGENDARY_ARTIFACT_VALUE = `MCM_CH_GetValue(class'GrimyLoot_Artifacts'.default.LEGENDARY_ARTIFACT_VALUE,LEGENDARY_ARTIFACT_VALUE);
	}
	else {
		LEGENDARY_ARTIFACT_VALUE = class'GrimyLoot_Artifacts'.default.LEGENDARY_ARTIFACT_VALUE;
	}
	
	if ( BASIC_UPGRADE_VALUE > 0 ) {
		BASIC_UPGRADE_VALUE = `MCM_CH_GetValue(class'GrimyLoot_UpgradesPrimary'.default.BASIC_UPGRADE_VALUE,BASIC_UPGRADE_VALUE);
	}
	else {
		BASIC_UPGRADE_VALUE = class'GrimyLoot_UpgradesPrimary'.default.BASIC_UPGRADE_VALUE;
	}
	if ( ADVANCED_UPGRADE_VALUE > 0 ) {
		ADVANCED_UPGRADE_VALUE = `MCM_CH_GetValue(class'GrimyLoot_UpgradesPrimary'.default.ADVANCED_UPGRADE_VALUE,ADVANCED_UPGRADE_VALUE);
	}
	else {
		ADVANCED_UPGRADE_VALUE = class'GrimyLoot_UpgradesPrimary'.default.ADVANCED_UPGRADE_VALUE;
	}
	if ( SUPERIOR_UPGRADE_VALUE > 0 ) {
		SUPERIOR_UPGRADE_VALUE = `MCM_CH_GetValue(class'GrimyLoot_UpgradesPrimary'.default.SUPERIOR_UPGRADE_VALUE,SUPERIOR_UPGRADE_VALUE);
	}
	else {
		SUPERIOR_UPGRADE_VALUE = class'GrimyLoot_UpgradesPrimary'.default.SUPERIOR_UPGRADE_VALUE;
	}

	if ( RARE_VALUE > 0 ) {
		RARE_VALUE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.RARE_VALUE,RARE_VALUE);
	}
	else {
		RARE_VALUE = class'GrimyLoot_Research'.default.RARE_VALUE;
	}
	if ( EPIC_VALUE > 0 ) {
		EPIC_VALUE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.EPIC_VALUE,EPIC_VALUE);
	}
	else {
		EPIC_VALUE = class'GrimyLoot_Research'.default.EPIC_VALUE;
	}
	if ( LEGENDARY_VALUE > 0 ) {
		LEGENDARY_VALUE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.LEGENDARY_VALUE,LEGENDARY_VALUE);
	}
	else {
		LEGENDARY_VALUE = class'GrimyLoot_Research'.default.LEGENDARY_VALUE;
	}

	if ( RARE_RESEARCH_COST > 0 ) {
		RARE_RESEARCH_COST = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.RARE_RESEARCH_COST,RARE_RESEARCH_COST);
	}
	else {
		RARE_RESEARCH_COST = class'GrimyLoot_Research'.default.RARE_RESEARCH_COST;
	}
	if ( EPIC_RESEARCH_COST > 0 ) {
		EPIC_RESEARCH_COST = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.EPIC_RESEARCH_COST,EPIC_RESEARCH_COST);
	}
	else {
		EPIC_RESEARCH_COST = class'GrimyLoot_Research'.default.EPIC_RESEARCH_COST;
	}
	if ( LEGENDARY_RESEARCH_COST > 0 ) {
		LEGENDARY_RESEARCH_COST = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.LEGENDARY_RESEARCH_COST,LEGENDARY_RESEARCH_COST);
	}
	else {
		LEGENDARY_RESEARCH_COST = class'GrimyLoot_Research'.default.LEGENDARY_RESEARCH_COST;
	}

	if ( RARE_RESEARCH_COST_INCREASE > 0 ) {
		RARE_RESEARCH_COST_INCREASE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.RARE_RESEARCH_COST_INCREASE,RARE_RESEARCH_COST_INCREASE);
	}
	else {
		RARE_RESEARCH_COST_INCREASE = class'GrimyLoot_Research'.default.RARE_RESEARCH_COST_INCREASE;
	}
	if ( EPIC_RESEARCH_COST_INCREASE > 0 ) {
		EPIC_RESEARCH_COST_INCREASE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.EPIC_RESEARCH_COST_INCREASE,EPIC_RESEARCH_COST_INCREASE);
	}
	else {
		EPIC_RESEARCH_COST_INCREASE = class'GrimyLoot_Research'.default.EPIC_RESEARCH_COST_INCREASE;
	}
	if ( LEGENDARY_RESEARCH_COST_INCREASE > 0 ) {
		LEGENDARY_RESEARCH_COST_INCREASE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.LEGENDARY_RESEARCH_COST_INCREASE,LEGENDARY_RESEARCH_COST_INCREASE);
	}
	else {
		LEGENDARY_RESEARCH_COST_INCREASE = class'GrimyLoot_Research'.default.LEGENDARY_RESEARCH_COST_INCREASE;
	}

	if ( LIGHT_ARMOR_CHANCE > 0 ) {
		LIGHT_ARMOR_CHANCE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.LIGHT_ARMOR_CHANCE,LIGHT_ARMOR_CHANCE);
	}
	else {
		LIGHT_ARMOR_CHANCE = class'GrimyLoot_Research'.default.LIGHT_ARMOR_CHANCE;
	}
	if ( HEAVY_ARMOR_CHANCE > 0 ) {
		HEAVY_ARMOR_CHANCE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.HEAVY_ARMOR_CHANCE,HEAVY_ARMOR_CHANCE);
	}
	else {
		HEAVY_ARMOR_CHANCE = class'GrimyLoot_Research'.default.HEAVY_ARMOR_CHANCE;
	}

	if ( WEAPON_UNLOCK_CHANCE > 0 ) {
		WEAPON_UNLOCK_CHANCE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.WEAPON_UNLOCK_CHANCE,WEAPON_UNLOCK_CHANCE);
	}
	else {
		WEAPON_UNLOCK_CHANCE = class'GrimyLoot_Research'.default.WEAPON_UNLOCK_CHANCE;
	}
	if ( ARMOR_UNLOCK_CHANCE > 0 ) {
		ARMOR_UNLOCK_CHANCE = `MCM_CH_GetValue(class'GrimyLoot_Research'.default.ARMOR_UNLOCK_CHANCE,ARMOR_UNLOCK_CHANCE);
	}
	else {
		ARMOR_UNLOCK_CHANCE = class'GrimyLoot_Research'.default.ARMOR_UNLOCK_CHANCE;
	}
}

defaultproperties
{
}