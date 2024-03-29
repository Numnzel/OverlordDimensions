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
		+NOBLOCKMAP;
	}
	
	States {
		
		Spawn:
			MODL A 0 NoDelay; //A_StartSound("Spell/BlackHole");
			MODL A 1 {
				
				if (scale.x < 30.0)
					A_SetScale(scale.x*1.25);
				
				class<Inventory> pow = (master && master.CountInv("magicamaximize") > 0) ? "negativexplosionmax" : "negativexplosion";

				A_RadiusGive(pow, 15.0*scale.x, RGF_MONSTERS);
				A_FadeOut(alpha*0.9);//A_FadeOut(0.013);
			}
			wait;
		Death:
			TNT1 A 0;
			Stop;
	}
}

class negativexplosion : powerup {

	double powerM; property pPowerMult: powerM;

	override void InitEffect () {

		if (owner && owner.CountInv(self.getClassName()) == 0) {
			
			master = players[consoleplayer].mo;

			owner.A_DamageSelf(powerM*800, "negative", DMSS_EXFILTER, "momonga", "None", AAPTR_MASTER);
		}

		super.InitEffect();
	}

	default {

		negativexplosion.pPowerMult 1.0;

		inventory.amount 1;
		inventory.maxamount 1;
		powerup.duration 30;
		
		+INVENTORY.AUTOACTIVATE;
	}
}

class negativexplosionmax : negativexplosion {

	default {

		negativexplosion.pPowerMult 1.5;
	}
}