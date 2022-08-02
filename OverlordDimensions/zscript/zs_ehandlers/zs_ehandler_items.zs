
class ItemHandler : StaticEventHandler {

	Dictionary replacements;

	void AddToDictionary (out Dictionary dict, string lump) {
		
		int lumpID = Wads.CheckNumForFullName(lump);

		if (lumpID == -1)
			return;
		
		Array<String> fileContent;
		Wads.ReadLump(lumpID).Split(fileContent, "\n");

		for (int i = 0; i < fileContent.Size(); i++) {

			Array<String> serial;
			fileContent[i].Split(serial, "=");

			if (serial.Size() == 2) {
				serial[1].StripRight("\r");
				dict.Insert(serial[0], serial[1]);
			}
		}
	}

	void CreateDictionary () {

		replacements = Dictionary.Create();

		string rootdir = "databases/";
		
		switch (gameinfo.gametype) {
			case GAME_Doom:
				AddToDictionary(replacements, rootdir .. "replacements.doom.txt"); break;
			case GAME_Heretic:
				AddToDictionary(replacements, rootdir .. "replacements.heretic.txt"); break;
			case GAME_Hexen:
				AddToDictionary(replacements, rootdir .. "replacements.hexen.txt"); break;
		}
		
		AddToDictionary(replacements, rootdir .. "replacements.txt");
	}

	override void OnRegister () {
		
		CreateDictionary();
	}

	override void CheckReplacement (ReplaceEvent e) {
		
		string i = GetDefaultByType(e.Replacee).getClassName();
		e.Replacement = replacements.At(i);
	}

	override void WorldThingSpawned (WorldEvent e) {

		// This is deleting the items dropped by enemies
		if (e.Thing is "inventory") {

			inventory i = inventory(e.Thing);
			if (e.Thing.getClassName() != "maxmanaspeckdrop" && i.bTOSSED) i.setState(null);
		}
		else if (e.Thing.bIsMonster) {

			if (e.Thing.getClassName() == "Lostsoul" && e.Thing.CheckProximity("Painelemental", 128.0, 1, CPXF_SETMASTER|CPXF_CLOSEST))
				if (e.Thing.master && e.Thing.master.getClassName() == "PainElemental" && e.Thing.master.getAge() > e.Thing.getAge())
					return;

			inventory droppedItem = e.Thing.GiveInventoryType("maxmanaspeckdrop");
			droppedItem.owner = e.Thing;
		}
	}

	override void WorldThingRevived (WorldEvent e) {

		if (e.Thing.bIsMonster && e.Thing.CountInv("maxmanaspeckdrop") > 0)
			e.Thing.TakeInventory("maxmanaspeckdrop", 1);
	}
}