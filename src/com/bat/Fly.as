package com.bat
{
	import flash.geom.ColorTransform;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.*;
	import flash.display.Sprite;
	
	public class Fly extends Sprite
	{
		var par:Object;
		public var body:Shape;
		public var ghost:Shape;
		var m:Number = 1;
		public var xx:Number = 0;
		public var yy:Number = 0;
		var lastxx:Number = 0, lastyy:Number = 0;
		
		var fps = 30;
		var speed = 2;
		
		var pi = 3.14159;
		
		public var chief:Fly = null;
		
		public var vmin = 1 * speed;
		public var vmax = 1.5 * speed;
		
		public var vrun = 1.5 * speed;//4 * speed;
		public var rrun = 350;
		public var vgr = 1.5 * speed;
		public var rgr = 10;
		
		
		var radius = 0;
		var angle = 0;
		var magn = 2;
		var dna = 0;
		var dnr = 0;
		var dnm = 0;
		
		var frames = 20;
		var fmin = 3;
		var fmax = 30;
		var curframe = 0;
		public var ghostcountdown:int;
		var MinX, MaxX, MinY, MaxY;
		
		public var dead:Boolean = false;

		public function Fly(p:Object, posx:Number, posy:Number)
		{
			angle = (Math.random() - 0.5) * 2 * pi;

			par = p;
			
			setBounds();			
			body = new Shape();
			ghost = new Shape();
			paint();
			addChild(body);
			addChild(ghost);
			ghost.visible = false;

			xx = posx;
			yy = posy;
			setNewSpeed();

			addEventListener('enterFrame', entfr);
			entfr();
		}
		
		public function setm(mgn:Number){
			m = mgn;
			paint();
		}
		
		public function paint(){
			body.graphics.clear();
			body.graphics.beginFill(par.colorfly);
			body.graphics.moveTo( -3 * m, -3 * m);
			body.graphics.lineTo(0, 0);
			body.graphics.lineTo(3*m, -3*m)

			//body.graphics.drawCircle(0, 0, 3 * m);
			body.graphics.endFill();

			ghost.graphics.clear();
			ghost.graphics.beginFill(par.colorflyghost);
			ghost.graphics.drawCircle(0, 0, 3 * m);
			ghost.graphics.endFill();
		}
		
		public function paintJustFly() {
			body.graphics.clear();
			body.graphics.beginFill(par.colorfly);
			if(Math.round(Math.random()) == 0) {
				body.graphics.moveTo( -4 * m, -2 * m);
				body.graphics.lineTo(0, 2 * m);
				body.graphics.lineTo(4 * m, -2 * m)
			} else {
				body.graphics.clear();
				body.graphics.beginFill(par.colorfly);
				body.graphics.moveTo( -4 * m, 0);
				body.graphics.lineTo(0, 2 * m);
				body.graphics.lineTo(4 * m, 0)
			}

			body.graphics.endFill();
		}
		
		public function setBounds()
		{
			var muhd = m * 10;
			MinX = muhd;
			MaxX = par.wdth - muhd;
			MinY = muhd;
			MaxY = par.hght - muhd;
		}
		
		public function entfr(e:Event=null):void
		{
			if (visible) {
				this.paintJustFly();
				var zx1 = xx;
			   var zy1 = yy;
			   while(zx1 < 0) zx1 += par.wdth;
			   while(zy1 < 0) zy1 += par.hght;
				
			   var batdist;
			   if (par.bat == null) {
				  batdist = 500; 
			   }else {
				   batdist = distance(par.bat.x, par.bat.y + 30 * par.bat.m, zx1 % par.wdth, zy1 % par.hght) / m;
				   if(ghost.visible){
					ghostcountdown--;
					var al = ghostcountdown / 30;
					
					
					ghost.scaleX = (1 + al * 3);
					ghost.scaleY = (1 + al * 3);
					if(ghostcountdown < 0){
						visible = false;
						par.flies.promote();
					} 
				   }else if (par.bat.visible && batdist < 25 /*&& par.bat.numflies < 15*/) {
					  dead = true; 
					body.visible = false;
					ghost.visible = true;
					ghostcountdown = 1 * 30;
					//par.bat.numflies += 1;
					//par.bat.paintFlies();
					//par.bat.paint()
				   }
			   }
			   
			   
		       if(curframe > frames){
		           curframe = 0;
		           setNewSpeed();
		       }
		       curframe++;
		       angle += dna;
		       radius += dnr;
		       magn += dnm;
		       
	       	var ang;
			   var rad;
			   if(chief == null){
			   	ang = angle;
			   	rad = radius;
			   	
		       }else{
			       var dgrx = (xx - chief.xx) / m;
			       var dgry = (yy - chief.yy) / m;
			       var dgrr = Math.sqrt(dgrx * dgrx + dgry * dgry);
			       
			       var gra = Math.acos(dgrx / dgrr);
			       if(dgry < 0) gra = -gra;
			       //var grr = vgr;
			
			       var grp = (rgr - dgrr) / rgr;
			       if(grp < 0) grp = 0;

			       var tmpangle = angle % (2 * pi);
			       if(gra - tmpangle < -pi){
			           gra += 2 * pi;
			       }else if(gra - tmpangle > pi){
			           gra -= 2 * pi;
			       }
			       
			       ang =  tmpangle + pi + (gra * (1 - grp) + chief.angle * (grp)- tmpangle) * (1 - grp);
			       rad = radius * (grp) + vgr * (1 - grp);
			       
		       }

			   if (par.bat.visible == false) {
				   var drunx = (zx1 % par.wdth - 0)/m;
				   var druny = (zy1 % par.hght - 0)/m;
			   }else{
				   var drunx = (zx1 % par.wdth - par.bat.x)/m;
				   var druny = (zy1 % par.hght - par.bat.y)/m;
			   }
			   var drunr = Math.sqrt(drunx * drunx + druny * druny);
		       
		       var runa = Math.acos(drunx / drunr);
		       if(druny < 0) runa = -runa;
		       //var runr = vrun;
		
		       var runp = (rrun - drunr) / rrun;
		       if(runp < 0) runp = 0;
		       if(runp > 1) runp = 1;
		       		       
		       var tmpangle = ang % (2 * pi);
		       if(runa - tmpangle < -pi){
		           runa += 2 * pi;
		       }else if(runa - tmpangle > pi){
		           runa -= 2 * pi;
		       }
		       
		       ang =  tmpangle + (runa - tmpangle) * runp;
		       rad = rad * (1 - runp) + vrun * runp;

			   var dyz = (par.hght / 2 - yy) / 200 * vmax;
			   //if(Math.abs(y
			   var dxz = (par.wdth / 2 - xx) / 200 * vmax;  
		       xx +=  m * rad * Math.cos(ang) + dxz;
		       yy += m * rad * Math.sin(ang) + dyz;
			   var zx1 = xx;
			   var zy1 = yy;
			   while(zx1 < 0) zx1 += par.wdth;
			   while(zy1 < 0) zy1 += par.hght;
			   x = zx1 % par.wdth;
			   y = zy1 % par.hght;
			   
			   var tmplxx = Math.floor(xx/par.wdth);
			   var tmplyy = Math.floor(yy/par.hght);

			   if(lastxx != tmplxx || lastyy != tmplyy){
			   	
			   	if(lastxx > tmplxx){
		   			 setNewSpeed1(pi, vrun, 1);
		   		}else if(lastxx < tmplxx){
		   			 setNewSpeed1(-pi, vrun, 1);
				   }
						   		
		   		if(lastyy > tmplyy){
		   			 setNewSpeed1(pi / 2, vrun, 1);
			   	}else if (lastyy < tmplyy){
		   			 setNewSpeed1(3 * pi / 2, vrun, 1);
			   	}
			   	lastxx = tmplxx;
			   	lastyy = tmplyy;
			   	
			   }
			   
		       //this.scaleX = (0.5 + 1.5 / rad)*1.5;
		       //this.scaleY = (0.5 + 1.5 / rad)*1.5;
		   }
		}
		
		function setNewSpeed(){
		   angle = angle % (2 * pi);
		   var newangle = angle + (Math.random() - 0.5) * 2 * pi;
		   var newradius = vmin + Math.random() * (vmax - vmin);
		   var newmagn = m * (1 + Math.random() * 0.5);
		
		   frames = fmin + Math.random() * (fmax - fmin);
		   dna =  (newangle - angle) / frames;
		   dnr =  (newradius - radius) / frames;
		   dnm = (newmagn - magn) / frames;
		}

		function setNewSpeed1(newangle, newradius, newmagn){
		   frames = 5;
		   dna =  (newangle - angle) / frames;
		   dnr =  (newradius - radius) / frames;
		   dnm = (newmagn - magn) / frames;
		}
		
		function distance(x1, y1, x2, y2): Number
		{
			var xx1:Number = x2 - x1;
			var yy1:Number = y2 - y1;
			return Math.sqrt(xx1 * xx1 + yy1 * yy1);
		}

	}
}
