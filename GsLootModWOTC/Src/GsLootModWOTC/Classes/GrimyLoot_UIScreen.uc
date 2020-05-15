class GrimyLoot_UIScreen extends UIScreen config(GrimyDynamicConfig)
	dependson(GrimyLoot_Research);

var localized String m_strRareName, m_strEpicName, m_strLegendaryName;
var localized array<String> ChoiceNames;
var config string RecentName;
var UIAlert AlertScreen;
var UIButton Choice1, Choice2, Choice3, Choice4;
var UIImage ImageA, ImageB, ImageX, ImageY, RewardImage;
var UIText ResearchComplete, TechLabel, TechLabelLarge, RewardName, RewardLabel;
var UIPanel BGBox;

var ELockboxRarity Rarity;
var XComGameState_Tech TechState;
var array<EGearType> ChoiceIndices;
var GrimyLoot_UIItemCard MyItemCard;
var int ButtonHeight, ButtonWidth;

simulated function InitLoot(UIAlert Alert, ELockboxRarity LockboxRarity, XComGameState_Tech Tech)
{
	AlertScreen = Alert;
	Rarity = LockboxRarity;
	TechState = Tech;
	
	SetWidth(Width);
	SetHeight(Height);
	AnchorCenter();
	OriginCenter();
	
	BGBox = Spawn(class'UIPanel', self);
	BGBox.bAnimateOnInit = true;
	BGBox.bIsNavigable = false;
	BGBox.InitPanel('', 'X2BackgroundSimple');
	BGBox.SetSize(Width, Height);
	BGBox.AnchorCenter();
	BGBox.OriginCenter();
	SetBGColor(bIsFocused);
	
	ResearchComplete = Spawn(class'UIText', self);
	ResearchComplete.bAnimateOnInit = true;
	ResearchComplete.InitText('', AlertScreen.m_strResearchProjectComplete);
	ResearchComplete.OriginCenter();
	ResearchComplete.AnchorCenter();
	ResearchComplete.SetPosition(-40, 0);
	
	TechLabel = Spawn(class'UIText',self);
	TechLabel.bAnimateOnInit = true;
	TechLabel.InitText('', AlertScreen.m_strResearchCompleteLabel);
	TechLabel.OriginCenter();
	TechLabel.AnchorCenter();
	TechLabel.SetPosition(-20, 0);
	
	TechLabelLarge = Spawn(class'UIText', self);
	TechLabelLarge.bAnimateOnInit = true;
	TechLabelLarge.InitText('', AlertScreen.m_strResearchCompleteLabel);
	TechLabelLarge.OriginCenter();
	TechLabelLarge.AnchorCenter();
	TechLabelLarge.SetPosition(0, 0);
	
	RewardName = Spawn(class'UIText', self);
	RewardName.bAnimateOnInit = true;
	RewardName.InitText();
	RewardName.OriginCenter();
	RewardName.AnchorCenter();
	RewardName.SetPosition(20, 0);
	
	RewardLabel = Spawn(class'UIText', self);
	RewardLabel.bAnimateOnInit = true;
	RewardLabel.InitText();
	RewardLabel.OriginCenter();
	RewardLabel.AnchorCenter();
	RewardLabel.SetPosition(40, 0);
	
	RewardImage = Spawn(class'UIImage', self);
	RewardImage.InitImage('', TechState.GetImage());
	RewardImage.OriginCenter();
	RewardImage.AnchorCenter();
	RewardImage.SetY(-Height / 4);
	
	PickIndices();
	
	Choice1 = Spawn(class'UIButton', self);
	Choice1.bAnimateOnInit = true;
	Choice1.InitButton('Choice1', ChoiceNames[ChoiceIndices[0]], GiveItem);
	Choice1.SetResizeToText(false);
	Choice1.OriginCenter();
	Choice1.AnchorCenter();
	Choice1.SetFontSize(28);
	Choice1.SetHeight(ButtonHeight);
	Choice1.SetWidth(ButtonWidth);
	Choice1.SetY((Height / 2) - (ButtonHeight * 4));

	if( `ISCONTROLLERACTIVE)
	{
		//Choice1.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		Choice1.DisableNavigation();
		ImageY = Spawn(class'UIImage', self);
		ImageY.InitImage('', "img:///gfxComponents." $ class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		ImageY.DisableNavigation();
		ImageY.OriginCenter();
		ImageY.AnchorCenter();
		ImageY.SetSize(Choice1.Height, Choice1.Height);
		ImageY.SetPosition(Choice1.X - (Choice1.Width / 2 + ImageY.Width), Choice1.Y);
	}
	
	Choice2 = Spawn(class'UIButton', self);
	Choice2.bAnimateOnInit = true;
	Choice2.InitButton('Choice2', ChoiceNames[ChoiceIndices[1]], GiveItem);
	Choice2.SetResizeToText(false);
	Choice2.OriginCenter();
	Choice2.AnchorCenter();
	Choice2.SetFontSize(28);
	Choice2.SetHeight(ButtonHeight);
	Choice2.SetWidth(ButtonWidth);
	Choice2.SetY(Choice1.Y + ButtonHeight);
	
	if( `ISCONTROLLERACTIVE)
	{
		//Choice2.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_X_SQUARE);
		Choice2.DisableNavigation();
		ImageX = Spawn(class'UIImage', self);
		ImageX.InitImage('', "img:///gfxComponents." $ class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE);
		ImageX.DisableNavigation();
		ImageX.OriginCenter();
		ImageX.AnchorCenter();
		ImageX.SetSize(ButtonHeight, ButtonHeight);
		ImageX.SetPosition(Choice2.X - (Choice2.Width / 2 + ImageX.Width), Choice2.Y);
	}
	
	Choice3 = Spawn(class'UIButton', self);
	Choice3.bAnimateOnInit = true;
	Choice3.InitButton('Choice3', ChoiceNames[ChoiceIndices[2]], GiveItem);
	Choice3.SetResizeToText(false);
	Choice3.OriginCenter();
	Choice3.AnchorCenter();
	Choice3.SetFontSize(28);
	Choice3.SetHeight(ButtonHeight);
	Choice3.SetWidth(ButtonWidth);
	Choice3.SetY(Choice2.Y + ButtonHeight);
	
	if( `ISCONTROLLERACTIVE)
	{
		//Choice3.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_B_CIRCLE);
		Choice3.DisableNavigation();
		ImageB = Spawn(class'UIImage', self);
		ImageB.InitImage('', "img:///gfxComponents." $ class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_B_CIRCLE);
		ImageB.DisableNavigation();
		ImageB.OriginCenter();
		ImageB.AnchorCenter();
		ImageB.SetSize(ButtonHeight, ButtonHeight);
		ImageB.SetPosition(Choice3.X - (Choice3.Width / 2 + ImageB.Width), Choice3.Y);
	}
	
	Choice4 = Spawn(class'UIButton', self);
	Choice4.bAnimateOnInit = true;
	Choice4.InitButton('Choice4', ChoiceNames[ChoiceIndices[3]], GiveItem);
	Choice4.SetResizeToText(false);
	Choice4.OriginCenter();
	Choice4.AnchorCenter();
	Choice4.SetFontSize(28);
	Choice4.SetHeight(ButtonHeight);
	Choice4.SetWidth(ButtonWidth);
	Choice4.SetY(Choice3.Y + ButtonHeight);
	
	if( `ISCONTROLLERACTIVE)
	{
		//Choice4.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_A_X);
		Choice4.DisableNavigation();
		ImageA = Spawn(class'UIImage', self);
		ImageA.InitImage('', "img:///gfxComponents." $ class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_A_X);
		ImageA.DisableNavigation();
		ImageA.OriginCenter();
		ImageA.AnchorCenter();
		ImageA.SetSize(ButtonHeight, ButtonHeight);
		ImageA.SetPosition(Choice4.X - (Choice4.Width / 2 + ImageA.Width), Choice4.Y);
	}
}

