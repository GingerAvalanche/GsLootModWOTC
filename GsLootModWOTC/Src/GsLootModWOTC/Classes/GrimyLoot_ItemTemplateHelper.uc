class GrimyLoot_ItemTemplateHelper extends X2ItemTemplate;

static function AddFontColor(X2ItemTemplate EditTemplate, string HexColor)
{
	if ( EditTemplate != none && InStr( EditTemplate.FriendlyName, "</font>" ) == -1 )
	{
		EditTemplate.FriendlyName = "<font color='#" $ HexColor $ "'>" $ EditTemplate.FriendlyName $ "</font>";
		EditTemplate.FriendlyNamePlural = "<font color='#" $ HexColor $ "'>" $ EditTemplate.FriendlyNamePlural $ "</font>";
	}
}