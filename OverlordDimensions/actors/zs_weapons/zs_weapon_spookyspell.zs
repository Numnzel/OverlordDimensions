class spookyspell : momongaweapon {
	
	StateLabel jumpstat;
	spell selectedSpell;
	mixin SpellPropertiesList;
	
	default {
		
		weapon.slotnumber 1;
		weapon.ammouse 0;
		weapon.ammotype "mana";
	}

	override void PostBeginPlay () {

		super.PostBeginPlay();

		setSpellProperties();
	}

	override void Tick () {

		super.Tick();

		// Update current spell data.
		getSpellProperties(CountInv("spellid"), selectedSpell);
	}
	
	action bool A_CheckSpellConditions (int spellid) {

		// If spell is not selected, or not enough mana, or it is on CD, return to ready.
		if (!invoker || spellid == 0 || CountInv("mana") < invoker.selectedSpell.mana || CountInv(invoker.selectedSpell.cd) > 0)
			return false;

		//yggdrasilSpell currentSpell;
		//yggdrasilSpells(invoker.FindInventory("yggdrasilSpells")).getSpellInfo("SpellArrow", currentSpell);

		invoker.jumpstat = invoker.selectedSpell.state;

		return true;
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
			//TNT1 A 1 A_AnimationMove(20, (80.0, 0.0), false, (0.0, 120.0));
			//TNT1 A 0 A_JumpIfInventory("doinganimation", 1, "enteranimation");
			goto prepared;
		exitanimation:
			//TNT1 A 1 A_AnimationMove(20, (0.0, 120.0));
			//HRSB B 0 A_JumpIfInventory("doinganimation", 1, "exitanimation");
			goto deselect+1;
		select:
			TNT1 A 0 A_TakeInventory("spookymelee");
		ready:
			//TNT1 A 0 A_JumpIfInventory("makeanimation", 1, "enteranimation");
		prepared:
			TNT1 A 0 A_TakeInventory("makeanimation");
			TNT1 A 1 A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER1|WRF_ALLOWUSER2|WRF_ALLOWUSER3);
			wait;
		deselect:
			//TNT1 A 0 A_JumpIfInventory("makeanimation", 1, "exitanimation");
			TNT1 A 0 A_Lower;
			wait;
		fire:
			// Check current spell conditions.
			TNT1 A 0 A_JumpIf(!A_CheckSpellConditions(CountInv("spellid")), "ready");
			// Take mana, apply (give) cooldown and jump to fire state. // TODO: This should be moved, is the spell code that has to check when to take mana and apply CD.
			TNT1 A 0 {
				A_GiveInventory(invoker.selectedSpell.cd);
				A_TakeInventory("mana", invoker.selectedSpell.mana);
			}
			TNT1 A 0 A_Jump(255, invoker.selectedSpell.astate);
		reload:
			TNT1 A 0 {
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
			TNT1 A 0 A_SwitchEnhancement("magicatriplet", "magicatripletdelay");
			goto prepared+1;
		user2:
			TNT1 A 0 A_SwitchEnhancement("magicamaximize", "magicamaximizedelay");
			goto prepared+1;
		user3:
			TNT1 A 0 A_SwitchEnhancement("magicawiden", "magicawidendelay");
			goto prepared+1;
	}
}