y -= 0.5
x += hsp-2

hsp = min(oPlayer.mov.hsp,hsp)

alpha -= 0.1
if alpha <= 0 then instance_destroy()