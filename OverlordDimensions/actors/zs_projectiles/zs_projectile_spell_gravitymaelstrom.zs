class magicgravitymaelstrom : actor {

	default {
		
		radius 6;
		height 12;
		speed 60;
		scale 0.12;
		mass 1800;
		//RenderStyle "Translucent";
		//Alpha 1.0;
		//SeeSound "";
		//DeathSound "";
		
		PROJECTILE;
		+RANDOMIZE;
		+HITMASTER;

		+BRIGHT;
		+ROLLSPRITE;
		+BLOODLESSIMPACT;
	}
	
	states {
		
		spawn:
			GRAV A 1 NoDelay A_SetRoll(random(0,359),SPF_INTERPOLATE);
			loop;
		death:
			GRAV A 0 {
				A_RadiusThrust(3000, 128, RTF_NOIMPACTDAMAGE, 128);
				if (master) A_DamageMaster(mass-master.mass);
			}
		death2:
			GRAV A 1 {
				A_SetScale(1.15);
				A_FadeOut(0.05+(alpha*0.5));
			}
			wait;
	}
}

class magicgravitymaelstrommax : magicgravitymaelstrom {

	default {
		
		mass 2700;
	}
}