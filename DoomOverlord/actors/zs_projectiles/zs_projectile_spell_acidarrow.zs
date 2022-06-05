
class magicacidarrow : actor {
	
	default {
		
		speed 40;
		damage 16;
		gravity 0.1;
		
		PROJECTILE;
		+BRIGHT;
		+BLOODLESSIMPACT;
		+HITMASTER;
		-NOGRAVITY;
	}
	
	states {
		
		spawn:
			BAL7 AB 4;
			loop;
		death:
			BAL7 C 0 A_GiveInventory("effectacid", 1, AAPTR_MASTER);
			BAL7 CDE 6;
			BAL7 E 0 A_SpawnItemEx("magicaciddrop");
			stop;
	}
}

class magicaciddrop : actor {

	default {
		
		+MISSILE;
		+THRUACTORS;
		+BRIGHT;
	}
	
	states {
		
		spawn:
			BAL7 C 1 {
				if(self.z <= floorz)
					setStateLabel("death");
			}
			loop;
		death:
			BAL7 C 35 A_SpawnItemEx("magicacidpool", 0, 0, floorz);
			stop;
	}
}

class magicacidpool : actor {
	
	default {
		
		translation "FadeToGreen";
		
		-SOLID;
		+LOOKALLAROUND;
	}
	
	states {
		
		spawn:
		death:
			POB2 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 3 { A_RadiusGive("effectacidpool", 64, RGF_PLAYERS|RGF_NOSIGHT); A_RadiusGive("effectacidpool", 64, RGF_MONSTERS|RGF_NOSIGHT); }
			POB2 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 3 { A_RadiusGive("effectacidpool", 64, RGF_PLAYERS|RGF_NOSIGHT); A_RadiusGive("effectacidpool", 64, RGF_MONSTERS|RGF_NOSIGHT); }
			POB2 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 3 { A_RadiusGive("effectacidpool", 64, RGF_PLAYERS|RGF_NOSIGHT); A_RadiusGive("effectacidpool", 64, RGF_MONSTERS|RGF_NOSIGHT); }
			POB2 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 3 { A_RadiusGive("effectacidpool", 64, RGF_PLAYERS|RGF_NOSIGHT); A_RadiusGive("effectacidpool", 64, RGF_MONSTERS|RGF_NOSIGHT); }
			POB2 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 3 { A_RadiusGive("effectacidpool", 64, RGF_PLAYERS|RGF_NOSIGHT); A_RadiusGive("effectacidpool", 64, RGF_MONSTERS|RGF_NOSIGHT); }
			stop;
	}
}

class effectacid : powerup {
	
	default {
		
		inventory.amount 1;
		inventory.maxamount 1;
		powerup.duration -12;
		powerup.color "Green";
		
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.NOSCREENBLINK;
	}
	
	override void doEffect() {
		
		if (owner && getAge()%4 == 0) {
			
			owner.A_SetTranslation("FadeToGreen");
			owner.A_DamageSelf(random(5,8), "Acid");
			
			if (owner)
				owner.A_SpawnItemEx("effectacidsfx", 0, 0, 8, random(-4, 4), random(-4, 4), random(2, 5), 0, 143, 176); // that if is necessary, don't ask me why.
		}
	}
	
	override void DetachFromOwner() {
		
		if (owner)
			if (owner.health > 0)
				owner.A_SetTranslation("Restore");
	}
}

class effectacidpool : effectacid {

	default {
		
		powerup.duration -1;
	}
}

class effectacidsfx : NashGore_FlyingBlood {

	default {
		
		NashGore_FlyingBlood.Trail "effectacidtrail";
		NashGore_FlyingBlood.Spot "effectacidspot";
		scale 0.5;
		translation "RedToGreen";
	}
}

class effectacidtrail : NashGore_FlyingBloodTrail {

	default {
		
		scale 0.4;
		//translation "RedToGreen";
	}
}

class effectacidspot : NashGore_BloodSpot {

	default {
		
		scale 0.5;
	}
}
