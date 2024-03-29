class magic_greaterteleportation : actor {
	
	bool unused;
	actor result;
	
	default {
		
		radius 18;
		height 56;
		
		+NOGRAVITY;
	}
	
	states {
		spawn:
			TNT1 A 1 NoDelay {
				
				if (!master)
					SetState(null);
				
				angle = master.angle;
				
				[unused, result] = A_SpawnItemEx("magic_greaterteleportation_beacon", cos(angle)*-64.0, sin(angle)*-64.0, 0, 0, 0, 0, angle );
				
				if (result) {
					master.Teleport( ((result.pos.x, result.pos.y), result.pos.z), angle, 4 ); // flag 4 disables camera lock
					master.angle -= -180;
					master.pitch = -master.pitch;
				}
			}
			stop;
	}
}

class magic_greaterteleportation_beacon : magic_greaterteleportation {
	
	default {
		
		+SOLID;
		+ISMONSTER;
	}
	
	states {
		spawn:
			TNT1 A 1;
			stop;
	}
}