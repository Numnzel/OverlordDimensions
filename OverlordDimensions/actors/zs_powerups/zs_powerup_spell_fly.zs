class magicfly : powerup {

	override void DoEffect () {

		if (getAge() == 0)
			owner.A_GiveInventory("magicflyeffect", 1);

		if (getAge() >= 35 * 60)
			owner.A_TakeInventory("magicfly");

		super.DoEffect();
	}

	override void DetachFromOwner () {

		owner.A_TakeInventory("magicflyeffect");

		super.DetachFromOwner();
	}

	default {
		powerup.duration -60;
	}
}

class magicflyeffect : PowerFlight {

	default {
		
		powerup.duration -100;
	}
}