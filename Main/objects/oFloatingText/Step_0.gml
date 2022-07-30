alpha = lerp(alpha,-0.25,0.05)

if alpha <= 0 then instance_destroy()

yspd = lerp(yspd,0,0.05)
y -= max(yspd,0)

hsp += hacc
vsp += vacc

x += hsp
y += vsp

shake = lerp(shake, 0, 0.1);