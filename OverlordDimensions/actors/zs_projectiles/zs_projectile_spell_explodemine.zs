class magicexplodemine : actor {

	default {
		
		radius 2;
		height 2;
		scale 0.25;
		renderstyle "Add";
		alpha 0.1;
		
		+FLATSPRITE;
		+BRIGHT;
		+VISIBILITYPULSE;

		+THRUACTORS;
		+NOBLOCKMAP;
		+MOVEWITHSECTOR;
	}

	override void PostBeginPlay () {

		SetZ(floorz);

		super.PostBeginPlay();
	}
	
	int checkMonsters (int area) {
		
		Actor monst = RoughMonsterSearch(area);
		
		if (monst && monst.bIsMonster && !monst.bFriendly && abs(monst.pos.z-self.pos.z) <= 16.0)
			return 256;
		
		return 0;
	}
	
	states {
		
		spawn:
			EXMI A 5 NoDelay A_Jump(checkMonsters(32), "death");
			loop;
		death:
			EXMI A 1 A_Explode(800, 350);
			stop;
	}
}

class magicexplodeminemax : magicexplodemine {

	default {

		translation "FadeToRed";
	}

	states {
		death:
			EXMI A 1 A_Explode(800*1.5, 350);
			stop;
	}
}

class magicexplodemineproj : actor {

	string mine; property pmine: mine;

	default {

		magicexplodemineproj.pmine "magicexplodemine";
		
		radius 40;
		height 4;
		speed 120;
	}
	
	states {
		
		spawn:
			TNT1 A 4;
			TNT1 A 0 A_SpawnItemEx(mine, 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER);
			stop;
	}

}

class magicexplodemineprojmax : magicexplodemineproj {

	default {

		magicexplodemineproj.pmine "magicexplodeminemax";
	}
}