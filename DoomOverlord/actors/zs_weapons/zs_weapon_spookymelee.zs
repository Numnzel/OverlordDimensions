class spookymelee : Weapon {
	
	double SpriteOffs;
	property Number: SpriteOffs;
	
	default {
	
		weapon.slotnumber 1;
		weapon.ammouse 0;
		weapon.kickBack 150;
		
		+WEAPON.MELEEWEAPON;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.AXEBLOOD;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		
		spookymelee.Number 52.0;
	}
	states {
		
		ready:
			AINZ B 0 A_TakeInventory("makeanimation");
			AINZ B 1 A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER1|WRF_ALLOWUSER2);
			wait;
		select:
			AINZ B 0 A_JumpIfInventory("makeanimation", 1, "animatedselect");
			AINZ B 0 A_Raise;
			wait;
		animatedselect:
			AINZ B 1 A_Raise;
			loop;
		reload:
			AINZ B 1 {
				A_GiveInventory("spellkeyone", 1);
				A_GiveInventory("spellkeytwo", 1);
				A_GiveInventory("spellkeythree", 1);
				A_GiveInventory("spellkeyfour", 1);
				A_GiveInventory("spellkeyfive", 1);
				A_GiveInventory("spellkeysix", 1);
				A_GiveInventory("spellkeyseven", 1);
				A_GiveInventory("spellkeyeight", 1);
				A_GiveInventory("spellkeynine", 1);
				A_GiveInventory("spellkeyzero", 1);
				A_GiveInventory("makeanimation", 1);
				A_GiveInventory("spookyspell", 1);
				A_TakeInventory("spookymelee", 1);
			}
		deselect:
			AINZ B 0 A_Lower;
			loop;
		fire:
			AINZ BBBB 1 A_WeaponOffset(2.0,-6.0,WOF_ADD|WOF_INTERPOLATE);
			AINZ CCCC 1 A_WeaponOffset(6.0,-7.0,WOF_ADD|WOF_INTERPOLATE);
			AINZ DDDDDDDDDDDDD 1 A_WeaponOffset(1.0,-1.0,WOF_ADD|WOF_INTERPOLATE);//A_WeaponOffset(9.5,-9.1,WOF_ADD|WOF_INTERPOLATE);
			AINZ EE 1 A_WeaponOffset(-34.0,25.0,WOF_ADD|WOF_INTERPOLATE);
			AINZ F 0 A_CustomPunch(random(40,110), TRUE, 0, "BulletPuff", 80, 0);
			AINZ FFFFFFFFFFFFFFF 1 A_WeaponOffset(-45.0,35.0,WOF_ADD|WOF_INTERPOLATE);
			//AINZ FFEEDDCCBB 2 A_WeaponOffset(0.0, 0.0,WOF_INTERPOLATE);
			goto ready;
		spawn:
			PIST A -1 nodelay;
			stop;
	}
}
