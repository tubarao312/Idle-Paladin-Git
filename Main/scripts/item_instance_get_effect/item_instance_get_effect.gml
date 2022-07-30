function item_instance_get_effect(instance) {
	
	// Fecth the item's stats
	var stats = item_instance_get_stats(instance);
	
	// Attributes stored within the effect
	var attributes = {
		stats: stats,
	}
	
	// Name that identifies the effect
	var name = global.itemTypeNames[instance.bp.type];

	// Function that changes the stat sponge every time it is ran
	var step = function(attributes, statSponge) {
		var i;
		for (i = 0; i < ds_list_size(attributes.stats); i++) {
			var stat = attributes.stats[|i];
			var value = stat_get_quantity(stat);
			var ID  = stat.bp.ID;
			
			switch (ID) {
				case STATS.Dex:			statSponge.dex			+= value;  break;
				case STATS.Int:			statSponge.int			+= value;  break;
				case STATS.Str:			statSponge.str			+= value;  break;
				case STATS.Mind:		statSponge.mind			+= value;  break;
				case STATS.Vit:			statSponge.vitality		+= value;  break;
				case STATS.End:			statSponge.endurance	+= value;  break;
				case STATS.BaseDamage:	statSponge.baseDamage	+= value;  break;
				case STATS.BaseDefense:	statSponge.baseDefense	+= value;  break;
			}	
		}
	}
	
	return effect_create(step, name, attributes);
}