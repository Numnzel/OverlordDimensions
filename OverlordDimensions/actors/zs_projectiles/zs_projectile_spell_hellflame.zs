class magichellflame : Actor {

	mk_BaseFire fire;

	default {
		
		radius 6;
		height 12;
		speed 4;
		damage 0;
		ProjectileKickBack 5;
		
		//SeeSound "";
		//DeathSound "";
		
		PROJECTILE;
		+RANDOMIZE;
		+BLOODLESSIMPACT;
		+FORCERADIUSDMG;
		+SEEKERMISSILE;
	}

	override void postBeginPlay () {
		
		super.postBeginPlay();
		
		fire = mk_BaseFire(spawn("mk_BigFire"));
		
		if (fire) {
			double firescale = 0.35;
			fire.A_SetScale(firescale*0.7, firescale);
			fire.follower = true;
			fire.master = self;
			fire.setShade("440000"); //5522FF
			fire.style = 1;
		}
	}

	states {
		spawn:
			TNT1 A 1 A_SeekerMissile(0, 2, SMF_PRECISE|SMF_CURSPEED);
			loop;
		death:
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 A_Warp(AAPTR_TRACER); // Dramatic pause
			TNT1 A 0 {
				if (fire) fire.destroy();
				if (tracer) tracer.A_GiveInventory("effecthellfire");
			}
			TNT1 AAAAAAAAAAAA 5 {
				
				if (tracer) {
					tracer.A_DamageSelf((min(max(1,(tracer.Default.Health/12)+1), 375)), "Fire", DMSS_NOFACTOR);
					tracer.TriggerPainChance('Fire', true);
					tracer.A_SpawnItemEx("magichellflameender", 0, 0, 0, frandom(0.1,3.0), 0, frandom(0.0, 5.0), random(1,360));
				}
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
			fire.setShade("440000");
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