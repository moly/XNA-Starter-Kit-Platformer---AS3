package dee.moly.platformer{
	
	import flash.display.BitmapData;

	// Represents an animated texture.
    // Currently, this class assumes that each frame of animation is
    // as wide as the animation is tall. The number of frames in the
    // animation are inferred from this.
	public class Animation{
	
		// All frames in the animation arranged horizontally.
		public function get texture():BitmapData{
			return _texture;
		}
		private var _texture:BitmapData;
		
		// Duration of time to show each frame.
		public function get frameTime():Number{
			return _frameTime;
		}
		private var _frameTime:Number;
		
		// When the end of the animation is reached, should it
		// continue playing from the beginning?
		public function get isLooping():Boolean{
			return _isLooping;
		}
		private var _isLooping:Boolean;
		
		// Gets the number of frames in the animation.
		public function get frameCount():int{
			return texture.width / frameWidth;
		}
		
		// Gets the width of a frame in the animation.
		public function get frameWidth():int{
			// Assume square frames.
			return texture.height;
		}
		
		// Gets the height of a frame in the animation.
		public function get frameHeight():int{
			return texture.height;
		}
		
		// Constructs a new animation.
		public function Animation(texture:BitmapData, frameTime:Number, isLooping:Boolean):void{
		
			_texture = texture;
			_frameTime = frameTime;
			_isLooping = isLooping;
		
		}
		
	}
	
}