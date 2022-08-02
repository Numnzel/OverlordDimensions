class spellkey : weapon abstract {

	meta int SpellOneId;
	meta int SpellTwoId;
	meta int SpellThreeId;
	
	property SpellOne: SpellOneId;
	property SpellTwo: SpellTwoId;
	property SpellThree: SpellThreeId;
	
	default {
		
		weapon.ammouse 0;
		weapon.ammotype "mana";
		weapon.upsound "HUD/Select";
		
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NO_AUTO_SWITCH;
		+WEAPON.NOALERT;
		+INVENTORY.UNTOSSABLE;
		+INVENTORY.NOSCREENFLASH;
		
		spellkey.SpellOne 0;
		spellkey.SpellTwo 0;
		spellkey.SpellThree 0;
	}
	
	// This function rotates through the spell slots of the spell key.
	action void A_SetSpellSlot() {

		if (CountInv("spellid") == invoker.SpellOneId)
			A_SetInventory("spellid", invoker.SpellTwoId);
		else if (CountInv("spellid") == invoker.SpellTwoId)
			A_SetInventory("spellid", invoker.SpellThreeId);
		else
			A_SetInventory("spellid", invoker.SpellOneId);
	}
	
	states {
		
		select:
			TNT1 A 0 A_SetSpellSlot();
		fire:
		ready:
		deselect:
			TNT1 A 0 {
				A_SelectWeapon("spookyspell");
				A_SelectWeapon("spookymelee");
			}
			TNT1 A 0 A_Lower;
			wait;
		spawn:
			TNT1 A 0;
			stop;
	}
}

class spellid : inventory {
	
	default {
		inventory.Amount 1;
		inventory.MaxAmount 50;
	}
}

class magicenhancement : inventory abstract {
	
	default {
		inventory.Amount 1;
		inventory.MaxAmount 1;
	}
}

class magicatriplet : magicenhancement {}
class magicamaximize : magicenhancement {}
class magicawiden : magicenhancement {}

class magicenhancementdelay : powerup abstract {
	
	default {
		
		powerup.duration 3;
		
		+INVENTORY.AUTOACTIVATE;
		+INVENTORY.NOSCREENBLINK;
	}
}

class magicatripletdelay : magicenhancementdelay {}
class magicamaximizedelay : magicenhancementdelay {}
class magicawidendelay : magicenhancementdelay {}