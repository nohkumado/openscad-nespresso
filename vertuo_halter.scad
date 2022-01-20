wd= 3;
height= 50;
typ = "vertuo_diavolito";// ["vertuo_diavolito"), "vertuo_colombia")]
			 //typ = "vertuo_colombia";

halter(typ= typ,h=height, wd=wd, flat=true);

function nespresso_formats(typ = "regular")=
(typ == "vertuo_diavolito")?[61,52]:
(typ == "vertuo_colombia")?[61,66]:
[37,38]
;

module halter(typ= typ, wd=wd, h=50, flat= false)
{
  grundf = nespresso_formats(typ);
  zoom = [
    (wd != 0)?(grundf[0]+2*wd)/grundf[0]:1,
    (wd != 0)?(grundf[1]+2*wd)/grundf[1]:1,
    (wd != 0)?(h+2*wd)/h:1,
  ];
  translate([0,(flat)?(grundf[1]+wd)/2:0,0])
    difference()
    {
      union()
      {
	scale(zoom)
	  schachtel2D(typ=typ, xcenter = true, wd= wd, h=h, renfort=true);
      }
      translate([0,0,2*wd])
	union()
	{
	  schachtel2D(typ=typ, xcenter = true );
	  //translate([0,-grundf[1]/2,wd]) cube([grundf[0]-2*wd,2*wd,grundf[1]-2*wd], center = true);
	  translate([0,-.1,wd+grundf[1]-22*cos(45)]) 
	    color("red") aussparung(grundf, wd);
	}
    }
}

module aussparung(grundf,wd, frad= 20)
{
  zsiz = grundf[1]-22*cos(45);
  translate([0,wd,wd-(zsiz-11)/2-wd/2+5]) cube([grundf[0]-2*wd,2*wd,(zsiz-11)-wd+10], center = true);
  translate([0,wd,4.9+frad/2]) cube([frad,2*wd,frad], center = true);
  translate([0,wd,4.9+frad]) rotate([90,0,0])cylinder(d= frad, h= 2*wd, center = true);
}

module schachtel2D(typ="vertuo", center = false, xcenter = false, wd= 0, h = 275, renfort=false)
{
  grundf = [ nespresso_formats(typ)[0],nespresso_formats(typ)[1]];
  lh = sqrt(2*22^2);
  x0 = (xcenter||center)? 0:grundf[0]/2;
  y0 = (xcenter||center)? 0:grundf[1]/2;
  z0 = (center)? 0:h/2+grundf[1]-22*cos(45);

  translate([x0,y0,z0])
    rotate([0,90,0])
    translate([-h/2,-grundf[1]+wd,-grundf[0]/2])
    union()
    {
      points = 
	[
	[0,0],//0
	[h,0],//1
	[h+grundf[1]-(22*cos(45)),grundf[1]-(22*sin(45))],//2
	[h+grundf[1]-lh,grundf[1]],//3
	[h,grundf[1]],//1
	[0,grundf[1]],//4
	];

      linear_extrude(height=grundf[0])
	polygon(points);

      if(renfort)
      {
	pointsR = 
	  [
	  [h,0],//1
	  [h+grundf[1]-22*cos(45),grundf[1]-22*sin(45)],//2
	  [h+grundf[1]-22*cos(45),0],//3
	  ];
	translate([0,0,grundf[0]/2])
	  linear_extrude(height=2*wd, center= true)
	  polygon(pointsR);
      }
    }
}
