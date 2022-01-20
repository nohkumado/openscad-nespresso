wd= 3;
height= 50;
typ = "vertuo_diavolito";// ["vertuo_diavolito"), "vertuo_colombia")]
//typ = "vertuo_colombia";

//halter(typ= typ,h=height, wd=wd, flat=true);
//halter2(typ= typ,h=height, wd=wd, flat=true);
halter3(typ= typ,h=height, wd=wd, flat=true);
//translate([70,0,0]) halter(typ= "vertuo_colombia",h=height, wd=wd, flat=true);
//schachtel(typ=typ, xcenter = false, wd= wd, renfort=true);
//schachtel(typ=typ, xcenter = true, wd= wd, renfort=false);
//schachtel2D(typ=typ, xcenter = true, wd= wd,h=height, renfort=true);

//translate([70,0,0]) schachtel(typ="vertuo_colombia", center = false, xcenter = true);
function nespresso_formats(typ = "regular")=
(typ == "vertuo_diavolito")?[61,52]:
(typ == "vertuo_colombia")?[61,66]:
[37,38]
;

module halter(typ= typ, wd=wd, h=50, flat= false)
{
  grundf = nespresso_formats(typ);
  translate([0,(flat)?(grundf[1]+wd)/2:0,0])
    //difference()
    {
      union()
      {
	%schachtel(typ=typ, xcenter = true, wd= wd, h=h, renfort=true);
      }
      translate([0,0,wd])
	union()
	{
	  schachtel(typ=typ, xcenter = true );
	  //translate([0,-grundf[1]/2,wd]) cube([grundf[0]-2*wd,2*wd,grundf[1]-2*wd], center = true);
	  translate([0,-grundf[1]/2-wd,wd]) 
	   color("red") aussparung(grundf, wd);
	}
    }
}
module halter2(typ= typ, wd=wd, h=50, flat= false)
{
  grundf = nespresso_formats(typ);
  zsiz = grundf[1]-22+wd;
  translate([0,(flat)?(grundf[1]+wd)/2:0,0])
  {
    difference()
    {
      union()
      {
	schachtel(typ=typ, xcenter = true, wd= wd, h=h, renfort=false);
	color("red")
	  translate([-wd,-22+1.8*wd,-zsiz])
	  cube([2*wd,(grundf[1]+wd)-22*sin(45),zsiz], center = false);
      }
      translate([0,0,wd])
	union()
	{
	  schachtel(typ=typ, xcenter = true );
	  //translate([0,-grundf[1]/2,wd]) 
	  translate([0,-grundf[1]/2-wd,wd]) 
	   color("red") aussparung(grundf, wd);
	}
    }
	  translate([0,-grundf[1]/2-wd/2,1.5*wd]) 
	   color("red") aussparung(grundf=[grundf[0]-2*wd, grundf[1]-2*wd], wd=wd/2, frad=20-wd);
  }
	//color("red") aussparung(grundf, wd);
}
module halter3(typ= typ, wd=wd, h=50, flat= false)
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

function addRenfort(renfort, alist)= (!renfort)?  concat([each(alist)],[[9,8,7,6]]):
concat([each(alist)],[
    //klappe hinten
    [9,14,12,6],[7,15,17,8],
    [13,12,14],//right
    [15,16,17],//left
    [13,16,15,12],//front
    [14,17,16,13]//bottom
    ]
    );
module schachtel(typ="vertuo", center = false, xcenter = false, wd= 0, h = 275, renfort=false)
{
  grundf = [ nespresso_formats(typ)[0]+wd,nespresso_formats(typ)[1]+wd];
  x0 = (xcenter||center)? -grundf[0]/2:0;
  x1 = (xcenter||center)? grundf[0]/2:grundf[0];
  y0 = (xcenter||center)? -grundf[1]/2:0;
  y1 = (xcenter||center)? grundf[1]/2:grundf[1];
  z0 = (center)? h/2:h;
  z1 = (center)? -h/2:0;
  z2 = z1-grundf[1];
  lh = sqrt(2*22^2);

  points = 
    [
    [x1,y0, z0],//0
    [x0,y0, z0],//1
    [x0,y1, z0],//2
    [x1,y1, z0],//3


    [x1,y0, z1],//4
    [x0,y0, z1],//5
    [x0,y1, z1],//6
    [x1,y1, z1],//7


    [x1,y0+22*cos(45), z2+22 ],//8
    [x0,y0+22*cos(45), z2+22 ],//9

    [x1,y0, z2+lh],//10
    [x0,y0, z2+lh],//11
		   //mitte unten
    [x0+grundf[0]/2-wd,y1, z1],//12
    [x0+grundf[0]/2-wd,y1, z2+22],//13 //mitte ganzunten
    [x0+grundf[0]/2-wd,y0+22*cos(45), z2+22 ],//14

    [x0+grundf[0]/2+wd,y1, z1],//15
    [x0+grundf[0]/2+wd,y1, z2+22],//16 //mitte ganzunten
    [x0+grundf[0]/2+wd,y0+22*cos(45), z2+22 ],//17
    ];

  faces =
    [
    //grundfläche oben
    [0,1,2,3],

    //[5,1,0,4],//front square
    [11,1,0,10],//front lip
		//[6,2,1,5],//left square
    [9,6,2,1,11],//left lip
    [7,3,2,6], //back
	       //[4,0,3,7], //right square
    [8,10,0,3,7], //right lip

    //grundfläche unten
    //	  [4,5,6,7],
    //klappe vorne
    [8,9,11,10],

    ];

    //  (!renfort)?  [9,8,7,6]:each([9,14,12,6],[7,15,17,8]),
    //  //(!renfort)?  [       ]:[7,15,17,8],
    //  //Stütze r
    //  (renfort)?[13,12,14]:[],//right
    //  (renfort)?[15,16,17]:[],//left
    //  (renfort)?[13,16,15,12]:[],//front
    //  (renfort)?[14,17,16,13]:[],//bottom
    //  //(renfort)?[15,12,14,17]:[],//bottom
    polyhedron(points, addRenfort(renfort,faces));
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
