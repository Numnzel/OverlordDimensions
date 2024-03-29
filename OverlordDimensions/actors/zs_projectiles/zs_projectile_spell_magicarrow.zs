
class magicarrow : actor {
	
	default {
		
		height 4;
		radius 16;
		speed 35;
		vspeed 100;
		damage 30;
		scale 0.25;
		Translation "FadeToYellow";
		
		PROJECTILE;
		+BRIGHT;
		+SEEKERMISSILE;
	}
	
	states {
		
		spawn:
			MODL AAAAAAAAAAAAA 1 {
				A_SeekerMissile(0, 2, SMF_PRECISE|SMF_CURSPEED);
				A_ScaleVelocity(0.75);
			}
			MODL AAAAAAAAAAAAA 1 {
				A_SeekerMissile(0, 2, SMF_PRECISE|SMF_CURSPEED);
				A_ScaleVelocity(1.35);
			}
			MODL A 1 {
				A_SeekerMissile(0, 2, SMF_PRECISE|SMF_CURSPEED);
				A_ScaleVelocity(1.05);
			}
			wait;
		death:
			MODL A 1 A_FadeOut(0.05);
			wait;
	}
}

class magicarrowmax : magicarrow {

	default {

		damage 45;
		Translation "FadeToWhite";
	}
}