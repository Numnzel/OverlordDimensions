class magicparticlechainthunder : Actor {
	
	int colorindex;
	
	default {
		
		RenderStyle "Add";
		alpha 1.0;
		scale 2.0;//scale 2.5;0.2
		radius 2;
		height 4;
		
		PROJECTILE;
		+FORCEXYBILLBOARD;
		+CLIENTSIDEONLY;
		+BRIGHT;
	}
	
	states {
		spawn:
			THU2 A 0;
			THU2 A 0 {
				
				colorindex = abs(args[0]);
				
				// cycle through colors if the index exceeds
				while(colorindex > 2)
					colorindex -= 3;
			}
			THU2 A 0 A_Jump(256, 1+colorindex); // select color
			THU2 A 0;
			goto repeat;
			THU3 A 0;
			goto repeat;
			THU4 A 0;
			goto repeat;
		repeat:
			#### A 0 A_SetScale( (scale.x*0.5) / (2.0+(0.01*args[1])) ); // A_SetScale( (scale.x*0.5) / (2.0+(0.05*args[1])) );
			#### A 1 { alpha = scale.x*2.5; }
		repeat2:
			#### A 0 {
				if (scale.x < 0.04)
					A_SetScale(scale.x*0.95);
				else
					A_SetScale(scale.x*0.65); // 0.7
			}
			#### A 1 {
				
				alpha = (scale.x*2.5)-0.001; //-0.02
				
				if(alpha < 0.001) //0.1
					SetState(null);
			}
			loop;
		death:
			TNT1 A 0;
			stop;
	}
}

class magicparticlechainthunderattack : Actor {
	
	default {
		
		RenderStyle "Add";
		alpha 0.9;
		scale 0.5;//scale 2.5;0.2
		
		PROJECTILE;
		+FORCEXYBILLBOARD;
		+CLIENTSIDEONLY;
		+BRIGHT;
	}
	
	states {
		spawn:
			THUN A 4;
			THUN A 20 A_SetScale(scale.x*0.15);
		repeat:
			THUN A 1 {
				A_SetScale(scale.x*0.96);
				A_FadeOut(0.05, FALSE);
				
				if(alpha < 0.001)
					SetState(null);
			}
			loop;
	}
}

class superrailgun : Actor abstract {
	
	const maxrays = 128; // you can extend this at your own risk
	const maxusesray = 31; // this can't be extended
	
	// internal vars
	array<int> colors; // stores color cycles
	array<bool> usesray; // stores enabled rays
	double circle; // stores iteration phase (used to offset the trail actors to generate a rotation)
	double viewp; // stores user camera pitch
	double roffsy; // random position offset applied to the trail actors, usually for decoration purposes
	double roffsz; // random position offset applied to the trail actors, usually for decoration purposes
	int rayn; // total rays
	
	// properties (use inheritance to redefine them)
	double radi; // rail radius
	string rayactr; // railgun trail actor
	string head; // first actor to be spawned
	double slope; // defines the 'slope' (curvature) of the ray, straighter the smaller this value is
	double inclinationoffs; // manual offset to adjust the sprite rotation to match the defined inclination (slope) at the defined speed
	
	property rayRadius: radi;
	property rayTrail: rayactr;
	property rayHead: head;
	property raySlope: slope;
	property rayInclination: inclinationoffs;
	
	// I have been unable to automatically calculate the inclination values, so here is a list with tested values:
	
	// tested inclination values for different slope values:
	// incl.	slope
	
	// at a speed of 20:
	// 1.0587	1
	// 1.0587	10
	// 1.0530	100
	// 1.0443	250
	// 1.0300	500
	// 1.0000	1000
	// 0.9410	2000
	// 0.8247	4000
	// 0.5900	8000
	
	// at a speed of 40:
	// 1.1245	1
	// 1.1230	10
	// 1.1120	100
	// 1.0935	250
	// 1.0625	500
	// 1.0000	1000
	// 0.8750	2000
	// 0.6250	4000
	// 1.2500	8000
	
	// at a speed of 60:
	// 1.1000	500
	// 1.0000	1000
	
	// at a speed of 80:
	// 1.28515	1
	// 1.2830	10
	// 1.2570	100
	// 1.0443	250
	// 1.0294	500
	// 1.0000	1000
	// 0.7150	2000
	// 0.1430	4000
	// 0.2800	8000
	
