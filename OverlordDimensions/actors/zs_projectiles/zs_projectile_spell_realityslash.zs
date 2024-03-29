class magicslash : actor {
	
	int timer;
	int animation;
	double ang;
	double ratio;
	double offs;
	PlayerInfo p;
	
	const pi = 3.14159;
	
	default {
		
		+NOCLIP;
	}
	
	states {
		spawn:
			TNT1 A 1;
			TNT1 A 0 {
				timer = 0;
				animation = 0;
				p = players[consoleplayer];
				
				ratio = Cvar.GetCVar("vid_defwidth", p).GetFloat() / Cvar.GetCVar("vid_defheight", p).GetFloat();
				
				ang = pitch;
				
				offs = 0.5-(sin(ang)/2.0);
			}
			TNT1 A 1 {
				Shader.SetEnabled(p, "realityslash", true);
				Shader.SetUniform1f(p, "realityslash", "timer", timer++);
				Shader.SetUniform1f(p, "realityslash", "angle", ((ang*pi)/180));
				Shader.SetUniform1f(p, "realityslash", "offsy", offs);
				
				if (++animation > 3)
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
	
	int cutlength; property pcutlength: cutlength;
	int cutp; property pcutparticles: cutp;
	bool slashenabled; property pslashen: slashenabled;
	bool unused;
	double cutangle;
	double pitchmem;
	actor slash;
	
	
	default {
		
		radius 3;
		height 2;
		speed 180;
		renderstyle "add";
		alpha 1.0;
		reactiontime 10;

		magiccutterspawner.pcutlength 100;
		magiccutterspawner.pcutparticles 20; // TODO: particle quantity should not affect curvature! 80 is accurate. 160 too much.
		magiccutterspawner.pslashen true;

		PROJECTILE;
		+RIPPER;
		+BRIGHT;
		+ROLLSPRITE;
	}
	
	void MapXZtoCrosshair (double crosshairpitch, in out double compx, in out double compz) {
		
		compx = sin(crosshairpitch)*compz; //-cos(crosshairpitch) + sin(crosshairpitch)*compz;
		compz = cos(crosshairpitch)*compz; //-sin(crosshairpitch) + cos(crosshairpitch)*compz;
	}
	
	override int SpecialMissileHit (actor victim) {
		
		RealitySlash();
		
		return -1;
	}
	
	// Start reality slash shader
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
				
				if (target) pitch = target.pitch;
				pitchmem = pitch;
				cutangle = frandom(-36.0, 36.0);
				A_SetRoll(-cutangle/2.0); // TODO: Does not match the cut perfectly...
			}
			BFS1 A 1 {
				
				cutlength += 60;
				scale.x *= 1.05;
				
				double spacey = cutlength/double(cutp);
				double spacez = sin(cutangle)*spacey;
				actor cut;
				
				for (int ray = 0; ray < cutp/2; ray++) {
					
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
						
						[unused, cut] = A_SpawnItemEx("magiccutter", compx, compy, compz, 0, 0, 0, cos(min(90,abs(pitch)*4))*(-ray/2.0), SXF_TRANSFERPITCH);
						if (cut) {
							if (target) cut.target = target; // source of damage is target
							if (cutangle < 0) cut.pitch += ray*0.3;
							else cut.pitch -= ray*0.2;
						}

						[unused, cut] = A_SpawnItemEx("magiccutter", -compx, -compy, -compz, 0, 0, 0, cos(min(90,abs(pitch)*4))*(ray/2.0), SXF_TRANSFERPITCH);
						if (cut) {
							if (target) cut.target = target; // source of damage is target
							if (cutangle < 0) cut.pitch -= ray*0.3;
							else cut.pitch += ray*0.2;
						}
					}
				}
				
				A_Countdown();
			}
			wait;
		death:
			BFS1 A 0 {
				pitch = pitchmem;
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
	
	class<Inventory> dmg; property pdmg: dmg;

	default {
		
		radius 1;
		height 1;

		magiccutter.pdmg "slashdamage";
		
		+INVISIBLE;
		+NOBLOCKMAP;
		+NOSECTOR;
		+NOGRAVITY;
	}
	
	states {
		spawn:
			TNT1 A 0 NoDelay {
				A_RadiusGive(dmg, 160, RGF_MONSTERS);
				A_RadiusGive(dmg, 160, RGF_OBJECTS);
			}
			stop;
	}
}

class slashdamage : powerup {

	override void InitEffect () {

		if (owner && owner.CountInv(self.getClassName()) == 0) {
			
			master = players[consoleplayer].mo;

			int dmg = (master && master.CountInv("magicamaximize") > 0) ? 2800*1.5 : 2800;

			owner.A_DamageSelf(dmg, "None", DMSS_NOPROTECT, null, "None", AAPTR_MASTER);
		}

		super.InitEffect();
	}

	default {

		inventory.amount 1;
		inventory.maxamount 1;
		powerup.duration 4;
		
		+INVENTORY.AUTOACTIVATE;
	}
}