package dee.moly.platformer{

	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.getTimer;
	
	// A valuable item the player can collect.
	public class Gem{
	
		private var _texture:BitmapData;
		private var _origin:Point;
		private var _collectedSound:Sound;
		
		public var pointValue:int;
		public var isPowerUp:Boolean;
		public var colour:ColorTransform;
			
		// The gem is animated from a base position along the y axis.
		private var _basePosition:Point;
		private var _bounce:Number;
		
		public function get level():Level{
			return _level;
		}
		private var _level:Level;
		
		// Gets the current position of the gem in world space.
		public function get position():Point{
			return _basePosition.add(new Point(0, _bounce));
		}
		
		// Gets a circle which bounds this gem in world space.
		public function get boundingCircle():Circle{
			return new Circle(position, Tile.WIDTH / 3);
		}
		
		// Constructs a new gem.
		public function Gem(level:Level, position:Point, isPowerUp:Boolean):void{
		
			_level = level;
			_basePosition = position;
			
			this.isPowerUp = isPowerUp;
    		if(isPowerUp){
      			pointValue = 100;
      			colour = new ColorTransform(0, 1, 1, 1, 200);
    		}else{
      			pointValue = 30;
				colour = new ColorTransform(0, 0, 1, 1, 255, 243);
   			}
			
			loadContent();
		
		}
		
		// Bounces up and down in the air to entice players to collect them.
		public function update(gameTime:Number):void{
			
			// Bounce control constants.
			const BOUNCE_HEIGHT:Number = 0.18;
            const BOUNCE_RATE:Number = 3;
            const BOUNCE_SYNC:Number = -0.75;
            
            // Bounce along a sine curve over time.
            // Include the X coordinate so that neighboring gems bounce in a nice wave pattern.            
            var t:Number = (getTimer() / 1000) * BOUNCE_RATE + position.x * BOUNCE_SYNC;
            _bounce = Math.sin(t) * BOUNCE_HEIGHT * _texture.height;
			
		}
		
		// Draws a gem.
		public function draw(gameTime:Number, canvasBD:BitmapData, cameraTransform:Matrix):void{
			
			cameraTransform.translate(position.x - _origin.x, position.y - _origin.y);
			canvasBD.draw(_texture, cameraTransform, colour);
			
		}
		
		// Called when this gem has been collected by a player and removed from the level.
        // The parameter is the player who collected this gem. Although currently not used, this parameter would be
        // useful for creating special powerup gems. For example, a gem could make the player invincible.
		public function onCollected(collectedBy:Player):void{
			
			_collectedSound.play();
			
			if(isPowerUp)
      			collectedBy.powerUp();
			
		}
		
		// Loads the gem texture and collected sound.
		private function loadContent():void{
			
			_texture = level.content.load(ContentManager.BITMAP, "/Sprites/Gem");
            _origin = new Point(_texture.width / 2, _texture.height / 2);
            _collectedSound = level.content.load(ContentManager.SOUND, "/Sounds/GemCollected");
			
		}
		
	}
	
}