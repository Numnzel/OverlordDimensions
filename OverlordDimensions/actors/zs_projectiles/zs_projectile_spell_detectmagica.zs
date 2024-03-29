class magicdoorghost : Actor {
	
	default {
		Health 60;
		Radius 2;
		Height 8;
		Speed 20;
		Monster;
		+THRUACTORS;
		+MISSILE;
		+NOGRAVITY;
		-FRIENDLY;
		+FRIGHTENED;
		+LOOKALLAROUND;
	}
	
	States
	{
		Spawn:
			TNT1 A 1 A_Look;
			Loop;
		See:
			TNT1 AAAAAAAAA 1 A_Chase;
		Death:
			TNT1 A 0;
			Stop;
	}
}

class magicdetectmagica : doomimpball {
	
	default {
		RenderStyle "Add";
		Alpha 0.95;
		Speed 8;
		Scale 0.15;
		+RANDOMIZE;
		+FLOORHUGGER;
		+STEPMISSILE;
		+BRIGHT;
	}
	
	states {
		Spawn:
			DMAG ABCDEFGHIJKLMNOPQRST 2 A_FadeOut(0.01);
			loop;
		death:
			TNT1 A 0 A_SpawnItemEx("magicdoorghost", 0, 0, 0, 0, 0, 0, 180, SXF_NOPOINTERS);
			stop;
	}
}
