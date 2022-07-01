class magic_shockwave : actor {
	
	double cube; property pcube: cube;
	
	
	default {
		
		magic_shockwave.pcube 4.0;
		radius 4;
		height 8;
		speed 40;
		reactiontime 13;
		
		PROJECTILE;
		+ISMONSTER;
		+NOCLIP;
	}
	
	states {
		spawn:
			TNT1 A 1 NoDelay {
				
				//A_RadiusThrust(10000, radius);
				A_RadiusGive("magic_shock", cube, RGF_MONSTERS);
				cube += 46;
				A_SetSize(radius+6, height+12, FALSE);
				A_CountDown();
				//A_LogInt(radius);
				//A_Log(target.getClassName());
			}
			loop;
	}
}

class magic_shock : custominventory {
	
	states {
		
		pickup:
			TNT1 A 0 {
				
				if (CountInv("magic_shock_disabled") == 0) {
					
					A_GiveInventory("magic_shock_disabled", 1);
					CheckProximity("momonga", 2048.0, 1, CPXF_CHECKSIGHT|CPXF_SETMASTER|CPXF_CLOSEST);
					
					if (master) {
						
						if (master.getClassName() == "momonga") {
							
							Thrust(10000.0/Distance3D(master), AngleTo(master)-180);
							A_DamageSelf(max(0.0, 600.0-Distance3D(master)), "None", 0, null, "None", AAPTR_MASTER);
						}
					}
				}
			}
			stop;
	}
}

class magic_shock_disabled : powerup {

	default {
		powerup.duration -5;
	}
}