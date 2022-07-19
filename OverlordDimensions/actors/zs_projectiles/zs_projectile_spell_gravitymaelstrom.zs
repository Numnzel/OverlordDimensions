class magicgravitymaelstrom : Actor {

	default {
		
		radius 6;
		height 12;
		speed 60;
		damage 140;
		scale 0.2;
		ProjectileKickBack 0;
		RenderStyle "Translucent";
		Alpha 1.0;
		//SeeSound "";
		//DeathSound "";
		
		PROJECTILE;
		+RANDOMIZE;
		+ROLLSPRITE;
		+BLOODLESSIMPACT;
		+HITMASTER;
		+BRIGHT;
		//+RIPPER;
	}
	
	/* // This doesn't work.
	override int SpecialMissileHit(Actor victim) {
		
		if (victim.GetClassName() == "momonga")
			return 1;
		
		if (victim.InStateSequence(victim.CurState, victim.ResolveState("Death")) || victim.InStateSequence(victim.CurState, victim.ResolveState("XDeath")))
			SetState(null);
		
		//let stat = victim.CurState;
		//A_Log(stat);
		
		return -1;
	}
	*/
	
	states {
		
		spawn:
			GRAV A 1 NoDelay {
				A_RadiusGive("effectgravitymaelstromforce", 512, RGF_MONSTERS); // A_RadiusThrust(100, 512, 16);
				A_SetRoll(random(0,359),SPF_INTERPOLATE);
			}
			Loop;
		death:
			GRAV A 0 A_GiveInventory("effectgravitymaelstrom", 1, AAPTR_MASTER);
			GRAV A 1 { A_SetScale(1.15); A_FadeOut(0.05+(alpha*0.5)); }
			Wait;
	}
}

class effectgravitymaelstrom : CustomInventory {
	
	default {
		
		inventory.amount 1;
		+INVENTORY.AUTOACTIVATE;
	}
	
	states {
		
		pickup:
			TNT1 A 0;
			TNT1 A 0; //A_Gravity();
			TNT1 A 0 A_DamageSelf(700/mass); // A_SetGravity(30000);
			stop;
	}
}

class effectgravitymaelstromforce : CustomInventory {

	default {
		
		inventory.amount 1;
		+INVENTORY.AUTOACTIVATE;
	}
	
	states {
		
		pickup:
			TNT1 A 0;
			TNT1 A 0 {
				
				CheckProximity("magicgravitymaelstrom", 512, 1, CPXF_CHECKSIGHT|CPXF_SETMASTER|CPXF_CLOSEST);
				
				if (master) {
					
					if (master.getClassName() == "magicgravitymaelstrom") {
						
						// XY Thrust
						double dist = Distance2D(master);
						double force = 90000.0/(dist*dist)+1; // Force increases when close to XY coords.
						
						Thrust(-force, AngleTo(master));
					}
				}
			}
			stop;
	}
}