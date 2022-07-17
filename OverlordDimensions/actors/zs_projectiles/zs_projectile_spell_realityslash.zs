


class magicslash : actor {
	
	int timer;
	int animation;
	double ang;
	double ratio;
	double offs;
	double pi;
	PlayerInfo p;
	
	default {
		
		+NOCLIP;
	}
	
	states {
		spawn:
			TNT1 A 1;
			TNT1 A 0 {
				timer = 0;
				animation = 0;
				pi = 3.14159;
				p = players[consoleplayer];
				
				ratio = Cvar.GetCVar("vid_defwidth", p).GetFloat() / Cvar.GetCVar("vid_defheight", p).GetFloat();
				
				ang = pitch;
				
				offs = 0.5-(sin(ang)/2.0);
			}
			TNT1 A 1 {
				Shader.SetEnabled(p, "realityslash", true);
				Shader.SetUniform1f(p, "realityslash", "timer", timer++);
				Shader.SetUniform1f(p, "realityslash", "angle", ((ang*pi)/180) );
				Shader.SetUniform1f(p, "realityslash", "offsy", offs);
				
				if(++animation > 3)
					SetStateLabel("death");
			}
			wait;
		death:
			TNT1 A 11;
			TNT1 A 0 {
				timer = 0;
				Shader.SetEnabled(p, "realityslash", false);
			}
			stop;
	}
}



class magiccutterspawner : actor {
	
	double cutangle;
	int cutlength;
	int cutn;
	int ttl;
	bool slashenabled;
	bool unused;
	actor slash;
	
	property slashe: slashenabled;
	
	default {
		
		radius 2;
		height 1;
		speed 180;
		renderstyle "add";
		alpha 1.0;
		magiccutterspawner.slashe true;
		
		PROJECTILE;
		+RIPPER;
		+NOGRAVITY;
		+BRIGHT;
		+ROLLSPRITE;
	}
	
	void MapXZtoCrosshair (double crosshairpitch, in out double compx, in out double compz) {
		
		compx = sin(crosshairpitch)*compz; //-cos(crosshairpitch) + sin(crosshairpitch)*compz;
		compz = cos(crosshairpitch)*compz; //-sin(crosshairpitch) + cos(crosshairpitch)*compz;
	}
	
	/*
	override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath) {
		
		SetStateLabel("dissapear");
	}*/
	
	override int SpecialMissileHit (actor victim) {
		
		RealitySlash();
		
		return -1;
	}
	
	void RealitySlash () {
		
		if (slashenabled) {
			
			slashenabled = false;
			
			[unused, slash] = A_SpawnItemEx("magicslash");
			
			if (slash)
				slash.pitch = cutangle; // TODO: Also add crystal break sound
		}
	}
	
	states {
		spawn:
			
			TNT1 A 0 NoDelay {
				
				// store initial values
				pitch = target.pitch;
				cutangle = frandom(-36.0, 36.0);
				cutlength = 100;
				cutn = 80;
				ttl = 0;
				slashenabled = true;
				
				A_SetRoll(-cutangle/2.0); // TODO: Does not match the cut perfectly...
			}
			BFS1 A 1 {
				
				cutlength += 60;
				scale.x *= 1.05;
				
				double spacey = cutlength/cutn;
				double spacez = sin(cutangle)*spacey;
				actor cut;
				
				for (int ray = 0; ray < cutn/2.0; ray++) {
					
					double valy = cos(cutangle)*spacey*ray;
					double valz = sin(cutangle)*spacez*ray;
					
					double compx = valz;
					double compy = valy;
					double compz = valz;
					
					MapXZtoCrosshair (pitch, compx, compz);
					
					if (cutangle < 0) {
						compx = -compx;
						compz = -compz;
					}
					
					if (ray == 0) {
						
						[unused, cut] = A_SpawnItemEx("magiccutter", compx, compy, compz, 0, 0, 0, 0, SXF_TRANSFERPITCH);
						
					} else {
						
						[unused, cut] = A_SpawnItemEx("magiccutter", compx, compy, compz, 0, 0, 0, cos(min(90,abs(pitch)*4))*(-ray/2.0), SXF_TRANSFERPITCH );
						if(cut)
							if (cutangle < 0) cut.pitch += ray*0.3;
							else cut.pitch -= ray*0.2;
						
						[unused, cut] = A_SpawnItemEx("magiccutter", -compx, -compy, -compz, 0, 0, 0, cos(min(90,abs(pitch)*4))*(ray/2.0), SXF_TRANSFERPITCH );
						if(cut)
							if (cutangle < 0) cut.pitch -= ray*0.3;
							else cut.pitch += ray*0.2;
					}
				}
				
				if (++ttl > 9)
					SetStateLabel("death");
			}
			wait;
		death:
			BFS1 A 0 {
				// TODO: Pitch resets when dead.
				A_ScaleVelocity(0);
				RealitySlash();
			}
			BFS1 AAAAAAA 1 {
				
				scale.x *= 1.005;
				scale.y *= 1.2;
			}
			BFS1 A 1 {
				
				
				scale.x *= 1.01;
				scale.y *= 0.5;
				A_FadeOut(0.03);
			}
			wait;
	}
}

class magiccutter : actor {
	
	default {
		
		radius 1;
		height 1;
		
		+NOGRAVITY;
		+NODAMAGETHRUST;
		+FORCERADIUSDMG;
	}
	
	states {
		spawn:
			TNT1 A 0;
		death:
			TNT1 A 1 A_Explode(112, 96, XF_NOSPLASH, false, 96);
			stop;
	}
}