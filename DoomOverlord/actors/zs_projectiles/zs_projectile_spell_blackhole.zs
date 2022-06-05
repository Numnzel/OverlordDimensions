class magicblackhole : Actor {
	
	double BHSS;
	double ACCON;
	double ACCOFF;
	
	property BlackHoleSizeSpeed: BHSS;
	property BlackHoleSizeAccelOn: ACCON;
	property BlackHoleSizeAccelOff: ACCOFF;
	
	default {
		
		Scale 0.2; // fail-safe value: 0.2
		Radius 2;
		Height 4;
		health 666;
		RenderStyle "Stencil";
		StencilColor "Black";
		
		magicblackhole.BlackHoleSizeSpeed 0.008; // fail-safe value: 0.008
		magicblackhole.BlackHoleSizeAccelOn 0.97; // fail-safe value: 0.97
		magicblackhole.BlackHoleSizeAccelOff 1.3; // fail-safe value: 1.3
		
		+NOTRIGGER;
		+NOTELEPORT;
		+NOTELESTOMP;
		+NOGRAVITY;
		+DONTTHRUST;
		+NOCLIP;
	}
	
	// monitor: [SPEED monitor var]
	// setpoint: [SPEED setpoint] If 0 and inverse, then instead of speed, the function will terminate when scale is 0
	// accel: [SPEED acceleration]
	// inverse: If negative, actor will shrink
	int ScaleAnimation(out double monitor, double setpoint, double accel = 1.0, bool inverse = FALSE) {
		
		if (monitor <= 0)
			return 0;
		
		// Update actor scale
		double change;
		
		if (inverse)
			change = scale.x-monitor;
		else
			change = scale.x+monitor;
		
		A_SetScale(change, change);
		
		// Speed acceleration
		monitor *= abs(accel);
		
		
		if (accel < 1.0 && monitor <= setpoint || accel > 1.0 && monitor >= setpoint && setpoint > 0)
			return 255;
		else if (setpoint <= 0 && scale.x <= 0)
			return 255;
		
		
		return 0;
	}
	
	void RemoveDebris() {
	
		ThinkerIterator debrisIterator = ThinkerIterator.Create("magicblackholedebris");
		
		magicblackholedebris debris;
		while (debris = magicblackholedebris (debrisIterator.Next()) ) {
			
			debris.finish();
		}
		
		return;
	}
	
	States {
		
		Spawn:
			MODL A 0 NoDelay A_StartSound("Spell/BlackHole", -1, CHANF_OVERLAP|ATTN_NONE|CHANF_NOPAUSE);
		Increase:
			MODL A 0 A_RadiusThrust(-500*(scale.x*2), 16*8*scale.x*10, RTF_THRUSTZ|RTF_NOIMPACTDAMAGE, 16*8*scale.x);
			MODL A 0 A_RadiusGive("magicblackholedeath", 16*8*scale.x, RGF_MONSTERS|RGF_NOSIGHT|RGF_MISSILES|RGF_CORPSES);
			MODL A 0 A_RadiusGive("magicblackholespeed", 16*8*scale.x*10, RGF_MONSTERS|RGF_NOSIGHT|RGF_MISSILES|RGF_CORPSES);
			MODL AAAAAA 0 A_SpawnProjectile("magicblackholedebris", 0, 0, random(0.0,360.0), CMF_AIMDIRECTION|CMF_ABSOLUTEANGLE, random(90.0, -90.0));
			MODL A 1 A_Jump(ScaleAnimation(invoker.BHSS, 0.0005, invoker.ACCON, FALSE), "Inverse");
			loop;
		Inverse:
			MODL A 0 A_RadiusThrust(-600*(scale.x*2), 16*8*scale.x*10, RTF_THRUSTZ|RTF_NOIMPACTDAMAGE, 16*8*scale.x);//RTF_NOTMISSILE
			MODL A 0 A_RadiusGive("magicblackholedeath", 16*8*scale.x, RGF_MONSTERS|RGF_NOSIGHT|RGF_MISSILES|RGF_CORPSES);
			MODL A 0 A_RadiusGive("magicblackholespeed", 16*8*scale.x*10, RGF_MONSTERS|RGF_NOSIGHT|RGF_MISSILES|RGF_CORPSES);
			MODL AAAAAA 0 A_SpawnProjectile("magicblackholedebris", 0, 0, random(0.0,360.0), CMF_AIMDIRECTION|CMF_ABSOLUTEANGLE, random(90.0, -90.0));
			MODL A 1 A_Jump(ScaleAnimation(invoker.BHSS, 0, invoker.ACCOFF, TRUE), "Death");
			loop;
		Death:
			TNT1 A 0 RemoveDebris(); //A_RemoveChildren(TRUE, RMVF_MISSILES|RMVF_NOMONSTERS);
		DeathShards:
			TNT1 A 0 A_Countdown();
			Stop;
	} //A_RadiusGive("magicblackholedeath", 16*radius*scale.x, RGF_MONSTERS|RGF_PLAYERS|RGF_OBJECTS|RGF_VOODOO|RGF_CORPSES|RGF_KILLED|RGF_NOSIGHT|RGF_MISSILES);
}

/*
class magicblackholedeath : CustomInventory {
	
	default {
		inventory.amount 1;
		+INVENTORY.AUTOACTIVATE;
	}
	
	states {
	
		pickup:
			TNT1 A 0;
			TNT1 A 0 {
				//let act = invoker.owner.GetClass();
				string bla = self.GetClass();
				if (bla)
					A_Print(bla);
				//Class<Inventory> pat = act;
				//let dmg = ApplyDamageFactors(pat, "Death", 5000, 5000);
				//if(dmg >= SpawnHealth()) {
				//	A_Remove(AAPTR_DEFAULT, RMVF_EVERYTHING);
				//	A_Die();
				//}
			}
			stop;
	}
}
*/

