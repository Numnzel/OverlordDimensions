class smallhealthorb : orb {

	default {

		orb.total 10;
		orb.resourceName "health";
		orb.resourceClass "health";
		orb.resourcemaxClass "fakemaxhealth";
		orb.sfxClass "smallhealthorbsfx";
		orb.sfxSpeedMin 0.6;
		orb.sfxSpeedMax 0.8;
		orb.isHealth true;
		alpha 0.7;
		scale 0.08;
	}

	states {
		spawn:
			HEAL A 0;
			goto Super::Spawn;
	}
}

class smallhealthorbsfx : orbsfx {

	default {

		orbsfx.sfxSpeedFade 0.01;
		alpha 0.4;
	}

	states {
		spawn:
			HEAL C 0;
			goto Super::Spawn;
	}
}