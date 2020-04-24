class NashGore_Blood : Blood replaces Blood {
	
	states {
		
		Spawn:
			BLUD C 8;
			BLUD B 8 A_SpawnItemEx("NashGore_FlyingBlood", 0, 0, 8, random(-4, 4), random(-4, 4), random(2, 5), 0, 143, 176); // [Nash] it used to use A_SpawnItem, but we're getting rid of that crap
			BLUD A 8;
			Stop;
	}
}

class NashGore_FlyingBlood : actor {
	
	string trail;
	string spot;
	property Trail: trail;
	property Spot: spot;
	
	default {
		
		NashGore_FlyingBlood.Trail "NashGore_FlyingBloodTrail";
		NashGore_FlyingBlood.Spot "NashGore_BloodSpot";
		
		Scale 0.75;
		Health 1;
		Radius 8;
		Height 1;
		Mass 1;
		Gravity 0.5; // [Nash] make it fall slower. pretty!
		
		+CORPSE;
		+NOTELEPORT;
		+NOBLOCKMAP;
		-SOLID; // [Nash] so that it doesn't stick into other Actors
	}
	
	states {
		
		Spawn:
			TNT1 A 0;
			FBLD A 1 A_SpawnItem(trail,0,0,0,1);
			FBLD A 1;
			FBLD A 1 A_SpawnItem(trail,0,0,0,1);
			FBLD A 1;
			FBLD B 1 A_SpawnItem(trail,0,0,0,1);
			FBLD B 1;
			FBLD B 1 A_SpawnItem(trail,0,0,0,1);
			FBLD B 1;
			FBLD C 1 A_SpawnItem(trail,0,0,0,1);
			FBLD C 1;
			FBLD C 1 A_SpawnItem(trail,0,0,0,1);
			FBLD C 1;
			FBLD D 1 A_SpawnItem(trail,0,0,0,1);
			FBLD D 1;
			FBLD D 1 A_SpawnItem(trail,0,0,0,1);
			FBLD D 1;
			loop;
		Crash:
			TNT1 A 1 A_SpawnItem(spot,0,0,0,1);
			Stop;
	}
}

class NashGore_FlyingBloodTrail : actor {
	
	default {
		
		Scale 0.70;
		Mass 1;
		
		+LOWGRAVITY;
		+NOTELEPORT;
		+NOBLOCKMAP;
	}
	
	states {
		
		Spawn:
			BTRL A 4;
			BTRL B 4;
			BTRL C 4;
			BTRL D 4;
			Stop;
	}
}

class NashGore_BloodSpot : actor {
	
	default {
		
		Radius 12;
		Height 2;
		Mass 1;
		
		+NOTELEPORT;
		-NOBLOCKMAP;
	}
	
	states {
		
		Spawn:
			TNT1 A 0;
			TNT1 A 0 A_PlaySound("bloodsplat");
			TNT1 A 0 A_Jump(64,4);
			TNT1 A 0 A_Jump(128,54);
			TNT1 A 0 A_Jump(192,104);
			TNT1 A 0 A_Jump(255,154);
			// make the blood spots stay on the ground. 1500 is the default duration.
			// Fadeout added by Zero Prophet for effect.
			BSPT A 1500;
			BSPT AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 A_FadeOut(0.02);
			Stop;
			BSPT B 1500;
			BSPT BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 1 A_FadeOut(0.02);
			Stop;
			BSPT C 1500;
			BSPT CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC 1 A_FadeOut(0.02);
			Stop;
			BSPT D 1500;
			BSPT DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD 1 A_FadeOut(0.02);
			Stop;
	}
}