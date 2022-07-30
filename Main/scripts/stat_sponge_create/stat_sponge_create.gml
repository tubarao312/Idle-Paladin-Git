function stat_sponge_create() {
	var statSponge = {
		// Attributes
		dex: 0,
		str: 0,
		int: 0,
		mind: 0,
		vitality: 0,
		endurance: 0,
		baseDamage: 0,
		baseDefense: 0,
		
		// Health
		maxHP: 0,
		hpRegen: 0,
	
		// Melee
		meleeDamage: 0,
		critChance: 0,
		critDamage: 0,
	
		// Spells
		spellPower: 0,
	
		// Mana
		maxMana: 0,
		manaHitRecoveryRate: 0,
	
		// Movement Speed
		spd: 0,
		restingSpdPenalty: 0,
	
		// Stamina
		maxStamina: 0,
		restingStaminaRecov: 0,
		passiveStaminaRecov: 0,
	}
	
	return statSponge;
}