function PickIndices()
{
	ChoiceIndices.AddItem(class'GrimyLoot_Research'.static.IdentifyIndex(Rarity > eRarity_Rare));
	
	ChoiceIndices.AddItem(class'GrimyLoot_Research'.static.IdentifyIndex(Rarity > eRarity_Rare));
	while ( ChoiceIndices[1] == ChoiceIndices[0] )
	{
		ChoiceIndices[1] = class'GrimyLoot_Research'.static.IdentifyIndex(Rarity > eRarity_Rare);
	}

	ChoiceIndices.AddItem(class'GrimyLoot_Research'.static.IdentifyIndex(Rarity > eRarity_Rare));
	while ( ChoiceIndices[2] == ChoiceIndices[1] || ChoiceIndices[2] == ChoiceIndices[0] )
	{
		ChoiceIndices[2] = class'GrimyLoot_Research'.static.IdentifyIndex(Rarity > eRarity_Rare);
	}

	ChoiceIndices.AddItem(class'GrimyLoot_Research'.static.IdentifyIndex(Rarity > eRarity_Rare));
	while ( ChoiceIndices[3] == ChoiceIndices[2] || ChoiceIndices[3] == ChoiceIndices[1] || ChoiceIndices[3] == ChoiceIndices[0] )
	{
		ChoiceIndices[3] = class'GrimyLoot_Research'.static.IdentifyIndex(Rarity > eRarity_Rare);
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if(!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
		return false;

	switch(cmd)
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
			Choice1.OnClickedDelegate(Choice1);
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			Choice2.OnClickedDelegate(Choice2);
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
			Choice3.OnClickedDelegate(Choice3);
			return true;
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			Choice4.OnClickedDelegate(Choice4);
			return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}

function GiveItem(UIButton ButtonChoice)
{
	local XComGameState_Item ItemState;

	if ( ButtonChoice == Choice1 ) {
		ItemState = class'GrimyLoot_Research'.static.IdentifyByIndex(TechState, ChoiceIndices[0], Rarity);
	}
	if ( ButtonChoice == Choice2 ) {
		ItemState = class'GrimyLoot_Research'.static.IdentifyByIndex(TechState, ChoiceIndices[1], Rarity);
	}
	if ( ButtonChoice == Choice3 ) {
		ItemState = class'GrimyLoot_Research'.static.IdentifyByIndex(TechState, ChoiceIndices[2], Rarity);
	}
	if ( ButtonChoice == Choice4 ) {
		ItemState = class'GrimyLoot_Research'.static.IdentifyByIndex(TechState, ChoiceIndices[3], Rarity);
	}

	if ( MyItemCard == none ) {
		MyItemCard = GrimyLoot_UIItemCard(AlertScreen.Spawn(class'GrimyLoot_UIItemCard', AlertScreen).InitItemCard());
		MyItemCard.SetPosition(8, 90);
	}
	MyItemCard.PopulateItemCard(ItemState.GetMyTemplate(),ItemState.GetReference());
	MyItemCard.Show();
	
	Choice1.Remove();
	Choice2.Remove();
	Choice3.Remove();
	Choice4.Remove();

	UpdateData();
}

static function SetRecentName(String RetName)
{
	default.RecentName = RetName;
}

function UpdateData(optional int RewardNo=-1)
{
	local XGParamTag ParamTag;
	local TAlertCompletedInfo kInfo;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2SchematicTemplate SchematicTemplate;
	local X2ItemTemplate ItemReward;

	if (RewardNo == -1)
		RewardNo += TechState.ItemRewards.Length;
	ItemReward = TechState.ItemRewards[RewardNo];

	if (ItemReward != none ) {
		switch ( TechState.GetMyTemplateName() )
		{
			case 'Tech_IdentifyRareLockbox':
				ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
				ParamTag.StrValue0 = m_strRareName @ ItemReward.GetItemFriendlyNameNoStats();
				break;
			case 'Tech_IdentifyEpicLockbox':
			case 'Tech_IdentifyEpicLockboxInstant':
				ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
				ParamTag.StrValue0 = m_strEpicName @ ItemReward.GetItemFriendlyNameNoStats();
				break;
			case 'Tech_IdentifyLegendaryLockbox':
			case 'Tech_IdentifyLegendaryLockboxInstant':
				ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
				ParamTag.StrValue0 = m_strLegendaryName @ ItemReward.GetItemFriendlyNameNoStats();
				break;
			default:
				return;
		}
		
		kInfo.strName = TechState.GetDisplayName();
		kInfo.strHeaderLabel = AlertScreen.m_strResearchCompleteLabel;
				
		if ( class'GrimyLoot_Research'.default.RANDOMIZE_NICKNAMES && RecentName != "" ) {
			RecentName = default.RecentName;
			kInfo.strBody = ParamTag.StrValue0;
			ParamTag.StrValue0 = RecentName;
		}
		else {
			kInfo.strBody = AlertScreen.m_strResearchProjectComplete;
		}
		kInfo.strBody $= "\n" $ `XEXPAND.ExpandString(TechState.GetMyTemplate().UnlockedDescription);

		kInfo.strConfirm = AlertScreen.m_strAssignNewResearch;
		kInfo.strCarryOn = AlertScreen.m_strCarryOn;
		kInfo = AlertScreen.FillInTyganAlertComplete(kInfo);
		kInfo.eColor = eUIState_Warning;
		kInfo.clrAlert = MakeLinearColor(0.75, 0.75, 0.0, 1);

		if ( X2EquipmentTemplate(ItemReward).InventorySlot != eInvSlot_PrimaryWeapon ) {
			kInfo.strImage = ItemReward.strImage;
		}
		else if ( ItemReward.CreatorTemplateName != '' ) {
			ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
			SchematicTemplate = X2SchematicTemplate(ItemTemplateManager.FindItemTemplate(ItemReward.CreatorTemplateName));
			kInfo.strImage = SchematicTemplate.strImage;
		}
		else if ( ItemReward.DataName == 'AssaultRifle_CV' ) {
			kInfo.strImage = "img:///GrimyLootConvWeapons.GrimyConvAssaultRifle";
		}
		else if ( ItemReward.DataName == 'Cannon_CV' ) {
			kInfo.strImage = "img:///GrimyLootConvWeapons.GrimyConvCannon";
		}	
		else if ( ItemReward.DataName == 'Shotgun_CV' ) {
			kInfo.strImage = "img:///GrimyLootConvWeapons.GrimyConvShotgun";
		}
		else if ( ItemReward.DataName == 'SniperRifle_CV' ) {
			kInfo.strImage = "img:///GrimyLootConvWeapons.GrimyConvSniperRifle";
		}
		else if ( ItemReward.DataName == 'AlienHunterRifle_CV' ) {
			kInfo.strImage = "img:///UILibrary_DLC2Images.ConvBoltCaster";
		}
		else if ( ItemReward.DataName == 'VektorRifle_CV' ) {
			kInfo.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_ConvVektor_Base";
		}
		else if ( ItemReward.DataName == 'Bullpup_CV' ) {
			kInfo.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_ConvSMG_Base";
		}
		else if ( ItemReward.DataName == 'ShardGauntlet_CV' ) {
			kInfo.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_ConvTGauntlet";
		}
		else {
			kInfo.strImage = "img:///GrimyLootPackage.Inv_Storage_Module";
		}
		AlertScreen.BuildCompleteAlert(kInfo);
	}

	`SCREENSTACK.Pop(self);
}

simulated function SetBGColor(bool focused)
{
	BGBox.mc.FunctionString("gotoAndPlay", focused ? "cyan" : "gray");
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	SetBGColor(bIsFocused);
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	SetBGColor(bIsFocused);	
}

defaultproperties
{
	Width=800
	Height=600
	ButtonWidth=400
	ButtonHeight=40
}