
class magictruedark : actor {
	
	double dmg;
	bool unused;
	actor light;
	
	default {
		
		radius 8;
		height 16;
		reactiontime 140;
		damage 1000;
		renderstyle "translucent";
		alpha 1.0;
		
		+OLDRADIUSDMG;
		+NODAMAGETHRUST;
		+BLOODLESSIMPACT;
		+DONTREFLECT;
		+NOEXTREMEDEATH;
		+PIERCEARMOR;
		+VISIBILITYPULSE;
	}
	
	states {
		
		spawn:
			DARK A 0 NoDelay {
				[unused, light] = A_SpawnItemEx("magictruedarklight", 0, 0, 0, 0, 0, 0, SXF_ORIGINATOR);
				if (light) light.target = self;
			}
			DARK A 1 {
				
				if (!target)
					SetState(null);
				
				dmg = damage;
				
				scale.x = 1.0*(1.0-(reactiontime/140.0));
				
				
				// damage grows up the less health it has, up to x4.
				if(target.health > 0)
					dmg += (damage*3.0)*(1.0-(1.0*target.Health/target.SpawnHealth()));
				else
					SetStateLabel("death");
				
				A_RadiusDamageSelf(dmg/140, 128);
				A_Warp(AAPTR_TARGET, 0, 0, 0, 0, WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
				A_CountDown();
			}
			wait;
		death:
			DARK AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 {	scale.x *= 0.92; }
			DARK A 0 { bVISIBILITYPULSE = false; }
			DARK A 1 A_FadeOut(0.04);
			wait;
	}
}

class magictruedarklight : PointLight {

	double age;
	
	default {
		
		args 255, 255, 255, 2;
		+DYNAMICLIGHT.SUBTRACTIVE;
	}
	
	override void Tick() {
		
		if (!target || !target.target || args[3] <= 1)
			SetState(null);
		
		age = 1.0*GetAge();
		
		// update position
		A_Warp(AAPTR_TARGET, 0, 0, 0, 0, WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
		
		// increase radius
		if (target.target.health > 0 && age < 140)
			args[3] = max(2,round(80*(1.0-(abs(age-140)/140))));
		
		// fade-out
		else if (target.target.health <= 0 || age > 140) {
			
			args[3] *= 0.92;
			
			if(args[3] <= 0)
				SetState(null);
		}
	}
	
}