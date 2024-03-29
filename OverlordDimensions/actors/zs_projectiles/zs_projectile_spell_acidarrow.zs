
class magicacidarrow : actor {
	
	default {
		
		height 16;
		radius 8;
		speed 30;
		damage 16;
		gravity 0.1;
		scale 0.25;
		LightLevel 64;
		
		PROJECTILE;
		+BLOODLESSIMPACT;
		+ADDLIGHTLEVEL;

		+HITMASTER;
		-NOGRAVITY;
	}
	
	states {
		
		spawn:
			ACID A 4;
			loop;
		death:
			TNT1 A 0 A_SpawnItemEx("magicaciddrop");
			TNT1 A 0 A_GiveInventory("effectacid", 1, AAPTR_MASTER);
			TNT1 AAA 6;
			stop;
	}
}

class magicaciddrop : actor {

	default {

		height 16;
		radius 8;
		
		+MISSILE;
		+THRUACTORS;
		+BRIGHT;
	}
	
	states {
		
		spawn:
			TNT1 A 1 {
				if (self.pos.z <= floorz)
					setStateLabel("death");
			}
			loop;
		death:
			ACID C 0 A_SpawnItemEx("magicacidpool", 0, 0, floorz);
			stop;
	}
}

class magicacidpool : actor {
	
	default {
		
		height 2;
		radius 64;
		scale 0.5;
		LightLevel 16;
		translation "FadeToGreen";
		
		+LOOKALLAROUND;
		+FLATSPRITE;
		+ROLLSPRITE;
		+ADDLIGHTLEVEL;
	}

	override void Tick () {

		if (getAge() % 3 == 0) {

			A_RadiusGive("effectacidpool", 128, RGF_PLAYERS|RGF_NOSIGHT);
			A_RadiusGive("effectacidpool", 128, RGF_MONSTERS|RGF_NOSIGHT);
		}

		if (self.pos.z > floorz)
			SetZ(floorz);

		super.Tick();
	}
	
	states {
		
		spawn:
		death:
			ACID P 0;
			ACID P 0 A_SetRoll(random(0,359));
			ACID P 525;
			ACID P 1 A_FadeOut(0.05);
			wait;
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
		
		if (owner && getAge() % 4 == 0) {
			
			owner.A_SetTranslation("FadeToGreen");
			owner.A_SpawnItemEx("effectacidsfx", 0, 0, 8, random(-4, 4), random(-4, 4), random(2, 5), 0, 143, 176); // that if is necessary, don't ask me why.
			owner.A_DamageSelf(random(5,8), "Acid");
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
