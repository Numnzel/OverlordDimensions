extend class spookyspell {
	
	states {

		anNone:
			TNT1 A 0 A_Overlay(-9, invoker.selectedSpell.state);
			goto ready;
		anSuper:
		anSlash:
		anGrasp:
		anHand:
		anPalm:
		anProjectile:
		anFinger:
			TNT1 A 0 A_GiveInventory("castingSpeedFinger", 1);
			HRSA ABCDEFGHIJKLMNOPQRSTUVWXYZ 2 Bright;
			HRSB ABCDEFGHIJKLMNO 2 Bright;
			#### # 0 A_Overlay(-9, invoker.selectedSpell.state);
			HRSB PQRSTUVWXYZ 2 Bright;
			HRSC ABCDEF 2 Bright;
			goto ready;
		attMagicArrow:
			TNT1 A 0 {

				int amount = (CountInv("magicatriplet") > 0) ? 3 : 1;
				A_FireMagicArrows(max(1, floor(CountInv("maxmana")/500)), amount, CountInv("magicamaximize"));
			}
			stop;
		attAcidArrow:
			TNT1 A 0 A_FireProjectile("magicacidarrow", 0, false, invoker.shootY, invoker.shootZ);
			stop;
		attLifeEssence:
			TNT1 A 0 A_GiveInventory("magic_completevision", 1);
			stop;
		attFireball:
			TNT1 A 0 {
				
				A_FireProjectile("magicfireball", 0, false, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 0);

				if (CountInv("magicatriplet") > 0) {
					A_FireProjectile("magicfireball", 16, false, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 30);
					A_FireProjectile("magicfireball", -16, false, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 30);
				}
			}
			stop;
		attLightning:
			TNT1 A 0 A_Light(9);
			TNT1 A 0 A_StartSound("Spell/Lightning1");
			TNT1 A 0 {
				
				int dmg = (CountInv("magicamaximize") > 0) ? 600*1.5 : 600;
				A_RailAttack(dmg, invoker.shootY, false, "", "LightBlue", RGF_SILENT|RGF_FULLBRIGHT|RGF_NORANDOMPUFFZ, 600, "", 1, 1, 0, 70, 2.0, 0.05, "magicparticlethunder", invoker.shootZ);
			}
			TNT1 A 0 A_Light(0);
			stop;
		attFly:
			TNT1 A 0 {

				class<Inventory> spw = (CountInv("magicamaximize") > 0) ? "magicflymax" : "magicfly";
				A_GiveInventory(spw, 1);
			}
			stop;
		attShockwave:
			TNT1 A 0 {

				class<Actor> spw = (CountInv("magicamaximize") > 0) ? "magicshockwavemax" : "magicshockwave";
				A_FireProjectile(spw, 0, false, invoker.shootY, invoker.shootZ);
			}
			stop;
		attExplodeMine:
			TNT1 A 0 {

				class<Actor> spw = (CountInv("magicamaximize") > 0) ? "magicexplodemineprojmax" : "magicexplodemineproj";

				/*FLineTraceData RemoteRay;
				LineTrace( angle, 65535, pitch, flags: TRF_THRUACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				vector3 place = RemoteRay.HitLocation;*/
				
				A_FireProjectile(spw, 0, false, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 0);

				if (CountInv("magicatriplet") > 0) {
					A_FireProjectile(spw, 32, false, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 30);
					A_FireProjectile(spw, -32, false, invoker.shootY, invoker.shootZ, FPF_NOAUTOAIM, 30);
				}
			}
			stop;
		attAntilifeCocoon:
			//TNT1 A 0 A_FireBullets(0, 0, 1, 0, "magicantilifecocoon", FBF_NOFLASH|FBF_NORANDOM|FBF_NORANDOMPUFFZ);
			TNT1 A 0 A_RailAttack(0, 0, false, "", "", RGF_SILENT|RGF_NORANDOMPUFFZ, 0, "magicantilifepuff");
			stop;
		attGravityMaelstrom:
			TNT1 A 0 {
				
				class<Actor> spw = (CountInv("magicamaximize") > 0) ? "magicgravitymaelstrommax" : "magicgravitymaelstrom";
				A_FireProjectile(spw, 0, false, invoker.shootY, invoker.shootZ);
			}
			stop;
		attWallOfSkeleton:
			TNT1 A 0 A_FireProjectile("magicwallofskeleton", 0, false, invoker.shootY, invoker.shootZ);
			stop;
		attGreaterTeleportation:
			TNT1 A 0 {
				
				FLineTraceData RemoteRay;
				LineTrace(angle, 65535, pitch, flags: TRF_THRUACTORS, offsetz: height-invoker.shootZ, data: RemoteRay);
				
				vector3 place = RemoteRay.HitLocation;
				
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
			stop;
		attDragonLightning:
			TNT1 A 0 {
				
				int amount = (CountInv("magicatriplet") > 0) ? 3 : 1;
				A_FireSuperRailgun(amount, 50.0);
			}
			stop;
		attUndeadArmy:
			TNT1 A 0 {
				
				FLineTraceData RemoteRay;
				LineTrace(angle, 256, pitch, flags: TRF_THRUACTORS, offsetz: height-invoker.shootZ, data: RemoteRay);
				
				Spawn("magic_skeleton_spawner", RemoteRay.HitLocation);
			}
			stop;
		attAstralSmite:
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 {
				
				class<Actor> spw = (CountInv("magicamaximize") > 0) ? "magicastralsmitemax" : "magicastralsmite";

				A_FireProjectile(spw, 0, false, invoker.shootY+frandom(-10.0,10.0), invoker.shootZ+frandom(-10.0,10.0));
				A_FireProjectile(spw, 0, false, invoker.shootY+frandom(-10.0,10.0), invoker.shootZ+frandom(-10.0,10.0));
			}
			stop;
		attHellFlame:
			TNT1 A 0 A_FireProjectile("magichellflame", 0, false, invoker.shootY, invoker.shootZ);
			stop;
		attNegativeBurst:
			TNT1 A 0 A_SpawnItemEx("magicnegativeburst", 0, 0, 0, 0, 0, 0, 0, SXF_SETMASTER);
			stop;
		attBlackHole:
			TNT1 A 0 A_FireProjectile("magicblackholelaunch", 0, false, invoker.shootY, invoker.shootZ);
			stop;
		attTrueDark:
			TNT1 A 0 {
				
				actor dark;
				bool unused2;
				FLineTraceData RemoteRay;
				LineTrace( angle, 2048, pitch, flags: TRF_ALLACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				if (RemoteRay.HitType == TRACE_HitActor) {
					
					if (!RemoteRay.HitActor.bCORPSE && RemoteRay.HitActor.bISMONSTER && RemoteRay.HitActor.SpawnHealth() > 0 && RemoteRay.HitActor.Health > 0) {
						
						[unused2, dark] = RemoteRay.HitActor.A_SpawnItemEx("magictruedark");
						dark.target = RemoteRay.HitActor;
					}
				}
			}
			stop;
		attGraspHearth:
			TNT1 A 0 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 256, pitch, flags: TRF_ALLACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				if (RemoteRay.HitType == TRACE_HitActor) {
					
					if (!RemoteRay.HitActor.bCorpse && RemoteRay.HitActor.SpawnHealth() < 5000) {
						
						RemoteRay.HitActor.A_Die();
					}
				}
			}
			stop;
		attNuclearBlast:
			TNT1 A 0 A_RailAttack(0, 0, false, "", "", RGF_SILENT|RGF_NORANDOMPUFFZ, 0, "magicnuclearblastspawn");
			stop;
		attBodyOfRefulgentBeryl:
			TNT1 A 0 A_GiveInventory("magicbodyofrefulgentberyl", 1);
			stop;
		attSummonUndead10th:
			TNT1 A 0 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 256, pitch, flags: TRF_ALLACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				if (RemoteRay.HitType == TRACE_HitActor) {
					
					if (RemoteRay.HitActor.bCorpse) {
						
						RemoteRay.HitActor.Destroy();
						Actor deathknight = Spawn("deathknight", RemoteRay.HitLocation);
					}
				}
			}
			stop;
		attRealitySlash:
			TNT1 A 0 A_FireProjectile("magiccutterspawner", 0, false, 0, 24.0, FPF_NOAUTOAIM);
			TNT1 A 0 A_JumpIfInventory("magicatriplet", 1, 1);
			stop;
			TNT1 A 13;
			TNT1 A 5 A_FireProjectile("magiccutterspawner", 0, false, 0, 24.0, FPF_NOAUTOAIM);
			TNT1 A 0 A_FireProjectile("magiccutterspawner", 0, false, 0, 24.0, FPF_NOAUTOAIM);
			stop;
		attTimeStop:
			TNT1 A 0 A_StartSound("Spell/TimeStopOn", -1, CHANF_OVERLAP|CHANF_NOPAUSE, 1.0, ATTN_NONE);
			TNT1 A 0 A_GiveInventory("magictimestop", 1);
			stop;
		attFallenDown:
			TNT1 A 0 {
				
				FLineTraceData RemoteRay;
				LineTrace( angle, 2800, pitch, flags: TRF_THRUACTORS, offsetz: height-invoker.shootZ, data: RemoteRay );
				
				let fallen = magicfallendown(Spawn("magicfallendown", RemoteRay.HitLocation));
				if (fallen)
					fallen.owner = self;
			}
			stop;
	}
}