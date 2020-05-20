class GrimyLoot_Artifacts extends X2Item config (GsLootModWOTC);

var config int Version;
var config int RARE_ARTIFACT_VALUE, EPIC_ARTIFACT_VALUE, LEGENDARY_ARTIFACT_VALUE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreateUnidentifiedLockboxRare());
	Resources.AddItem(CreateUnidentifiedLockboxEpic());
	Resources.AddItem(CreateUnidentifiedLockboxLegendary());

	return Resources;
}

static function int GetRareArtifactPrice()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.RARE_ARTIFACT_VALUE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.RARE_ARTIFACT_VALUE;
	}
	else
	{
		return default.RARE_ARTIFACT_VALUE;
	}
}

static function int GetEpicArtifactPrice()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.EPIC_ARTIFACT_VALUE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.EPIC_ARTIFACT_VALUE;
	}
	else
	{
		return default.EPIC_ARTIFACT_VALUE;
	}
}

static function int GetLegendaryArtifactPrice()
{
	if ( class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_ARTIFACT_VALUE > 0 )
	{
		return class'GrimyLoot_ScreenListener_MCM'.default.LEGENDARY_ARTIFACT_VALUE;
	}
	else
	{
		return default.LEGENDARY_ARTIFACT_VALUE;
	}
}

static function X2DataTemplate CreateUnidentifiedLockboxRare()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'GrimyUnidentifiedLockboxRare');
	class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(Template,class'X2Research_GsLoot'.default.RARE_COLOR);
	InitializeLockboxTemplate(Template);
	Template.TradingPostValue = GetRareArtifactPrice();
	Template.strImage = "img:///GrimyLootPackage.Inv_Storage_Module";

	return Template;
}

static function X2DataTemplate CreateUnidentifiedLockboxEpic()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'GrimyUnidentifiedLockboxEpic');
	class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(Template,class'X2Research_GsLoot'.default.EPIC_COLOR);
	InitializeLockboxTemplate(Template);
	Template.TradingPostValue = GetEpicArtifactPrice();
	Template.strImage = "img:///GrimyLootPackage.LockboxAL";

	return Template;
}

static function X2DataTemplate CreateUnidentifiedLockboxLegendary()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'GrimyUnidentifiedLockboxLegendary');
	class'GrimyLoot_ItemTemplateHelper'.static.AddFontColor(Template,class'X2Research_GsLoot'.default.LEGENDARY_COLOR);
	InitializeLockboxTemplate(Template);
	Template.TradingPostValue = GetLegendaryArtifactPrice() ;
	Template.strImage = "img:///GrimyLootPackage.LockboxER";

	return Template;
}

// ----------------
// Utility Function
// ----------------

static function InitializeLockboxTemplate(X2ItemTemplate Template)
{
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.ItemCat = 'utility';
	Template.CanBeBuilt = false;
	Template.HideInInventory = false;
	Template.bOneTimeBuild = false;
	Template.bBlocked = false;
}