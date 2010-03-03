package dee.moly.platformer{
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;

	// A uniform grid of tiles with collections of gems and enemies.
    // The level owns the player and controls the game's win and lose
    // conditions as well as scoring.
	public class Level{
	
		// Physical structure of the level
		private var _tiles:Vector.<Vector.<Tile>>;
		private var _layers:Vector.<Layer>;
		// The layer which objects are drawn on top of
		private const ENTITY_LAYER:int = 2;
	
		// Ojects in the level
		public function get player():Player{
			return _player;
		}
		private var _player:Player;
		
		private var _enemies:Vector.<Enemy> = new Vector.<Enemy>();
		private var _gems:Vector.<Gem> = new Vector.<Gem>();
	
		// Key locations in the level
		private var _start:Point;
		private var _exit:Point = INVALID_POSITION;
		private static const INVALID_POSITION:Point = new Point(-1, -1);
		
		// Level game state
		private var _cameraPosition:Point = new Point();
	
		public function get score():int{
			return _score;
		}
		private var _score:int;
	
		public function get reachedExit():Boolean{
			return _reachedExit;
		}
		private var _reachedExit:Boolean;
		
		public function get timeRemaining():int{
			return _timeRemaining;
		} 
		private var _timeRemaining:Number;
		
		private const POINTS_PER_SECOND:int = 5;
		
		// Level content.
		public function get content():ContentManager{
			return _content;
		}
		private var _content:ContentManager;
		
		private var _exitReachedSound:Sound;
	
		// Constructs a new level.
		public function Level(levelString:String):void{
			
			// Create a new content manager to load content used just by this level.
			_content = new ContentManager();
			
			_timeRemaining = 120000;
			
			loadTiles(levelString);
			
			// Load background layer textures. For now, all levels must
            // use the same backgrounds and only use the left-most part of them.
            _layers = new Vector.<Layer>(3, true);
            _layers[0] = new Layer(content, "Layer0", 0.2, levelHeight * Tile.HEIGHT);
            _layers[1] = new Layer(content, "Layer1", 0.5, levelHeight * Tile.HEIGHT);
            _layers[2] = new Layer(content, "Layer2", 0.8, levelHeight * Tile.HEIGHT);
			
			// Load sounds
			_exitReachedSound = content.load(ContentManager.SOUND, "/Sounds/ExitReached");
			
		}
		
		// Updates all the objects in the level.
		public function update(gameTime:Number):void{
			
			// Pause while the player is dead or time is expired.
			if(!player.isAlive || timeRemaining == 0){
				
				// Still want to perform physics on the player.
				player.applyPhysics(gameTime);
				
			}else if(reachedExit){
				
				// Animate the time being converted into points.
				var seconds:int = int(Math.round((gameTime / 1000) * 100));
				seconds = Math.min(seconds, int(Math.ceil(timeRemaining / 1000)));
				_timeRemaining -= seconds * 1000;
				_score += seconds * POINTS_PER_SECOND;
				
			}else{
				
				_timeRemaining -= gameTime;
				
				player.update(gameTime);
				
				updateGems(gameTime);
				
				// Falling off the bottom of the level kills the player.
				if(player.boundingRectangle.top >= levelHeight * Tile.HEIGHT)
					onPlayerKilled(null);
					
				updateEnemies(gameTime);
				
				// The player has reached the exit if they are standing on the ground and
                // his bounding rectangle contains the center of the exit tile.
                if(player.isAlive &&
                	player.isOnGround &&
                	player.boundingRectangle.containsPoint(_exit)){
                		
                		onExitReached();
                		
                	}
				
			}
			
			// Clamp the time remaining at zero.
			if(_timeRemaining < 0)
				_timeRemaining = 0;
			
		}
		
		public function draw(gameTime:Number, canvasBD:BitmapData):void{
			
			scrollCamera(canvasBD.rect);
			var cameraTransform:Matrix = new Matrix(1, 0, 0, 1, -_cameraPosition.x, -_cameraPosition.y);
			
			for(var i:int = 0; i <= ENTITY_LAYER; ++i)
				_layers[i].draw(canvasBD, _cameraPosition);
			
			drawTiles(canvasBD, cameraTransform);
			
			for(var gem:String in _gems)
				_gems[gem].draw(gameTime, canvasBD, cameraTransform.clone());
				
			player.draw(gameTime, canvasBD, cameraTransform.clone());
			
			for(var enemy:String in _enemies)
				_enemies[enemy].draw(gameTime, canvasBD, cameraTransform.clone());
				
			for(i = ENTITY_LAYER + 1; i < _layers.length; ++i)
				_layers[i].draw(canvasBD, _cameraPosition);		
			
		}
		
		// Restores the player to the starting point to try the level again.
		public function startNewLife():void{
			
			player.reset(_start);
			
		}
		
		// Get the collision mode of a tile at a particular location.
		public function getCollision(x:int, y:int):int{
			
			// Prevent escaping past the level ends
			if(x < 0 || x >= levelWidth)
				return Tile.IMPASSABLE;
			// Allow jumping past the level top and falling through the bottom.
			if(y < 0 || y >= levelHeight)
				return Tile.PASSABLE;
				
			return _tiles[x][y].collision;
			
		}
		
		// Get the bounding rectangle of a tile.
		public function getBounds(x:int, y:int):Rectangle{
			
			return new Rectangle(x * Tile.WIDTH, y * Tile.HEIGHT, Tile.WIDTH, Tile.HEIGHT);
			
		}
		
		// Iterates over every tile in the structure file and loads its
        // appearance and behavior. This method also validates that the
        // file is well-formed with a player start point, exit, etc.
		private function loadTiles(levelString:String):void{
			
			var pattern:String;
			var lines:Array;
			var width:int;
			
			// Check whether file uses Windows or Unix line endings
			if(levelString.search("\r\n")){
				pattern = "\r\n";
			}else{
				pattern = "/n";
			}
			
			lines = levelString.split(pattern);
			width = lines[0].length;
			
			for(var i:String in lines)
				if(lines[i].length != width)
					throw new Error("The length of line " + i + " is different to all preceeding lines.");
			
			// Allocate the tile grid
			_tiles = new Vector.<Vector.<Tile>>(width);
			for(var j:int = 0; j < width; ++j)
				_tiles[j] = new Vector.<Tile>();
				
			// Loop over every tile position
			for(var y:int = 0; y < lines.length; ++y){
				
				for(var x:int = 0; x < width; ++x){
					
					// Load each tile
					var tileType:String = String(lines[y]).charAt(x);
					_tiles[x][y] = loadTile(tileType, x, y);
					
				}
				
			}
			
			// Verify that the level has a beginning and an end
			if(player == null)
				throw new Error("A level must have a starting point.");
			if(_exit == INVALID_POSITION)
				throw new Error("A level must have an exit.");
			
		}
		
		// Loads an individual tile's appearance and behavior.
		private function loadTile(tileType:String, x:int, y:int):Tile{
			
			switch (tileType){
				
                // Blank space
                case '.':
                    return new Tile(null, Tile.PASSABLE);

                // Exit
                case 'X':
                    return loadExitTile(x, y);

                // Gem
                case 'G':
                    return loadGemTile(x, y, false);
                    
                // Power-up gem
    			case 'P':
      				return loadGemTile(x, y, true);

                // Floating platform
                case '-':
                    return createTile("Platform", Tile.PLATFORM);

                // Various enemies
                case 'A':
                    return loadEnemyTile(x, y, "MonsterA");
                case 'B':
                    return loadEnemyTile(x, y, "MonsterB");
                case 'C':
                    return loadEnemyTile(x, y, "MonsterC");
                case 'D':
                    return loadEnemyTile(x, y, "MonsterD");

                // Platform block
                case '~':
                    return loadVarietyTile("BlockB", 2, Tile.PLATFORM);

                // Passable block
                case ':':
                    return loadVarietyTile("BlockB", 2, Tile.PASSABLE);

                // Player 1 start point
                case '1':
                    return loadStartTile(x, y);

                // Impassable block
                case '#':
                    return loadVarietyTile("BlockA", 7, Tile.IMPASSABLE);

                // Unknown tile type character
                default:
                    throw new Error("Unsupported tile type character '" + tileType + "' at position " + x + ", " +  y + ".");
            }
			
		}
		
		// Creates a new tile.
		private function createTile(name:String, collision:int):Tile{
			
			return new Tile(content.load(ContentManager.BITMAP, "/Tiles/" + name), collision);
			
		}
		
		// Load a tile with random appearnce.
		private function loadVarietyTile(baseName:String, variationCount:int, collision:int):Tile{
			
			var index:int = int(Math.random() * variationCount);
			return createTile(baseName + index, collision);
			
		}
		
		// Instantiates a player, puts him in the level, and remembers where to put him when he is resurrected.
		private function loadStartTile(x:int, y:int):Tile{
			
			if(player != null)
				throw new Error("A level may only have one start point.");
				
			_start = RectangleExtensions.getBottomCenter(getBounds(x, y));
			_player = new Player(this, _start);
			
			return new Tile(null, Tile.PASSABLE);
			
		}
		
		// Remembers the location of the level's exit.
		private function loadExitTile(x:int, y:int):Tile{
			
			if(_exit != INVALID_POSITION)
				throw new Error("A level may only have one exit.");
			
			var exitRect:Rectangle = getBounds(x, y);
			_exit = new Point(exitRect.x + (exitRect.width/2), exitRect.y + (exitRect.height/2));
			
			return createTile("Exit", Tile.PASSABLE);
			
		}
		
		// Instantiates an enemy and puts him in the level.
		private function loadEnemyTile(x:int, y:int, spriteSet:String):Tile{
			
			var position:Point = RectangleExtensions.getBottomCenter(getBounds(x, y));
			_enemies[_enemies.length] = new Enemy(this, position, spriteSet);
			
			return new Tile(null, Tile.PASSABLE);
			
		}
		
		// Instantiates a gem and puts it in the level.
		private function loadGemTile(x:int, y:int, isPowerUp:Boolean):Tile{
			
			var gemRect:Rectangle = getBounds(x, y);
			var position:Point = new Point(gemRect.x + (gemRect.width/2), gemRect.y + (gemRect.height/2));
			_gems[_gems.length] = new Gem(this, new Point(position.x, position.y), isPowerUp);
			
			return new Tile(null, Tile.PASSABLE);
			
		}
		
		// Width of level measured in tiles.
		private function get levelWidth():int{
			
			return _tiles.length;
			
		}
		
		// Height of level measured in tiles.
		private function get levelHeight():int{
			
			return _tiles[0].length;
			
		}
		
		// Animates each gem and allows the player to collect them.
		private function updateGems(gameTime:Number):void{
			
			for(var i:int = 0; i < _gems.length; ++i){
				
				var gem:Gem = _gems[i];
				
				gem.update(gameTime);
				
				if(gem.boundingCircle.intersects(player.boundingRectangle)){
					
					_gems.splice(i, 1);
					
					onGemCollected(gem, player);
					
				}
				
			}
			
		}
		
		// Updates each player and allows them to kill the player.
		private function updateEnemies(gameTime:Number):void{
			
			for each(var enemy:Enemy in _enemies){
				
				enemy.update(gameTime);
				
				// Touching an enemy without a powerUp instantly kills the player
				if(enemy.isAlive && enemy.boundingRectangle.intersects(player.boundingRectangle)){
					
      				if(player.isPoweredUp){
       					onEnemyKilled(enemy, player);
      				}else{
        				onPlayerKilled(enemy);
      				}
      				
    			}
				
			}
			
		}
		
		private function onEnemyKilled(enemy:Enemy, killedBy:Player):void{
			
      		enemy.onKilled(killedBy);
      		
    	}
		
		// Called when a gem is collected.
		private function onGemCollected(gem:Gem, collectedBy:Player):void{
			
			_score += gem.pointValue;
			
			gem.onCollected(collectedBy);

		}
		
		// Called when the player is killed.
		private function onPlayerKilled(killedBy:Enemy):void{
			
			player.onKilled(killedBy);
			
		}
		
		// Called when the player reaches the levels exit.
		private function onExitReached():void{
			
			player.onReachedExit();
			
			_exitReachedSound.play();
			
			_reachedExit = true;
			
		}
		
		// Scroll the camera to follow the player.
		private function scrollCamera(viewPort:Rectangle):void{
			
			const horizontalViewMargin:Number = 0.35;
			const verticalViewMargin:Number = 0.35;
			
			// Calculate the edges of the screen.
			var marginWidth:Number = viewPort.width * horizontalViewMargin;
			var marginLeft:Number = _cameraPosition.x + marginWidth;
			var marginRight:Number = _cameraPosition.x + viewPort.width - marginWidth;
			
			var marginHeight:Number = viewPort.height * verticalViewMargin;
			var marginTop:Number = _cameraPosition.y + marginHeight;
			var marginBottom:Number = _cameraPosition.y + viewPort.height - marginHeight;
			
			// Calculate how far to scroll the when the player is near the edges of the screen.
			var cameraMovement:Point = new Point();
			if(player.position.x < marginLeft)
				cameraMovement.x = player.position.x - marginLeft;
			else if(player.position.x > marginRight)
				cameraMovement.x = player.position.x - marginRight;
			
			if(player.position.y < marginTop)
				cameraMovement.y = player.position.y - marginTop;
			else if(player.position.y > marginBottom)
				cameraMovement.y = player.position.y - marginBottom;
				
			// Update the camera position, but prevent scrolling off the ends of the level.
			var maxCameraPositionX:Number = Tile.WIDTH * levelWidth - viewPort.width;
			var maxCameraPositionY:Number = Tile.HEIGHT * levelHeight - viewPort.height;
			_cameraPosition.x = RectangleExtensions.clamp(_cameraPosition.x + cameraMovement.x, 0, maxCameraPositionX);
			_cameraPosition.y = RectangleExtensions.clamp(_cameraPosition.y + cameraMovement.y, 0, maxCameraPositionY);
			
		}
		
		// Draws each tile in the level.
		private function drawTiles(canvasBD:BitmapData, cameraTransform:Matrix):void{
			
			// Calculate the visible range of tiles.
			var left:int = int(_cameraPosition.x / Tile.WIDTH);
			var right:int = left + canvasBD.width / Tile.WIDTH;
			right = Math.min(right, levelWidth - 1);
			
			// For each tile position
			for(var y:int = 0; y < levelHeight; ++y){
				for(var x:int = left; x <= right; ++x){
					// If there is a visible tile in that position
					var texture:BitmapData = _tiles[x][y].texture;
					if(texture!=null){
						// Draw it in screen space
						var position:Point = new Point(x * Tile.WIDTH, y * Tile.HEIGHT);
						canvasBD.copyPixels(texture, texture.rect, cameraTransform.transformPoint(position), null, null, true);
					}
				}
			}
			
		}
		
	}
	
}