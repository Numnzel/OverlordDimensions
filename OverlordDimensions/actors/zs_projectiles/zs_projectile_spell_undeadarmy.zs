class magic_skeleton_spawner : actor {
	
	int skeletons;
	int skeleton;
	int ang;
	float dist;
	
	default {
		
		radius 128;
		height 52;
		scale 0.25;
		
		+FLATSPRITE;
		+BRIGHT;
	}
	
	states {
		spawn:
			UNAR A 1 NoDelay {
				
				skeletons = 10;
				skeleton = 0;
				ang = 0;
				dist = 0;
			}
			UNAR A 1 {
				
				
				
				if (A_SpawnItemEx("magic_skeleton", dist, 0, 0, 1, 0, 0, ang))
					skeleton++;
				
				if (skeleton >= skeletons)
					SetState(null);
				
				ang += 15;
				
				if (ang >= 360) {
					ang = 0;
					dist += 16.0;
				}
				
				if (dist >= 96.0) // radius -16.0*2
					dist = 0.0;
			}
			wait;
	}
}