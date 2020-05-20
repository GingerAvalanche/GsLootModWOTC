class GsLootDataStructures extends Object;

struct TemplateImage
{
	var name TemplateName;
	var string strImage;
};

struct UpgradeSetup
{
	var name				UpgradeName;
	var string				InventoryIconPath;
	var name				SocketName;
	var name				UIArmoryCameraPointTag;
	var string				MeshPath;
	var string				ProjectilePath;
	var bool				AttachToPawn;
	var string				IconPath;
	var string				InventoryCategoryIcon;
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