
enum fire_args {
	spawn_smoke,
	spawn_ember,
	flame_dlight,
	ember_dlight,
}

class mk_BaseFire : actor abstract {
	// Custom LightScale parameter, allows the user to set the scale of the Dynamic Light if args[3] is enabled.
	int lightScale; property lightScale: lightScale;
	
	// a boolean to check if the fire needs to follow and check status of Master. 
	bool follower;
	
	// selected renderstyle
	int style;
	string type; property firetype: type;
	string type2; property firetype2: type2;
	
	bool unused;
	
	default {
		RenderStyle "None";
		
		+NOGRAVITY;
		+NOBLOCKMAP;
		//+NOTIMEFREEZE;
		
		mk_BaseFire.lightScale 48;
		mk_BaseFire.firetype "mk_Flame";
		mk_BaseFire.firetype2 "mk_FlameShadow";
	}
	
	override void postBeginPlay () {
		super.postBeginPlay();
		
		// if the Dynamic Light arg is enabled, attach a new light, and set the matching colour.
		if (args[flame_dlight]) {
			let light = mk_FireLight (Spawn ("mk_FireLight", (pos.x, pos.y, pos.z+8)));
			
			if (light) {
				// set the new light's colours.
				light.args[DYNAMICLIGHT.LIGHT_RED] 					= fillColor.r;
				light.args[DYNAMICLIGHT.LIGHT_GREEN] 				= fillColor.g;
				light.args[DYNAMICLIGHT.LIGHT_BLUE] 				= fillColor.b;
				
				light.args[DYNAMICLIGHT.LIGHT_INTENSITY]			= lightScale*scale.x;
				light.args[DYNAMICLIGHT.LIGHT_SECONDARY_INTENSITY]	= lightScale*scale.x;
				
				light.master = self;
			}
		}
	}
	
	override void Activate (Actor activator) {
		bDORMANT = false;
	}
	override void DeActivate (Actor activator) {
		bDORMANT = true;
	}
	
	override void tick () {
		super.tick();
		
		// if the fire is set to Dormant or Deactivated, skip the spawning code.
		if (bDORMANT)
			return;
		
		actor flame;
		actor ember;
		actor light;
		
		if (follower) {
			// if master is dormant, skip the spawning code.
			if (master && master.bDORMANT)
				return;
			
			// if there is a master, warp to it.
			if (master)
				A_Warp(AAPTR_MASTER,-5,0,1,0,WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE);
			
			else
				destroy();
		}
		
		// spawn the visual flame actor.
		string firespawn = type;
		if (style == 1 && random(0,4) == 0)
			firespawn = type2;
		
		
		[unused, flame] = A_SpawnItemEx (firespawn,	xofs: frandom (-3.0,3.0),
													zvel: frandom (0.1,1.3),
													angle: random (0,359),
													flags: SXF_TRANSFERSPRITEFRAME|SXF_TRANSFERTRANSLATION|SXF_TRANSFERSCALE);
		
		// set the flame actor's colour to match the defined colour.
		if (flame) {
			flame.SetShade (fillColor);
		}
		
		// if smoke is enabled, spawn it.
		if (args[spawn_smoke]) {
			A_SpawnItemEx ("mk_Smoke",		zofs: 24.0,
											xvel: frandom (-1.0,1.0),
											zvel: frandom (1.0,3.0),
											angle: random (0,359),
											flags: SXF_TRANSFERSCALE);
		}
		
		// if Spawn embers is non-zero, attempt to spawn embers.
		if (args[spawn_ember]) {
			[unused, ember] = A_SpawnItemEx ("mk_Ember",		frandom (1.0,4.0),
																0.0,
																frandom (24.0, 32.0) * scale.x,
																frandom (0.25,1.25),
																0.0,
																frandom (0.5,3.0),
																random (0,359),
																SXF_NOCHECKPOSITION|SXF_TRANSFERTRANSLATION|SXF_TRANSFERSPECIAL|SXF_TRANSFERSCALE,
																255-args[spawn_ember]); // 0 = no embers, 255 = embers every tick
			
			// set the ember to match the colour.
			if (ember)
				ember.SetShade(fillColor);
			
			// if lights are enabled, toggle the flag on the ember actor.
			if (args[ember_dlight] && ember) {
				let ember = mk_Ember(ember);
				
				if (ember) {
					ember.Light = true;
				}
			}
		}
	}
	
	states {
		Spawn:
			TNT1 A 1;
			loop;
	}
}


// example fire type.
// to create your own, simply inherit from mk_BaseFire
class mk_SmallFire : mk_BaseFire {
	default {
		//$Category ZScript Fire
		//$Title Small Fire
		//$Color 17
		
		//$Arg0 Emit Smoke?
		//$Arg0Type 11
		//$Arg0Enum { 0 = "No"; 1 = "Yes"; }
		
		//$Arg1 Ember Frequency
		
		//$Arg2 Dynamic Light?
		//$Arg2Type 11
		//$Arg2Enum { 0 = "No"; 1 = "Yes"; }		
		
		//$Arg3	Ember Dynamic Light?
		//$Arg3Type 11
		//$Arg3Enum { 0 = "No"; 1 = "Yes  (Perfomance Warning!)"; }
	}
	
