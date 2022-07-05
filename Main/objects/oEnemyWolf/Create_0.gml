event_inherited();

spr = { // The enemy's sprites
	// Sprites that get drawn
	standing: sEnemyWolfIdle1,
	walking: sEnemyWolfWalking1,
	attacking: sEnemyWolfAttacking1,
	dying: sEnemyWolfDying1,
	
	// Shadow Sprite and Coordinates
	shadow: sWolfShadow,
	shadowRelX: 2,
	shadowRelY: 0,
}

mask_index = sEnemyWolfWalking1; // Collision Mask

enemyStats = { // The enemy's stats
	// Movement Stats
	walkSpd: random_range(1.1, 1.3), // The speed which this enemy walks at
	
	// Combat Stats
	maxHP: 12 * random_range(0.95, 1.05),
	attack: 4* random_range(0.95, 1.05),
	attackSpd: random_range(0.9, 1.1),
	
	// Range for starting certain states
	walkRange: random_range(100, 200),
	attackRange: 50,
	
	// AI Tracking
	enemy: oPlayer, // If the enemy needs to be changed, just change here
	
	// Player Melee
	canBeMeleed: true,
	canBeAttacked: true,
	
	// Whether this enemy can even attack
	canAttack: true,
	
	// Attack Hitbox
	attackHitboxRelX: -45,
	attackHitboxRelY: -20,
	attackHitboxWidth: 45,
	attackHitboxHeight: 40,
	attackHitboxDuration: 14,
	hitboxActivateIndex: 2,
	
	// VFX Size for getting hit
	effectsSize: 0.8,
	
	// HP Bar Information
	hpBarType: HPBAR_MEDIUM,
	hpBarRelX: -20,
	hpBarRelY: -17,
}

enemyStats.hp = enemyStats.maxHP;
meleeHit.vars.damage = enemyStats.attack;