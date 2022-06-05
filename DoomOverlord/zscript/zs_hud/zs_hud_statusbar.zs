class MinimalStatusBar : BaseStatusBar {

	HUDFont mMM2BigFont;
	HUDFont mMM2SmallFont;
	InventoryBarState diparms;
	mixin PowerupValues;
	mixin SpellPropertiesList;
	
	
	override void Init() {
		
		Super.Init();
		// this has to be done, even if the HUD is fullscreen, it prevents a crash
		SetSize(0, 320, 200);
		
		// Create the font used for the fullscreen HUD
		Font fnt = "MM2FONTO";
		mMM2BigFont = HUDFont.Create(fnt);
		fnt = "MM2SFNTO";
		// the small font is monospace because it helps with centering and positioning
		mMM2SmallFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), true);
		diparms = InventoryBarState.Create(null, Font.CR_UNTRANSLATED, 1, "ITEMBOX");
	}
	
	// makes my life easier
	Vector2 TexSize(String texture) { return Texman.GetScaledSize(TexMan.CheckForTexture(texture, TexMan.Type_Any)); }
	
	void InterpolateValue(int value, out int interpolatedValue, out int pile, int speed = 1, int accel = 5) { // safe values: speed = 2, accel = 10;
		
		int diff = max(interpolatedValue, value) - min(interpolatedValue, value);
		int curve = clamp((diff / max(1,accel)), 1, 4);
		int slowmo = (diff < 20 && diff > 0) ? 50/max(1,diff) : 0;
		
		if (++pile >= abs(speed)+slowmo) {
			
			pile = 0;
			
			if (interpolatedValue > value)
				interpolatedValue = (interpolatedValue - curve < value) ? value : interpolatedValue - curve;
			else if (interpolatedValue < value)
				interpolatedValue = (interpolatedValue + curve > value) ? value : interpolatedValue + curve;
		}
	}
	
	int CreatePercent(int monitor, int monitorMax, int relativeValue) {
		
		double monitorD = monitor;
		
		return round(monitorD * relativeValue/monitorMax);
	}
}
