class mana : Ammo {
	
	default {
		inventory.Amount 1;
		inventory.MaxAmount 10000;
	}
	
	//override bool HandlePickup (Inventory item) {
	//if (owner.FindInventory("maxmana", true)
}

class maxmana : Inventory {

	default {
		inventory.Amount 1;
		inventory.MaxAmount 10000;
	}
}

class manaunit : CustomInventory {
	
	states {
		spawn:
			IFOG DE 4;
			loop;
		pickup:
			TNT1 A 0;
			TNT1 A 0 {
				if (CountInv("mana") >= CountInv("maxmana")) {
					return;
				}
				A_GiveInventory("mana", 1);
			}
			stop;
	}
}