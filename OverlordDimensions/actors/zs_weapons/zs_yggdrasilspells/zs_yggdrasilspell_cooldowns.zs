class cooldownTimer : Powerup abstract {
	
	default {
		Powerup.Color "000000", 0.0;
		Powerup.Duration 0;
		
		+INVENTORY.UNDROPPABLE;
		+INVENTORY.UNTOSSABLE;
		+INVENTORY.NOSCREENFLASH;
		+INVENTORY.HUBPOWER;
		+INVENTORY.QUIET;
		+INVENTORY.NOSCREENBLINK;
	}
}

class spellkeyoneCD1 : cooldownTimer { default { Powerup.Duration -15; } }
class spellkeyoneCD2 : cooldownTimer { default { Powerup.Duration -20; } }
class spellkeyoneCD3 : cooldownTimer { default { Powerup.Duration -15; } }

class spellkeytwoCD1 : cooldownTimer { default { Powerup.Duration -15; } }
class spellkeytwoCD2 : cooldownTimer { default { Powerup.Duration -20; } }
class spellkeytwoCD3 : cooldownTimer { default { Powerup.Duration -15; } }

class spellkeythreeCD1 : cooldownTimer { default { Powerup.Duration -30; } }
class spellkeythreeCD2 : cooldownTimer { default { Powerup.Duration -60; } }
class spellkeythreeCD3 : cooldownTimer { default { Powerup.Duration -30; } }

class spellkeyfourCD1 : cooldownTimer { default { Powerup.Duration -30; } }
class spellkeyfourCD2 : cooldownTimer { default { Powerup.Duration -60; } }
class spellkeyfourCD3 : cooldownTimer { default { Powerup.Duration -30; } }

class spellkeyfiveCD1 : cooldownTimer { default { Powerup.Duration -60; } }
class spellkeyfiveCD2 : cooldownTimer { default { Powerup.Duration -90; } }
class spellkeyfiveCD3 : cooldownTimer { default { Powerup.Duration -60; } }

class spellkeysixCD1 : cooldownTimer { default { Powerup.Duration -60; } }
class spellkeysixCD2 : cooldownTimer { default { Powerup.Duration -90; } }
class spellkeysixCD3 : cooldownTimer { default { Powerup.Duration -60; } }

class spellkeysevenCD1 : cooldownTimer { default { Powerup.Duration -90; } }
class spellkeysevenCD2 : cooldownTimer { default { Powerup.Duration -120; } }
class spellkeysevenCD3 : cooldownTimer { default { Powerup.Duration -90; } }

class spellkeyeightCD1 : cooldownTimer { default { Powerup.Duration -90; } }
class spellkeyeightCD2 : cooldownTimer { default { Powerup.Duration -120; } }
class spellkeyeightCD3 : cooldownTimer { default { Powerup.Duration -90; } }

class spellkeynineCD1 : cooldownTimer { default { Powerup.Duration -90; } }
class spellkeynineCD2 : cooldownTimer { default { Powerup.Duration -60; } }
class spellkeynineCD3 : cooldownTimer { default { Powerup.Duration -90; } }

class spellkeyzeroCD1 : cooldownTimer { default { Powerup.Duration 0x7FFFFFFF; } }
class spellkeyzeroCD2 : cooldownTimer { default { Powerup.Duration 0x7FFFFFFF; } }
class spellkeyzeroCD3 : cooldownTimer { default { Powerup.Duration 0x7FFFFFFF; } }