	default {
		
		damage 0;
		radius 2;
		height 4;
		
		PROJECTILE;
		+RIPPER;
		
		superrailgun.rayRadius 96.0;
		superrailgun.rayTrail "";
		superrailgun.rayHead "";
		superrailgun.raySlope 1000;
		superrailgun.rayInclination 1.0;
	}
	
	void CreateRays (double r, double randy = 0.0, double randz = 0.0) {
		
		bool unused;
		actor trailact;
		
		// Trail position offset, is increased to create the rotation.
		// Args3 is the railgun speed, ensures the rotation effect matches perfectly with different speeds
		// This calculation only works for a default slope of 1000, other slopes have to be corrected manually with the inclination
		circle += inclinationoffs*(360-args[3]);
		
		// For each enabled ray...
		for (int ray = 0; ray < rayn; ray++) {
			
			if (usesray[ray]) {
				
				double valuecos = r*cos(circle-(ray*(360.0/rayn)));
				double valuesin = r*sin(circle-(ray*(360.0/rayn)));
				
				double compx = -cos(viewp) + sin(viewp)*valuesin;
				double compy = valuecos+randy;
				double compz = -sin(viewp) + cos(viewp)*(valuesin+randz);
				
				// Spawn ray trail
				[unused, trailact] = A_SpawnItemEx(rayactr, compx, compy, compz, 0, 0, 0, 0, SXF_ORIGINATOR|SXF_SETMASTER); // TODO: remove flags
				
				// Spawn ray head, if any
				if (head != "")
					A_SpawnItemEx(head, compx, compy, compz, 0, 0, 0, 0, SXF_ORIGINATOR|SXF_SETMASTER);
				
				if (trailact) {
					
					trailact.args[0] = ray; // Set painting
					trailact.args[1] = args[0]; // Pass iteration phase to trail actor, can be used to fade-out scale effect...
				}
			}
		}
		
		return;
	}
	
	// This function converts the integer input and stores it as a boolean array
	void setUsedRays (int input) {
		
		int pile;
		
		pile = input;
		
		// Fill binary array
		while (pile > 0) {
			
			usesray.push(pile%2);
			
			pile /= 2;
		}
		
		// Fill the remaining positions
		for(int i = usesray.size(); i < maxrays; i++) {
			
			if (i >= maxusesray)
				usesray.Push(1);
			else
				usesray.Push(0);
		}
		
		return;
	}
	
	states {
		
		spawn:
			TNT1 A 0;
			TNT1 A 0 {
				
				setUsedRays(args[4]);
				
				// store initial values
				viewp = target.pitch;
				
				rayn = args[2];
				circle = args[0]*(slope/1000.0); // position is offset initially, so the trail forms a curve
				
				// only spawn the head actor at the first iteration
				if(args[1] == 0)
					head = "";
			}
		repeat:
			TNT1 A 0 {
				/*
				roffsy = frandompick(-24.0,0.0,24.0);
				
				if(roffsy == 0.0)
					roffsz = -32.0;
				else
					roffsz = 0.0;
				*/
				
				roffsy = frandom(-0.0, 0.0);
				roffsz = frandom(-0.0, 0.0);
			}
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 CreateRays(radi, roffsy, roffsz);
			loop;
		death:
			TNT1 A 8; //A_KillChildren("", KILS_KILLMISSILES);
			stop;
	}
}

class magicchaindragonlightning : superrailgun {
	
	default {
		
		superrailgun.rayRadius 12.0;
		superrailgun.rayTrail "magicparticlechainthunder";
		superrailgun.rayHead "magicchaindragonlightningattack";
		superrailgun.raySlope 500;
		superrailgun.rayInclination 1.08;
	}
}

class magicchaindragonlightningattack : actor {
	
	default {
		
		radius 2;
		height 4;
		reactiontime 1;
		
		+ISMONSTER;
		+LOOKALLAROUND;
		+FRIENDLY;
	}
	
	states {
		
		spawn:
			TNT1 AA 1 NoDelay A_LookEx(LOF_NOSOUNDCHECK|LOF_DONTCHASEGOAL);
			goto death;
		see:
			TNT1 A 0 A_CustomRailgun(random(45,90), 0, "", "LightBlue", RGF_FULLBRIGHT|RGF_NORANDOMPUFFZ, 1, 600, "", 0, 0, 0, 0, 3.5, 0, "magicparticlechainthunderattack", -8);
		death:
			TNT1 A 0;
			stop;
	}
}