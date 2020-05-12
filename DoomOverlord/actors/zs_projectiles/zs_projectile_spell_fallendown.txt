
class magicfallendown : actor {
	
	int lite;
	double fallspeed;
	double increment;
	double deccel;
	bool splash;
	actor owner;
	actor column;
	
	default {
		
		radius 2;
		height 1;
		renderstyle "add";
		alpha 1.0;
		
		+NOGRAVITY;
		+BRIGHT;
		+ROLLSPRITE;
	}
	
	override void Tick() {
		
		Super.Tick();
		
		SetZ(floorz + 60000.0);
		
		if (splash) {
			
			if (GetAge()%35 == 0) {
				
				double dist = scale.x;
				A_QuakeEx(5.0, 5, 5, 35, dist,	1.0 * dist, "world/quake", 0, 0, 1);
				A_QuakeEx(4.0, 4, 4, 35, 0,		2.0 * dist, "", 0, 0, 1);
				A_QuakeEx(3.0, 3, 3, 35, 0,		4.0 * dist, "", 0, 0, 1);
				A_QuakeEx(2.0, 2, 2, 35, 0,		8.0 * dist, "", 0, 0, 1);
				A_QuakeEx(1.0, 1, 1, 35, 0,		16.0 * dist, "", 0, 0, 1);
				
				for(int i = 0; i < 500; i++)
					A_SpawnItemEx("magicruinsfx", frandom(0.0, dist * 1.4), 0, 0, 0, 0, frandom(0.5, 5.0), frandom(0.0, 360.0), SXF_NOCHECKPOSITION);
			}
		}
	}
	
	void holycurtain (int offs = 0) {
		
		let curtain = magicfallendownholy(spawn("magicfallendownholy"));
		
		if (curtain) {
			
			curtain.target = self;
			curtain.delta = offs;
		}
	}
	
	states {
		spawn:
			TNT1 A 0 NoDelay {
				
				// Initial values
				splash = false;
				lite = 0;
				increment = 16.0;
				fallspeed = 500.0;
				deccel = 0.05;
				scale.x = 0.01;
				pitch = 180;
				
				A_StartSound("Spell/FallenDownStart", CHAN_AUTO, CHANF_DEFAULT, 1.0, ATTN_NONE);
				
				//Light_ForceLightning(0);
			}
		grow:
			BFS1 A 1 {
				
				// Create the dot in sky
				scale.x = min(scale.x+0.6, 100.0);
				
				if (scale.x >= 100.0)
					SetStateLabel("column");
			}
			loop;
		column:
			BFS1 AAA 1 {
				
				// The column falls to the ground
				scale.y = min(scale.y+fallspeed, 181000.0);
				fallspeed *= 1.0+deccel;
				increment -= deccel;
				
				if (scale.y >= 181000.0)
					SetStateLabel("expand");
			}
			BFS1 A 0 {
				
				if (owner && lite < 20)
					owner.A_Light(++lite);
			}
			loop;
		expand:
			BFS1 A 0 {
				
				// The column touches the ground
				column = null;
				increment = 15.0;
				splash = true;
				
				A_StartSound("Spell/FallenDown", CHAN_AUTO, CHANF_DEFAULT, 1.0, ATTN_NONE);
				
				column = spawn("magicfallendownareas", (pos.x, pos.y, floorz));
				
				if (column)
					column.target = self;
				
				for (int a = 0; a < 360; a += 360/180)
					holycurtain(a);
			}
			BFS1 A 1 {
				
				// The column grows and destroys everything
				scale.x += increment;
				increment -= deccel;
				
				if (increment <= 0.0)
					SetStateLabel("death");
			}
			wait;
		death:
			BFS1 A 0 {
				
				if (column)
					column.SetStateLabel("death");
			}
			//BFS1 A 105; // Wait to damaged player red screen sfx to dissapear, because it alters the dissapearing shader.
		dissapear:
			BFS1 AAAAA 1 A_FadeOut(0.02);
			BFS1 A 0 {
				if (owner && lite > 0)
					owner.A_Light(lite--);
			}
			loop;
	}
}

// This actor is in the center and gives the area effects
class magicfallendownareas : actor {
	
	default {
		
		radius 4;
		height 1;
		
		+FLOORHUGGER;
		+INVISIBLE;
	}
	
