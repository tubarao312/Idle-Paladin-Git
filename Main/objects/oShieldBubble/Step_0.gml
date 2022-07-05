// Particles Emitting Passively

if passiveParticleCount > 0 {

	part_emitter_region(global.part_system_normal, emitter, x+25, x-25, y-25, y+25, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_normal, emitter, particles1, passiveParticleCount);
	part_emitter_burst(global.part_system_normal, emitter, particles2, passiveParticleCount);
	part_emitter_burst(global.part_system_normal, emitter, particles3, passiveParticleCount);

	passiveParticleCount --;
}