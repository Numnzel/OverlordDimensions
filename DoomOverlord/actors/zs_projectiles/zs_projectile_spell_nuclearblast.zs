class magicnuclearblastspawn : actor {

	default {
		
		vspeed 0;
		
		+ALLOWTHRUFLAGS;
		+THRUACTORS;
		+ALWAYSPUFF;
	}
	
	States {
		Spawn:
			TNT1 A 0;
			TNT1 A 1 A_SpawnItemEx("magicnuclearblast", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION );
			stop;
	}
}

class magicnuclearblast : actor {
	
	bool spawned;
	
	default {
		
		radius 64;
		height 32;
		+BRIGHT;
	}
	
	states {
		spawn:
			TNT1 A 0 NoDelay { SetZ(floorz); }
			TNT1 A 0 A_Explode(200, 300, XF_NOTMISSILE);
			TNT1 A 4;
			TNT1 A 0 {
				
				A_SpawnItemEx("magicnuclearblastexplosiontrail", 8.0, 0, 0, 0, 0, 0, 0, SXF_SETTARGET);
				A_SpawnItemEx("magicnuclearblastexplosiontrail", -8.0, 0, 0, 0, 0, 0, 0, SXF_SETTARGET);
				A_SpawnItemEx("magicnuclearblastexplosiontrail", 0, 8.0, 0, 0, 0, 0, 0, SXF_SETTARGET);
				A_SpawnItemEx("magicnuclearblastexplosiontrail", 0, -8.0, 0, 0, 0, 0, 0, SXF_SETTARGET);
				
				double xcoords;
				for (int i = 360/64; i < 360; i+=360/64) {
					xcoords = 32.0;
					do {
						spawned = A_SpawnItemEx("magicnuclearblastexplosiontrail", xcoords, 0, 0, 0, 130, 0, i, SXF_SETTARGET);
						xcoords += 8.0;
					}
					until (spawned || xcoords > 160.0)
				}
			}
			MISL BCD 4;
			TNT1 A 600;
			stop;
	}
}

class magicnuclearblastexplosiontrail : actor {
	
	default {
		
		radius 8;
		height 16;
		damage 0;
		
		ReactionTime 13;
		
		PROJECTILE;
		+NODAMAGETHRUST;
		+DONTREFLECT;
		+NOEXPLODEFLOOR;
		+STEPMISSILE;
		+FLOORHUGGER;
		+RIPPER;
		+THRUACTORS;
		+BRIGHT;
		+NOCLIP;
	}
	
	states {
		spawn:
			TNT1 A 0;
			TNT1 A 1 { bNoclip = FALSE; }
		repeat:
			MISL BCD 2 {
				A_RadiusThrust(350, 150, RTF_NOIMPACTDAMAGE|RTF_THRUSTZ);
				A_RadiusGive("magicnuclearblastexplosiondamage", 250, RGF_MONSTERS);
				A_ScaleVelocity(0.9);
				A_CountDown();
				A_SpawnItemEx("magicnuclearblastradiationspawner");
			}
			loop;
		death:
			TNT1 A 0 A_SpawnItemEx("magicnuclearblastradiationspawner");
			TNT1 A 0 A_RadiusGive("magicnuclearblastexplosiondamage", 1000, RGF_MONSTERS);
			stop;
	}
}

class magicnuclearblastexplosiondamage : CustomInventory {
	
	default {
		
		inventory.amount 1;
		inventory.maxamount 1;
		+INVENTORY.AUTOACTIVATE;
	}
	
	states {
		
		pickup:
			TNT1 A 0;
			TNT1 A 0 A_JumpIfInventory("magicnuclearblastexplosiondamagecheck", 1, 3);
			TNT1 A 0 A_DamageSelf(500);
			TNT1 A 0 A_GiveInventory("magicnuclearblastexplosiondamagecheck", 1);
			TNT1 A 0;
			stop;
	}
}

class magicnuclearblastexplosiondamagerads : magicnuclearblastexplosiondamage {
	
	states {
		
		pickup:
			TNT1 A 0;
			TNT1 A 0 A_JumpIfInventory("magicnuclearblastexplosiondamageradspile", 4, "repeat");
			stop;
		repeat:
			TNT1 A 0 A_DamageSelf(random(20,30), "Radiation");
			TNT1 A 0 A_TakeInventory("magicnuclearblastexplosiondamageradspile", 7);
			stop;
	}
}

class magicnuclearblastexplosiondamageradspile : Inventory {

	default {
		
		inventory.amount 1;
		inventory.maxamount 200;
	}
}

