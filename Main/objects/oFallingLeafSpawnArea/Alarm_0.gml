alarm[0] = spawnPeriod * 3;

var angle = random_range(0,360);
var spawnRadius = random_range(0, radius);

instance_create_depth(x + dcos(angle) * spawnRadius, y + dsin(angle) * spawnRadius, depth, oFallingLeaf);