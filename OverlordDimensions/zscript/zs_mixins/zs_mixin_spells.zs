struct spell {

	int id;
	int mana;
	string tx;
	Class<Inventory> cd;
	StateLabel state; // firing state
	StateLabel astate; // firing animation state
	//StateLabel cstate; // channeling animation state
	//double ypos;
	uint eff; // 3 bits for checking effects
	string name;
};

mixin Class SpellPropertiesList {

	const SPELLKEYS = 10;
	const SPELLSLOTS = 3;

	spell momongaSpells[SPELLKEYS][SPELLSLOTS];
	
	void setSpellProperties () {
		
		if (momongaSpells[0][0].id == 0) {
			
			momongaSpells[0][0].id = 1; // magic arrow
			momongaSpells[0][1].id = 2; // acid arrow
			momongaSpells[0][2].id = 3; // life essence
			momongaSpells[1][0].id = 4; // fireball
			momongaSpells[1][1].id = 5; // lightning
			momongaSpells[1][2].id = 6; // fly
			momongaSpells[2][0].id = 7; // shockwave
			momongaSpells[2][1].id = 8; // explode mine
			momongaSpells[2][2].id = 9; // anti-life cocoon
			momongaSpells[3][0].id = 10; // gravity maelstrom
			momongaSpells[3][1].id = 11; // wall of skeleton
			momongaSpells[3][2].id = 12; // greater teleportation
			momongaSpells[4][0].id = 13; // TBD
			momongaSpells[4][1].id = 14; // chain dragon lightning
			momongaSpells[4][2].id = 15; // undead army
			momongaSpells[5][0].id = 16; // astral smite
			momongaSpells[5][1].id = 17; // hell flame
			momongaSpells[5][2].id = 18; // negative burst
			momongaSpells[6][0].id = 19; // TBD - Hold of ribs (?)
			momongaSpells[6][1].id = 20; // black hole
			momongaSpells[6][2].id = 21; // true dark
			momongaSpells[7][0].id = 22; // grasp hearth
			momongaSpells[7][1].id = 23; // nuclear blast
			momongaSpells[7][2].id = 24; // body of refulgent beryl
			momongaSpells[8][0].id = 25; // summon undead 10th
			momongaSpells[8][1].id = 26; // reality slash
			momongaSpells[8][2].id = 27; // time stop
			momongaSpells[9][0].id = 28; // fallen down
			momongaSpells[9][1].id = 29; // TBD - Iä Shub-Niggurath (?)
			momongaSpells[9][2].id = 30; // TBD - Wish Upon A Star (?)
			momongaSpells[0][0].mana = 30; // magic arrow
			momongaSpells[0][1].mana = 60; // acmana arrow
			momongaSpells[0][2].mana = 20; // life essence
			momongaSpells[1][0].mana = 110; // fireball
			momongaSpells[1][1].mana = 130; // lightning
			momongaSpells[1][2].mana = 100; // fly
			momongaSpells[2][0].mana = 210; // shockwave
			momongaSpells[2][1].mana = 350; // explode mine
			momongaSpells[2][2].mana = 200; // anti-life cocoon
			momongaSpells[3][0].mana = 250; // gravity maelstrom
			momongaSpells[3][1].mana = 400; // wall of skeleton
			momongaSpells[3][2].mana = 240; // greater teleportation
			momongaSpells[4][0].mana = 180; // TBD
			momongaSpells[4][1].mana = 480; // chain dragon lightning
			momongaSpells[4][2].mana = 1100; // undead army
			momongaSpells[5][0].mana = 900; // astral smite
			momongaSpells[5][1].mana = 1400; // hell flame
			momongaSpells[5][2].mana = 500; // negative burst
			momongaSpells[6][0].mana = 690; // TBD - Hold of ribs (?)
			momongaSpells[6][1].mana = 1550; // black hole
			momongaSpells[6][2].mana = 650; // true dark
			momongaSpells[7][0].mana = 1000; // grasp hearth
			momongaSpells[7][1].mana = 1600; // nuclear blast
			momongaSpells[7][2].mana = 380; // body of refulgent beryl
			momongaSpells[8][0].mana = 1320; // summon undead 10th
			momongaSpells[8][1].mana = 1700; // reality slash
			momongaSpells[8][2].mana = 1180; // time stop
			momongaSpells[9][0].mana = 10001; // fallen down
			momongaSpells[9][1].mana = 10002; // TBD - Iä Shub-Niggurath (?)
			momongaSpells[9][2].mana = 10003; // TBD - Wish Upon A Star (?)
			momongaSpells[0][0].tx = "SPELL00";
			momongaSpells[0][1].tx = "SPELL01";
			momongaSpells[0][2].tx = "SPELL02";
			momongaSpells[1][0].tx = "SPELL10";
			momongaSpells[1][1].tx = "SPELL11";
			momongaSpells[1][2].tx = "SPELL12";
			momongaSpells[2][0].tx = "SPELL20";
			momongaSpells[2][1].tx = "SPELL21";
			momongaSpells[2][2].tx = "SPELL22";
			momongaSpells[3][0].tx = "SPELL30";
			momongaSpells[3][1].tx = "SPELL31";
			momongaSpells[3][2].tx = "SPELL32";
			momongaSpells[4][0].tx = "SPELL40";
			momongaSpells[4][1].tx = "SPELL41";
			momongaSpells[4][2].tx = "SPELL42";
			momongaSpells[5][0].tx = "SPELL50";
			momongaSpells[5][1].tx = "SPELL51";
			momongaSpells[5][2].tx = "SPELL52";
			momongaSpells[6][0].tx = "SPELL60";
			momongaSpells[6][1].tx = "SPELL61";
			momongaSpells[6][2].tx = "SPELL62";
			momongaSpells[7][0].tx = "SPELL70";
			momongaSpells[7][1].tx = "SPELL71";
			momongaSpells[7][2].tx = "SPELL72";
			momongaSpells[8][0].tx = "SPELL80";
			momongaSpells[8][1].tx = "SPELL81";
			momongaSpells[8][2].tx = "SPELL82";
			momongaSpells[9][0].tx = "SPELL90";
			momongaSpells[9][1].tx = "SPELL91";
			momongaSpells[9][2].tx = "SPELL92";
			momongaSpells[0][0].cd = "spellkeyoneCD1";
			momongaSpells[0][1].cd = "spellkeyoneCD2";
			momongaSpells[0][2].cd = "spellkeyoneCD3";
			momongaSpells[1][0].cd = "spellkeytwoCD1";
			momongaSpells[1][1].cd = "spellkeytwoCD2";
			momongaSpells[1][2].cd = "spellkeytwoCD3";
			momongaSpells[2][0].cd = "spellkeythreeCD1";
			momongaSpells[2][1].cd = "spellkeythreeCD2";
			momongaSpells[2][2].cd = "spellkeythreeCD3";
			momongaSpells[3][0].cd = "spellkeyfourCD1";
			momongaSpells[3][1].cd = "spellkeyfourCD2";
			momongaSpells[3][2].cd = "spellkeyfourCD3";
			momongaSpells[4][0].cd = "spellkeyfiveCD1";
			momongaSpells[4][1].cd = "spellkeyfiveCD2";
			momongaSpells[4][2].cd = "spellkeyfiveCD3";
			momongaSpells[5][0].cd = "spellkeysixCD1";
			momongaSpells[5][1].cd = "spellkeysixCD2";
			momongaSpells[5][2].cd = "spellkeysixCD3";
			momongaSpells[6][0].cd = "spellkeysevenCD1";
			momongaSpells[6][1].cd = "spellkeysevenCD2";
			momongaSpells[6][2].cd = "spellkeysevenCD3";
			momongaSpells[7][0].cd = "spellkeyeightCD1";
			momongaSpells[7][1].cd = "spellkeyeightCD2";
			momongaSpells[7][2].cd = "spellkeyeightCD3";
			momongaSpells[8][0].cd = "spellkeynineCD1";
			momongaSpells[8][1].cd = "spellkeynineCD2";
			momongaSpells[8][2].cd = "spellkeynineCD3";
			momongaSpells[9][0].cd = "spellkeyzeroCD1";
			momongaSpells[9][1].cd = "spellkeyzeroCD2";
			momongaSpells[9][2].cd = "spellkeyzeroCD3";
			momongaSpells[0][0].eff = 3; // magic arrow
			momongaSpells[0][1].eff = 5; // acid arrow
			momongaSpells[0][2].eff = 0; // life essence
			momongaSpells[1][0].eff = 2; // fireball
			momongaSpells[1][1].eff = 1; // lightning
			momongaSpells[1][2].eff = 1; // fly
			momongaSpells[2][0].eff = 1; // shockwave
			momongaSpells[2][1].eff = 3; // explode mine
			momongaSpells[2][2].eff = 5; // anti-life cocoon
			momongaSpells[3][0].eff = 1; // gravity maelstrom
			momongaSpells[3][1].eff = 4; // wall of skeleton
			momongaSpells[3][2].eff = 0; // greater teleportation
			momongaSpells[4][0].eff = 0; // TBD
			momongaSpells[4][1].eff = 0; // chain dragon lightning
			momongaSpells[4][2].eff = 0; // undead army
			momongaSpells[5][0].eff = 1; // astral smite
			momongaSpells[5][1].eff = 0; // hell flame
			momongaSpells[5][2].eff = 1; // negative burst
			momongaSpells[6][0].eff = 0; // TBD - Hold of ribs (?)
			momongaSpells[6][1].eff = 4; // black hole
			momongaSpells[6][2].eff = 1; // true dark
			momongaSpells[7][0].eff = 0; // grasp hearth
			momongaSpells[7][1].eff = 4; // nuclear blast
			momongaSpells[7][2].eff = 0; // body of refulgent beryl
			momongaSpells[8][0].eff = 0; // summon undead 10th
			momongaSpells[8][1].eff = 3; // reality slash
			momongaSpells[8][2].eff = 1; // time stop
			momongaSpells[9][0].eff = 0; // fallen down
			momongaSpells[9][1].eff = 0; // TBD - Iä Shub-Niggurath (?)
			momongaSpells[9][2].eff = 0; // TBD - Wish Upon A Star (?)
			momongaSpells[0][0].state = "attMagicArrow";
			momongaSpells[0][1].state = "attAcidArrow";
			momongaSpells[0][2].state = "attLifeEssence";
			momongaSpells[1][0].state = "attFireball";
			momongaSpells[1][1].state = "attLightning";
			momongaSpells[1][2].state = "attFly";
			momongaSpells[2][0].state = "attShockwave";
			momongaSpells[2][1].state = "attExplodeMine";
			momongaSpells[2][2].state = "attAntilifeCocoon";
			momongaSpells[3][0].state = "attGravityMaelstrom";
			momongaSpells[3][1].state = "attWallOfSkeleton";
			momongaSpells[3][2].state = "attGreaterTeleportation";
			momongaSpells[4][0].state = "ready";
			momongaSpells[4][1].state = "attDragonLightning";
			momongaSpells[4][2].state = "attUndeadArmy";
			momongaSpells[5][0].state = "attAstralSmite";
			momongaSpells[5][1].state = "attHellFlame";
			momongaSpells[5][2].state = "attNegativeBurst";
			momongaSpells[6][0].state = "ready";
			momongaSpells[6][1].state = "attBlackHole";
			momongaSpells[6][2].state = "attTrueDark";
			momongaSpells[7][0].state = "attGraspHearth";
			momongaSpells[7][1].state = "attNuclearBlast";
			momongaSpells[7][2].state = "attBodyOfRefulgentBeryl";
			momongaSpells[8][0].state = "attSummonUndead10th";
			momongaSpells[8][1].state = "attRealitySlash";
			momongaSpells[8][2].state = "attTimeStop";
			momongaSpells[9][0].state = "attFallenDown";
			momongaSpells[9][1].state = "ready";
			momongaSpells[9][2].state = "ready";
			momongaSpells[0][0].astate = "anHand";
			momongaSpells[0][1].astate = "anProjectile";
			momongaSpells[0][2].astate = "anNone";
			momongaSpells[1][0].astate = "anProjectile";
			momongaSpells[1][1].astate = "anFinger";
			momongaSpells[1][2].astate = "anNone";
			momongaSpells[2][0].astate = "anPalm";
			momongaSpells[2][1].astate = "anPalm";
			momongaSpells[2][2].astate = "anPalm";
			momongaSpells[3][0].astate = "anProjectile";
			momongaSpells[3][1].astate = "anNone";
			momongaSpells[3][2].astate = "anNone";
			momongaSpells[4][0].astate = "anHand";
			momongaSpells[4][1].astate = "anFinger";
			momongaSpells[4][2].astate = "anNone";
			momongaSpells[5][0].astate = "anPalm";
			momongaSpells[5][1].astate = "anFinger";
			momongaSpells[5][2].astate = "anNone";
			momongaSpells[6][0].astate = "anPalm";
			momongaSpells[6][1].astate = "anHand";
			momongaSpells[6][2].astate = "anPalm";
			momongaSpells[7][0].astate = "anGrasp";
			momongaSpells[7][1].astate = "anNone";
			momongaSpells[7][2].astate = "anNone";
			momongaSpells[8][0].astate = "anPalm";
			momongaSpells[8][1].astate = "anSlash";
			momongaSpells[8][2].astate = "anNone";
			momongaSpells[9][0].astate = "anSuper";
			momongaSpells[9][1].astate = "anSuper";
			momongaSpells[9][2].astate = "anSuper";
			momongaSpells[0][0].name = "Magic Arrow";
			momongaSpells[0][1].name = "Acid Arrow";
			momongaSpells[0][2].name = "Life Essence";
			momongaSpells[1][0].name = "Fireball";
			momongaSpells[1][1].name = "Lightning";
			momongaSpells[1][2].name = "Fly";
			momongaSpells[2][0].name = "Shockwave";
			momongaSpells[2][1].name = "Explode Mine";
			momongaSpells[2][2].name = "Anti-life Cocoon";
			momongaSpells[3][0].name = "Gravity Maelstrom";
			momongaSpells[3][1].name = "Wall of Skeleton";
			momongaSpells[3][2].name = "Greater Teleportation";
			momongaSpells[4][0].name = "TBD";
			momongaSpells[4][1].name = "Dragon Lightning";
			momongaSpells[4][2].name = "Undead Army";
			momongaSpells[5][0].name = "Astral Smite";
			momongaSpells[5][1].name = "Hell Flame";
			momongaSpells[5][2].name = "Negative Burst";
			momongaSpells[6][0].name = "TBD";
			momongaSpells[6][1].name = "Black Hole";
			momongaSpells[6][2].name = "True Dark";
			momongaSpells[7][0].name = "Grasp Hearth";
			momongaSpells[7][1].name = "Nuclear Blast";
			momongaSpells[7][2].name = "Body of Refulgent Beryl";
			momongaSpells[8][0].name = "Summon Undead 10th";
			momongaSpells[8][1].name = "Reality Slash";
			momongaSpells[8][2].name = "Time Stop";
			momongaSpells[9][0].name = "Fallen Down";
			momongaSpells[9][1].name = "TBD";
			momongaSpells[9][2].name = "TBD";
			return;
		}
	}

	void getSpellProperties (int spid, out spell sp) {

		for (int k = 0; k < SPELLSLOTS; k++)
			for (int i = 0; i < SPELLKEYS; i++)
				if (momongaSpells[i][k].id == spid) {
					
					sp.id = momongaSpells[i][k].id;
					sp.mana = momongaSpells[i][k].mana;
					sp.tx = momongaSpells[i][k].tx;
					sp.cd = momongaSpells[i][k].cd;
					sp.state = momongaSpells[i][k].state;
					sp.astate = momongaSpells[i][k].astate;
					//sp.cstate = momongaSpells[i][k].cstate;
					//sp.ypos = momongaSpells[i][k].ypos;
					sp.eff = momongaSpells[i][k].eff;
					sp.name = momongaSpells[i][k].name;
				}
	}
}

/*
class SpellsList {

	Dictionary SpellReg;

	override void PostBeginPlay () {
			
		super.PostBeginPlay();

		SpellReg = Dictionary.Create();
		SpellReg.Insert("SpellArrow", "30/spellkeyoneCD1/attackmagicarrow");
		SpellReg.Insert("SpellAcid", "60/spellkeyoneCD2/attackacidarrow");
	}

	void getSpellInfo (string spellID, out yggdrasilSpell spellInfo) {

		string spellInfoSerial = SpellReg.At(spellID);

		int num = spellInfoSerial.IndexOf(spellInfoSerial, "/");

		string str = spellInfoSerial.Left(num);
		
		spellInfo.spellID = str.ToInt(10);
		// TODO
	}
}
*/