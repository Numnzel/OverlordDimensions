class magicfireball : Actor {

	default {
		
		radius 6;
		height 12;
		speed 30;
		damage 110;
		ProjectileKickBack 20;
		RenderStyle "Add";
		Alpha 0.9;
		//SeeSound "";
		//DeathSound "";
		
		PROJECTILE;
		+RANDOMIZE;
		+BLOODLESSIMPACT;
		+ROLLSPRITE;
	}

	states {
		spawn:
			FBAL ABCD 1 Bright {
				A_SpawnItemEx("magicfireballtrail", 0, 0, 0, 0, random(-1,1), random(-1,1), 0, SXF_TRANSFERALPHA|SXF_TRANSFERSPRITEFRAME|SXF_CLIENTSIDE);
				A_SpawnItemEx("magicfireballtrailblack", 0, 0, 0, 0, random(-1,1), random(-1,1), 0, SXF_TRANSFERSPRITEFRAME|SXF_CLIENTSIDE);
				A_SetRoll(random(0,359),SPF_INTERPOLATE);
			}
			Loop;
		death:
			BAL1 C 0 {
				A_SetTranslation("FadeToOrange");
				A_Explode(130, 80, XF_HURTSOURCE, TRUE, 0, 0, 0, "", "Fire");
				for (int i = random(0,2); i < 6; i++)
					A_SpawnItemEx("magicfireballender", 0, 0, 0, frandom(0.5,5.0), 0, frandom(0.0,2.0), random(0,359));
			}
			BAL1 CDE 6 Bright A_SetScale(1.2);
			Stop;
	}
}

class magicfireballtrail : Actor {
	
	default {
		speed 0;
		alpha 0.9;
		scale 0.9;
		
		PROJECTILE;
		+ROLLSPRITE;
		+CLIENTSIDEONLY;
	}
	
	states {
		spawn:
			FBAL ABCD 1 NoDelay Bright {
				A_SetRoll(roll+random(0,32), SPF_INTERPOLATE);
				A_FadeOut(0.09);
				A_SetScale(1.1);
			}
			loop;
	}
}

class magicfireballtrailblack : magicfireballtrail {

	default {
		alpha 0.05;
	}

	states {
		spawn:
			FBAL ABCD 1 NoDelay Bright {
				A_SetRoll(roll+random(0,32), SPF_INTERPOLATE);
				A_FadeIn(0.18);
				A_SetRenderStyle(alpha, STYLE_Shaded);
			}
		fadeout:
			FBAL ABCD 1 Bright {
				A_SetRoll(roll+random(0,32), SPF_INTERPOLATE);
				A_FadeOut(0.09);
				A_SetRenderStyle(alpha, STYLE_Shaded);
				A_SetScale(1.1);
			}
			loop;
	}
}

class magicfireballender : actor {
	
	int ttl;
	
	default {
		radius 1;
		height 2;
		gravity 0.8;
		+NODAMAGETHRUST;
	}
	
	override void postBeginPlay () {
		
		super.postBeginPlay();
		
		let fire = mk_BaseFire(spawn("mk_SmallFire"));
		
		if (fire) {
			double firescale = frandom(0.5,0.8);
			fire.A_SetScale(firescale, firescale);
			fire.follower = true;
			fire.master = self;
			fire.setShade("FF8B53");
			fire.args[spawn_ember] = true;
			fire.args[spawn_smoke] = true;
		}
	}
	
	states {
		spawn:
			TNT1 A 0 NoDelay {
				ttl = random(2,7);
			}
			TNT1 A 15 {
				
				A_Explode(random(4,6), 48, 0, false);
				if (--ttl < 0)
					SetState(null);
			}
			wait;
	}
}