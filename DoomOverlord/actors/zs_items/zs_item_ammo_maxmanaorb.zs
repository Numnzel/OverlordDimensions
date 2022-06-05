class maxmanaorb : CustomInventory {

	states {
		spawn:
			IFOG DE 4;
			loop;
		pickup:
			TNT1 A 0;
			TNT1 A 0 A_GiveInventory("maxmana", 1);
			TNT1 A 0 A_GiveInventory("manaorb", 1);
			stop;
	}
}