event_inherited();

spr = { // The enemy's sprites
	// Sprites that get drawn
	standing: sEnemyGhostIdle,
	walking: sEnemyGhostWalking,
	attacking: sEnemyGhostDying,
	dying: sEnemyGhostDying,
	
	// Shadow Sprite and Coordinates
	shadow: noone,
	shadowRelX: 2,
	shadowRelY: 0,
}

mask_index = sEnemyGhostIdle; // Collision Mask

enemyStats = { // The enemy's stats
	// Movement Stats
	walkSpd: random_range(0.7, 0.9), // The speed which this enemy walks at
	
	// Combat Stats
	maxHP: 5 * random_range(0.95, 1.05),
	attack: 5,
	attackSpd: random_range(0.9, 1.1),
	
	// Range for starting certain states
	walkRange: random_range(200, 300),
	attackRange: random_range(100, 130),
	
	// AI Tracking
	enemy: oPlayer, // If the enemy needs to be changed, just change here
	
	// Player Melee
	canBeMeleed: true,
	canBeAttacked: true,
	
	// Whether this enemy can even attack
	canAttack: false,
	
	// Attack Hitbox
	attackHitboxRelX: -85,
	attackHitboxRelY: -20,
	attackHitboxWidth: 85,
	attackHitboxHeight: 40,
	attackHitboxDuration: 7,
	hitboxActivateIndex: 10,
	
	// VFX Size for getting hit
	effectsSize: 0.6,
	
	// HP Bar Information
	hpBarType: HPBAR_SMALL,
	hpBarRelX: -14,
	hpBarRelY: -13,
}
enemyStats.hp = enemyStats.maxHP;