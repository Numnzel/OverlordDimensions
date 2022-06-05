
class magic_completevision : powertorch {
	
	default {
		powerup.duration -120;
		+INVENTORY.NOSCREENBLINK;
	}
	
	override void doEffect () {
		
		super.doEffect();
		
		if (owner)
			owner.A_RadiusGive("magic_lifeaura", 4096, RGF_MONSTERS, 1);
	}
}

class magic_lifeaura : inventory {
	
	override void AttachToOwner (actor other) {
		
		if (other)
			for (int detail = 0; detail < 10; detail++)
				other.A_SpawnItemEx("magic_lifeaurasfx", frandom(0.0, other.radius*0.8), 0.0, 0.0, frandom(0.0,1.5), 0.0, frandom(1.0,5.5), frandom(0.0,360.0));
		
		SetState(null);
	}
}

class magic_lifeaurasfx : actor {
	
	double originalsize;
	double relativesize;
	
	default {
		
		radius 2;
		height 2;
		scale 0.05;
		alpha 0.9;
		renderstyle "add";
		
		+NOGRAVITY;
		+NOCLIP;
		+ROLLSPRITE;
	}
	
	states {
		spawn:
			SEHT A 0 NoDelay {
				
				if (target) {
					
					// Adjust initial scale
					originalsize = target.SpawnHealth()/1000.0;
					relativesize = target.health/(1.0*target.SpawnHealth());
					
					scale.x += originalsize;
					scale.x *= relativesize;
					scale.y = scale.x;
					
					// Adjust initial speed
					A_ScaleVelocity((5.0+originalsize)/5.0);
				}
			}
			SEHT A 1 {
				
				// Update scale
				double decrement = max(0.005, (0.05-(target.health/80000.0))/3.0);
				
				scale *= frandom(0.96, 0.99);
				scale.x = max(0, scale.x-decrement);
				scale.y = scale.x;
				
				// Update alpha
				alpha -= 0.03;
				
				// Update speed
				A_ScaleVelocity(0.98);
				
				// Roll
				A_SetRoll(roll+random(0,32), SPF_INTERPOLATE);
				
				// Remove
				if (alpha <= 0.0)
					SetState(null);
			}
			wait;
	}
}