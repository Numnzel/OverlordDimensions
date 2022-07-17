
class ItemHandler : StaticEventHandler {

	Dictionary replacements;

	void CreateDictionary () {

		replacements = Dictionary.Create();

		int lump = -1;
		while (-1 != (lump = Wads.FindLump("replacements", lump + 1))) {
			
			Array<String> lines;
			//console.printf("%s", Wads.ReadLump(lump));
			string txt = Wads.ReadLump(lump);
			txt.Split(lines, "\n");

			for (int i = 0; i < lines.Size(); i++) {

				Array<String> replacement;
				lines[i].Split(replacement, "=");

				if (replacement.Size() == 2) {
					replacement[1].StripRight("\r");
					replacements.Insert(replacement[0], replacement[1]);
					//console.printf("replaced: %s replacee: %s", replacement[0], replacement[1]);
				}
			}
		}

		//console.printf(replacements.toString());
	}

	override void OnRegister () {
		
		CreateDictionary();
	}

	override void CheckReplacement (ReplaceEvent e) {
		
		string i = GetDefaultByType(e.Replacee).getClassName();
		e.Replacement = replacements.At(i);
	}

	override void WorldThingSpawned (WorldEvent e) {

		// This is deleting the smallmanaorb (clip) dropped by zombies
		if (e.Thing.getClassName() == "smallmanaorb") {

			inventory i = inventory(e.Thing);
			if (i.bTOSSED) i.setState(null);
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

		if (e.Thing.bIsMonster) {

			if (e.Thing.CountInv("maxmanaspeckdrop") > 0)
				e.Thing.TakeInventory("maxmanaspeckdrop", 1);
		}
	}
}