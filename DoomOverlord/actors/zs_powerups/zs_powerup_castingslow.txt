class castingSpeedSlow : PowerSpeed abstract {

	default {
		
		speed 0.6;
		powerup.duration -1;
		
		+POWERSPEED.NOTRAIL;
		+INVENTORY.ADDITIVETIME;
	}
}

class castingSpeedSlowWeak : castingSpeedSlow {
	
	default {
		
		speed 0.6;
	}
}

class castingSpeedSlowStrong : castingSpeedSlow {
	
	default {
		
		speed 0.1;
	}
}