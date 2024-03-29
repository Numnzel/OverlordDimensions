mixin Class PowerupValues {
	
	String PowerupNames[6]; // Name list
	String PowerupDisplay[6]; // Icon list
	
	void setPowerups() {
		
		PowerupNames[0] = "magicbodyofrefulgentberyleffect";
		PowerupNames[1] = "magictimestop";
		PowerupNames[2] = "magicfly";
		PowerupNames[3] = "magicflymax";
		PowerupNames[4] = "magic_completevision";
		PowerupNames[5] = "effectacidpool";

		PowerupDisplay[0] = "POWBODY";
		PowerupDisplay[1] = "POWTIME";
		PowerupDisplay[2] = "POWFLY";
		PowerupDisplay[3] = "POWFLY";
		PowerupDisplay[4] = "POWEYE";
		PowerupDisplay[5] = "POWACID";

		//PowerupNames.Push("effectacid");						PowerupDisplay.Push("POWACID");
		
		// PowerupNames.Push("magicperfectwarrior");	PowerupDisplay.Push("");
		// PowerupNames.Push("magicinvisibility");		PowerupDisplay.Push("");
		// PowerupNames.Push("magictgoalid");			PowerupDisplay.Push("");
		// PowerupNames.Push("magicremoteview");		PowerupDisplay.Push("");
		// PowerupNames.Push("PowerInvulnerable");		PowerupDisplay.Push("");
		
		return;
	}
}