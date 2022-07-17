class magichellflame : Actor {

	default {
		
		radius 6;
		height 12;
		speed 4;
		damage 0;
		ProjectileKickBack 5;
		
		SeeSound "imp/attack";
		DeathSound "imp/shotx";
		
		PROJECTILE;
		+RANDOMIZE;
		+BLOODLESSIMPACT;
		+FORCERADIUSDMG;
	}

	override void postBeginPlay () {
		
		super.postBeginPlay();
		
		let fire = mk_BaseFire(spawn("mk_BigFire"));
		
		if (fire) {
			double firescale = 0.35;
			fire.A_SetScale(firescale*0.7, firescale);
			fire.follower = true;
			fire.master = self;
			fire.setShade("4400FF"); //5522FF
			fire.style = 1;
		}
	}

	states {
		spawn:
			TNT1 A 1;
			loop;
		death:
			TNT1 A 40; // Dramatic pause
			TNT1 A 0 {
				
				A_Explode(4100, 600, XF_HURTSOURCE, TRUE, 200, 0, 0, "", "HellFire");
				
				A_RadiusGive("effecthellfire", 400, RGF_MONSTERS);
				A_RadiusGive("effecthellfire", 400, RGF_PLAYERS);
				A_RadiusGive("effecthellfire", 400, RGF_CORPSES);
				A_RadiusGive("effecthellfire", 400, RGF_KILLED);
				
				for (int i = random(0,30); i < 700; i++)
					A_SpawnItemEx("magichellflameender", 0, 0, 0, frandom(0.1,6.0), 0, frandom(0.0, 10.0), random(0,359));
			}
			Stop;
	}
}

class effecthellfire : powerup {
	
	default {
		
		inventory.amount 1;
		inventory.maxamount 1;
		powerup.duration -10;
		powerup.color "Black";
		
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.NOSCREENBLINK;
	}
	
	override void doEffect() {
		
		owner.A_SetTranslation("FadeToBlack");
		
		if (owner && getAge()%35 == 0)
			owner.A_SpawnItemEx("magichellflameender", 0, 0, 3); // that IF() is necessary, don't ask me why.
	}
	
	override void DetachFromOwner() {
		
		if (owner)
			if (owner.health > 0)
				owner.A_SetTranslation("Restore");
			else
				owner.A_SpawnItemEx("magichellflameendercorpse", 0, 0, 3);
	}
}

class magichellflameender : actor {
	
	default {
		
		radius 1;
		height 2;
		gravity 0.35;
	}
	
	override void postBeginPlay () {
		
		super.postBeginPlay();
		
		let fire = mk_BaseFire(spawn("mk_BigFire"));
		
		if (fire) {
			double firescale = frandom(0.7,1.0);
			fire.A_SetScale(firescale, firescale*0.5);
			fire.follower = true;
			fire.master = self;
			fire.setShade("150055");
			fire.style = 1;
		}
	}
	
	states {
		spawn:
			TNT1 A random(5,110);
			stop;
	}
}

class magichellflameendercorpse : magichellflameender {
	
	states {
		spawn:
			TNT1 A random(90,240);
			stop;
	}
}