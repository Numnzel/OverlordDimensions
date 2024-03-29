class manaorb : smallmanaorb {

	default {

		orb.total 200;
		orb.sfxClass "manaorbsfx";
		orb.sfxSpeedMin 0.5;
		orb.sfxSpeedMax 1.5;
		alpha 0.7;
		scale 0.1;
		radius 20;
	}
}

class manaorbsfx : orbsfx {

	default {

		orbsfx.sfxSpeedFade 0.026;
		alpha 0.9;
	}

	states {
		spawn:
			MANA B 0 NoDelay A_SetScale(frandom(0.1,0.2));
			goto Super::Spawn;
	}
}