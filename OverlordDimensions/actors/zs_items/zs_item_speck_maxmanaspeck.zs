class maxmanaspeck : speck {

	default {

		speck.resourceClass "maxmana";
		speck.resourceName "Max mana";
		speck.resourceAmount 1;
		speck.searchRadius 1024;
		scale 0.08;
	}

	states {
		spawn:
			MANA M 0;
			goto Super::Spawn;
	}
}

class maxmanaspeckdropped : actor {

	default {

		gravity 0.1;
		height 8;
		radius 4;
		renderstyle "Add";
		alpha 1.0;
		scale 0.1;

		+NOSPRITESHADOW;
		+FORCEXYBILLBOARD;
		+BRIGHT;

		+CORPSE;
		+NOBLOCKMONST;
	}

	states {
		spawn:
			MANA MMMMMMMMMM 3 { speed /= 2; }
		crash:
		death:
			TNT1 A 0 A_SpawnItemEx("maxmanaspeck", 0, 0, 0, 0, 0, 0, 0);
			stop;
	}
}

class maxmanaspeckdrop : inventory {

	override void OwnerDied () {

		super.OwnerDied();

		int n = 1;

		if (owner.GetSpawnHealth() >= 180) n *= 2; // Tier 2 enemies
		if (owner.GetSpawnHealth() >= 640) n *= 2; // Tier 3 enemies
		if (owner.GetSpawnHealth() >= 1500) n *= 2; // Tier 4 enemies
		if (owner.GetSpawnHealth() >= 5500) n *= 2; // Tier X enemies

		while (n-- > 0)
			owner.A_SpawnItemEx("maxmanaspeckdropped", 0, 0, owner.height/2, frandom(1.0,4.0), 0, frandom(0.0,1.0), random(1,360));
	}

	default {

		inventory.amount 1;
		inventory.maxAmount 1;
	}
}