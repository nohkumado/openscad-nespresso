wd= 2;
typ = "vertuo_diavolito";

//halter(typ= typ, wd=wd, flat=true);
//translate([70,0,0]) halter(typ= "vertuo_colombia", wd=wd, flat=true);
//schachtel(typ=typ, xcenter = false, wd= wd, renfort=true);
//schachtel(typ=typ, xcenter = true, wd= wd, renfort=false);

difference()
{
  schachtel(typ=typ, xcenter = true, wd= wd, renfort=true, h=50);
  color("red")
    translate([90,0,wd]) schachtel(typ=typ, xcenter = true, wd= 0, renfort=false);
}

//translate([70,0,0]) schachtel(typ="vertuo_colombia", center = false, xcenter = true);
function nespresso_formats(typ = "regular")=
(typ == "vertuo_diavolito")?[61,52]:
(typ == "vertuo_colombia")?[61,66]:
[37,38]
;

module halter(typ= typ, wd=wd, h=50, flat= false)
{
  grundf = nespresso_formats(typ);
  translate([0,(flat)?grundf[1]/2+wd:0,0])
    difference()
    {
      schachtel(typ=typ, xcenter = true, wd= wd, h=h, renfort=true);
      translate([0,0,wd])
	union()
	{
	  schachtel(typ=typ, xcenter = true );
	  //translate([0,-grundf[1]/2,wd]) cube([grundf[0]-2*wd,2*wd,grundf[1]-2*wd], center = true);
	}
    }
  //color("red")
  //  translate([0,grundf[1]/2,h-0.1+5])
  //  {
  //    difference()
  //    {
  //      cube([grundf[0]+1*wd, wd, 10], center = true);
  //      union()
  //      {
  //        translate([-grundf[0]/2+10,0,0]) rotate([90,0,0]) cylinder(d=5, h=4*wd, center = true, $fn=20);
  //        translate([grundf[0]/2-10,0,0]) rotate([90,0,0]) cylinder(d=5, h=4*wd, center = true, $fn=20);
  //      }
  //    }
  //  }
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
