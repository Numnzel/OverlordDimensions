class magicparticlethunder : Actor {
	
	default {
		speed 0;
		RenderStyle "Add";
		alpha 0.8;
		scale 2.5;
		PROJECTILE;
		+ROLLSPRITE;
		+FORCEXYBILLBOARD;
		+CLIENTSIDEONLY;
	}
	
	states {
		spawn:
			THUN A 1 NoDelay Bright A_SetScale(scale.x*0.7);
			THUN A 0 Bright { A_SetRenderStyle(0.9, STYLE_Normal); A_SetScale(scale.x*0.7); }
			THUN A 1 Bright { A_SetRenderStyle(0.9, STYLE_Add); A_SetScale(scale.x*0.7); }
			THUN A 0 Bright { A_SetRenderStyle(0.9, STYLE_Normal); A_SetScale(scale.x*0.7); }
			THUN A 1 Bright { A_SetRenderStyle(0.9, STYLE_Add); A_SetScale(scale.x*0.7); }
			THUN A 0 Bright { A_SetRenderStyle(0.9, STYLE_Normal); A_SetScale(scale.x*0.7); }
			THUN A 1 Bright { A_SetRenderStyle(0.9, STYLE_Add); A_SetScale(scale.x*0.7); }
			THUN A 8 Bright;
		fade:
			THUN A 1 Bright A_FadeOut(0.3);
			Loop;
	}
}