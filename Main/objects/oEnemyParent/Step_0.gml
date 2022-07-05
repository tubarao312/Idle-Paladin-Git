update_step();

if enemyStats.canBeAttacked then read_hits_taken_list();
else ds_list_clear(hitsTaken);

superstate_machine_update(superstateMachine);