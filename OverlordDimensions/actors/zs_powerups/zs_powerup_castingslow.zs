class castingSpeedSlow : PowerSpeed abstract {

	double memViewBob;
	PlayerPawn pp;

	default {
		
		speed 0.5;
		powerup.duration -1;
		
		+POWERSPEED.NOTRAIL;
	}

	override void InitEffect () {

		super.InitEffect();

		if (!owner)
			return;
		
		pp = PlayerPawn(owner);
		
		memViewBob = pp.ViewBob;
		pp.ViewBob = 0.0;
	}

	override void EndEffect () {

		super.EndEffect();

		if (pp) pp.ViewBob = memViewBob;
	}
}

class castingSpeedFinger : castingSpeedSlow {
	
	default {
		
		speed 0.03;
		powerup.duration -3;
	}
}