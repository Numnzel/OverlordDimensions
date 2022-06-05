class magicwallofskeleton : actor {
	
	Actor child;
	bool unused;
	
	default {
		
		height 64;
		radius 16;
		speed 60;
		
		PROJECTILE;
		//+RELATIVETOFLOOR;
		//+MOVEWITHSECTOR;
	}
	
	states {
		
		spawn:
			TNT1 A 8;
		death:
			TNT1 A 0 {
				for(int i = 0; i < 16; i++) {
					[unused, child] = A_SpawnItemEx("magicwallofskeletonpole", 0, (radius*i-(radius*8))*1, -32-(pos.z-floorz), 0.0, 0.0, 0, 0, SXF_NOCHECKPOSITION|SXF_ABSOLUTEVELOCITY);
					child.pitch = frandom(2.0,4.0);
				}
			}
			stop;
	}
}

class magicwallofskeletonpole : actor {
	
	double zght;
	double zspd;
	bool smms;
	
	property zheight: zght;
	property zspeed: zspd;
	property summons: smms;
	
	Actor child;
	bool unused;
	int iterations;
	
	default {
		
		magicwallofskeletonpole.zheight 0;
		magicwallofskeletonpole.zspeed 1.0;
		magicwallofskeletonpole.summons true;
		
		health 1000;
		height 64;
		radius 16;
		
		+SOLID;
		+SHOOTABLE;
		+NOGRAVITY;
		+DONTTHRUST;
		+FRIENDLY;
		+NOBLOOD;
		//+NOEXPLODEFLOOR;
		//+MISSILE;
	}
	
	states {
		
		spawn:
			TNT1 A 0 NoDelay {
				invoker.zspd = pitch; // Pitch is unused, so here works for transfering the speed to the childs.
				iterations = 4;
			}
			goto spawn2+1;
		halt:
			POL2 A 0 {
				
				if (invoker.zspd > 0) {
					invoker.zspd = 0;
					if (child) child.SetStateLabel("halt");
				}
			}
		spawn2:
			POL2 A 1 A_DamageSelf(3);
			POL2 A 0 {
				
				if(health%105 == 0.0)
					A_Explode(40, 80, XF_NOSPLASH, FALSE, 0, 0, 0, "", "");
				
				if (invoker.zght >= (height*iterations)-invoker.zspd)
					SetStateLabel("halt");
				
				invoker.zght += invoker.zspd;
				
				if (pos.z - floorz <= 0) // While actor is submerged, the Z is always 0, so we need to accelerate externally (zght). (Also, the engine tries constantly to put the actor above ground...)
					SetZ(pos.z+invoker.zght-height);
				else
					AddZ(invoker.zspd);
			}
			POL2 A 0 A_CheckCeiling("halt");
			POL2 A 0 {
				
				if (invoker.zght >= height+invoker.zspd && invoker.smms) {
					invoker.smms = false;
					if (!child)
						[unused, child] = A_SpawnItemEx("magicwallofskeletonpole", 0.0, 0.0, pos.z-height, 0.0, 0.0, 0.0, 0, SXF_NOCHECKPOSITION|SXF_SETMASTER|SXF_TRANSFERPITCH);
				}
			}
			loop;
		death:
			TNT1 A 0 A_KillChildren;
			TNT1 A 0 A_KillMaster;
			stop;
	}
}