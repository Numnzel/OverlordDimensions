extend class MinimalStatusBar {
	
	int healthInterpolated;
	int healthInterpolationPile;
	int manaInterpolated;
	int manaInterpolationPile;
	
	void DrawFullScreenStuff (double TicFrac) {
		
		if (!CPlayer || automapactive)
			return;
		
		// flags used for positioning text
		int tAlign = DI_TEXT_ALIGN_CENTER | DI_SCREEN_CENTER_BOTTOM;
		// player data
		let pmo = CPlayer.mo;
		// WIP compact hud
		bool hudSM = CVar.GetCVar("OD_hud_smaller", CPlayer).GetInt();
		// Current selected spell
		spell currSpell;
		getSpellProperties(pmo.CountInv("spellid"), currSpell);

		
		// ================================================================================= HEALTH BAR =================================================================================
		int healthCurrent = pmo.health;
		int healthMax = pmo.GetMaxHealth(TRUE);
		int healthXoffs = 32;
		int healthYoffs = 0;
		int healthBarXSz = 300;
		int healthBarYSz = 16;
		int healthBarXpos = -healthBarXSz-healthXoffs;
		int healthBarYpos = -25-healthYoffs;
		int healthStrXpos = -healthBarXSz-healthXoffs-3;
		int healthStrYpos = healthBarYpos;
		color colBarHealthBackg = color(128, 64, 24, 8);
		color colBarHealth1Base = color(255, 255, 0, 0);
		color colBarHealth1Fade = color(255, 64, 0, 0);
		color colBarHealth2Base = color(128, 255, 255, 255);
		color colBarHealth2Fade = color(128, 0, 0, 0);
		color colBarHealthCount = Font.CR_UNTRANSLATED;
		
		if (healthInterpolated >= healthMax) colBarHealthCount = Font.CR_GOLD;

		InterpolateValue(healthCurrent, healthInterpolated, healthInterpolationPile);
		
		//DrawHudBoxCol("HBCORN", "HBEDGE", color(128, 0, 0, 0), (healthBarXpos, -72), (healthBarXSz, 64), DI_SCREEN_CENTER_BOTTOM, alphaSetting);
		
		// Health texts
		//DrawString(mMM2SmallFont, "HEALTH", (-99, -64), tAlign);
		DrawString(mMM2BigFont, FormatNumber(healthInterpolated, 0, 9), (healthStrXpos, healthStrYpos), DI_TEXT_ALIGN_RIGHT | DI_SCREEN_CENTER_BOTTOM, colBarHealthCount);
		
		// Bar outline
		DrawHudBoxCol("SBCORN", "SBEDGE", colBarHealthBackg, (healthBarXpos, healthBarYpos), (healthBarXSz, healthBarYSz), DI_SCREEN_CENTER_BOTTOM);
		// Bar
		DrawUnitBarGrad(colBarHealth1Base, colBarHealth1Fade,	healthInterpolated, healthMax, (healthBarXpos+1, healthBarYpos+1), (healthBarXSz-2, healthBarYSz-2), DI_SCREEN_CENTER_BOTTOM, TRUE);
		DrawUnitBarGrad(colBarHealth2Base, colBarHealth2Fade,	healthInterpolated-healthMax, healthMax, (healthBarXpos+1, healthBarYpos+1), (healthBarXSz-2, healthBarYSz-2), DI_SCREEN_CENTER_BOTTOM, TRUE);
		
		
		// ================================================================================= MANA BAR =================================================================================
		int manaAmount = pmo.CountInv("mana");
		int manaCost = currSpell.mana;
		int manaMax = pmo.CountInv("maxmana");
		int manaCap = 3000;
		int manaXoffs = 32;
		int manaYoffs = 0;
		int manaBarXsiz = 300;
		int manaBarYsiz = 16;
		int manaBarXpos = manaXoffs;
		int manaBarYpos = -25-manaYoffs;
		int manaStrXpos = manaBarXsiz+manaXoffs;
		int manaStrYpos = manaBarYpos;
		color colBarManaBackg = color(128, 64, 24, 8);
		color colBarMana1Base = color(255, 128, 16, 255);
		color colBarMana1Fade = color(255, 32, 16, 64);
		color colBarMana2Base = color(255, 0, 255, 255);
		color colBarMana2Fade = color(255, 0, 64, 64);
		color colBarCost1Base = color(255, 96, 0, 192);
		color colBarCost1Fade = color(255, 24, 0, 48);
		color colBarCost2Base = color(255, 0, 128, 128);
		color colBarCost2Fade = color(255, 0, 32, 32);
		color colBarCostError = color(255, 48, 0, 96);
		color colBarManaCount = Font.CR_UNTRANSLATED;

		if (manaInterpolated >= manaMax) colBarManaCount = Font.CR_GOLD;
		getSpellManaCostEnhanced(currSpell.id, pmo.CountInv("magicamaximize"), pmo.CountInv("magicatriplet"), pmo.CountInv("magicawiden"), manaCost);
		
		int manaDiff = manaAmount-manaCost;
		
		// Bar
		if (manaDiff < 0) {
			
			colBarCost1Base = colBarCostError;
			colBarCost2Base = colBarCostError;
		}
		
		InterpolateValue(manaAmount, manaInterpolated, manaInterpolationPile);
		
		// Mana texts
		//DrawString(mMM2SmallFont, "MANA", (99, -64), tAlign);
		DrawString(mMM2BigFont, FormatNumber(manaInterpolated, 0, 9), (manaStrXpos, manaStrYpos), DI_TEXT_ALIGN_LEFT | DI_SCREEN_CENTER_BOTTOM, colBarManaCount);
		
		// Bar outline
		DrawHudBoxCol("SBCORN", "SBEDGE", colBarManaBackg, (manaBarXpos, manaBarYpos), (manaBarXsiz, manaBarYsiz), DI_SCREEN_CENTER_BOTTOM);
		// Bar
		DrawUnitBarGrad(colBarCost1Base, colBarCost1Fade, manaInterpolated, manaCap/2, (manaBarXpos+1, manaBarYpos+1), (manaBarXsiz-2, manaBarYsiz-2), DI_SCREEN_CENTER_BOTTOM);
		DrawUnitBarGrad(colBarMana1Base, colBarMana1Fade, manaDiff, manaCap/2, (manaBarXpos+1, manaBarYpos+1), (manaBarXsiz-2, manaBarYsiz-2), DI_SCREEN_CENTER_BOTTOM);
		
		DrawUnitBarGrad(colBarCost2Base, colBarCost2Fade, manaInterpolated-manaCap/2, manaCap/2, (manaBarXpos+1, manaBarYpos+1), (manaBarXsiz-2, manaBarYsiz-2), DI_SCREEN_CENTER_BOTTOM);
		DrawUnitBarGrad(colBarMana2Base, colBarMana2Fade, manaDiff-manaCap/2, manaCap/2, (manaBarXpos+1, manaBarYpos+1), (manaBarXsiz-2, manaBarYsiz-2), DI_SCREEN_CENTER_BOTTOM);
		
		
		// ================================================================================= POWERUPS =================================================================================
		Array<String> PowerupStrings;
		int powerRowXoffs = 40;
		int powerXpos = 20;
		int powerYpos = 48;
		int powerIconSize = 256;
		double powerIconAlpha = 1.0;
		double powerIconScale = 0.2; // Scale works better with multiples of 2

		// Draw powerup (effects) icons
		int j = 0;
		for (int i = 0; i < PowerupNames.size(); i++) {
			
			let pow = Powerup(pmo.FindInventory(PowerupNames[i]));
			
			if (pow && pow.EffectTics > 0) {
				
				class<Powerup> pw = pow.getClassName();
				
				string s = string.format("%d", pow.EffectTics/Thinker.TICRATE);
				PowerupStrings.push(s);
				int powerDuration = Powerup(GetDefaultByType(pw)).EffectTics;

				int monitorTime = CreatePercent(pow.EffectTics, powerDuration, powerIconSize);
				
				j++;
				DrawImageBar(PowerupDisplay[i], monitorTime, powerIconSize, powerXpos+(powerRowXoffs*j), powerYpos, DI_SCREEN_LEFT_TOP, powerIconAlpha, (-1,-1), (powerIconScale,powerIconScale));
				DrawString(mMM2BigFont, PowerupStrings[j-1], (powerXpos+(powerRowXoffs*j), powerYpos), DI_TEXT_ALIGN_CENTER | DI_SCREEN_LEFT_TOP);
			}
		}


		// ================================================================================= BUTTONS =================================================================================
		int buttonsXpos = 0;
		int buttonsYpos = 67;
		double buttonsFrameAlpha = 0.4;
		double buttonsFrameScale = 0.25;

		DrawImage("BTTNA00", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, buttonsFrameAlpha, (-1, -1), (buttonsFrameScale, buttonsFrameScale));
		DrawImage("BTTNB00", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, 1.0, (-1, -1), (buttonsFrameScale, buttonsFrameScale));

		if (CPlayer.ReadyWeapon) {
			if (CPlayer.ReadyWeapon.getClassName() == "spookyspell") {
				
				if (pmo.FindInventory("magicamaximize"))
					DrawImage("BTTNC21", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, 1.0, (-1, -1), (buttonsFrameScale, buttonsFrameScale));
				if (pmo.FindInventory("magicatriplet"))
					DrawImage("BTTNC31", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, 1.0, (-1, -1), (buttonsFrameScale, buttonsFrameScale));
				if (pmo.FindInventory("magicawiden"))
					DrawImage("BTTNC41", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, 1.0, (-1, -1), (buttonsFrameScale, buttonsFrameScale));
				
				DrawImage("BTTNC20", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, 1.0, (-1, -1), (buttonsFrameScale, buttonsFrameScale));
				DrawImage("BTTNC30", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, 1.0, (-1, -1), (buttonsFrameScale, buttonsFrameScale));
				DrawImage("BTTNC40", (buttonsXpos, -buttonsYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, 1.0, (-1, -1), (buttonsFrameScale, buttonsFrameScale));
			} else {
				// ...
			}
		}
		
		
		// ================================================================================= FACE =================================================================================
		int faceXpos = 0;
		int faceYpos = 67;
		double faceImageAlpha = 1.0;
		double faceImageScale = 0.25;

		//DrawHudBoxCol("HBCORN", "HBEDGE", color(128, 0, 0, 0), (-27, -72), (54, 64), DI_SCREEN_CENTER_BOTTOM, alphaSetting);
		DrawImage(GetCustomMugshot(pmo), (faceXpos, -faceYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, faceImageAlpha, (-1, -1), (faceImageScale, faceImageScale));
		//DrawTexture(GetMugShot(5), (faceXpos, -faceYpos), DI_ITEM_CENTER | DI_SCREEN_CENTER_BOTTOM, faceImageAlpha, (-1, -1), (faceImageScale, faceImageScale));
		
		
		// ================================================================================= SPELLS =================================================================================
		double spellsAlpha = Clamp(CVar.GetCVar("OD_hud_spells_alpha", CPlayer).GetFloat(), 0, 1);
		bool enhancementsAlways = CVar.GetCVar("OD_hud_enhanc_always", CPlayer).GetInt();
		bool spellsAlways = CVar.GetCVar("OD_hud_spells_always", CPlayer).GetInt();
		
		int spellsSize = 256;
		int spellsYoffs = 30;
		int spellsColXSpacing = 64;
		int spellsColMidSpacing = 100;
		int spellsColXoffs = -16;
		int spellsColYoffs = 40;
		double spellsIconAlpha = 0.8*spellsAlpha;
		double spellsIconSelAlpha = 1.0;
		double spellsSlotAlpha = 0.4*spellsAlpha;
		double spellsSlotSelAlpha = 1.0;
		double spellsCDAlpha = 1.0;
		double spellsScarceManaRedAlpha = 0.4*spellsAlpha;
		double spellsScale = 0.2; // Scale works better with multiples of 2
		int spellsEffectSize = 48;
		int spellsEffectXYpos = 68*spellsScale;
		int spellsEffectXYoffs = 40*spellsScale;

		for (int k = 0; k < SPELLSLOTS; k++) {
			for (int i = 0; i < SPELLKEYS; i++) {
				
				bool spellSelected = (currSpell.id == momongaSpells[i][k].id);

				if (spellsAlways || CPlayer.ReadyWeapon && CPlayer.ReadyWeapon.getClassName() == "spookyspell") {

					// Set position
					int spellYpos = -spellsColYoffs*k;
					int spellXpos = spellsColXSpacing*i;
					
					if (i >= SPELLKEYS/2) {
						spellXpos += spellsColMidSpacing;
						spellXpos -= spellsColXoffs*k;
					} else {
						spellXpos += spellsColXoffs*k;
					}
					
					spellYpos -= spellsYoffs;
					spellXpos -= (spellsColMidSpacing/2)+(spellsColXSpacing*(SPELLKEYS-1)/2);
					
					// Draw spells icons
					if (spellSelected) {
						DrawImageBar("SPELLA0", spellsSize, spellsSize, spellXpos, spellYpos, 0, spellsSlotSelAlpha, (-1,-1), (spellsScale,spellsScale));
						DrawImageBar(momongaSpells[i][k].tx, spellsSize, spellsSize, spellXpos, spellYpos, 0, spellsIconSelAlpha, (-1,-1), (spellsScale,spellsScale));
					}
					else {
						DrawImageBar("SPELLA0", spellsSize, spellsSize, spellXpos, spellYpos, 0, spellsSlotAlpha, (-1,-1), (spellsScale,spellsScale));
						DrawImageBar(momongaSpells[i][k].tx, spellsSize, spellsSize, spellXpos, spellYpos, 0, spellsIconAlpha, (-1,-1), (spellsScale,spellsScale));
					}

					if (momongaSpells[i][k].mana > manaAmount)
						DrawImageBar("SPELLU0", spellsSize, spellsSize, spellXpos, spellYpos, 0, spellsScarceManaRedAlpha, (-1,-1), (spellsScale,spellsScale));
					
					// Draw cooldown icons
					let spellCD = Powerup(pmo.FindInventory(momongaSpells[i][k].cd));

					if (spellCD && spellCD.EffectTics > 0) {
						
						class<Powerup> sp = spellCD.getClassName();
						
						int spellCDduration = Powerup(GetDefaultByType(sp)).EffectTics;
						string spellCDtimeS = string.format("%d", spellCD.EffectTics/35);

						if (spellCD.EffectTics > 35*1000)
							spellCDtimeS = "";

						if (spellCD.EffectTics < 35)
							spellCDtimeS = string.format(".%d", spellCD.EffectTics/3.5);

						int monitorCD = CreatePercent(spellCD.EffectTics, spellCDduration, spellsSize);
						
						DrawImageBar("CDWN00", monitorCD, spellsSize, spellXpos, spellYpos, 0, spellsCDAlpha, (-1,-1), (spellsScale,spellsScale));
						DrawString(mMM2SmallFont, spellCDtimeS, (spellXpos, spellYpos-16), tAlign);
					}
					
					// Draw spell selector icon over selected spell
					if (spellSelected)
						DrawImageBar("SPELLB0", spellsSize, spellsSize, spellXpos, spellYpos, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
						
					// Draw multiplier effects
					if (momongaSpells[i][k].eff > 0) {
						
						double effectsYpos = spellYpos + (spellsEffectSize/2*spellsScale) - (spellsSize/2*spellsScale) - spellsEffectXYpos;
						double effectsXpos = spellXpos - spellsEffectXYpos;

						bool bitEffects[3];
						int tmpEffectVal = momongaSpells[i][k].eff;
						for (int b = 0; b < 3; b++) {
							bitEffects[b] = tmpEffectVal % 2 == 1;
							tmpEffectVal /= 2;
						}

						if (bitEffects[0]) { // Maximize magica
							
							if (!enhancementsAlways) {
								if (pmo.FindInventory("magicamaximize")) {
									DrawImageBar("SPELLC0", spellsEffectSize+2, spellsEffectSize+2, effectsXpos-spellsEffectXYoffs, effectsYpos+spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
									DrawImageBar("SPELLM00", spellsEffectSize+2, spellsEffectSize+2, effectsXpos-spellsEffectXYoffs, effectsYpos+spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								}
							} else {
							
								DrawImageBar("SPELLC0", spellsEffectSize+2, spellsEffectSize+2, effectsXpos-spellsEffectXYoffs, effectsYpos+spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								if (pmo.FindInventory("magicamaximize"))
									DrawImageBar("SPELLM00", spellsEffectSize+2, spellsEffectSize+2, effectsXpos-spellsEffectXYoffs, effectsYpos+spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								else
									DrawImageBar("SPELLM01", spellsEffectSize+2, spellsEffectSize+2, effectsXpos-spellsEffectXYoffs, effectsYpos+spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
							}
						}
						if (bitEffects[1]) { // Triplet magica
						
							if (!enhancementsAlways) {
								if (pmo.FindInventory("magicatriplet")) {
									DrawImageBar("SPELLC0", spellsEffectSize+2, spellsEffectSize+2, effectsXpos, effectsYpos, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
									DrawImageBar("SPELLT00", spellsEffectSize+2, spellsEffectSize+2, effectsXpos, effectsYpos, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								}
							} else {

								DrawImageBar("SPELLC0", spellsEffectSize+2, spellsEffectSize+2, effectsXpos, effectsYpos, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								if (pmo.FindInventory("magicatriplet"))
									DrawImageBar("SPELLT00", spellsEffectSize+2, spellsEffectSize+2, effectsXpos, effectsYpos, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								else
									DrawImageBar("SPELLT01", spellsEffectSize+2, spellsEffectSize+2, effectsXpos, effectsYpos, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
							}
						}
						if (bitEffects[2]) { // Widen magica

							if (!enhancementsAlways) {
								if (pmo.FindInventory("magicawiden")) {
									DrawImageBar("SPELLC0", spellsEffectSize+2, spellsEffectSize+2, effectsXpos+spellsEffectXYoffs, effectsYpos-spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
									DrawImageBar("SPELLW00", spellsEffectSize+2, spellsEffectSize+2, effectsXpos+spellsEffectXYoffs, effectsYpos-spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								}
							} else {
								
								DrawImageBar("SPELLC0", spellsEffectSize+2, spellsEffectSize+2, effectsXpos+spellsEffectXYoffs, effectsYpos-spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								if (pmo.FindInventory("magicawiden"))
									DrawImageBar("SPELLW00", spellsEffectSize+2, spellsEffectSize+2, effectsXpos+spellsEffectXYoffs, effectsYpos-spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
								else
									DrawImageBar("SPELLW01", spellsEffectSize+2, spellsEffectSize+2, effectsXpos+spellsEffectXYoffs, effectsYpos-spellsEffectXYoffs, 0, 1.0, (-1,-1), (spellsScale,spellsScale));
							}
						}
					}
				}

				// Draw spell text name
				if (spellSelected && CVar.GetCVar("OD_hud_spells_names", CPlayer).GetInt() && CPlayer.ReadyWeapon && CPlayer.ReadyWeapon.getClassName() == "spookyspell")
					DrawString(mMM2SmallFont, momongaSpells[i][k].name, (0, -faceYpos*2.1), DI_SCREEN_CENTER_BOTTOM | DI_TEXT_ALIGN_CENTER);
			}
		}
		
		
		// ================================================================================= INVENTORY BAR =================================================================================
		if (isInventoryBarVisible())
			DrawInventoryBar(diparms, (0, -96), 3, DI_SCREEN_CENTER_BOTTOM | DI_ITEM_HCENTER | DI_ITEM_BOTTOM);
		
		
		// ================================================================================= LEVEL STATS STUFF =================================================================================
		bool secrets = CVar.GetCVar("gzs_stats_secrets", CPlayer).GetInt();
		bool monsters = CVar.GetCVar("gzs_stats_monsters", CPlayer).GetInt();
		bool items = CVar.GetCVar("gzs_stats_items", CPlayer).GetInt();
		bool timer = CVar.GetCVar("gzs_stats_timer", CPlayer).GetInt();
		bool gametimer = CVar.GetCVar("gzs_stats_gametimer", CPlayer).GetInt();
		
		font fnt = "MM2SFNTO";
		int fntHeight = fnt.GetHeight();
		int y = 8;
		if (timer) {
			DrawString(mMM2SmallFont, level.TimeFormatted(), (-8, y), DI_SCREEN_RIGHT_TOP | DI_TEXT_ALIGN_RIGHT);
			y += fntHeight + 1;
		}
		if (gametimer) {
			DrawString(mMM2SmallFont, level.TimeFormatted(true), (-8, y), DI_SCREEN_RIGHT_TOP | DI_TEXT_ALIGN_RIGHT);
			y += fntHeight + 1;
		}
		
		y = 8;
		if (monsters) {
			DrawString(mMM2SmallFont, Stringtable.Localize("$AM_MONSTERS").." "..level.killed_monsters.."/"..level.total_monsters, (8, y));
			y += fntHeight + 1;
		}
		if (secrets) {
			DrawString(mMM2SmallFont, Stringtable.Localize("$AM_SECRETS").." "..level.found_secrets.."/"..level.total_secrets, (8, y));
			y += fntHeight + 1;
		}
		if (items) {
			DrawString(mMM2SmallFont, Stringtable.Localize("$AM_ITEMS").." "..level.found_items.."/"..level.total_items, (8, y));
			y += fntHeight + 1;
		}
	}
}
