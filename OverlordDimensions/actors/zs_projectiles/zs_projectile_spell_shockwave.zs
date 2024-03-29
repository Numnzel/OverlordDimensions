class magicshockwave : actor {
	
	double cube; property pcube: cube;
	string force; property pforce: force;
	
	default {
		
		magicshockwave.pcube 4.0;
		magicshockwave.pforce "shockwaveforce";
		radius 4;
		height 4;
		speed 40;
		reactiontime 13;
		
		PROJECTILE;
		+THRUACTORS;
	}
	
	states {
		spawn:
			TNT1 A 1 NoDelay {
				
				A_RadiusGive(force, cube, RGF_MONSTERS);
				A_RadiusGive(force, cube, RGF_OBJECTS);
				A_RadiusGive(force, cube, RGF_CORPSES);
				cube += 46;
				//A_SetSize(radius+6, height+12, FALSE);
				A_CountDown();
			}
			loop;
	}
}

class magicshockwavemax : magicshockwave {

	default {

		magicshockwave.pforce "shockwaveforcemax";
	}
}

class shockwaveforce : powerup {

	double powerM; property pPowerMult: powerM;

	override void InitEffect () {

		if (owner && owner.CountInv(self.getClassName()) == 0) {
			
			master = players[consoleplayer].mo;

			if (master) {
				owner.Thrust((powerM*10000)/owner.Distance3D(master), owner.AngleTo(master)-180);
				owner.A_DamageSelf(max(0, (powerM*600)-owner.Distance3D(master)), "None", 0, null, "None", AAPTR_MASTER);
			}
		}

		super.InitEffect();
	}

	default {

		shockwaveforce.pPowerMult 1.0;

		inventory.amount 1;
		inventory.maxamount 1;
		powerup.duration 15;
		
		+INVENTORY.AUTOACTIVATE;
	}
}

class shockwaveforcemax : shockwaveforce {

	default {

		shockwaveforce.pPowerMult 1.5;
	}
}