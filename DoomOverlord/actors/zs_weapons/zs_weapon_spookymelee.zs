class spookymelee : momongaweapon {
	
	default {
	
		weapon.slotnumber 1;
		weapon.ammouse 0;
		weapon.kickBack 150;
		
		+WEAPON.MELEEWEAPON;
		+WEAPON.AXEBLOOD;
	}
	
	states {

		enteranimation:
			AINZ B 1 A_AnimationMove(20, (80.0, 0.0), false, (0.0, 120.0));
			AINZ B 0 A_JumpIfInventory("doinganimation", 1, "enteranimation");
			goto prepared;
		exitanimation:
			AINZ B 1 A_AnimationMove(20, (0.0, 120.0));
			AINZ B 0 A_JumpIfInventory("doinganimation", 1, "exitanimation");
			goto deselect+1;
		select:
			AINZ B 0 A_TakeInventory("spookyspell");
		ready:
			AINZ B 0 A_JumpIfInventory("makeanimation", 1, "enteranimation");
		prepared:
			AINZ B 0 A_TakeInventory("doinganimation");
			AINZ B 0 A_TakeInventory("makeanimation");
			AINZ B 1 A_WeaponReady(WRF_ALLOWRELOAD);
			wait;
		deselect:
			AINZ B 0 A_JumpIfInventory("makeanimation", 1, "exitanimation");
			AINZ B 0 A_Lower;
			wait;
		fire:
			AINZ BBBB 1 A_AnimationMove(4, (2.0, -6.0), true);
			AINZ CCCC 1 A_AnimationMove(4, (6.0, -7.0), true);
			AINZ DDDDDDDDD 1 A_AnimationMove(9, (1.0, -1.0), true);
			AINZ EE 1 A_AnimationMove(2, (-34.0, 25.0), true);
			TNT1 A 0 A_CustomPunch(random(40,110), TRUE, 0, "BulletPuff", 80, 0);
			AINZ FF 1 A_AnimationMove(2, (-180.0, 70.0), true);
			AINZ FFFF 1 A_AnimationMove(4, (0, 0), true);
			TNT1 AA 0 A_AnimationSet((80.0, 0.0));
			goto ready;
		reload:
			AINZ B 0 {
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
				A_SelectWeapon("spookyspell");
			}
			goto deselect;
	}
}
