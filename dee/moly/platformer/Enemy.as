package dee.moly.platformer{

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;

	// A monster who is impeding the progress of our adventurer.
	public class Enemy{
	
		// Facing direction.
		private const LEFT:int = -1;
		private const RIGHT:int = 1;
	
		public function get level():Level{
			return _level;
		}
		private var _level:Level;
		
		// Position in world space of the bottom centre of this enemy.
		public function get position():Point{
			return _position;
		}
		private var _position:Point;
		
		private var _localBounds:Rectangle;
		// Gets a rectangle which bounds this enemy in world space.
		public function get boundingRectangle():Rectangle{
			
			var left:int = int(Math.round(position.x - _sprite.origin.x)) + _localBounds.x;
            var top:int = int(Math.round(position.y - _sprite.origin.y)) + _localBounds.y;

        	return new Rectangle(left, top, _localBounds.width, _localBounds.height);
			
		}
		
		public var isAlive:Boolean;
		
		// Animations
		private var _runAnimation:Animation;
		private var _idleAnimation:Animation;
		private var _dieAnimation:Animation;
		private var _sprite:AnimationPlayer;
		
		// Sounds
    	private var _killedSound:Sound;
		
		// The direction this enemy is facing and moving along the X axis.
		private var _direction:int = -1;
		
		// How long this enemy has been waiting before turning around.
		private var _waitTime:Number;
		
		// How long to wait before turning around.
		private const MAX_WAIT_TIME:Number = 0.5;
		
		// The speed at which this enemy moves along the X axis.
		private const MOVE_SPEED:Number = 128;
	
		// Constructs a new enemy.
		public function Enemy(newLevel:Level, newPosition:Point, spriteSet:String):void{
		
			_level = newLevel;
			_position = newPosition;
			
			_sprite = new AnimationPlayer();
			
			loadContent(spriteSet);
			
			isAlive = true;
		
		}
		
		// Paces back and forth along a platform, waiting at either end
		public function update(gameTime:Number):void{
			
			var elapsed:Number = gameTime / 1000;

			if(!isAlive)
      			return;
			
            // Calculate tile position based on the side we are walking towards.
            var posX:Number = position.x + _localBounds.width / 2 * _direction;
            var tileX:int = int(Math.floor(posX / Tile.WIDTH)) - _direction;
            var tileY:int = int(Math.floor(position.y / Tile.HEIGHT));

            if(_waitTime > 0){
                // Wait for some amount of time.
                _waitTime = Math.max(0, _waitTime - elapsed);
                if(_waitTime <= 0){
                    // Then turn around.
                    _direction = -_direction;
                } 
            }else{
                // If we are about to run into a wall or off a cliff, start waiting.
                if (level.getCollision(tileX + _direction, tileY - 1) == Tile.IMPASSABLE ||
                    level.getCollision(tileX + _direction, tileY) == Tile.PASSABLE){
                    	
                    _waitTime = MAX_WAIT_TIME;
                    
                }else{
                    // Move in the current direction.
                    var velocity:Point = new Point(_direction * MOVE_SPEED * elapsed, 0);
                    _position = position.add(velocity);
                }
            }
			
		}
		
		// Draws the animated enemy
		public function draw(gameTime:Number, canvasBD:BitmapData, cameraTransform:Matrix):void{
			
			 // Play dying animation if dead. Stop running when the game is paused or before turning around.
			 if (!isAlive){
      			_sprite.playAnimation(_dieAnimation);
    		}else if(!level.player.isAlive ||
                level.reachedExit ||
                level.timeRemaining == 0 ||
                _waitTime > 0){
                	
                _sprite.playAnimation(_idleAnimation);
                
            }else{
            	
                _sprite.playAnimation(_runAnimation);
                
            }

            // Draw facing the way the enemy is moving.
            var flip:Boolean = _direction > 0 ? true : false;
            _sprite.draw(gameTime, canvasBD, position, flip, cameraTransform);
			
		}
		
		public function onKilled(killedBy:Player):void{
				
      		isAlive = false;
      		_killedSound.play();
      			
    	}
		
		// Loads a particular enemy sprite sheet and sounds.
		private function loadContent(spriteSet:String):void{
			
			// Load animations.
            spriteSet = "/Sprites/" + spriteSet + "/";
            _runAnimation = new Animation(level.content.load(ContentManager.BITMAP, spriteSet + "Run"), 0.1, true);
            _idleAnimation = new Animation(level.content.load(ContentManager.BITMAP, spriteSet + "Idle"), 0.15, true);
            _dieAnimation = new Animation(level.content.load(ContentManager.BITMAP, spriteSet + "Die"), 0.07, false);
            _sprite.playAnimation(_idleAnimation);
            
            // Load sounds.
    		_killedSound = level.content.load(ContentManager.SOUND, "/Sounds/MonsterKilled");

            // Calculate bounds within texture size.
            var width:int = int(_idleAnimation.frameWidth * 0.35);
            var left:int = (_idleAnimation.frameWidth - width) / 2;
            var height:int = int(_idleAnimation.frameWidth * 0.7);
            var top:int = _idleAnimation.frameHeight - height;
            _localBounds = new Rectangle(left, top, width, height);
			
		}
		
	}
	
}