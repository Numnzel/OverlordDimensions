class magicantilifepuff : BulletPuff {

	default {
		vspeed 0;
		+ALLOWTHRUFLAGS;
		+THRUACTORS;
		+ALWAYSPUFF;
	}
	
	States {
		Spawn:
			TNT1 A 1 NoDelay A_SpawnItemEx("magicantilifecocoon", 0, 0, 0);
			stop;
	}
}

class magicantilifecocoon : Actor {
	
	default {
		
		Health 8000;
		RenderStyle "Add";
		Alpha 0.4;
		
		+NOTRIGGER;
		+SHOOTABLE;
		+DONTTHRUST;
		+NOTELEPORT;
		+NOTELESTOMP;
		+NOGRAVITY;
		+VISIBILITYPULSE;
	}
	
	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle) {
		
		
		//GetPointer(master).health -= damage;
		//A_LogInt(damage);
		Super.DamageMobj(inflictor, source, damage, mod, flags, angle);
		return damage;
	}
	
	void SpawnSphere(String actor, double radius, int density = 5, bool semiSphere = FALSE, double angle = 360.0) {
		
		// Parameters
		double r = radius;
		double c = angle;
		int alpha = density;
		
		// Check parameters
		if (alpha <= 0)
			return;
		
		// Internal parameters
		double h;
		double x;
		int beta = 90;
		
		for (int L = 0; L <= 1; L++) {
			
			int q = 1;
			
			for (int k = beta; k >= 0; k-=alpha) {
				
				x = r * cos(k);
				h = r * sin(k);
				
				int o = (k%(alpha*2)) ? 1 : 0;
				
				for (double i = ((c/(2*q))*o); i < c; i+=c/q)
					if (L != 1 || k != 0) A_SpawnItemEx(actor, x, 0.0, h, 0.0, 0.0, 0.0, i, SXF_SETMASTER); // Check so the bottom semi-sphere doesn't stack on the middle of the sphere.
				
				q += (k == 90) ? 5 : 6;
			}
			
			if (semiSphere)
				break;
			
			r = -r;
		}
		return;
	}
	
	States {
		
		Spawn:
			MODL A 0 NoDelay SpawnSphere("magicantilifecrystal", 256.0, 3, FALSE);
			MODL A 1; //SetShade("FF0000");//A_FadeIn(0.02);
			wait;
		Death:
			TNT1 A 1 A_KillChildren();
			TNT1 A 1 A_RemoveChildren(TRUE, RMVF_EVERYTHING);
			Stop;
	}
}

class magicantilifecrystal : Actor {

	default {
		
		Health 8000;
		Radius 4;
		Height 8;
		RenderStyle "Add";
		Alpha 0.0;
		
		+BRIGHT;
		+SOLID;
		+MISSILE;
		+THRUSPECIES;
		+SHOOTABLE;
		+NOGRAVITY;
		+FORCEXYBILLBOARD;
		+NORADIUSDMG;
		+NOTELEPORT;
		+NOTELESTOMP;
		+DONTDRAIN;
		+DONTTHRUST;
		+NOBLOOD;
		+INVISIBLE;
		//+VISIBILITYPULSE;
	}
	
	override bool CanCollideWith(Actor other, bool passive) {
		
		if(passive) {
			
			if (other.GetSpecies() == "momonga")
				return false;
		}
		return true;
	}
	
	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle) {
		
		Actor ptr = master;
		if (ptr)
			A_DamageMaster(damage);
		
		//GetPointer(master).health -= damage;
		Super.DamageMobj(inflictor, source, damage, mod, flags, angle);
		return damage;
	}
	
	States {
		
		Spawn:
			APBX E 0;
			APBX E 0 { invoker.bMissile = FALSE; }
			APBX E -1;
			stop;
		Death:
			APBX E 0;
			stop;
	}
}