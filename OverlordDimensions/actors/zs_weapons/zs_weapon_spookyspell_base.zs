class spookyspellbase : momongaweapon abstract {
	
	StateLabel jumpstat;
	
	default {
		
		weapon.slotnumber 1;
		weapon.ammouse 0;
		weapon.ammotype "mana";
	}
	
	action int A_CheckSpell (int spellid) {
		
		invoker.jumpstat = "ready";
		
		if (spellid == 10001 && CountInv("spellkeyzeroCD1") == 0)		invoker.jumpstat = "attackfallendown";
		else if (spellid == 1700 && CountInv("spellkeynineCD2") == 0)	invoker.jumpstat = "attackrealityslash";
		else if (spellid == 1600 && CountInv("spellkeyeightCD2") == 0)	invoker.jumpstat = "attacknuclearblast";
		else if (spellid == 1550 && CountInv("spellkeysevenCD2") == 0)	invoker.jumpstat = "attackblackhole";
		else if (spellid == 1400 && CountInv("spellkeysixCD2") == 0)	invoker.jumpstat = "attackhellflame";
		else if (spellid == 1320 && CountInv("spellkeynineCD1") == 0)	invoker.jumpstat = "attacksummonundead10th";
		else if (spellid == 1180 && CountInv("spellkeynineCD3") == 0)	invoker.jumpstat = "attacktimestop";
		else if (spellid == 1100 && CountInv("spellkeyfiveCD3") == 0)	invoker.jumpstat = "attackundeadarmy";
		else if (spellid == 1000 && CountInv("spellkeyeightCD1") == 0)	invoker.jumpstat = "attackgraspheart";
		else if (spellid == 900 && CountInv("spellkeysixCD1") == 0)		invoker.jumpstat = "attackastralsmite";
		else if (spellid == 650 && CountInv("spellkeysevenCD3") == 0)	invoker.jumpstat = "attacktruedark";
		else if (spellid == 500 && CountInv("spellkeysixCD3") == 0)		invoker.jumpstat = "attacknegativeburst";
		else if (spellid == 480 && CountInv("spellkeyfiveCD2") == 0)	invoker.jumpstat = "attackchaindragonlightning";
		else if (spellid == 400 && CountInv("spellkeyfourCD2") == 0)	invoker.jumpstat = "attackwallofskeleton";
		else if (spellid == 380 && CountInv("spellkeyeightCD3") == 0)	invoker.jumpstat = "attackbodyofrefulgentberyl";
		else if (spellid == 350 && CountInv("spellkeythreeCD2") == 0)	invoker.jumpstat = "attackexplodemine";
		else if (spellid == 250 && CountInv("spellkeyfourCD1") == 0)	invoker.jumpstat = "attackgravitymaelstrom";
		else if (spellid == 240 && CountInv("spellkeyfourCD3") == 0)	invoker.jumpstat = "attackgreaterteleportation";
		else if (spellid == 210 && CountInv("spellkeythreeCD1") == 0)	invoker.jumpstat = "attackshockwave";
		else if (spellid == 200 && CountInv("spellkeythreeCD3") == 0)	invoker.jumpstat = "attackantilifecocoon";
		else if (spellid == 130 && CountInv("spellkeytwoCD2") == 0)		invoker.jumpstat = "attacklightning";
		else if (spellid == 110 && CountInv("spellkeytwoCD1") == 0)		invoker.jumpstat = "attackfireball";
		else if (spellid == 100 && CountInv("spellkeytwoCD3") == 0)		invoker.jumpstat = "attackfly";
		else if (spellid == 20 && CountInv("spellkeyoneCD3") == 0)		invoker.jumpstat = "attacklifeessence";
		else if (spellid == 60 && CountInv("spellkeyoneCD2") == 0)		invoker.jumpstat = "attackacidarrow";
		else if (spellid == 30 && CountInv("spellkeyoneCD1") == 0)		invoker.jumpstat = "attackmagicarrow";
		else return 255;
		
		return 0;
	}

	action void A_SwitchEnhancement (string enhancement, string delay) {

		if (CountInv(delay) == 0) {

			bool count = CountInv(enhancement);

			if (count)
				A_StartSound("HUD/EnhanceOff", CHAN_AUTO);
			else
				A_StartSound("HUD/Enhance", CHAN_AUTO);

			A_SetInventory(enhancement, !count);
		}
		
		A_GiveInventory(delay, 1);
	}

	states {

		enteranimation:
			AINZ A 1 A_AnimationMove(20, (80.0, 0.0), false, (0.0, 120.0));
			AINZ A 0 A_JumpIfInventory("doinganimation", 1, "enteranimation");
			goto prepared;
		exitanimation:
			AINZ A 1 A_AnimationMove(20, (0.0, 120.0));
			AINZ B 0 A_JumpIfInventory("doinganimation", 1, "exitanimation");
			goto deselect+1;
		select:
			AINZ A 0 A_TakeInventory("spookymelee");
		ready:
			AINZ A 0 A_JumpIfInventory("makeanimation", 1, "enteranimation");
		prepared:
			AINZ A 0 A_TakeInventory("makeanimation");
			AINZ A 1 A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER1|WRF_ALLOWUSER2|WRF_ALLOWUSER3);
			wait;
		deselect:
			AINZ A 0 A_JumpIfInventory("makeanimation", 1, "exitanimation");
			AINZ A 0 A_Lower;
			wait;
		fire:
			// If the spell costs more than 10000, ignores cost.
			AINZ A 0 A_JumpIf(CountInv("spellid") > 10000, 2);
			// If not enough mana or no spell is selected, return to ready.
			AINZ A 0 A_JumpIf(CountInv("spellid") <= 0 || CountInv("mana") < CountInv("spellid"), "ready");
			// Identify current selected spell and stores the specific fire state to jump. Skip fire if there's an active cooldown.
			AINZ A 0 A_Jump(A_CheckSpell(CountInv("spellid")), "ready");
			// Everything ok at this point; Take mana, apply (give) cooldown and jump to fire state. // TODO: This should be moved, is the spell code that has to check when to take mana and apply CD.
			AINZ A 0 {
				let ownr = momonga(invoker.owner);
				if (ownr)
					A_GiveInventory(ownr.cooldown);
				if (invoker.jumpstat != "ready" && CountInv("spellid") <= 10000)
					A_TakeInventory("mana", CountInv("spellid"));
			}
			AINZ A 0 A_Jump(255, invoker.jumpstat);
			goto prepared;
		reload:
			AINZ A 0 {
				A_TakeInventory("spellkeyone");
				A_TakeInventory("spellkeytwo");
				A_TakeInventory("spellkeythree");
				A_TakeInventory("spellkeyfour");
				A_TakeInventory("spellkeyfive");
				A_TakeInventory("spellkeysix");
				A_TakeInventory("spellkeyseven");
				A_TakeInventory("spellkeyeight");
				A_TakeInventory("spellkeynine");
				A_TakeInventory("spellkeyzero");
				A_GiveInventory("makeanimation", 1);
				A_GiveInventory("spookymelee", 1);
				A_SelectWeapon("spookymelee");
			}
			goto deselect;
		user1:
			AINZ A 0 A_SwitchEnhancement("magicatriplet", "magicatripletdelay");
			goto prepared+1;
		user2:
			AINZ A 0 A_SwitchEnhancement("magicamaximize", "magicamaximizedelay");
			goto prepared+1;
		user3:
			AINZ A 0 A_SwitchEnhancement("magicawiden", "magicawidendelay");
			goto prepared+1;
	}
}