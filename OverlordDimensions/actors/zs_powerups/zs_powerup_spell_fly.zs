class magicfly : powerup {

	override void InitEffect () {
		
		if (owner)
			owner.A_GiveInventory("magicflyeffect", 1);
		
		super.InitEffect();
	}

	override void DetachFromOwner () {

		if (owner && owner.CountInv("magicfly") == 0 && owner.CountInv("magicflymax") == 0)
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

class magicflymax : magicfly {

	default {
		
		powerup.duration -120;
	}
}

// PowerFlight duration is infinite in Hexen, that's why we handle it manually.
class magicflyeffect : PowerFlight {

	default {
		
		powerup.duration 0x7FFFFFFD;
	}
}