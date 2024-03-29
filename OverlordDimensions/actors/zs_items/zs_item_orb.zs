class orb : CustomInventory abstract {

	bool isHP;
	int diff;
	int pile;
	int piledefault;
	int sinoffs;
	double sfxSpdMin;
	double sfxSpdMax;
	string resource;
	string resourcemax;
	string sfx;
	string resourcetxt;

	property isHealth: isHP;
	property total: pile;
	property resourceClass: resource;
	property resourcemaxClass: resourcemax;
	property resourceName: resourcetxt;
	property sfxClass: sfx;
	property sfxSpeedMin: sfxSpdMin;
	property sfxspeedMax: sfxSpdMax;

	default {

		orb.total 1;
		orb.sfxSpeedMin 0.5;
		orb.sfxSpeedMax 1.5;
		orb.isHealth false;

		height 20;
		radius 16;
		renderstyle "Add";
		alpha 0.7;
		scale 0.1;

		+NOSPRITESHADOW;
		+FORCEXYBILLBOARD;
		+BRIGHT;

		+NOGRAVITY;
	}

	override bool TryPickup (in out Actor toucher) {

		if (!toucher)
			return false;
		
		if (isHP) {
			class<PlayerPawn> pl = toucher.getClassName();
			diff = min(pile, PlayerPawn(GetDefaultByType(pl)).maxhealth - toucher.health);
		}
		else
			diff = min(pile, toucher.CountInv(resourcemax) - toucher.CountInv(resource));

		if (diff > 0 && pile > 0) {
			
			toucher.GiveInventory(resource, diff);
			pile -= diff;
			
			return true;
		}
		
		if (pile == 0)
			setState(null);
		
		return false;
	}

	override String PickupMessage () {

		if (diff > 0) {

			String message = "Took " .. string.Format("%d", diff) .. " from a " .. resourcetxt .. " orb.";
			return message;
		}

		return Super.PickupMessage();
	}

	override void Tick () {
		
		if (getAge() == 0) {
			sinoffs = random(1,360);
			piledefault = pile;
		}

		// Z Bobbing
		if (!Level.IsFrozen())
			SetZ(floorz + height + (height/2 * sin(sinoffs + getAge()*3)));

		super.Tick();
	}

	states {
		spawn:
			#### # 0;
			#### # 0 A_SpawnItemEx(invoker.sfx, 0, 0, 0, frandom(invoker.sfxSpdMin,invoker.sfxSpdMax), 0, frandom(-invoker.sfxSpdMax,invoker.sfxSpdMax), random(1, 360));
			#### # 0 A_SetTics(ceil(10.1-(10.0*(1.0*invoker.pile/invoker.piledefault))));
			loop;
		pickup:
			TNT1 A 0;
			stop;
	}
}

class orbsfx : Actor abstract {

	double sfxFade;

	property sfxSpeedFade: sfxFade;

	default {

		orbsfx.sfxSpeedFade 0.05;

		RenderStyle "Add";
		alpha 0.9;
		scale 0.1;

		+NOSPRITESHADOW;
		+FORCEXYBILLBOARD;
		+NOTONAUTOMAP;
		+DONTSPLASH;

		+NOGRAVITY;
		+NOCLIP;
	}

	states {
		spawn:
			#### # 0;
			#### # 0 A_SetSpriteRotation(frandom(0.0,360.0), AAPTR_DEFAULT);
			#### # 1 A_FadeOut(invoker.sfxFade);
			wait;
	}
}