	states {
		Spawn:
			TNT1 A 0 noDelay A_Jump(255, random(0,11));
		SpawnLoop:
			FFLG FGHIJKLMNOPQ 2;
			loop;
	}
}

// another example, with different sprites and using the lightScale parameter.
class mk_BigFire : mk_BaseFire {
	default {
		//$Category ZScript Fire
		//$Title Large Fire
		//$Color 17
		
		//$Arg0 Emit Smoke?
		//$Arg0Type 11
		//$Arg0Enum { 0 = "No"; 1 = "Yes"; }
		
		//$Arg1 Ember Frequency
		
		//$Arg2 Dynamic Light?
		//$Arg2Type 11
		//$Arg2Enum { 0 = "No"; 1 = "Yes"; }		
		
		//$Arg3	Ember Dynamic Light?
		//$Arg3Type 11
		//$Arg3Enum { 0 = "No"; 1 = "Yes  (Perfomance Warning!)"; }
		mk_BaseFire.lightScale 64;
	}
	states {
		Spawn:
			TNT1 A 0 noDelay A_Jump(255, random(0,7));
		SpawnLoop:
			BFIR ABCDEFG 2;
			loop;
	}
}

// the standard flame actor
// copies the current sprite from the owner.
class mk_Flame : actor {

	default {
		+BRIGHT;
		//+NOTIMEFREEZE;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+ROLLSPRITE;
		
		Renderstyle "AddShaded";
		Alpha 0.0;
	}

	double firegrowth;

	override void PostBeginPlay () {
		A_SetScale(scale.x + frandom(-0.010,0.500),scale.y);
		firegrowth = frandom(8.0,12.0);
		Super.PostBeginPlay();
	}

	void ShadowFade () {
		A_FadeOut(0.075);
		A_SetScale(scale.x-(scale.x/firegrowth), scale.y+(scale.y/(firegrowth*1.5)));
	}

	States {
		Spawn:
			"####" "####" 1 A_FadeIn(0.33);
		FadeOut:
			"####" "#" 1 ShadowFade();
			loop;
	}
}

class mk_FlameShadow : mk_Flame {

	default {
		
		Renderstyle "Shadow";
	}
}

class mk_Smoke : actor {

	default {
		+NOGRAVITY;
		+NOBLOCKMAP;
		+ROLLSPRITE;
		+ROLLCENTER;
		//+NOTIMEFREEZE;
		+NOCLIP;
		+FORCEXYBILLBOARD;
		
		RENDERSTYLE "Translucent";
		ALPHA 0.0;
		Radius 1;
		Height 1;
	}

	override void postBeginPlay () {
		
		super.postBeginPlay();
		
		A_SetScale (1.0 + (frandom(-0.25, 0.25)));
	}

	override void tick () {
		
		Super.tick ();
		
		A_SetRoll(roll+5, SPF_INTERPOLATE);
		A_SetScale(scale.x + (scale.x/400));
	}

	States {
		
		Spawn:
			TNT1 A 0 NoDelay A_Jump(255,"Smoke1","Smoke2","Smoke3");
		Smoke1:
			SMOK AAAAAA 1 A_FadeIn(0.02);
			Goto Fade;
		Smoke2:
			SMOK BBBBBB 1 A_FadeIn(0.02);
			Goto Fade;
		Smoke3:
			SMOK CCCCCC 1 A_FadeIn(0.02);
			Goto Fade;
		Fade:
			"####" "#" random(5,15);
		Fade.Loop:
			"####" "#" 1 A_FadeOut(0.005);
			loop;
	}
}

Class mk_Ember : actor {

	Default {
		+NOBLOCKMAP;
		+NOCLIP;
		+NOGRAVITY;
		//+NOTIMEFREEZE;
		+FORCEXYBILLBOARD;
		
		RADIUS 1;
		HEIGHT 1;
		Renderstyle "AddShaded";
		Scale 0.5;
	}

	int lifespan;
	bool light;
	
	override void postBeginPlay () {
		
		Super.postBeginPlay();
		
		scale.x = scale.y + frandom(0.001, 0.080);
		
		if (light)
			A_AttachLight ("EmberLight", DynamicLight.PointLight, fillColor, 3, 3);
			
		lifespan = random(45,65);
	}

	override void tick () {
		
		Super.tick();
		
		A_BishopMissileWeave();
		lifespan--;
		
		if (lifespan <= 0)
			SetStateLabel ("Fade"); 
	}

	states {
		Spawn:
			EMBR A 0 Nodelay;
		Fade:
			EMBR A 1 BRIGHT {
				A_FadeOut(0.025);
			}
			loop;
	}
}

// custom dynamic light class, spawned by the base fire.
class mk_FireLight : pointLight {

	default {
		// if you wish to enable attenuated lights I suggest increasing the base lightScale factor significantly
		//+DYNAMICLIGHT.ATTENUATE;
	}
	
	int rad1;
	int rad2;
	
	override void postBeginPlay () {
		
		super.postBeginPlay();
		
		rad1 = args[3];
		rad2 = args[4];
	}
	
	override void tick () {
		
		if (master && master.bDORMANT) {
			args[3] = 0;
			args[4] = 0;
		}
		else {
			args[3] = rad1;
			args[4] = rad2;
		}
		
		// Modify the secondary light radius.
		if (random(0,10) >= 3)
			args[3] = args[4] + random ( -(args[4]/20), (args[4]/20) );
	}
}