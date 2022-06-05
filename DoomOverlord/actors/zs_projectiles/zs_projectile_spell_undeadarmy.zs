class magic_skeleton : actor {
	
	default {
		
		Health 250;
		Radius 16;
		Height 44;
		Mass 100;
		Speed 8;
		PainChance 16;
		MeleeThreshold 196;
		Scale 0.8;
		
		MONSTER;
		+MISSILEMORE;
		+FLOORCLIP;
		+FRIENDLY;
		+ALWAYSFAST;
		
		SeeSound "skeleton/sight";
		//PainSound "skeleton/pain";
		DeathSound "skeleton/death";
		ActiveSound "skeleton/active";
		MeleeSound "skeleton/melee";
		HitObituary "$OB_UNDEADHIT"; // "%o was punched by a revenant."
	}
	
	States {
		
		Spawn:
			ZKEL AB 10 A_Look;
			Loop;
		See:
			ZKEL AABBCCDDEEFF 2 A_Chase;
			Loop;
		Melee:
			ZKEL G 1 A_FaceTarget;
			ZKEL G 6 A_SkelWhoosh;
			ZKEL H 0 A_FaceTarget;
			ZKEL H 2 A_Recoil(-3);
			ZKEL H 0 A_FaceTarget;
			ZKEL H 2 A_Recoil(-4);
			ZKEL H 0 A_FaceTarget;
			ZKEL H 2 A_Recoil(-4);
			ZKEL I 6 A_SkelFist;
			Goto See;
		Pain:
			ZKEL L 5;
			ZKEL L 5 A_Pain;
			Goto See;
		Death:
			ZKEL LM 7;
			ZKEL N 7 A_Scream;
			ZKEL O 7 A_NoBlocking;
			ZKEL P 7;
			ZKEL Q -1;
			Stop;
		Raise:
			ZKEL Q 5;
			ZKEL PONML 5;
			Goto See;
	}
}

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