class magicblackholespeed : CustomInventory {
	
	default {
		
		inventory.amount 1;
		+INVENTORY.AUTOACTIVATE;
	}
	
	states {
		
		pickup:
			TNT1 A 0;
			TNT1 A 0 {
				
				if (!CheckClass("magicblackholedebris") && !CheckClass("magicblackholeshard")) {
					if (A_CheckFlag("MISSILE", "Null")) {
					
						CheckProximity("magicblackhole", 5000, 1, CPXF_CHECKSIGHT|CPXF_SETMASTER|CPXF_CLOSEST);
						
						if (master != null) {
							
							// Z Thrust
							double distz = Distance3D(master);
							double finalspeed = 80000.0/(distz*distz)+1;
							if (z > master.z) finalspeed = -finalspeed;
							
							AddZ(finalspeed);
							
							// XY Thrust
							double dist = Distance2D(master);
							double force = 40000.0/(dist*dist)+1; // Force increases when close to XY coords.
							double xyforce = force*0.5; // XY gravity is reduced when Z distance is high.
							double antixyf = -force*0.5;
							
							Thrust(xyforce, AngleTo(master));
							Thrust(antixyf, angle); // Reduce centripetal force.
						}
					}
					else {
						
						A_ChangeVelocity(clamp(velx, -4, 4), clamp(vely, -4, 4), clamp(velz, -4, 4), CVF_REPLACE);
					}
				}
			}
			stop;
	}
}

class magicblackholedeath : CustomInventory {
	
	default {
		
		inventory.amount 1;
		+INVENTORY.AUTOACTIVATE;
		+NODAMAGETHRUST;
	}
	
	states {
		
		pickup:
			TNT1 A 0;
			TNT1 A 0 {
				
				//A_GiveInventory("magicblackholepowerup", 1);
				//A_Explode(5, 2, XF_HURTSOURCE|XF_NOTMISSILE, FALSE, 0, 0, 0, "", "UltraDeath");
				if (!CheckClass("magicblackholedebris")) {
					A_Remove(AAPTR_DEFAULT, RMVF_EVERYTHING);
				}
			}
			stop;
	}
}

/*
class DeathDamage : Powerup {
	
	override void ModifyDamage (int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags) {
		
		if (passive && damage > 0)
		{
			if (Owner != null)
			{
				if (damageType == "UltraDeath") {
					newdamage = damage*1000;
					
					if (Owner.health <= newdamage)
						A_Die();
				}
				else
					newdamage = max(0, ApplyDamageFactors(GetClass(), damageType, damage, damage));
			}
		}
	}
}

class magicblackholepowerup : PowerupGiver {
	
	default {
		
		Inventory.PickupMessage "Black Hole Damage!!";
		Powerup.Color "Grey4";
		Inventory.MaxAmount 0;
		//Inventory.UseSound "pickups/slowmo"
		Powerup.Type "DeathDamage";
		Powerup.Duration 5;
		Translation "128:143=96:103";
		
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.FANCYPICKUPSOUND;
	}
	
	States {
		
		Spawn:
			TNT1 A -1;
			Stop;
	}
}
*/

class magicblackholedebris : Actor {
	
	default {
		
		Speed 80;
		Radius 2;
		Height 4;
		
		PROJECTILE;
		+THRUACTORS;
	}
	
	void finish() {
		
		A_Remove(AAPTR_DEFAULT, RMVF_EVERYTHING);
		return;
	}
	
	states {
		
		spawn:
			TNT1 A 1 A_Jump(16, "death");
			loop;
		death:
			TNT1 A 0 A_SpawnProjectile("magicblackholeshard", 0, 0, 0, CMF_TRACKOWNER, 0, AAPTR_TARGET);//A_SpawnItemEx("magicblackholeshard", 0, 0, 0, 20, 0, 0, 0, SXF_TRANSFERPOINTERS, 0);//
			stop;
	}
}

class magicblackholeshard : Actor {
	
	default {
		
		Speed 20;
		Radius 2;
		Height 4;
		RenderStyle "Add";
		Alpha 0.01;
		
		PROJECTILE;
		+BRIGHT;
		+THRUACTORS;
	}
	
	int seekTarget() {
		
		if(target) {
			
			A_FaceTarget();
			return 16;
		}
		
		bNoGravity = FALSE;
		gravity = frandom(0.05,0.3);
		A_ScaleVelocity(frandom(0.4,0.7));
		return 256;
	}
	
	states {
		
		spawn:
			PUFF C 0 NoDelay A_SetScale(frandom(0.15,0.65));
		appear:
			PUFF C 0 A_FadeIn(frandom(0.05,0.15));
			PUFF C 1 A_Jump(seekTarget(), "death");
			loop;
		death:
			PUFF C 0 A_FadeOut(frandom(0.1,0.3));
			PUFF C 1 A_Jump(seekTarget(), "deathend");
			loop;
		deathend:
			PUFF C 1 A_FadeOut(frandom(0.005,0.020));
			loop;
	}
}

class magicblackholelaunch : Actor {
	
	default {
		
		Speed 60;
		Radius 2;
		Height 4;
		
		PROJECTILE;
		+SKYEXPLODE;
	}
	
	states {
		spawn:
			TNT1 A 8;
		death:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("magicblackhole");
			stop;
	}
}