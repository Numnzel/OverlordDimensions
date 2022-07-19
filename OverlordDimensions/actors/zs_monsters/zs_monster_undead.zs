class magic_skeleton : actor {
	
	default {
		
		Health 350;
		Radius 16;
		Height 44;
		Mass 100;
		Speed 8;
		PainChance 16;
		Scale 0.8;
		
		MONSTER;
		+MISSILEMORE;
		+FLOORCLIP;
		+FRIENDLY;
		+ALWAYSFAST;
		+QUICKTORETALIATE;
		
		//SeeSound "";
		//PainSound "";
		//DeathSound "";
		//ActiveSound "";
		//MeleeSound "";
		HitObituary "%o was killed by an undead.";
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