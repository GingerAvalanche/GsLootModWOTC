class GrimyLoot_WeaponUpgradeTemplate extends X2WeaponUpgradeTemplate;

function array<string> GetAttachmentInventoryCategoryImages(XComGameState_Item Weapon)
{
	local WeaponAttachment Attach;
	local array<string> Images;
	
	//`Log("GrimyLoot_WeaponUpgradeTemplate.GetAttachmentInventoryCategoryImages starting...");

	foreach UpgradeAttachments(Attach)
	{
		if( Attach.InventoryCategoryIcon != "" &&
			Attach.ApplyToWeaponTemplate == Weapon.GetMyTemplateName() && 
			Images.Find(Attach.InventoryCategoryIcon) == INDEX_NONE )
			Images.AddItem(Attach.InventoryCategoryIcon);
	}

	if ( Images.length == 0 ) {
		Images.AddItem("img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_heat_sink");
	}
	
	//`Log("GrimyLoot_WeaponUpgradeTemplate.GetAttachmentInventoryCategoryImages returning...");

	return Images;
}