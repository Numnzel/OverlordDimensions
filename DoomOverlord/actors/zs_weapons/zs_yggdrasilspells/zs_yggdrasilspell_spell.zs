class yggdrasilspell : weapon abstract {

	meta int SpellOneMana;
	meta int SpellTwoMana;
	meta int SpellThreeMana;
	meta Class<Inventory> SpellOneCooldown;
	meta Class<Inventory> SpellTwoCooldown;
	meta Class<Inventory> SpellThreeCooldown;
	
	property SpellOne: SpellOneMana;
	property SpellTwo: SpellTwoMana;
	property SpellThree: SpellThreeMana;
	property SpellOneCD: SpellOneCooldown;
	property SpellTwoCD: SpellTwoCooldown;
	property SpellThreeCD: SpellThreeCooldown;
	
	default {
		
		weapon.ammouse 0;
		weapon.ammotype "mana";
		weapon.upsound "HUD/Select";
		
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NO_AUTO_SWITCH;
		+WEAPON.NOALERT;
		+INVENTORY.UNTOSSABLE;
		+INVENTORY.NOSCREENFLASH;
		
		yggdrasilspell.SpellOne 0;
		yggdrasilspell.SpellTwo 0;
		yggdrasilspell.SpellThree 0;
		yggdrasilspell.SpellOneCD "";
		yggdrasilspell.SpellTwoCD "";
		yggdrasilspell.SpellThreeCD "";
	}
	
	action void SetManaCost() {
		// This function rotates through the spells of the spell slot and stores the selected spell cooldown.
		// Every spell (weapon) sends its linked cooldown powerup class to the player(owner), so the main
		// spell weapon reads it and knows the correct cooldown powerup to give.
		let ownr = momonga(invoker.owner);
		if (ownr) {
			
			if (CountInv("spellid") == invoker.SpellOneMana) {
				A_SetInventory("spellid", invoker.SpellTwoMana);
				ownr.cooldown = invoker.SpellTwoCooldown;
				
			} else if (CountInv("spellid") == invoker.SpellTwoMana) {
				A_SetInventory("spellid", invoker.SpellThreeMana);
				ownr.cooldown = invoker.SpellThreeCooldown;
				
			} else {
				A_SetInventory("spellid", invoker.SpellOneMana);
				ownr.cooldown = invoker.SpellOneCooldown;
			}
		}
	}
	
	states {
	
		ready:
			TNT1 A 0;
			goto deselect;
		select:
			TNT1 A 0 SetManaCost();
			goto deselect;
		fire:
			TNT1 A 0;
			goto deselect;
		deselect:
			TNT1 A 0 {
				A_SelectWeapon("spookyspell");
				A_SelectWeapon("spookymelee");
			}
		deselectloop:
			TNT1 A 0 A_Lower;
			loop;
		spawn:
			TNT1 A 0;
			stop;
	}
}

class spellid : inventory {
	
	default {
		inventory.Amount 1;
		inventory.MaxAmount 10050;
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