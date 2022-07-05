// Emitting Particles

particleSpawnCount += particleSpawnRate;
var particlesToSpawn = floor(particleSpawnCount);
particleSpawnCount -= particlesToSpawn;
	
part_emitter_region(global.part_system_fire_smoke, emitter1, x-radius, x+radius, y, y+3, ps_shape_ellipse, ps_distr_linear);

if random_range(0, 1) > 0.5 {
	part_emitter_burst(global.part_system_fire_smoke, emitter1, particle1, particlesToSpawn);
} else {
	part_emitter_burst(global.part_system_fire_smoke, emitter1, particle2, particlesToSpawn);
}

part_emitter_burst(global.part_system_fire_smoke, emitter1, particle3, particlesToSpawn);