package dee.moly.platformer{

	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	// Our adventurer.
	public class Player{
		
		// Animations
		private var _idleAnimation:Animation;
        private var _runAnimation:Animation;
        private var _jumpAnimation:Animation;
        private var _celebrateAnimation:Animation;
        private var _dieAnimation:Animation;
        private var _flip:Boolean;
        private var _sprite:AnimationPlayer = new AnimationPlayer();
		
		// Sounds
		private var _killedSound:Sound;
		private var _jumpSound:Sound;
		private var _fallSound:Sound;
		
		public function get level():Level{
			return _level;
		}
		private var _level:Level;
		
		public function get isAlive():Boolean{
			return _isAlive;
		}
		private var _isAlive:Boolean;
		
		// Powerup state
    	private const MAX_POWER_UP_TIME:Number = 6;
    	private var _powerUpTime:Number;
    	public function get isPoweredUp():Boolean{
      		return _powerUpTime > 0;
    	}
    	private const _poweredUpColours:Array = [
                        new ColorTransform(0, 1, 1, 1, 200),
                        new ColorTransform(1, 1, 0, 1, 0, 0, 200),
                        new ColorTransform(0, 0, 1, 1, 200, 150),
                        new ColorTransform(0, 0, 1, 1, 200, 200),
                                               	];
    	private var _powerUpSound:Sound;
		
		// Physics state
		public function get position():Point{
			return _position;			
		}
		public function set position(value:Point):void{
			_position = value;
		}
		private var _position:Point;
		
		private var _previousBottom:Number;
		
		public function get velocity():Point{
			return _velocity;
		}
		public function set velocity(value:Point):void{
			_velocity = value;
		}
		private var _velocity:Point;
		
		// Constants for controling horizontal movement
        private const MOVE_ACCELERATION:Number = 15000;
        private const MAX_MOVE_SPEED:Number = 1800;
        private const GROUND_DRAG_FACTOR:Number = 0.5;
        private const AIR_DRAG_FACTOR:Number = 0.5;

        // Constants for controlling vertical movement
        private const MAX_JUMP_TIME:Number = 0.3;
        private const JUMP_LAUNCH_VELOCITY:Number = -3800;
        private const GRAVITY_ACCELERATION:Number = 3000;
        private const MAX_FALL_SPEED:Number = 400;
        private const JUMP_CONTROL_POWER:Number = 0.12;
        
        // Gets whether or not the player's feet are on the ground.
        public function get isOnGround():Boolean{
        	return _isOnGround;
        }
        private var _isOnGround:Boolean;
        
        // Current user movement input
        private var _movement:Number;
        
        // Jumping state
        private var _isJumping:Boolean;
        private var _wasJumping:Boolean;
        private var _jumpTime:Number;
        
        private var _localBounds:Rectangle;
        // Gets a rectangle which bounds this player in world space.
        public function get boundingRectangle():Rectangle{
			
			var left:int = int(Math.round(position.x - _sprite.origin.x)) + _localBounds.x;
			var top:int = int(Math.round(position.y - _sprite.origin.y)) + _localBounds.y;
			
			return new Rectangle(left, top, _localBounds.width, _localBounds.height);
			
		}
		
		// Constructs a new player
		public function Player(level:Level, position:Point):void{
		
			_level = level;
			
			loadContent();
			
			reset(position);
		
		}
		
		// Handles input, performs physics and animates the player sprite
		public function update(gameTime:Number):void{
			
			var elapsed:Number = gameTime / 1000;
			
			if(isPoweredUp)
      			_powerUpTime = Math.max(0, _powerUpTime - elapsed);
			
			getInput();
			
			applyPhysics(gameTime);
			
			if(isAlive && isOnGround){
				if(Math.abs(velocity.x) - 0.02 > 0){
					_sprite.playAnimation(_runAnimation);
				}else{
					_sprite.playAnimation(_idleAnimation);
				}
			}
			
			// Clear input
			_movement = 0;
			_isJumping = false;
			
		}
			
		// Updates the player's velocity and position based on input, gravity etc
		public function applyPhysics(gameTime:Number):void{
			
			var elapsed:Number = gameTime / 1000;
			
			var previousPosition:Point = position;
			
			// Base velocity is a combination of horizontal movement control and
            // acceleration downward due to gravity.
            
            velocity.x += _movement * MOVE_ACCELERATION * elapsed;
            velocity.y = RectangleExtensions.clamp(velocity.y + GRAVITY_ACCELERATION * elapsed, -MAX_FALL_SPEED, MAX_FALL_SPEED);
            	
            velocity.y = doJump(velocity.y, elapsed);
            
            // Apply psuedo-drag horizontally.
            if(isOnGround)
            	velocity.x *= GROUND_DRAG_FACTOR;
            else
            	velocity.x *= AIR_DRAG_FACTOR;
            	
            // Prevent the player running faster than his top speed.
            velocity.x = RectangleExtensions.clamp(velocity.x, -MAX_MOVE_SPEED, MAX_MOVE_SPEED);
           
			// Apply velocity.
			position = position.add(new Point(velocity.x * elapsed, velocity.y * elapsed));
			position = new Point(Math.round(position.x), Math.round(position.y));
			
			// If the player is now colliding with the level, seperate them.
			handleCollisions();
			
            // If the collision stopped us from moving, reset the velocity to zero.
            if (position.x == previousPosition.x)
                velocity.x = 0;

            if (position.y == previousPosition.y)
                velocity.y = 0;
			
		}
		
		// Draws the animated player.
		public function draw(gameTime:Number, canvasBD:BitmapData, cameraTransform:Matrix):void{
			
			// Flip the sprite to face the way we are moving.
			if(velocity.x > 0)
				_flip = true;
			else if(velocity.x < 0)
				_flip = false;
				
			// Calculate a tint color based on power up state.
    		var colour:ColorTransform;
    		if(isPoweredUp){
      			var t:Number = ((getTimer() / 1000) + _powerUpTime / MAX_POWER_UP_TIME) * 20;
      			var colourIndex:int = int(t % _poweredUpColours.length);
      			colour = _poweredUpColours[colourIndex];
    		}else{
      			colour = null;
   	 		}
 
			// Draw the sprite
			_sprite.draw(gameTime, canvasBD, position, _flip, cameraTransform, colour);
			
		}
		
		public function powerUp():void{
			
      		_powerUpTime = MAX_POWER_UP_TIME;
      		_powerUpSound.play();
      		
    	}
		
		// Called when the player has been killed
        public function onKilled(killedBy:Enemy):void{
        	
        	_isAlive = false;
        	
        	if(killedBy!=null)
        		_killedSound.play();
        	else
        		_fallSound.play();
        		
        	_sprite.playAnimation(_dieAnimation);
        	
        }
		        
        // Called when the player reaches the level's exit
        public function onReachedExit():void{
        	
        	_sprite.playAnimation(_celebrateAnimation);
        	
        }
        	
		// Brings the player back to life
		public function reset(position:Point):void{
			
			_position = position;
			velocity = new Point();
			_isAlive = true;
			_powerUpTime = 0;
			_sprite.playAnimation(_idleAnimation);
			
		}
        
        // Loads the player sprite sheet and content
		private function loadContent():void{
			
			// Load animated textures.
			_idleAnimation = new Animation(level.content.load(ContentManager.BITMAP, "/Sprites/Player/Idle"), 0.1, true);
			_runAnimation = new Animation(level.content.load(ContentManager.BITMAP, "/Sprites/Player/Run"), 0.1, true);
			_jumpAnimation = new Animation(level.content.load(ContentManager.BITMAP, "/Sprites/Player/Jump"), 0.1, false);
			_celebrateAnimation = new Animation(level.content.load(ContentManager.BITMAP, "/Sprites/Player/Celebrate"), 0.1, false);
			_dieAnimation = new Animation(level.content.load(ContentManager.BITMAP, "/Sprites/Player/Die"), 0.1, false);
			
			// Calculate bounds within texture size.            
            var width:int = int(_idleAnimation.frameWidth * 0.4);
            var left:int = (_idleAnimation.frameWidth - width) / 2;
            var height:int = int(_idleAnimation.frameWidth * 0.8);
            var top:int = _idleAnimation.frameHeight - height;
            _localBounds = new Rectangle(left, top, width, height);
			
			// Load sounds.
			_killedSound = level.content.load(ContentManager.SOUND, "/Sounds/PlayerKilled");
			_jumpSound = level.content.load(ContentManager.SOUND, "/Sounds/PlayerJump");
			_fallSound = level.content.load(ContentManager.SOUND, "/Sounds/PlayerFall");
			_powerUpSound = level.content.load(ContentManager.SOUND, "/Sounds/PowerUp");
			
		}
		
		// Gets player movement commands from input
		private function getInput():void{
			
			if(Key.isDown(Keyboard.LEFT)){
				_movement = -1.0;
			}
			else if(Key.isDown(Keyboard.RIGHT)){
				_movement = 1.0;
			}
			
			// Check if the player wants to jump.
			_isJumping = Key.isDown(Keyboard.UP) ||
							Key.isDown(Keyboard.SPACE);
			
		}
		
		// Calculates the Y velocity for jumping and animates accordingly.
		private function doJump(velocityY:Number, gameTime:Number):Number{
			
			// If the player wants to jump
			if(_isJumping){
				// Begin or continue a jump
				if((!_wasJumping && isOnGround) || _jumpTime > 0){
					if(_jumpTime == 0)
						_jumpSound.play();
						
					_jumpTime += gameTime;
					_sprite.playAnimation(_jumpAnimation);
				}
				
				// If we are in the ascent of a jump
				if(_jumpTime > 0 && _jumpTime <= MAX_JUMP_TIME){
					
					// Fully override the vertical velocity with a power curve that gives players
					// more control over the top of the jump.
					velocityY = JUMP_LAUNCH_VELOCITY * (1 - Math.pow(_jumpTime / MAX_JUMP_TIME, JUMP_CONTROL_POWER));
					
				}else{
					
					// Reached the apex of the jump.
					_jumpTime = 0.0;
					
				}
				
			}else{
				
				// Continues not jumping or cancels a jump in progress
				_jumpTime = 0.0;
				
			}
			
			_wasJumping = _isJumping;
			
			return velocityY;
			
		}
		
		// Detects and resolves all collisions between the player and his neighbouring
        // tiles. When a collision is detected, the player is pushed away along one
        // axis to prevent overlapping. There is some special logic for the Y axis to
        // handle platforms which behave differently depending on direction of movement.
        private function handleCollisions():void{
        	
        	// Get the player's bounding rectangle and find neighbouring tiles.
        	var bounds:Rectangle = boundingRectangle;
        	var leftTile:int = int(Math.floor(bounds.left / Tile.WIDTH));
            var rightTile:int = int(Math.ceil(bounds.right / Tile.WIDTH)) - 1;
            var topTile:int = int(Math.floor(bounds.top / Tile.HEIGHT));
            var bottomTile:int = int(Math.ceil(bounds.bottom / Tile.HEIGHT)) - 1;
            
            // Reset flag to search for ground collision.
            _isOnGround = false;
            
            // For each potentially colliding tile
            for(var y:int = topTile; y <= bottomTile; ++y){
            	
            	for(var x:int = leftTile; x <= rightTile; ++x){
            		
            		// If this tile is collidable
            		var collision:int = level.getCollision(x, y);
            		
            		if(collision != Tile.PASSABLE){
            			
            			// Determine collision depth (with direction) and magnitude.
            			var tileBounds:Rectangle = level.getBounds(x, y);
            			var depth:Point = RectangleExtensions.getIntersectionDepth(bounds, tileBounds);
            			
            			if(depth.x != 0 && depth.y != 0){
            				
            				var absDepthX:Number = Math.abs(depth.x);
            				var absDepthY:Number = Math.abs(depth.y);
            				
            				// Resolve the collision along the shallow axis
            				if(absDepthY < absDepthX || collision == Tile.PLATFORM){
            					
            					// If we crossed the top of a tile, we are on the ground.
            					if(_previousBottom <= tileBounds.top)
            						_isOnGround = true;
            						
            					// Ignore platforms, unless we are on the ground.
            					if(collision == Tile.IMPASSABLE || isOnGround){
            						
            						// Resolve the collision along the y axis.
            						position = new Point(position.x, position.y + depth.y);
            						
            						// Perform further collisions with the new bounds.
            						bounds = boundingRectangle;
            						
            					}
            					
            				}else if(collision == Tile.IMPASSABLE){ // Ignore platforms.
            				
            					// Resolve the collision along the x axis.
            					position = new Point(position.x + depth.x, position.y);
            					
            					// Perform further collisions with the new bounds.
            					bounds = boundingRectangle;
            				
            				}
            				
            			}
            			
            		}
            		
            	}
            	
            }
            
            // Save the new bounds bottom.
            _previousBottom = bounds.bottom;
                    	
        }
        	
	}
	
}