/*class magicfly : PowerupGiver {

	default {
		inventory.Amount 1;
		powerup.type Flight;
		powerup.duration -40;
	}
	
	states {
		spawn:
			TNT1 A 1;
			loop;
	}
}*/

class magicfly : PowerupGiver {

	default {
		
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.ALWAYSPICKUP;
		+INVENTORY.NOSCREENBLINK;
		inventory.maxamount 0;
		powerup.type "magicflypower";
	}
}

class magicflypower : PowerFlight {

	default {
		
		powerup.duration -40;
	}
}