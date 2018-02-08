/*import("/Users/jstevens/Downloads/3D Printing/Adafruit/Adafruit_ESP8266_Feather/files/Adafruit_ESP8266_Feather_1.STL");*/
/*import("/Users/jstevens/Downloads/3D Printing/Adafruit/feather-case.stl");*/

t = 0.4;
$fn = 100;

module huzzah_holder(use_holder){
  base_w = 23;
  w = 46.5;
  d = 18;
  h = -1;
  x1 = 2.55;
  x2 = x1 + w;
  y1 = 2.5;
  y2 = y1 + d;
  cabel_w = 12.5;
  cabel_d = 30;
  module post(){ cylinder(h=8,d=2,center=true, $fn=10);}
  module holder() {
    translate([x1,y1,h]) post();
    translate([x1,y2,h]) post();
    //translate([x2,y1-0.5,h]) post();
    //translate([x2,y2+0.5,h]) post();
    /*difference() {
      cube([51,base_w,1]);
      translate([4,4,-1]) cube([51-8,base_w-8,3]);
    }*/
  }
  module hole () {
    cube([51,base_w, 10]);
    translate([-10,base_w/2,10]) cube([cabel_d,cabel_w,20], center=true);
  }

  if (use_holder) {
    holder();
  }
  else{
    hole();
  }
}


/*
Base outter 80
Inner Bottom 74.31
Inner Top D 66.56
*/
base_h = 10;
lower_base = 80;
upper_base = 74.31+.6;
upper_base_top = 66.56+3;
upper_base_h = base_h-5;

module globe_base() {
  module globe_main(){
    cylinder(h=base_h,d=80,center=true);
    /*translate([0,0,base_h/2]) cylinder(h=upper_base_h,d=upper_base_top,center=true);*/
    translate([0,0,base_h/2]) cylinder(h=upper_base_h,d=74.31-t,center=true);
  }

  difference(){
    globe_main();
    translate([0,0,16]) cylinder(h=base_h*4,d=74.31-t-3,center=true);
  }
}

module clip() {
  h = 5;
  half_h = h/2;
  stick_h = 29 - 2 - 3;
  module cone(){
    translate([-1,0,stick_h * -0.5]) cylinder(h=stick_h, d1=h+4, d2=2);
  }

  translate([upper_base_top * 0.49,0,upper_base_h]){
    translate([0,h*.5,stick_h * .4]) rotate([90,0,0]) cylinder(h=h,d=h, $fn=3);
    translate([-.75,0,-3]){
      cube([1,h,stick_h], center=true);
      cone();
    }
  }
}

module clips(){
  module clip_ring(){
    translate([0,0,0]) difference(){
      cylinder(h=1,d=upper_base_top, center=true);
      cylinder(h=2,d=upper_base_top - 5, center=true);
    }
  }
  translate([0,0,upper_base_h * 1.1]) rotate([0,0,45]){
    //clip_ring();
    /*translate([0,0,20]) clip_ring();*/
    clip();
    rotate([0,0,90]) clip();
    rotate([0,0,-90]) clip();
    rotate([0,0,180]) clip();
  }
}
clips();

translate ([upper_base * -0.4,upper_base * -0.15,0]) huzzah_holder(true);

difference() {
  globe_base();
  translate ([upper_base * -0.25,upper_base * -0.15,-4]) huzzah_holder(false);
}
