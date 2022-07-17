class healthorb : smallhealthorb {

	default {

		orb.total 30;
		orb.sfxClass "healthorbsfx";
		orb.sfxSpeedMin 0.6;
		orb.sfxSpeedMax 0.8;
		alpha 0.7;
		scale 0.1;
		radius 20;
	}

	states {
		spawn:
			HEAL A 0;
			goto Super::Spawn;
	}
}

class healthorbsfx : orbsfx {

	default {

		orbsfx.sfxSpeedFade 0.005;
		alpha 0.4;
	}

	states {
		spawn:
			HEAL B 0 NoDelay A_SetScale(frandom(0.1,0.2));
			goto Super::Spawn;
	}
}