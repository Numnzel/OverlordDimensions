class smallmanaorb : orb {

	default {

		orb.total 50;
		orb.resourceName "mana";
		orb.resourceClass "mana";
		orb.resourcemaxClass "maxmana";
		orb.sfxClass "smallmanaorbsfx";
		orb.sfxSpeedMin 0.5;
		orb.sfxSpeedMax 1.5;
		alpha 0.7;
		scale 0.08;
	}

	states {
		spawn:
			MANA A 0;
			goto Super::Spawn;
	}
}

class smallmanaorbsfx : orbsfx {

	default {

		orbsfx.sfxSpeedFade 0.05;
		alpha 0.9;
	}

	states {
		spawn:
			MANA C 0;
			goto Super::Spawn;
	}
}