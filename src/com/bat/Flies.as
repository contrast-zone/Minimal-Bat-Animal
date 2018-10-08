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
	
	public class Flies extends Sprite
	{
		var par :Object;
		var pi = 3.14159;
		public var m:Number = 1;
		
		var recnum:int = 4;		
		var flies:Array;

		public function Flies(p:Object, easy:String="easy")
		{
			par = p;
			flies = new Array();
			//for(var i = 1; i < 3; i++){
			recnum = 1;
			//generateFlies1(null, recnum);
			//generateFlies0(null, 3, 3, 2, 0.8);
			var rrun;
			if (easy == "easy") {
				rrun = 200;
			}else if (easy == "hard"){
				rrun = 300;
			}else {
				rrun = 300;
			}

			if (easy == "easy") {
				generateFlies1(null, 3, 3, 3, 0.5, 1, 75, rrun);
//				generateFlies1(null, 3, 3, 3, 1, 2, 50, rrun);
				generateFlies1(null, 3, 3, 3, 0.75, 1, 200, rrun);
			}else if(easy == "hard") {
				generateFlies1(null, 3, 3, 3, 1, 2, 75, rrun);
				generateFlies1(null, 3, 3, 3, 1, 2, 50, rrun);
				generateFlies1(null, 3, 3, 4, 1, 2, 200, rrun);
			} else {
				generateFlies1(null, 3, 3, 3, 1, 2, 75, rrun);
				generateFlies1(null, 3, 3, 3, 1, 2, 200, rrun);
				generateFlies1(null, 3, 3, 4, 1, 2, 200, rrun);
				generateFlies1(null, 3, 3, 5, 2, 3, 200, rrun);
			}
			//generateFlies1(null, 2, 3, 25, 4, 1, 50, 250);
			//generateFlies1(null, 25, 25, 1, 1, 1, 10, 250);
			//generateFlies1(null, recnum);
			recnum = 10;
			//generateFlies2(null, recnum);
			//}

			setBounds();
		}
		
		public function setm(mgn:Number){
			m = mgn;
			for(var i = 0; i < flies.length; i++){
				flies[i].setm(m*2/3);
			}
		}
		
		function setSpeed(fly:Fly, speed, rgr, rrun)
		{
			var sp = speed;//(maxspeed - minspeed) / maxspeed;
			fly.speed = sp;
			
            fly.vmin = 3 *  fly.speed;
            fly.vmax = 4 *  fly.speed;
            fly.vgr = 4 *  fly.speed;
            fly.vrun = 8 * fly.speed;
            fly.rgr = rgr;
            fly.rrun = rrun;
            fly.radius = 0;
            
		}
		
		public function generateFlies0(chief:Fly, rec:int, maxrec:int, treefact:int, min:Number, max:Number, rgr:int, rrun:int)
		{
			var sc = (maxrec - rec + 1) / maxrec * 0.9;
            var fly:Fly;
			//if(chief == null){
	            fly = new Fly(par, par.wdth / 2, par.hght / 2);

	            addChild(fly);
	            setSpeed(fly, min + sc * (max - min), rgr, rrun);
	            fly.vrun = 9;
	            fly.scaleX = 1 - sc + 2 / maxrec + 0.2;
	            fly.scaleY = 1 - sc + 2 / maxrec + 0.2;
	            flies.push(fly);

	            fly.chief = chief;
			//}
			
            if(rec > 1){
				for(var i = 0; i < treefact; i++){
	            	generateFlies0(fly, rec - 1, maxrec, treefact, min, max, rgr, rrun);
	            }
	        }			
		}

		public function generateFlies1(chief:Fly, rec:int, maxrec:int,treefact:int, min:Number, max:Number, rgr:int, rrun:int)
		{
			var sc:Number = rec / maxrec * 0.9;
            var fly:Fly;
            
			//if(chief == null){
	            fly = new Fly(par, par.wdth / 2, par.hght / 2);

	            addChild(fly);
	            setSpeed(fly, min + sc * (max - min), rgr, rrun);
	            fly.vrun = 9;
	            fly.scaleX = sc + 2 / maxrec + 0.2;
	            fly.scaleY = sc + 2 / maxrec + 0.2;
	            flies.push(fly);

	            fly.chief = chief;
			//}
			
            if(rec > 1){
				for(var i = 0; i < treefact; i++){
	            	generateFlies1(fly, rec - 1, maxrec, treefact, min, max, rgr, rrun);
	            }
	        }			
		}
		/*
		public function generateFlies2(chief:Fly, rec:int)
		{
            var fly:Fly;
            var min = (recnum - rec) / (recnum + 1);
            var max = 1;
			if(chief == null){
	            fly = new Fly(par, par.wdth/2, par.hght/2);
	            addChild(fly);
	            setSpeed(fly, max, min);
	            flies.push(fly);

	            chief = fly;
			}
			
			for(var i = 0; i < 1; i++){
	            var fly:Fly = new Fly(par, par.wdth/2, par.hght/2);
	            addChild(fly);
	            fly.chief = chief;
	            setSpeed(fly, max, min);
	            fly.rgr = 15;
	            flies.push(fly);
	            if(rec > 1){
	            	generateFlies2(fly, rec - 1);
	            }
	        }			
		}
		*/
		
		function promote(){
			for(var i = 0; i < flies.length; i++){
				var p = flies[i].chief;
				if(p != null){
					while(!p.visible){
						p = p.chief;
						if(p == null){
							break;
						}
					}
					flies[i].chief = p;
				}
			}
		}
		
		public function setBounds(){
			for(var i = 0; i < flies.length; i++){
				flies[i].setBounds();
			}
		}
	}
}
