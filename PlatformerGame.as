package{

	import dee.moly.platformer.ContentManager;
	import dee.moly.platformer.Key;
	import dee.moly.platformer.Level;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[SWF(width="800", height="450", backgroundColor=0xFFFFFF, frameRate="30")]
	
	public class PlatformerGame extends Sprite{
	
		// Resources for drawing
		private var _canvasBD:BitmapData;
		private var _canvasBitmap:Bitmap;
		private var _content:ContentManager;
		
		// Global content
		private var _hudFont:String = "Pericles";
		
		private var _winOverlay:BitmapData;
		private var _loseOverlay:BitmapData;
		private var _diedOverlay:BitmapData;
	
		private var _lastTime:int;
		private var _elapsed:int;
	
		// Meta-level game state
		private var _levelIndex:int = -1;
		private var _level:Level;
		private var _wasContinuePressed:Boolean;
		
		// When the time remaining is less than the warning time, it blinks on the hud
		private const WARNING_TIME:int = 30;
		
		private var _gameTick:Timer;
	
		public function PlatformerGame():void{
		    
			_canvasBD = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			_canvasBitmap = new Bitmap(_canvasBD);
			addChild(_canvasBitmap);
			
			Key.initialize(stage);
			
			_content = new ContentManager();
			
			_gameTick = new Timer(20);
			_gameTick.addEventListener(TimerEvent.TIMER, update);
			
			loadContent();
			
			stage.scaleMode = "noScale";
			stage.focus = this;
			
		}
		
		// LoadContent will be called once per game and is the place to load
        // all of your content.
		private function loadContent():void{
			
			// Load overlay textures
			_winOverlay = _content.load(ContentManager.BITMAP, "/Overlays/you_win");
			
			_loseOverlay = _content.load(ContentManager.BITMAP, "/Overlays/you_lose");
			
			_diedOverlay = _content.load(ContentManager.BITMAP, "/Overlays/you_died");
			
			loadNextLevel();
			
			var song:Sound = _content.load(ContentManager.SOUND, "/Sounds/Music");
			song.play(0, 1000);
			
		}
		
		// Allows the game to run logic such as updating the world,
        // checking for collisions, gathering input, and playing audio.
		private function update(e:TimerEvent):void{
			
			_elapsed = getTimer() - _lastTime;
			
			handleInput();
			
			_level.update(_elapsed);
			
			draw();
			
			_lastTime = getTimer();
			
			//e.updateAfterEvent();
			
		}
		
		private function handleInput():void{
			
			var continuePressed:Boolean = Key.isDown(Keyboard.SPACE) || Key.isDown(Keyboard.UP);
			
			// Perform the appropriate action to advance the game and
            // to get the player back to playing.
            if(!_wasContinuePressed && continuePressed){
            	
                if(!_level.player.isAlive){
                	
                    _level.startNewLife();
                    
                }else if(_level.timeRemaining == 0){
                	
                    if(_level.reachedExit)
                        loadNextLevel();
                    else
                        reloadCurrentLevel();
                        
                }
                
            }

            _wasContinuePressed = continuePressed;
            
		}
		
		private function loadNextLevel():void{
			
			// Stop updating the game while we wait for the text file to load,
			_gameTick.stop();
			
			// Find the path of the next level
			var levelPath:String;
				
			// Try to find the next level. They are sequentially numbered txt files.
			levelPath = ++_levelIndex + ".txt";
			var levelLoader:URLLoader = new URLLoader();
			levelLoader.addEventListener(Event.COMPLETE, startLevel);
			levelLoader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			levelLoader.load(new URLRequest(levelPath));
			
		}
		
		private function startLevel(e:Event):void{
			
			e.target.removeEventListener(Event.COMPLETE, startLevel);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadError);	
				
			// Load the level
			_level = new Level(e.target.data);
			
			_lastTime = getTimer();
			
			_gameTick.start();
			
		}
		
		private function loadError(e:Event):void{		
				
			// If there isn't even a level 0, something has gone wrong
			if(_levelIndex == 0)
				throw new Error("No Levels Found.");
					
			// Whenever we can't find a level, start over again at 0
			_levelIndex = -1;
				
			loadNextLevel();
			
		}
		
		private function reloadCurrentLevel():void{
			
			--_levelIndex;
			loadNextLevel();
			
		}
		
		// Draws the game
		private function draw():void{
			
			_canvasBD.lock();
			
			_canvasBD.fillRect(_canvasBD.rect, 0xAAD6D0);
			
			_level.draw(_elapsed, _canvasBD);
			
			drawHud();			
			
			_canvasBD.unlock();
			
		}
		
		
		private function drawHud():void{
			
			var hudLocation:Point = new Point(0, 0);
			var centre:Point = new Point(stage.stageWidth / 2.0, stage.stageHeight / 2.0);
		
			// Draw time remaining. Uses modulo division to cause blinking when the
            // player is running out of time.
            var timeString:String = "TIME: " + int((_level.timeRemaining / 1000) / 60) + ":" + int((_level.timeRemaining / 1000) % 60);
            var timeColour:ColorTransform;
            if(_level.timeRemaining / 1000 > WARNING_TIME ||
            	_level.reachedExit ||
            	int(_level.timeRemaining / 1000) % 2 == 0){
            		
            	timeColour = new ColorTransform(0, 0, 0, 1, 255, 255);
            		
            }else{
            		
            	timeColour = new ColorTransform(0, 0, 0, 1, 255);
            		
            }
            	
            drawShadowedString(_hudFont, timeString, hudLocation, timeColour);
            
            // Draw score
            drawShadowedString(_hudFont, "SCORE: " + _level.score, hudLocation.add(new Point(0, 20)), new ColorTransform(0, 0, 0, 1, 255, 255));
            
            // Determine the status overlay message to show.
            var status:BitmapData = null;
            if(_level.timeRemaining == 0){
            	
            	if(_level.reachedExit)
            		status = _winOverlay;
            	else
            		status = _loseOverlay;
            		
            }else if(!_level.player.isAlive){
            	
            	status = _diedOverlay;
            	
  			}
  			
  			if(status != null){
  			
  				// Draw status message.
  				var halfStatusSize:Point = new Point(status.width/2, status.height/2);
  				_canvasBD.copyPixels(status, status.rect, centre.subtract(halfStatusSize));  
  				
  			} 
			
		}
		
		private function drawShadowedString(font:String, value:String, position:Point, colour:ColorTransform):void{
			
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = value;
			tf.setTextFormat(new TextFormat(font, 18));
			
			var matrix:Matrix = new Matrix(1, 0, 0, 1, position.x, position.y);
			
			_canvasBD.draw(tf, matrix);
			
			matrix.translate(1, 1);
			
			_canvasBD.draw(tf, matrix, colour);
			
		}
		
	}
	
}