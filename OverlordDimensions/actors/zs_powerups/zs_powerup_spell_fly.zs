class magicfly : powerup {

	override void DoEffect () {

		if (owner && getAge() == 0)
			owner.A_GiveInventory("magicflyeffect", 1);

		super.DoEffect();
	}

	override void DetachFromOwner () {

		if (owner && owner.CountInv("magicfly") == 0)
			owner.A_TakeInventory("magicflyeffect");

		super.DetachFromOwner();
	}

	default {
		powerup.duration -60;
		inventory.maxamount 2;
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
	}
}

// PowerFlight duration is infinite in Hexen, that's why we handle it manually.
class magicflyeffect : PowerFlight {

	default {
		
		powerup.duration 0x7FFFFFFD;
	}
}