
inner_ring = 22;
h = 5;
difference(){
    cylinder(h=h,d=inner_ring,center=true);
    cylinder(h=h+1,d=inner_ring-2,center=true);
}

translate ([0,0,h*-0.5])cylinder(h=1,d=40,center=true);
