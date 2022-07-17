class healthspeck : speck {

	default {

		speck.resourceClass "healthspeckbonus";
		speck.resourceName "Health";
		speck.resourceAmount 2;
		speck.searchRadius 256;
		speck.isHealth true;
		scale 0.08;
	}

	states {
		spawn:
			HEAL A 0;
			goto Super::Spawn;
	}
}

class healthspeckbonus : health {

	default {
		inventory.amount 1;
		inventory.maxamount 10000;
	}
}