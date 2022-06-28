class speck : inventory abstract {

	private bool space;
	bool isHP;
	int search;
	int amount;
	int sinoffs;
	string resource;
	string resourcetxt;

	property isHealth: isHP;
	property searchRadius: search;
	property resourceClass: resource;
	property resourceName: resourcetxt;
	property resourceAmount: amount;

	override String PickupMessage () {
		
		String message = resourcetxt .. " increased.";

		return message;
	}

	override void Tick () {

		Super.Tick();

		if (!bSPECIAL)
			return;
		
		// Z Bobbing
		if (getAge() == 0)
			sinoffs = random(1,360);

		// Acquire a target, and then check if it has space
		if (target)
			space = CheckSpace(target, resource, isHP);
		else if (getAge() % 15 == 0)
			CheckProximity("momonga", search, 1, CPXF_SETTARGET);
		
		// If it has space, move to it, else do not move
		if (space) {

			double dist = Distance3D(target);

			if (dist <= 24.0) {
				PickInventory(target, self.getClassName(), amount);
				SetState(null);
			}
			else {
				A_FaceTarget();
				VelFromAngle(speed*50/(dist+128.0));
				Vel.Z = (target.pos.Z + target.Height/3 - pos.Z) / DistanceBySpeed(target, 5.0);
			}
		}
		else {
			A_Stop();

			// Z Bobbing
			if (!Level.IsFrozen())
				SetZ(floorz + height + (height/2 * sin(sinoffs + getAge()*3)));
		}
	}
	
	override bool TryPickup (in out Actor toucher) {

		if (!space)
			return false;
		
		toucher.GiveInventory(resource, amount);
		
		return true;
	}

	bool CheckSpace (Actor destOwner, string itemClass, bool isHP = false) {

		if (!destOwner || !itemClass)
			return false;
		
		class<Actor> cls = itemClass;

		if (!cls)
			return false;

		int maxam = Inventory(GetDefaultByType(cls)).maxamount;
		int count = isHP ? destOwner.health : destOwner.CountInv(itemClass);

		if (count < maxam)
			return true;

		return false;
	}

	void PickInventory (Actor destOwner, class<Inventory> itemClass, int amount = 1) {

		if (!destOwner || !itemClass)
			return;
		
		self.Touch(destOwner);

		if (self.bSPECIAL) // SPECIAL not cleared -> item could not be picked.
			self.Destroy();
	}

	default {

		speck.searchRadius 1024;
		speck.resourceAmount 1;
		inventory.maxamount 0;

		height 20;
		radius 4;
		renderstyle "Add";
		alpha 1.0;
		scale 0.1;
		speed 120;

		+NOSPRITESHADOW;
		+FORCEXYBILLBOARD;
		+BRIGHT;

		+NOGRAVITY;
		+NOBLOCKMONST;
	}

	states {
		spawn:
			#### # 1;
			loop;
	}
}