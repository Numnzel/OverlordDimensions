class deathknight : actor {
	
	default {
		
		Health 3000;
		Radius 24;
		Height 56;
		Mass 500;
		Speed 16;
		Scale 1.2;
		RenderStyle "Subtract";
		Alpha 1.0;
		
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
		HitObituary "%o was mauled by a death knight.";
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