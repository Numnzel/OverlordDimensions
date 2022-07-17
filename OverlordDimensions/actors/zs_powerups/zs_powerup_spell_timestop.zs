class magictimestop : powerup {

	override void DoEffect () {

		if (getAge() == 0) {
			A_StartSound("Spell/TimeStopLoop", 5, CHANF_LOOP|CHANF_NOPAUSE, 1.0, ATTN_NONE);
			owner.A_GiveInventory("magictimestopeffect", 1);
		}

		if (getAge() >= 35 * 15)
			owner.A_TakeInventory("magictimestop");

		super.DoEffect();
	}

	override void DetachFromOwner () {

		A_StopSound(5);
		owner.A_TakeInventory("magictimestopeffect");

		super.DetachFromOwner();
	}

	default {
		powerup.duration -15;
	}
}

class magictimestopeffect : PowerTimeFreezer {

	default {
		powerup.duration -100;
		Powerup.Colormap 0.0, 0.0, 0.0, 1.0, 1.0, 1.0;
	}
}