class magicnuclearblastexplosiondamagecheck : Powerup {

	default {
		
		powerup.duration -5;
	}
}


class magicnuclearblastradiationspawnerlight : PointLight {

	default {
		
		args 12, 0, 255, 128; // args 4, 0, 96, 128;
		//+DYNAMICLIGHT.ADDITIVE;
	}
	/*
	override void Tick() {
		
		if (GetAge() > 500 && random(0,2800) < GetAge())
			SetState(Null);
	}
	*/
}

class magicnuclearblastradiationspawner : Actor {
	
	bool unused;
	actor light;
	
	default {
		
		radius 2;
		height 4;
		ReactionTime 30;
		+NOCLIP;
		+RELATIVETOFLOOR;
		+NOGRAVITY;
	}

	states {
		
		spawn:
			TNT1 A 0 NoDelay {
				
				[unused, light] = A_SpawnItemEx("magicnuclearblastradiationspawnerlight", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER);
				A_SpawnItemEx("magicnuclearblastradiationparticlespawner", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER);
			}
		repeat:
			TNT1 A 18 A_RadiusGive("magicnuclearblastexplosiondamageradspile", 300, RGF_MONSTERS|RGF_NOSIGHT|RGF_PLAYERS);
			TNT1 A 18 A_RadiusGive("magicnuclearblastexplosiondamagerads", 300, RGF_MONSTERS|RGF_NOSIGHT|RGF_PLAYERS);
			TNT1 A 0 A_CountDown();
			loop;
		death:
			TNT1 A 18 A_RadiusGive("magicnuclearblastexplosiondamageradspile", 300, RGF_MONSTERS|RGF_NOSIGHT|RGF_PLAYERS);
			TNT1 A 18 A_RadiusGive("magicnuclearblastexplosiondamagerads", 300, RGF_MONSTERS|RGF_NOSIGHT|RGF_PLAYERS);
			TNT1 A 0 A_Jump(16, "death2");
			loop;
		death2:
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 {
				
				light.args[DynamicLight.LIGHT_RED] -= light.args[DynamicLight.LIGHT_RED]/70;
				light.args[DynamicLight.LIGHT_GREEN] -= light.args[DynamicLight.LIGHT_GREEN]/70;
				light.args[DynamicLight.LIGHT_BLUE] -= light.args[DynamicLight.LIGHT_BLUE]/70;
				light.args[DynamicLight.LIGHT_INTENSITY] -= light.args[DynamicLight.LIGHT_INTENSITY]/70;
			}
			//TNT1 A 0 { light.SetState(Null); }
			TNT1 A 0 A_RemoveChildren(TRUE, RMVF_EVERYTHING);
			stop;
	}
}

class magicnuclearblastradiationparticlespawner : magicnuclearblastradiationspawner {


	states {
		
		spawn:
			TNT1 A 8 NoDelay A_SetTics(random(1,70));
		repeat:
			TNT1 A 8;
			TNT1 A 0 A_Jump(248, "repeat");
			TNT1 A 16 A_SpawnItemEx("magicnuclearblastradiationparticle", frandom(-32.0,32.0), frandom(-32.0,32.0), frandom(0,ceilingz-pos.z), frandompick(-frandom(10.0,20.0),frandom(10.0,20.0)), frandompick(-frandom(10.0,20.0),frandom(10.0,20.0)), frandompick(-frandom(10.0,20.0),frandom(10.0,20.0)), random(0,360), SXF_ABSOLUTEVELOCITY, 1);
			loop;
		death:
			TNT1 A 0;
			stop;
	}
}

class magicnuclearblastradiationparticle : Actor {

	default {
		
		radius 2;
		height 4;
		scale 0.15;
		renderstyle "Add";
		alpha 1.05;
		
		PROJECTILE;
		+BRIGHT;
		+THRUACTORS;
		+SPAWNFLOAT;
		+NOGRAVITY;
	}
	
	states {
		
		spawn:
			APBX EEEEEEEEEEEEEEEEEEEEE 1 {
				// A_FadeIn(0.3);
				A_SpawnItemEx("magicnuclearblastradiationparticletrail", 0, 0, 0, 0, 0, 0, 0, SXF_TRANSFERALPHA);
				A_ScaleVelocity(0.7);
			}
		death:
			APBX E 1 A_FadeOut(0.1);
			wait;
	}
}

class magicnuclearblastradiationparticletrail : magicnuclearblastradiationparticle {

	states {
		
		spawn:
			APBX E 0;
		death:
			APBX E 1 A_FadeOut(0.1);
			wait;
	}
}