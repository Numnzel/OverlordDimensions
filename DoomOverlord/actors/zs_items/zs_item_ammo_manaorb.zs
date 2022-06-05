class manaorb : CustomInventory {

	states {
		spawn:
			IFOG DE 4;
			loop;
		pickup:
			TNT1 A 0;
			TNT1 A 0 {
				for (int manac = 50; manac > 0; manac--) {
					
					A_GiveInventory("manaunit", 1);
				}
			}
			stop;
	}
}
