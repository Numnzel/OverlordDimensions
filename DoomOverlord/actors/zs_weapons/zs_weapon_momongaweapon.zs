class momongaweapon : weapon abstract {

	int ovCounter;
	float shootZ;
	float shootY;
	float ovStartX;
	float ovStartY;
	float ovEndX;
	float ovEndY;
	vector2 ovLastPos;
	vector2 ovStartPosMem;
	vector2 ovEndPosMem;

	/* // Custom bobbing system test
	int ovSwayCounter;
	const ovSwaySpeed = 4.0;
	const ovRecenterSpeed = 0.25;
	const ovMaxSway = 24; */
	//Array<double> moveMem;

	property shootZoffs: shootZ;
	property shootYoffs: shootY;
	property overlayStartX: ovStartX;
	property overlayStartY: ovStartY;
	property overlayEndX: ovEndX;
	property overlayEndY: ovEndY;

	default {

		momongaweapon.shootZoffs 20.0; //24.0 is screen center with A_FireProjectile
		momongaweapon.shootYoffs 2.0;

		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.NOALERT;
	}

	override void doEffect () {

		super.doEffect();

		if (owner && owner.player.ReadyWeapon && owner.player.ReadyWeapon is self.getClassName() && owner.CountInv("makeanimation") == 0)
			offsetSprPosAnimationEnd();
	}

	void offsetSprPosAnimationEnd () {

		let pspr = owner.player.psprites;
		
		if (!pspr) return;

		pspr.x = ovLastPos.x;
		pspr.y = ovLastPos.y;
	}

	/* Custom bobbing system test

	// Extra conditions
	//(owner.player.WeaponState & WF_WEAPONBOBBING ||
	//owner.player.WeaponState & WF_WEAPONSWITCHOK))

	void weaponSway () {

		let pspr = owner.player.psprites;
		
		if (!pspr) return;
		
		double velocity = owner.vel.xy.length();
		double xinput = owner.GetPlayerInput(MODINPUT_SIDEMOVE);
		double yinput = owner.GetPlayerInput(MODINPUT_FORWARDMOVE);

		// reset sway direction if almost still
		if (ovSwayCounter != 0 && velocity < 0.5) {
			A_Log("RESSET");
			ovSwayCounter = 0;
		}
		
		// decide where to start sway
		if (ovSwayCounter == 0 && (xinput != 0 || yinput != 0)) {
			A_Log("MOVING");
			if (xinput > 0 || yinput > 0)
				ovSwayCounter = 5;
			else if (xinput < 0 || yinput < 0)
				ovSwayCounter = -5;
		} // or keep swaying
		else if (ovSwayCounter > 0)
			ovSwayCounter += 5;
		else if (ovSwayCounter < 0)
			ovSwayCounter -= 5;
		
		// get sway
		double swayX = velocity * 3 * sin(ovSwayCounter);
		double swayY = velocity * 1 * abs(sin(ovSwayCounter));
		
		// store older input values, needed for combo reading (currently not used)
		if (moveMem.Size() > 3)
			moveMem.Delete(0);
		
		moveMem.Push(xinput); // store in memory
		
		pspr.x = ovEndX + swayX;
		pspr.y = ovEndY + swayY;
	} */

	action bool A_AnimationMove (int duration, vector2 endPos, bool add = false, vector2 startPos = (-9999,-9999), bool reverse = false) {
		
		if (!invoker.owner && duration < 2)
			return false;
		
		if (invoker.owner.CountInv("doinganimation") == 0)
			A_GiveInventory("doinganimation", 1);

		// set initial position and duration
		if (invoker.ovCounter == 0) {
			invoker.ovCounter = duration;
			invoker.ovStartPosMem = startPos == (-9999,-9999) ? invoker.ovLastPos : startPos;
			invoker.ovEndPosMem = add ? invoker.ovStartPosMem+endPos : endPos;
		}
		
		// calculate position based on counter
		int ovCounterRel = reverse ? invoker.ovCounter : duration-invoker.ovCounter;

		double factor = ovCounterRel/double(duration-1);
		double invfactor = abs(factor-1.0);

		vector2 resultPos;
		resultPos.x = (factor*invoker.ovEndPosMem.x)+(invfactor*invoker.ovStartPosMem.x);
		resultPos.y = (factor*invoker.ovEndPosMem.y)+(invfactor*invoker.ovStartPosMem.y);
		
		// set position and check if ended
		A_AnimationSet(resultPos, true);

		if (--invoker.ovCounter == 0)
			A_TakeInventory("doinganimation");
		
		return (invoker.owner.CountInv("doinganimation") == 0);
	}

	action void A_AnimationSet (vector2 endPos, bool interpolate = false) {

		if (interpolate)
			A_WeaponOffset(endPos.x, endPos.y, WOF_INTERPOLATE);
		else
			A_WeaponOffset(endPos.x, endPos.y);
		
		invoker.ovLastPos = endPos;
	}

	states {

		spawn:
			TNT1 A 0;
			stop;
	}
}

class makeanimation : Inventory {

	default {
		inventory.Amount 1;
		inventory.MaxAmount 1;
	}
}

class doinganimation : makeanimation {}