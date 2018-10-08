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
	
	public class BatAnimal extends Sprite
	{
		var par:Object;
		var pi:Number = 3.14;
		var speed:Number = 20, flap:Number = 0, dflap:Number = .05;
		var isfather:Boolean;
		public var numflies:int = 0
		public var flies:Sprite;
		
		public var m:Number = 1.2;
		public var bx:Number = 0;
		public var by:Number = 0;
		var nx:Number = 0, ny:Number = 0, ox:Number = 0, oy:Number = 0;
		
		var bodyfront:Shape;
		var bodyside:Shape;
		var lwing:Sprite, lwing1:Shape, lwing2:Shape, rwing:Sprite, rwing1:Shape, rwing2:Shape;
		
		public function BatAnimal(o:Object, isfather:Boolean)
		{
			par = o;
			this.isfather = isfather;
			if(!isfather){
				x = 25 * m;
				y = par.hght - 25 * m;
				dflap = .1;
			}
			
			flap = Math.random();
			
			bodyfront = new Shape();
			addChild(bodyfront);

			bodyside = new Shape();
			addChild(bodyside);

			lwing = new Sprite();
			lwing1 = new Shape();
			lwing.addChild(lwing1);
			lwing2 = new Shape();
			lwing.addChild(lwing2);
			addChild(lwing);

			rwing = new Sprite();
			rwing1 = new Shape();
			rwing.addChild(rwing1);
			rwing2 = new Shape();
			rwing.addChild(rwing2);
			addChild(rwing);
			
			//flies = new Sprite();
			//addChild(flies);

			paint();

			addEventListener('enterFrame', entfr);
			entfr();

		}
		
		
		public function paint(){
			var cc = par.colorbat;
			
			bodyfront.graphics.clear();
			bodyfront.graphics.beginFill(cc);
			bodyfront.graphics.moveTo(0 * m, 0 * m);
			bodyfront.graphics.lineTo(10 * m, -10 * m)
			bodyfront.graphics.lineTo(20 * m, 40 * m)
			bodyfront.graphics.lineTo(0 * m, 80 * m)
			bodyfront.graphics.lineTo(-20 * m, 40 * m)
			bodyfront.graphics.lineTo(-10 * m, -10 * m)
			bodyfront.graphics.lineTo(0 * m, 0 * m)
			bodyfront.graphics.endFill();

			bodyside.graphics.clear();
			bodyside.graphics.beginFill(cc);
			bodyside.graphics.moveTo(0 * m, 0 * m);
			bodyside.graphics.lineTo(20 * m, 15 * m)
			bodyside.graphics.lineTo(15 * m, 25 * m);
			bodyside.graphics.lineTo(20 * m, 40 * m)
			bodyside.graphics.lineTo(0 * m, 80 * m)
			bodyside.graphics.lineTo(-15* m, 40 * m)
			bodyside.graphics.lineTo(0 * m, 0 * m);
			bodyside.rotationY = 90;

			lwing1.graphics.clear();
			lwing1.graphics.beginFill(cc);
			lwing1.graphics.moveTo(0 * m, 0 * m);
			lwing1.graphics.lineTo(-60 * m, -30 * m)
			lwing1.graphics.lineTo(-60 * m, 20 * m)
			lwing1.graphics.lineTo(0 * m, 0 * m);

			lwing2.graphics.clear();
			lwing2.graphics.beginFill(cc);
			lwing2.graphics.moveTo(0 * m, -30 * m);
			lwing2.graphics.lineTo(-60 * m, 50 * m)
			lwing2.graphics.lineTo(0 * m, 20 * m)
			lwing2.x = -60 * m

			lwing.y = 20 * m;

			rwing1.graphics.clear();
			rwing1.graphics.beginFill(cc);
			rwing1.graphics.moveTo(0 * m, 0 * m);
			rwing1.graphics.lineTo(60 * m, -30 * m)
			rwing1.graphics.lineTo(60 * m, 20 * m)
			rwing1.graphics.lineTo(0 * m, 0 * m);
			
			
			rwing2.graphics.clear();
			rwing2.graphics.beginFill(cc);
			rwing2.graphics.moveTo(0 * m, -30 * m);
			rwing2.graphics.lineTo(60 * m, 50 * m)
			rwing2.graphics.lineTo(0 * m, 20 * m)
			//rwing2.rotationY = -45;
			rwing2.x = 60 * m
			
			rwing.y = 20 * m;
			//rwing.rotationX = -45;
		}
		
		public function setSkelet(mood:Number, rotx:Number, roty:Number){
			//mood = 0;
			y = by - m * Math.abs(mood - 0.5) * 30;
			x = bx - m * Math.abs(mood - 0.5) * 15;
			
			rotationY = roty;//-90;//t;//flap * 90;
			rotationX = rotx + 60 + Math.abs(mood - 0.5) * 20;
			//rotationX = 30 + Math.abs(mood - 0.5) * 20;
			var seq;
			var flap:Number;
			if(mood < 0.4){
				seq = "mahanje";
				var ss = (mood - 0.0) / 0.4 - 0.5;
				var direction = ss < 0;
				flap = Math.abs(ss);
			}else{
				seq = "promjena";
				var ss = 1 - (mood - 0.4) / 0.6;
				flap = ss;
			}
			
			if(seq == "promjena"){
					var nflap = 1 - flap;

					lwing2.rotationY = (-30 - 30) * nflap + (-30 + 45) * flap;
					lwing.rotationX = (30 - 30) * nflap + (30 + 45) * flap;
					lwing.rotationZ = (45 - 75) * nflap + (45 - 75) * flap;

					rwing2.rotationY = (30 + 30) * nflap + (30 - 45) * flap;
					rwing.rotationX = (30 - 30) * nflap + (30 + 45) * flap;
					rwing.rotationZ = (-45 + 75) * nflap + (-45 + 75) * flap;

			}else if(seq == "mahanje"){
				if(direction){
					//maše gori
					lwing2.rotationY = -30 - flap * 30;
					lwing.rotationX = 30 - flap * 30;
						rwing2.rotationY = 30 + flap * 30;
					rwing.rotationX = 30 - flap * 30;
					}else{
					//maše doli
					lwing2.rotationY = -30 + flap * 45;
					lwing.rotationX = 30 + flap * 45
						rwing2.rotationY = 30 - flap * 45;
					rwing.rotationX = 30 + flap * 45;
					
				}
					lwing.rotationZ = 45 - flap * 75;
				rwing.rotationZ = -45 + flap * 75;
				
			}
		}

		
		public function entfr(e:Event=null):void
		{
			flap += dflap;
			if(flap > 1){
				flap = 0;
				var tmpx = nx;
				var tmpy = ny;
				nx = 200 * (Math.random() - 0.5);
				ny = 200 * (Math.random() - 0.5);
				ox = (nx - tmpx) * dflap;
				oy = (ny - tmpy) * dflap;
			}
		
			if(!isfather){
				//var dx:Number = Math.random();
				//var dy:Number = Math.random();
					bx = bx + ox * m;
					by = by + oy * m;
			}else{
				var dx:Number = (par.mouseX - bx) / m;
				var dy:Number = (par.mouseY - by) / m;
				var dr:Number = Math.sqrt(dx * dx + dy * dy);
				if(dr > 0){
				//debug(dr);
				//if(dr > 5){
					
					/*
					if(dx > novir){ dx = novir;}
					if(dx < -novir){ dx = -novir;}
					if(dy > novir){ dy = novir;}
					if(dy < -novir){ dy = -novir;}
					*/
					//if(dr < 5){ dr = 5;}
					//if(dr > 30){ dr = 30;}
					speed = dr;
					if(speed > 150) speed = 150;
					//if(speed * 20) speed = dr;
					var novirx:Number = dx / dr * speed * 0.2;
					var noviry:Number = dy / dr * speed * 0.2;
						by += m * noviry;
						bx += m * novirx;
					
					if(bx > par.wdth){ bx = par.wdth;}
					if(by > par.hght){ by = par.hght;}
		
					x = bx;
					y = by;
				}
			}

			var roty = -dx / 2;
			if(roty > 90){ roty = 90;}
			if(roty < -90){ roty = -90;}
    		
    		var rotx = -35 + dy / 2;						
			if(rotx > -20){ rotx = -20;}
			if(rotx < -40){ rotx = -40;}
			rotx += Math.abs(roty / 4);
			
			setSkelet(flap, rotx, roty);
			/*
			if(y > par.hght - 150 * m && x < 150 * m){
				numflies = 0;
				paintFlies();
			} 
			*/
		}

		function distance(x1, y1, x2, y2): Number
		{
			var xx = x2 - x1;
			var yy = y2 - y1;
			return Math.sqrt(xx * xx + yy * yy);
		}

		public function setm(mgn:Number){

			if(isfather){
				m = mgn / 3;
				//paintFlies();
			}else{
				m = mgn / 9;
			}
			paint();
		}
		
		public function paintFlies(){
			while(flies.numChildren > 0){
				flies.removeChildAt(0);
			}
			var co;
			if(numflies >= 15){
				co = par.colorbat;
			}else{
				co = par.colorfly;
			}
			var yy = 75 * m;
			//var z = Math.sqrt(numflies)+10;
			var count = 0;
			for(var j = 1; count < numflies; j++){
				for(var i = j; i > 0 && count < numflies; i--){
					if(count < numflies){
						var f = new Shape();
			 	   	par.bat.paintFly(f, co);
				    	f.x = i * 10 * m - (j + 1)* 5 * m;
				    	f.y = yy + j * 10 * m;
				    	par.bat.flies.addChild(f);
				    	count++;
				    }
			    }
			}
		}

		public function paintFly(fly:Shape, cc:int){
			//var cc = par.colorfly;
			fly.graphics.clear();
			fly.graphics.beginFill(cc);
			fly.graphics.drawCircle(0, 0, 4 * m);
			fly.graphics.endFill();
		}
	}
}
