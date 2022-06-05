version "4.3.0"

#include "actors/zs_weapons/zs_weapon.zs"
#include "actors/zs_projectiles/zs_projectile.zs"
#include "actors/zs_sfx/zs_sfx.zs"
#include "actors/zs_items/zs_item.zs"
#include "actors/zs_others/zs_other.zs"
#include "actors/zs_powerups/zs_powerup.zs"
#include "zscript/zs_hud/zs_hud.zs"

/*
class repa : inventory
{
	override void DoEffect()
	{
		let arm = Owner.FindInventory("BasicArmor", true);
		if (arm != null) {
			arm.Amount += 1;
		}
	}
	
	states
	{
	spawn:
		CLIP A -1;
		stop;
	}
}

class packback : backpack
{

	override bool HandlePickup (Inventory item)
	{
		if(owner.FindInventory("backpack", true) == null) return super.HandlePickup(item);
		
		if(owner.FindInventory("backpack", true) != null)
		{//assuming that if player already have backpack in pocket it already have all necessary ammo
		  for (let probe = Owner.Inv; probe != NULL; probe = probe.Inv)
		  {
			 if (probe.GetParentClass() == 'Ammo')
			 {
				probe.MaxAmount += Ammo(probe).Default.BackpackMaxAmount;
				
				if (probe.Amount < probe.MaxAmount || sv_unlimited_pickup)
				{
				   int amount = Ammo(probe).Default.BackpackAmount;
				   // extra ammo in baby mode and nightmare mode
				   if (!bIgnoreSkill)
				   {
					  amount = int(amount * G_SkillPropertyFloat(SKILLP_AmmoFactor));
				   }
				   probe.Amount += amount;
				   if (probe.Amount > probe.MaxAmount && !sv_unlimited_pickup)
				   {
					  probe.Amount = probe.MaxAmount;
				   }
				}
			 }
		  }
	   }
	   item.bPickupGood = true;
	   return true;
	}

}
*/