extend class MinimalStatusBar {
	
	override void DrawAutomapHUD(double ticFrac) {
		// This uses the normal automap HUD but just changes the highlight color.
		DoDrawAutomapHUD(Font.CR_GREY, Font.CR_UNTRANSLATED);
	}
	
	override void Draw (int state, double TicFrac) {
		
		if (CPlayer) {
			
			setPowerups();
			setSpellProperties();
		}
		
		Super.Draw(state, TicFrac);
		
		if (state == HUD_StatusBar) {
			
			BeginStatusBar();
			DrawMainBar(TicFrac);
		}
		else if (state == HUD_Fullscreen) {
			
			BeginHUD();
			DrawFullScreenStuff(TicFrac);
		}
	}
}
