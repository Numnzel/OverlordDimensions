class spookyspell : spookyspellbase {
	
	default {
		
	}
	
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
	
	
	
	states {
		
		attackmagicarrow:
			AINZ A 1 {
				
				if (CountInv("magicatriplet") > 0)
					FireMagicArrows(max(1, floor(CountInv("maxmana")/500)), 3);
				else
					FireMagicArrows(max(1, floor(CountInv("maxmana")/500)), 1);
			}
			goto ready;
		attackacidarrow:
			AINZ A 1 A_FireProjectile("magicacidarrow", 0, FALSE, invoker.shootY, invoker.shootZ);
			goto ready;
		attackfireball:
			AINZ A 1 A_JumpIfInventory("magicatriplet", 1, 2);
			AINZ A 1 A_FireProjectile("magicfireball", 0, FALSE, invoker.shootY, invoker.shootZ);
			goto ready;
			AINZ A 0 A_FireProjectile("magicfireball", 8, FALSE, invoker.shootY, invoker.shootZ);
			AINZ A 0 A_FireProjectile("magicfireball", -8, FALSE, invoker.shootY, invoker.shootZ);
			AINZ A 1 A_FireProjectile("magicfireball", 0, FALSE, invoker.shootY, invoker.shootZ);
			goto ready;
		attacklightning:
			AINZ A 0 A_Light(9);
			AINZ A 0 A_StartSound("Spell/Lightning1");
			AINZ A 1 A_RailAttack(350, 0, FALSE, "", "LightBlue", RGF_SILENT|RGF_FULLBRIGHT|RGF_NORANDOMPUFFZ, 600, "", 1, 1, 0, 70, 3.5, 0.05, "magicparticlethunder", 16);
			AINZ A 0 A_Light(0);
			goto ready;
		attacklifeessence:
			AINZ A 0 A_GiveInventory("magic_completevision", 1);
			goto ready;
		attackfly:
			AINZ A 0;
			AINZ A 1 A_GiveInventory("magicfly", 1);
			goto ready;
		attackshockwave:
			AINZ A 1 {
				
				actor shock;
				bool unused3;
				
				A_FireProjectile("magic_shockwave", 0, FALSE, invoker.shootY, invoker.shootZ);
				/*
				[unused3, shock] = A_SpawnItemEx("magic_shockwave", 8.0, 0, 0);
				
				let shock2 = magic_shockwave(shock);
				
				if (shock2)
					shock2.prad = 512.0;*/
			}
			goto ready;
		attackgreaterteleportation:
			AINZ A 1 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 2048, pitch, flags: TRF_THRUACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				Vector3 place;
				place = RemoteRay.HitLocation;
				
				//place.xy = RotateVector(place.xy, angle);
				//A_LogFloat(angle);
				//place.xy.x -= 16.0;
				//place.xy.x += 32.0;
				
				//Teleport(place, angle, 0);
				actor beacon = Spawn("magic_greaterteleportation", place);
				
				if (beacon)
					beacon.master = self;
				//A_SpawnItemEx("magic_greaterteleportation", place.xy.x, place.xy.y, place.z, 0, 0, 0, angle);
			}
			goto ready;
		attackgravitymaelstrom:
			AINZ A 1 A_FireProjectile("magicgravitymaelstrom", 0, FALSE, invoker.shootY, invoker.shootZ);
			goto ready;
		attackantilifecocoon:
			AINZ A 0;
			//AINZ A 1 A_FireBullets(0, 0, 1, 0, "magicantilifecocoon", FBF_NOFLASH|FBF_NORANDOM|FBF_NORANDOMPUFFZ);
			AINZ A 1 A_RailAttack(0, 0, FALSE, "", "", RGF_SILENT|RGF_NORANDOMPUFFZ, 0, "magicantilifepuff");
			goto ready;
		attackchaindragonlightning:
			AINZ A 0;
			AINZ A 0 {
				
				if (CountInv("magicatriplet") > 0)
					FireSuperRailgun(1, 50.0);
				else
					FireSuperRailgun(1, 50.0);
			}
			AINZ A 1;
			goto ready;
		attackundeadarmy:
			AINZ A 1 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 256, pitch, flags: TRF_THRUACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				Spawn("magic_skeleton_spawner", RemoteRay.HitLocation);
			}
			goto ready;
		attackwallofskeleton:
			AINZ A 0;
			AINZ A 1 A_FireProjectile("magicwallofskeleton", 0, FALSE, invoker.shootY, invoker.shootZ);
			goto ready;
		attackastralsmite:
			AINZ A 0;
			AINZ AA 0 A_GiveInventory("castingSpeedSlowWeak", 1);
			AINZ AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 {
				
				A_FireProjectile("magicastralsmite", 0, FALSE, invoker.shootY+frandom(-10.0,10.0), invoker.shootZ+frandom(-10.0,10.0));
				A_FireProjectile("magicastralsmite", 0, FALSE, invoker.shootY+frandom(-10.0,10.0), invoker.shootZ+frandom(-10.0,10.0));
			}
			goto ready;
		attackhellflame:
			AINZ A 1 A_FireProjectile("magichellflame", 0, FALSE, invoker.shootY, invoker.shootZ);
			goto ready;
		attacknegativeburst:
			AINZ A 0;
			AINZ A 0 A_GiveInventory("castingSpeedSlowWeak", 1);
			AINZ A 0 A_SpawnItemEx("magicnegativeburst", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER);
			AINZ A 0 A_SpawnItemEx("magicnegativeburstexplosion", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER);
			goto ready;
		attackblackhole:
			AINZ A 1;
			AINZ A 8 A_FireProjectile("magicblackholelaunch", 0, FALSE, invoker.shootY, invoker.shootZ);
			goto ready;
		attacksummonundead10th:
			AINZ A 1;
			AINZ A 8 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 256, pitch, flags: TRF_ALLACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				if (RemoteRay.HitType == TRACE_HitActor) {
					
					if (RemoteRay.HitActor.bCorpse) {
						
						RemoteRay.HitActor.SetState(Null);
						Actor deathknight = Spawn("revenant", RemoteRay.HitLocation);
						
						if (deathknight) {
							
							deathknight.bFriendly = TRUE;
							deathknight.health = 1000;
							A_Log("A deathknight rises to your side.");
						}
					}
				}
			}
			goto ready;
		attackrealityslash:
			AINZ A 1 {
				// TODO: Make the camera immobile while shooting. (Investigate: A_ZoomFactor, CVars...)
				//PlayerInfo p;
				//p = players[consoleplayer];
				//CVar attacksetting = CVar.FindCVar('mouse_sensitivity');
				//CVar attacksetting = Cvar.GetCVar("vid_defwidth", p);
				//attacksetting.SetFloat(0.0);
				
				A_FireProjectile("magiccutterspawner", 0, FALSE, 0, 24.0, FPF_NOAUTOAIM);
			}
			goto ready;
		attackexplodemine:
			AINZ A 1 A_JumpIfInventory("magicatriplet", 1, 2);
			AINZ A 1 A_FireProjectile("magicexplodemineproj", 0, FALSE, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 0);
			goto ready;
			AINZ A 0 A_FireProjectile("magicexplodemineproj", 32, FALSE, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 30);
			AINZ A 0 A_FireProjectile("magicexplodemineproj", -32, FALSE, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 30);
			AINZ A 1 A_FireProjectile("magicexplodemineproj", 0, FALSE, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 0);
			goto ready;
		attacknuclearblast:
			AINZ A 1 A_RailAttack(0, 0, FALSE, "", "", RGF_SILENT|RGF_NORANDOMPUFFZ, 0, "magicnuclearblastspawn");
			goto ready;
		attacktruedark:
			AINZ A 1 {
				
				actor dark;
				bool unused2;
				FLineTraceData RemoteRay;
				LineTrace( angle, 2048, pitch, flags: TRF_ALLACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				if (RemoteRay.HitType == TRACE_HitActor) {
					
					if (!RemoteRay.HitActor.bCorpse && RemoteRay.HitActor.bISMONSTER && RemoteRay.HitActor.SpawnHealth() > 0 && RemoteRay.HitActor.Health > 0) {
						
						[unused2, dark] = RemoteRay.HitActor.A_SpawnItemEx("magictruedark");
						dark.target = RemoteRay.HitActor;
					}
				}
			}
			goto ready;
		attackgraspheart:
			AINZ A 1;
			AINZ A 8 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 256, pitch, flags: TRF_ALLACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				if (RemoteRay.HitType == TRACE_HitActor) {
					
					if (!RemoteRay.HitActor.bCorpse && RemoteRay.HitActor.SpawnHealth() < 5000) {
						
						RemoteRay.HitActor.A_Die();
					}
				}
			}
			goto ready;
		attackbodyofrefulgentberyl:
			AINZ A 1;
			AINZ A 0 A_GiveInventory("magicbodyofrefulgentberyl", 1);
			goto ready;
		attacktimestop:
			AINZ A 0;
			AINZ A 0 A_StartSound("Spell/TimeStopOn", -1, CHANF_OVERLAP|CHANF_NOPAUSE, 1.0, ATTN_NONE);
			AINZ A 1 A_GiveInventory("magictimestop", 1);
			goto ready;
		attackfallendown:
			AINZ A 1 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 2800, pitch, flags: TRF_THRUACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				let fallen = magicfallendown(Spawn("magicfallendown", RemoteRay.HitLocation));
				if (fallen)
					fallen.owner = self;
			}
			goto ready;
	}
}