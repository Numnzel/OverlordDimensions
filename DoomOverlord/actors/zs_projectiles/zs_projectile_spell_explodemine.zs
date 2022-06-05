
class magicexplodemine : actor {

	default {
		
		radius 2;
		height 2;
		scale 0.25;
		gravity 10000;
		renderstyle "Add";
		alpha 0.1;
		
		+FLATSPRITE;
		+BRIGHT;
		+VISIBILITYPULSE;
	}
	
	int checkMonsters(int area) {
		
		Actor monst = RoughMonsterSearch(area);
		
		if(monst != Null)
			if(monst.bIsMonster == TRUE && monst.bFriendly == FALSE)
				return 256;
		
		return 0;
	}
	
	states {
		
		spawn:
			EXMI A 0;
			EXMI A 3 A_Jump(checkMonsters(0), "death");
			loop;
		death:
			EXMI A 1 A_Explode(550, 350);
			stop;
	}
}

class magicexplodemineproj : actor {

	default {
		
		radius 40;
		height 4;
		speed 120;
		
		+THRUACTORS;
	}
	
	states {
		
		spawn:
			TNT1 A 4;
		death:
			TNT1 A 0;
			TNT1 A 0 A_SpawnItemEx("magicexplodemine", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER);
			stop;
	}

}