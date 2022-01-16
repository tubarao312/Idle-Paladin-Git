event_inherited();

spr = { // The enemy's sprites
	// Sprites that get drawn
	standing: sEnemyMinotaurIdle,
	walking: sEnemyMinotaurWalking,
	attacking: sEnemyMinotaurAttacking,
	dying: sEnemyMinotaurDying,
	
	// Shadow Sprite and Coordinates
	shadow: sMinotaurShadow,
	shadowRelX: 2,
	shadowRelY: 0,
}

mask_index = sEnemyMinotaurWalking; // Collision Mask

enemyStats = { // The enemy's stats
	// Movement Stats
	walkSpd: random_range(0.7, 0.9), // The speed which this enemy walks at
	
	// Combat Stats
	maxHP: 25 * random_range(0.95, 1.05),
	attack: 45 * random_range(0.95, 1.05),
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
	canAttack: true,
	
	// Attack Hitbox
	attackHitboxRelX: -85,
	attackHitboxRelY: -20,
	attackHitboxWidth: 85,
	attackHitboxHeight: 40,
	attackHitboxDuration: 7,
	hitboxActivateIndex: 10,
	
	// VFX Size for getting hit
	effectsSize: 1,
	
	// HP Bar Information
	hpBarType: HPBAR_BIG,
	hpBarRelX: -30,
	hpBarRelY: -27,
}
enemyStats.hp = enemyStats.maxHP;

meleeHit.vars.damage = enemyStats.attack;