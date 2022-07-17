class emotion : powerup abstract {
	
	default {
		
		powerup.duration 50;
		
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.NOSCREENBLINK;
	}
}

class playeranim1 : emotion { default { powerup.duration 15; } }
class playeranim2 : emotion {}
class playerleft1 : emotion { default { powerup.duration 15; } }
class playerleft2 : emotion {}
class playerright1 : emotion { default { powerup.duration 15; } }
class playerright2 : emotion {}
class playerpain : emotion {}
class playerspell : emotion {}
class playerfacepalm : emotion {}
class playerdied : emotion { default { powerup.duration 3; } }