class magicbodyofrefulgentberyleffect : PowerInvulnerable {

	default {
		
		powerup.duration -5;
		powerup.color "GoldMap";//"FFAA00";
		+INVENTORY.NOSCREENBLINK;
	}
	
	override void DoEffect() {
		
		owner.bGhost = TRUE;
		owner.bThruactors = TRUE;
		owner.A_SetRenderStyle(owner.alpha, STYLE_Add);
		owner.A_FadeTo(0.05,0.11);
	}
}

class magicbodyofrefulgentberylexit : Powerup {

	default {
		
		powerup.duration 0x7FFFFFFD;
		powerup.color "FFD700", 0.2;
		+INVENTORY.NOSCREENBLINK;
	}
	
	override void DoEffect() {
		
		if(!CheckInventory("magicbodyofrefulgentberyleffect", 1)) {
			
			owner.bGhost = FALSE;
			
			if(A_SpawnItemEx("magicbodyofrefulgentberylcheck", owner.x, owner.y, owner.z, 0.0, 0.0, 0.0, 0, SXF_ABSOLUTEPOSITION, 0) || owner.bThruactors == FALSE) {
				
				owner.bThruactors = FALSE;
				
				if (owner.alpha >= 1.0) {
					
					owner.A_SetRenderStyle(1.0, STYLE_Normal); // TODO: Test: owner.RestoreRenderStyle();
					owner.A_TakeInventory("magicbodyofrefulgentberylexit");
					return;
					
				} else {
					
					owner.A_FadeTo(1.0,0.11);
				}
				
			} else {
				
				owner.A_FadeTo(0.5,0.11);
				owner.A_TakeInventory("mana", 1);
			}
		}
	}
	
	/* // If this override is enabled, then the DoEffect one doesn't work! (?)
	override void AttachToOwner(Actor user) {
		
		return;
	}
	*/
}

class magicbodyofrefulgentberyl : CustomInventory {

	states {
		
		spawn:
			TNT1 A -1;
		pickup:
			TNT1 A 0 A_GiveInventory("magicbodyofrefulgentberyleffect", 1);
			TNT1 A 0 A_GiveInventory("magicbodyofrefulgentberylexit", 1);
			TNT1 A 0;
			stop;
	}
}

class magicbodyofrefulgentberylcheck : actor {

	default {
		
		radius 16;
		height 56;
		
		+BLOCKEDBYSOLIDACTORS;
		+ISMONSTER; // This flag ensures that the check for position is performed.
	}
	
	states {
		
		spawn:
		death:
			TNT1 A 3;
			stop;
	}

}