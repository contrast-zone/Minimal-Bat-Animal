package com.bat
{
	import flash.geom.ColorTransform;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.geom.*;

	
	/**
	 * Application entry-point
	 */
	public class Application extends Sprite
	{
		var pi:Number = 3.14;
		public var colorbat = 240 + 200 * Math.pow(2, 8) + 130 * Math.pow(2, 16);
		public var colorfly = 150 + 255 * Math.pow(2, 8) + 255 * Math.pow(2, 16);
		public var colorflyghost = colorbat;// 30 + 30 * Math.pow(2, 8) + 220 * Math.pow(2, 16);
		public var colormoon = 0xFFFFFF

		public var m:Number = 1; 
        public var wdth:int;// = 160;
		public var hght:int;// = 120;
		var tt:int = 0;
		
		var title:TextField = new TextField();
		var score:TextField = new TextField();
		var easyTF:TextField = new TextField();
		var hardTF:TextField = new TextField();
		var extrTF:TextField = new TextField();
		var titleFormat:TextFormat = new TextFormat();
		var scoreFormat:TextFormat = new TextFormat();
		
		var easygame:String = "easy";

		var rands:Array;
		var randsptr:int;
		
		var sky:Shape;
		var mountains:Shape;
		var lover:Number, rover:Number;
		var sun:Shape;
		
		var bat:BatAnimal;// , bat1:BatAnimal, bat2:BatAnimal, bat3:BatAnimal;
		var flies:Flies;
		var msk:Shape;
		
		var rs1, gs1, bs1, rl1, gl1, bl1;
		var rs2, gs2, bs2, rl2, gl2, bl2;
		var dan:Number = 0, ddan:Number, olddan:Number = -1;
		
		public function Application()
		{
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
            
            wdth = stage.stageWidth;
            hght = stage.stageHeight; 
            

			msk = new Shape();
				msk.graphics.beginFill(0);
				msk.graphics.drawRect(0, 0, wdth, hght);
				msk.graphics.endFill();
			addChild(msk);
			msk.x = 0;
			msk.y = 0;
			this.mask = msk;
/*
			x = 0;
			y = 0;
			width = wdth;
			height = hght;
*/

            generateLandscape();   
            setColors(dan);

/*            
            bat = new BatAnimal(this);
            bat.x = 0;
            bat.y = 0;
            addChild(bat);
            
            flies = new Flies(this);
            addChild(flies)
*/
			addChild(title);
			addChild(score);
			addChild(easyTF);
			addChild(hardTF);
			
			bat = new BatAnimal(this, true);
			bat.bx = 0;
			bat.x = 0;
			bat.by = 0;
			bat.y = 0;
			addChild(bat);
			bat.visible = false;

			flies = new Flies(this);
			addChild(flies)

			stage.addEventListener(Event.RESIZE, repos);
			stage.dispatchEvent(new Event(Event.RESIZE));
			

			addEventListener('enterFrame', entfr);
			entfr();

			//uncomment to enable debugger console
			//Debugger.setParent(this, true);
			//debug(stage.stageWidth);
			//debug(stage.stageWidth);
		}
		
		public function setm(mgn:Number){
			m = mgn;
			//if(olddan == 2){
				bat.setm(mgn*1.2);
				/*
				bat1.setm(mgn*1.2);
				bat2.setm(mgn*1.2);
				bat3.setm(mgn*1.2);
				*/
				flies.setm(mgn * 1.2);
				/*
	            bat1.bx = 25 * m;
				bat1.by = hght - 25 * m;
	            bat2.bx = 25 * m;
				bat2.by = hght - 25 * m;
	            bat3.bx = 25 * m;
				bat3.by = hght - 25 * m;
				*/
			//}
		}
		
		function init(){
			wdth = stage.stageWidth;
			hght = stage.stageHeight;
		}
		
		public function repos(e:Event=null):void
		{
			
			removeChild(title);
			removeChild(score);
			removeChild(easyTF);
			removeChild(hardTF);
			removeChild(sky);
			removeChild(sun);
			removeChild(mountains);
			if(olddan == 2 || olddan == -1 || olddan == -2)	removeChild(flies);
			if(olddan == 2)	removeChild(bat);
			
			var oldwdth = wdth;
			if(oldwdth == 0){ oldwdth = stage.stageWidth; }
			var oldhght = hght;
			if(oldhght == 0){ oldhght = stage.stageHeight; }

			msk.width = 1;
			msk.height = 1;
			wdth = stage.stageWidth;
			hght = stage.stageHeight;
			if(wdth < 50){wdth = 50;}
			if(hght < 50){hght = 50;}
			msk.width = wdth;
			msk.height = hght;
			if(wdth < hght){
				setm(wdth / 400);
			}else{
				setm(hght / 400);
			}
			this.transform.perspectiveProjection.projectionCenter=new Point(wdth / 2, hght / 2);
			this.transform.perspectiveProjection.fieldOfView= 20 / m;
			if(olddan == 2){ flies.setBounds();}
			
			if (olddan == 1) 
				setColors(dan);
			else
				setColors(0);
				
			addChild(sky);
			addChild(sun);
			addChild(mountains);
			if(olddan == 2 || olddan == -1 || olddan == -2) addChild(flies);
			if(olddan == 2) addChild(bat);
				//addChild(bat1);
				//addChild(bat2);
				//addChild(bat3);
			

			titleFormat.color=colorbat;
			titleFormat.align="center";
			titleFormat.size=40*m;
			titleFormat.font="Arial";
			//format.letterSpacing = 3;
			titleFormat.bold = true;
			
			title.defaultTextFormat = titleFormat;
			title.width = wdth;
			title.x = 0;
			title.y = 100*m;
			title.text = "Minimal Bat Animal";
			//title.antiAliasType = AntiAliasType.ADVANCED;
			//title.mouseEnabled = false;
			title.selectable = false;
			addChild(title);

			scoreFormat.color=colorfly;
			scoreFormat.align="center";
			scoreFormat.size=40*m;
			scoreFormat.font="Arial";
			//format.letterSpacing = 3;
			scoreFormat.bold = true;

			score.defaultTextFormat = scoreFormat;
			score.width = wdth;
			score.x = 0;
			score.y = hght / 2;
			if (score.text == "") 
				score.text = "Catch flies";
			else
				score.text = score.text;
			//score.antiAliasType = AntiAliasType.ADVANCED;
			//title.mouseEnabled = false;
			score.selectable = false;
			addChild(score);
			//score.textColor = colorfly;
			

			//Creat the textField
			easyTF.text = "easy";
			easyTF.setTextFormat(titleFormat);
			easyTF.selectable = false;
			easyTF.autoSize = TextFieldAutoSize.CENTER;
			easyTF.x = wdth / 5 - easyTF.width / 2;
			easyTF.y = hght - 100 * m;

			addChild(easyTF);
			
			//Now, listen for the mouse events!
			easyTF.addEventListener(MouseEvent.MOUSE_OVER, function() { 
				easyTF.text = "EASY";
				easyTF.setTextFormat(titleFormat);
				easyTF.textColor = colorfly;
				//easyTF.x -= easyTF.width / 2 * 0.2
				//easyTF.scaleX = 1.2;
				//easyTF.scaleY = 1.2;
			} );
			easyTF.addEventListener(MouseEvent.MOUSE_OUT, function() { 
				easyTF.text = "easy";
				easyTF.setTextFormat(titleFormat);
				easyTF.textColor = colorbat; 
				//easyTF.scaleX = 1; 
				//easyTF.scaleY = 1;
				//easyTF.x += easyTF.width / 2 * 0.2
			} );
			easyTF.addEventListener(MouseEvent.CLICK, function() { 
				flies.visible = false;
				olddan = 1;
				easygame = "easy";
			} );
			
			hardTF.text = "hard";
			hardTF.setTextFormat(titleFormat);
			hardTF.selectable = false;
			hardTF.autoSize = TextFieldAutoSize.CENTER;
			hardTF.x = 4 * wdth / 9 - hardTF.width / 2;
			hardTF.y = hght - 100 * m;
			
			//Now, listen for the mouse events!
			hardTF.addEventListener(MouseEvent.MOUSE_OVER, function() { 
				hardTF.text = "HARD";
				hardTF.setTextFormat(titleFormat);
				hardTF.textColor = colorfly;
				//hardTF.x -= m * hardTF.width / 2 * 0.1
				//hardTF.scaleX = 1.2;
				//hardTF.scaleY = 1.2;
			} );
			hardTF.addEventListener(MouseEvent.MOUSE_OUT, function() { 
				hardTF.text = "hard";
				hardTF.setTextFormat(titleFormat);
				hardTF.textColor = colorbat; 
				//hardTF.scaleX = 1; 
				//hardTF.scaleY = 1;
				//hardTF.x += m * hardTF.width / 2 * 0.1
			} );
			hardTF.addEventListener(MouseEvent.CLICK, function() { 
				flies.visible = false;
				olddan = 1;
				easygame = "hard";
			} );
			addChild(hardTF);

			extrTF.text = "extreme";
			extrTF.setTextFormat(titleFormat);
			extrTF.selectable = false;
			extrTF.autoSize = TextFieldAutoSize.CENTER;
			extrTF.x = 3 * wdth / 4 - extrTF.width / 2;
			extrTF.y = hght - 100 * m;
			
			//Now, listen for the mouse events!
			extrTF.addEventListener(MouseEvent.MOUSE_OVER, function() { 
				extrTF.text = "EXTREME";
				extrTF.setTextFormat(titleFormat);
				extrTF.textColor = colorfly;
				//extrTF.x -= m * extrTF.width / 2 * 0.1
				//extrTF.scaleX = 1.2;
				//extrTF.scaleY = 1.2;
			} );
			extrTF.addEventListener(MouseEvent.MOUSE_OUT, function() { 
				extrTF.text = "extreme";
				extrTF.setTextFormat(titleFormat);
				extrTF.textColor = colorbat; 
				//extrTF.scaleX = 1; 
				//extrTF.scaleY = 1;
				//extrTF.x += m * extrTF.width / 2 * 0.1
			} );
			extrTF.addEventListener(MouseEvent.CLICK, function() { 
				flies.visible = false;
				olddan = 1;
				easygame = "extreme";
			} );
			addChild(extrTF);
		}
		
		public function easyClicked(e:Event=null):void
		{	
			title.visible = false;
			olddan = 1;
		}

		public function repeatRands():void
		{	randsptr = 0;
		}
		
		public function resetRands():void
		{	randsptr = 0;
 			if(rands != null){
				 rands.splice(0, rands.length);
				 rands = null;
		     }
		}
		
		public function nextRand():Number
		{
			if(rands == null){
				rands = new Array();
			}
			if(randsptr >= rands.length){ 
				rands.push(Math.random());
			}
			
			return rands[randsptr++];
		}
		
		public function generateLandscape()
		{		
			dan = 0;
			ddan = 0.05;

			rs1 = 180;
			gs1 = 150;
			bs1 = 255;
			rl1 = 80;
			gl1 = 150;
			bl1 = 20;

			rs2 = 0;
			gs2 = 0;
			bs2 = 0;
			rl2 = 50;
			gl2 = 50;
			bl2 = 50;

            resetRands();

            sky = new Shape();
			addChild(sky);
			sun = new Shape();
			addChild(sun);
            mountains = new Shape();
			addChild(mountains);
		}

		public function paintSky(s:Shape, cc:int)
		{		
            s.graphics.clear(); 
			s.graphics.beginFill(cc);
			s.graphics.drawRect(0, 0, wdth, hght / 2);
			s.graphics.endFill();
		}
		
		public function paintSun(s:Shape, cc:int)
		{		
			s.graphics.clear();
			//s.graphics.beginFill(150 + 255 * Math.pow(2, 8) + 255 * Math.pow(2, 16));
			s.graphics.beginFill(cc);
			s.graphics.drawCircle(0, 0, m * 40);
			s.graphics.endFill();
		}

		public function paintMountains(s:Shape, rs:int, gs:int, bs:int, rl:int, gl:int, bl:int)
		{		
			var b = 1;
			var g = Math.pow(2,8);
			var r = Math.pow(2,16)
			
			s.graphics.clear();
			lover = 0;
			rover = 0;

            var mr = nextRand();
            var oldi:Number = 0
            for(var i:Number = 0.1; i < 1; i+= (mr * i) / 2){
				var cc = int((i/3) * 255);
				cc = ((int)(rl * i + rs * (1 - i))) * r + ((int)(gl * i + gs * (1 - i))) * g + ((int)(bl * i + bs * (1 - i))) * b;

            	var xx = nextRand() * wdth;
            	var yy = hght / 2 * (1 + i);
            	var ww = wdth / 4 + nextRand() * (wdth * i);
            	var hh = nextRand() * (hght / 4) * (1.5 + i/3);
				
				s.graphics.beginFill(cc);
				s.graphics.drawRect(0, hght / 2 * (1 + oldi)-10*m, wdth, hght / 2 * (1 + (i - oldi))+10*m);
				s.graphics.endFill();
				var ltmp = xx - ww / 2;
				if(ltmp < 0){
					if(lover > ltmp){
						lover = ltmp;
					}
				}
				var rtmp = xx + ww / 2 - wdth;
				if(rtmp > 0){
					if(rover < rtmp){
						rover = rtmp;
					}
				}
				paintTriangle(s, xx, yy, ww, hh, cc);
				mr = nextRand();
				oldi = i;
            }
		}

		public function paintTriangle(s:Shape, x:int, y:int, w:int, h:int, c:int):void
		{
			
			    s.graphics.beginFill(c);
            	var x1 = x - w / 2;
            	var y1 = y;
            	s.graphics.moveTo(x1, y1);
            	var x2 = x + w / 2;
            	var y2 = y;
            	s.graphics.lineTo(x2, y2);
            	var x3 = x;
            	var y3 = y - h;
            	s.graphics.lineTo(x3, y3);
				s.graphics.endFill();
		}
		
		public function setColors(dan:Number){
			var tdan:Number = dan;//2 * (dan - 0.5);
			if(tdan < 0){
				tdan = 0;
			}
			var tnoc:Number = 1 - dan;
			
			var b = 1;
			var g = Math.pow(2,8);
			var r = Math.pow(2,16)

			var rs, gs, bs, rl, gl, bl;
			rs = rs1 * tdan + rs2 * tnoc;
			gs = gs1 * tdan + gs2 * tnoc;
			bs = bs1 * tdan + bs2 * tnoc;
			rl = rl1 * tdan + rl2 * tnoc;
			gl = gl1 * tdan + gl2 * tnoc;
			bl = bl1 * tdan + bl2 * tnoc;
			
			var cc = (int)(rs) * r + (int)(bs) * b + (int)(gs) * g;
			paintSky(sky, cc);
			
			if (olddan == 2) 
				paintSun(sun, colormoon);
			else
				paintSun(sun, colorfly);
			var x0:Number = wdth / 2;
			var y0:Number = hght / 2;
			var rx0:Number = wdth / 2; 
			var ry0:Number = hght / 2;
			var a0:Number;
			if(ddan > 0) {
				a0 = pi + pi * dan / 2;
				//a0 = pi * dan;
			}else{
				a0 = 2 * pi - pi * dan / 2;
				//a0 = 2 * pi - pi * dan;
			}
			sun.x = x0 + rx0 * Math.cos(a0);
			sun.y = y0 + ry0 * Math.sin(a0) + sun.height / 2;
			
			repeatRands();
			paintMountains(mountains, rs, gs, bs, rl, gl, bl);
//			setChildIndex(s, numChildren - 1);
		}
		
		public function entfr(e:Event=null):void
		{
			if (olddan == -1) {
				setColors(0);
				
				title.visible = true;
				score.visible = true;
				hardTF.visible = true;
				easyTF.visible = true;
				extrTF.visible = true;
				dan = 0;
				olddan = -2;
				paintSun(sun, colorfly);
				
			}if (dan >= 0 && olddan == 1) {
				title.visible = false;
				score.visible = false;
				hardTF.visible = false;
				easyTF.visible = false;
				extrTF.visible = false;

				dan += ddan;
				if(dan > 1 || dan < 0){
					 ddan = -ddan;
				}
				setColors(dan);
				olddan = 1;
				
			}else if(olddan == 1){

				olddan = 2;
				dan = 0;
				setColors(dan);
				
				init();
				
				removeChild(bat);
				bat = null;
	            bat = new BatAnimal(this, true);
	            bat.bx = 0;
	            bat.x = 0;
	            bat.by = 0;
	            bat.y = 0;
	            addChild(bat);
	            /*
	            bat1 = new BatAnimal(this, false);
	            addChild(bat1);
	            bat2 = new BatAnimal(this, false);
	            addChild(bat2);
	            bat3 = new BatAnimal(this, false);
	            addChild(bat3);
				*/
				removeChild(flies);
				flies = null;
	            flies = new Flies(this, easygame);
	            addChild(flies)
				
	            repos();
				paintSun(sun, colormoon);
			}else if (olddan == 2) {
				sun.scaleX = 0.5;
				sun.scaleY = 0.5;
				dan += ddan/30 * 1.25;
				if(dan > 1 || dan < 0){
					 ddan = -ddan;
				}
				var x0:Number = wdth / 2;
				var y0:Number = hght / 2;
				var rx0:Number = wdth / 2; 
				var ry0:Number = hght / 2;
				var a0:Number;
				if(ddan > 0) {
					a0 = pi + pi * dan / 2;
					//a0 = pi * dan;
				}else{
					a0 = 2 * pi - pi * dan / 2;
					//a0 = 2 * pi - pi * dan;
				}
				sun.x = x0 + rx0 * Math.cos(a0);
				sun.y = y0 + ry0 * Math.sin(a0) + sun.height / 2;				
				var imaih:int = 0; 
				for (var i:int = 0; i < flies.flies.length; i++) {
					if (!flies.flies[i].dead) imaih++;
				}
				if (imaih == 0 || dan < 0) {
					if (imaih > 0) {
					    if(imaih == 1)
						    score.text = imaih + " fly left";
					    else
					        score.text = imaih + " flies left"
					}else {
						score.text = "ALL CAPTURED!!!"
					}
					sun.scaleX = 1;
					sun.scaleY = 1;
					bat.visible = false;
					//removeChild(flies);
					olddan = -1;
				}
			}	
			
			//setColors(dan);
			

			/*
				var i:uint;
				for each(s in a)
					s.rotation += i++/3;
				*/
				//bytes.clear();
				//bytes.position = 0;
				/*
				for(var i:int = 0; i < bytes.length; i++){
					cc++;
					if(cc > 189) cc = 0;
					bytes.writeByte(0);
				}
				*/
/*
				for(y = 0; y < hght; y++){
					for(x = 0; x < wdth; x++){
						cc = 100;
						if(x < 100) cc = 0;
						bytes.writeByte(0);
						bytes.writeByte(200 * Math.sqrt(1 + x*x + y*y) / Math.sqrt(1 + wdth*wdth + hght * hght));
						bytes.writeByte(cc);
						bytes.writeByte(0);
					}
				}
				
*/
/*				
				//screenBD.lock();
				var bd:BitmapData = screenB.bitmapData;
				//bd.lock();
				tt++;
				var cc:int = 0;
				cc = Math.random() * 100;
				for(y = 0; y < hght; y++){
					for(x = 0; x < wdth; x++){
						//cc = 200;
						//if(x < 100) cc = Math.random() *100;
						if(x == 0 || y == 0) cc = 0xffffff;
						else if(x == wdth-1 || y == hght-1) cc = 0xffffff;
						else cc = x/y * 255 * tt;
						bd.setPixel(x, y, cc);
						
						//graphics.beginFill(cc);
						//graphics.drawRect(x, y, 1, 1);
						//graphics.endFill();
				
					}
				}
*/				
				//bd.unlock();
				
				//screenBD.unlock();
				//screenBD.width = wdth;
				
//				bytes.position = 0;
				//screenBD.lock();
//				screenBD.setPixels(rect, bytes);
				//screenBD.unlock()
				//screenB.bitmapData = screenBD;
				
				
				

				//rotation += 33;
				//rotationY += .4;
			}
	}
}
