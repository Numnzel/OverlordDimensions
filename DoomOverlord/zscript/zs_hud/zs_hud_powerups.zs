mixin Class PowerupValues {
	
	String PowerupNames[5]; // Name list
	String PowerupDisplay[5]; // Icon list
	
	void setPowerups() {
		
		PowerupNames[0] = "magicbodyofrefulgentberyleffect";
		PowerupNames[1] = "magictimestop";
		PowerupNames[2] = "magicflypower";
		PowerupNames[3] = "magic_completevision";
		PowerupNames[4] = "effectacidpool";

		PowerupDisplay[0] = "POWBODY";
		PowerupDisplay[1] = "POWTIME";
		PowerupDisplay[2] = "POWFLY";
		PowerupDisplay[3] = "POWEYE";
		PowerupDisplay[4] = "POWACID";

		//PowerupNames.Push("effectacid");						PowerupDisplay.Push("POWACID");
		
		// PowerupNames.Push("magicperfectwarrior");	PowerupDisplay.Push("");
		// PowerupNames.Push("magicinvisibility");		PowerupDisplay.Push("");
		// PowerupNames.Push("magictgoalid");			PowerupDisplay.Push("");
		// PowerupNames.Push("magicremoteview");		PowerupDisplay.Push("");
		// PowerupNames.Push("PowerInvulnerable");		PowerupDisplay.Push("");
		
		return;
	}
}