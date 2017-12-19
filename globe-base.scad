/*import("/Users/jstevens/Downloads/3D Printing/Adafruit/Adafruit_ESP8266_Feather/files/Adafruit_ESP8266_Feather_1.STL");*/
/*import("/Users/jstevens/Downloads/3D Printing/Adafruit/feather-case.stl");*/

/*
Base outter 80
Inner Bottom 74.31
Inner Top D 66.56
*/

t = 0.4;
$fn = 100;
base_h = 3;

module holder(){
  module post(){ cylinder(h=5,d=2,center=true, $fn=10); }
  w = 46;
  d = 18;
  h = 3;
  x1 = 2.55;
  x2 = x1 + w;
  y1 = 2.5;
  y2 = y1 + d;
  translate([x1,y1,h]) post();
  translate([x1,y2,h]) post();
  translate([x2,y1-1,h]) post();
  translate([x2,y2+1,h]) post();
  difference() {
    cube([51,23,1]);
    translate([4,4,-1]) cube([51-8,23-8,3]);
  }
}
holder();

/*
module clip() {
  cylinder(h=base_h,d=80,center=true, $fn=3);
  d = 1;
  w = 3;
  h = 3;
  translate ([0,0,h]) rotate([180,0,0]) hull(){
    cube([w,1,d]);
    rotate([90,0,0]) cube([w,1,d]);
  }
  translate([h,-d,0]) cube([h,d,w]);
}
module clips(){
  translate([0,-1,0]) cube([51,25,1]);
  clip();
  mirror([1,0,0]) translate([-50,0,0]) clip();
  mirror([0,1,0]) translate([0,-23,0]) clip();
  translate([50,23,0]) mirror([1,0,0]) mirror([0,10,0]) clip();
}
clips();
*/

/*
cylinder(h=base_h,d=80,center=true);
translate([0,0,base_h]) cylinder(h=base_h,d=74.31-t,center=true);
*/