	override void Tick() {
		
		if (target) {
			
			double dist = target.scale.x;
			A_RadiusThrust(1000,					dist * 1.1);
			A_RadiusGive("magicholycurtaindmg",		dist, RGF_NOSIGHT|RGF_PLAYERS);
			A_RadiusGive("magicholycurtaindmg",		dist, RGF_NOSIGHT|RGF_MONSTERS);
			A_RadiusGive("magicholylightplayers",	dist, RGF_NOSIGHT|RGF_PLAYERS);
			A_RadiusGive("magicholylight",			dist, RGF_NOSIGHT|RGF_MONSTERS);
			A_RadiusGive("magicholylight",			dist, RGF_NOSIGHT|RGF_CORPSES);
			A_RadiusGive("magicholylight",			dist, RGF_NOSIGHT|RGF_KILLED);
		}
	}
	
	states {
		spawn:
			TNT1 A 1;
			loop;
		death:
			TNT1 A 10 {
				
				A_RadiusGive("magicholyremoveshader",	32768, RGF_NOSIGHT|RGF_PLAYERS);
				SetState(null); // this is necessary
			}
			stop;
	}
}

// These actors orbit the light column
class magicfallendownholy : magicfallendownareas {
	
	int delta; property deltaoffs: delta;
	
	default {
		
		magicfallendownholy.deltaoffs 0;
	}
	
	override void Tick() {
		
		if (target)
			A_Warp(AAPTR_TARGET, target.scale.x, 0, 32, delta+GetAge(), WARPF_ABSOLUTEANGLE|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
		else
			SetState(null);
	}
}

// Column damage. This object is given ONCE to each who enters the light column.
class magicholycurtaindmg : powerup {
	
	default {
		
		powerup.duration -30;
	}
	
	override void doEffect() {
		
		if (owner && getAge() < 2)
			owner.A_DamageSelf(10000);
	}
}

// White translation to actors inside the light column.
class magicholylight : powerup {
	
	default {
		
		powerup.duration -2;
		
		+INVENTORY.NOSCREENBLINK;
	}
	
	override void doEffect() {
		
		if (owner)
			owner.A_SetTranslation("FadeToWhite");
	}
	
	override void DetachFromOwner() {
		
		if (owner)
			owner.A_SetTranslation("Restore");
	}
}

// White translation and also applies a bright screen shader for the players.
class magicholylightplayers : magicholylight {
	
	PlayerInfo p;
	
	override void doEffect() {
		
		if (GetAge() < 2) {
			p = players[consoleplayer];
			Shader.SetEnabled(p, "fallendown", true);
		}
		
		if (owner && GetAge() >= 2)
			Shader.SetUniform1f(p, "fallendown", "timer", owner.CountInv("magicholystrenght"));
		
		if (owner) {
			owner.GiveInventory("magicholystrenght", 1);
			owner.A_SetTranslation("FadeToWhite");
		}
	}
	
	override void DetachFromOwner() {
		
		if (owner) {
			owner.A_SetTranslation("Restore");
			owner.GiveInventory("removeholyshader", 1);
		}
	}
}

// For removing the player white screen shader gradually.
class removeholyshader : powerup {
	
	PlayerInfo p;
	
	default {
		
		powerup.duration -30;
		
		+INVENTORY.NOSCREENBLINK;
	}
	
	override void doEffect() {
		
		if (GetAge() < 2)
			p = players[consoleplayer];
		
		if (owner && owner.CountInv("magicholyremoveshader") > 0) {
			
			Shader.SetUniform1f(p, "fallendown", "timer", owner.CountInv("magicholystrenght"));
			owner.TakeInventory("magicholystrenght", 1);
			
			if (owner.CountInv("magicholystrenght") == 0) {
				
				Shader.SetEnabled(p, "fallendown", false);
				owner.TakeInventory("magicholyremoveshader", 1);
			}
		}
	}
}

class magicholystrenght : inventory {

	default {
		
		inventory.amount 1;
		inventory.maxamount 200;
	}
}

class magicholyremoveshader : inventory {
	
	default {
		
		inventory.amount 1;
		inventory.maxamount 1;
	}
}

class magicruinsfx : actor {
	
	double turn;
	
	default {
		
		renderstyle "add";
		alpha 1.0;
		
		+NOGRAVITY;
		+ROLLSPRITE;
		+NOINTERACTION;
	}
	
	states {
		spawn:
			TNT1 A 0 NoDelay {
				A_Warp(AAPTR_DEFAULT, 0, 0, 0, 0, WARPF_TOFLOOR);
				A_SetScale(frandom(0.03, 0.8));
				turn = frandom(-4.0, 4.0);
			}
			TNT1 A 0 A_Jump(256, 1, 2, 3);
			RUIN A 0;
			goto fly;
			RUIN B 0;
			goto fly;
			RUIN C 0;
			goto fly;
		fly:
			#### # 1 {
				A_SetRoll(getAge()*turn);
				A_FadeOut(frandom(0.001, 0.008));
			}
			loop;
	}
}