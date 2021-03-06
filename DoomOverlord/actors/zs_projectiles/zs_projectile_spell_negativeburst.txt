
class magicnegativeburst : Actor {
	
	default {
		
		Scale 1.0;
		Radius 2;
		Height 4;
		RenderStyle "Stencil";
		StencilColor "Black";
		
		+NOTRIGGER;
		+NOTELEPORT;
		+NOTELESTOMP;
		+NOGRAVITY;
		+DONTTHRUST;
		+NOCLIP;
	}
	
	States {
		
		Spawn:
			MODL A 0 NoDelay; //A_StartSound("Spell/BlackHole");
			MODL A 1 {
				
				if(scale.x < 30.0)
					A_SetScale(scale.x*1.25);
				
				A_FadeOut(0.013);
			}
			wait;
		Death:
			TNT1 A 0;
			Stop;
	}
}

class magicnegativeburstexplosion : magicnegativeburst {
	
	States {
		
		Spawn:
			TNT1 AAA 8 NoDelay {
				
				int hits = A_Explode(510, 800, XF_THRUSTZ, 0, 64, 0, 0, "", "negative");
				
				if (hits > 0) {}
					A_DamageMaster(max(-33, -3*hits), "negative", DMSS_FOILINVUL);
			}
			stop;
	}
}