class momonga : PlayerPawn {

	Class<Inventory> cooldown;

	default {
		
		health 300;
		player.maxhealth 300;
		mass 500;
		player.DisplayName "momonga";
		player.ViewHeight 56;
		player.AirCapacity 0;
		player.FallingScreamSpeed 100.0,110.0;
		player.ForwardMove 1, 0.6;
		player.SideMove 1, 0.6;
		
		Player.WeaponSlot 1, "spookyspell", "spookymelee", "spellkeyone";
		Player.WeaponSlot 2, "spellkeytwo";
		Player.WeaponSlot 3, "spellkeythree";
		Player.WeaponSlot 4, "spellkeyfour";
		Player.WeaponSlot 5, "spellkeyfive";
		Player.WeaponSlot 6, "spellkeysix";
		Player.WeaponSlot 7, "spellkeyseven";
		Player.WeaponSlot 8, "spellkeyeight";
		Player.WeaponSlot 9, "spellkeynine";
		Player.WeaponSlot 0, "spellkeyzero";
		
		Player.StartItem "mana", 300;
		Player.StartItem "maxmana", 600;
		Player.StartItem "spookymelee", 1;
		Player.StartItem "spellid", 0;
		
		damagefactor "Fire", 1.0; // His divine gear gives him fire immunity.
		damagefactor "Holy", 2.0;
		damagefactor "Poison", 0.0;
		damagefactor "PoisonCloud", 0.0;
		damagefactor "Bio", 0.0;
		damagefactor "Death", 0.0;
		damagefactor "Drowning", 0.0;
		damagefactor "RealitySlash", 0.0;
		damagefactor "Radiation", 1.0;
		damagefactor "Dark", 0.0;
		damagefactor 0.1;
		painthreshold 10;
		
		+NOBLOOD;
		+DONTDRAIN;
		+NOTELEFRAG;
		+NOICEDEATH;
		+DONTGIB;
		+PLAYERPAWN.NOTHRUSTWHENINVUL;
	}

	override void Tick() {
		
		super.Tick();

		if (self.bCORPSE) {

			A_GiveInventory("playerdied", 1);
		}
		else if (self.getAge() % 70 == 0) {
			
			RegenerateMana();

			switch(random(1,9)) {
				case 1:
					A_GiveInventory("playerleft1", 1);
					A_GiveInventory("playerleft2", 1);
					break;
				case 2:
					A_GiveInventory("playerright1", 1);
					A_GiveInventory("playerright2", 1);
					break;
				case 3:
					A_GiveInventory("playeranim1", 1);
					A_GiveInventory("playeranim2", 1);
			}
		}
	}
	
	override void CheckFOV() {
		return;
	}
	
	action void RegenerateMana() {
		
		if (self.CountInv("mana") < self.CountInv("maxmana"))
			A_GiveInventory("manaunit", 1);
	}
	
	states {
		
		Spawn:
			#### # 1;
			loop;
		See:
			#### # 1;
			loop;
		Missile:
			#### # 1 A_GiveInventory("playerspell", 1);
			goto Spawn;
		Melee:
			#### # 1 A_GiveInventory("playerspell", 1);
			goto Spawn;
		Pain:
			#### # 0 A_GiveInventory("playerpain", 1);
			#### # 1 A_Pain();
			goto Spawn;
		Death:
			#### # 0 A_PlayerScream();
			#### # 1 A_NoBlocking();
			#### # -1;
			stop;
	}
}