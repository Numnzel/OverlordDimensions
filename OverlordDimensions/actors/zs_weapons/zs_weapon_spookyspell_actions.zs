extend class spookyspell {
	
	action void FireMagicArrows (int number = 1, int lines = 1) {
		
		for (int t = 1; t <= lines; t++)
			for (float a = -180.0; a <= 180.0; a+=(360.0/(number-1))) {
				
				double ang = a/4.0;
				double pit = 0;
				
				if (t > 1) {
					if (a > 0)
						ang -= 2;
					else if (a < 0)
						ang += 2;
					
					if (t%2 == 0)
						pit += 4;
					else
						pit -= 4;
				}
				
				if (number == 1)
					ang = 0;
				
				A_FireProjectile("magicarrow", ang, FALSE, invoker.shootY, invoker.shootZ, 0, pit);
			}
	}
	
	action int FireSuperRailgun (int raysused = 3, double vel = 80.0, int enabledrays = 0) {
		
		// - How to use the enabledrays parameter -
		
		// As arrays as properties are still unsupported, we use a 32bit int and codify the used rays in a binary form:
		
		// enabledrays = 1 ->			0000000000000000000000000000001 -> first (1) ray only
		// enabledrays = 2 ->			0000000000000000000000000000010 -> second (2) ray only
		// enabledrays = 3 ->			0000000000000000000000000000011 -> first (1) and second (2) ray only
		// enabledrays = 4 ->			0000000000000000000000000000100 -> third (3) ray only
		// enabledrays = 16 ->			0000000000000000000000000010000 -> fifth (5) ray only
		// enabledrays = 256 ->			0000000000000000000000100000000 -> ninth (9) ray only
		// enabledrays = 32768 ->		0000000000000001000000000000000 -> sixtenth (16) ray only
		// enabledrays = 65535 ->		0000000000000001111111111111111 -> sixten (16) rays enabled
		// enabledrays = 2147483647 ->	1111111111111111111111111111111 -> all (31) rays enabled
		
		// The last bit stores the sign, so we can't use it.
		// You can specify a larger number of rays, (up to 128) though they will be enabled by default.
		
		
		int particles = round(vel*0.95);
		actor dragon;
		bool unused;
		
		for (int i = 0; i < particles+(vel*0.0375); i++) {
			
			double crosshairz = cos(pitch)*50.0;
			double aimingskyz = -sin(pitch)*(90.0-i);
			double frontoffsx = cos(pitch)*(80.0-i);
			
			[unused, dragon] = A_SpawnItemEx("magicchaindragonlightning", frontoffsx, invoker.shootY, aimingskyz+crosshairz, cos(pitch)*vel, 0, -sin(pitch)*vel, 0);
			
			if (dragon) {
				
				// args doesn't accept doubles, so we will use integers instead.
				
				dragon.args[0] = i; // Pass iteration phase
				dragon.args[1] = (i == 0) ? 1 : 0; // Pass 1 to also summon head actor
				dragon.args[2] = raysused; // Pass used rays
				dragon.args[3] = vel; // Pass speed
				dragon.args[4] = (enabledrays == 0) ? 2147483647 : enabledrays;
			}
		}
		
		if (dragon)
			return 1;
		
		return 0;
	}
}