class magicastralsmite : Actor {

	default {
		
		radius 8;
		height 16;
		speed 75;
		damage 8;
		damagetype "Holy";
		ProjectileKickBack 1;
		Scale 0.2;
		Translation "112:127=196:198";
		SeeSound "Spell/AstralSmite";
		//DeathSound "";
		
		PROJECTILE;
		+BRIGHT;
		+SEEKERMISSILE;
		+SCREENSEEKER;
		+SPECTRAL;
		+STRIFEDAMAGE;
	}

	states {
		
		spawn:
			MODL A 16;
			MODL A 20 A_SeekerMissile(0, 90, SMF_LOOK|SMF_PRECISE, 255, 10);
			wait;
		death:
			MODL A 1 {
				A_FadeOut(0.15);
				scale *= 1.1;
			}
			wait;
	}
}

class magicastralsmitemax : magicastralsmite {

	default {

		damage 12;
	}
}