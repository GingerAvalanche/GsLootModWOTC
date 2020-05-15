class GrimyLoot_Screenlistener_MCM_Hook extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local GrimyLoot_ScreenListener_MCM Listener;

	if (MCM_API(Screen) != none)
	{
		Listener = new class'GrimyLoot_ScreenListener_MCM';
		Listener.OnInit(Screen);
	}
}

defaultproperties
{
	ScreenClass = class'MCM_OptionsScreen'; // This will throw a warning, but leave it like this. The class will exist at runtime if they have MCM installed
}