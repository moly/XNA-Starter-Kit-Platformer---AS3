package dee.moly.platformer{
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	// Controls playack of an animation.
	public class AnimationPlayer{
	
		// Gets the animation which is currently playing.
		public function get animation():Animation{
			return _animation;
		}
		private var _animation:Animation;
		
		// Gets the index of the current frame in the animation.
		public function get frameIndex():int{
			return _frameIndex;
		}
		private var _frameIndex:int;
		
		// The amount of time in seconds that the current frame has been shown for.
		private var _time:Number;
		
		// The contents of the current frame
		private var _frame:BitmapData;
		
		// Gets a texture origin at the bottom centre of each frame.
		public function get origin():Point{
			return new Point(animation.frameWidth / 2, animation.frameHeight);
		}
		
		public function AnimationPlayer():void{
	
		}
		
		// Begins or continues playback of an animation.
		public function playAnimation(animation:Animation):void{
			
			// If this animation is already running, do not restart it.
			if(_animation == animation)
				return;
				
			// Start the new animation.
			_animation = animation;
			_frameIndex = 0;
			_time = 0;
			
			_frame = new BitmapData(animation.frameWidth, animation.frameHeight);
			
		}
		
		// Advances the time position and draws the current frame.
		public function draw(gameTime:Number, canvasBD:BitmapData, position:Point, flip:Boolean, cameraTransform:Matrix, colour:ColorTransform = null):void{
			
			if(_animation == null)
				throw new Error("No animation is currently playing.");
				
			// Process passing time.
			_time += gameTime / 1000;
			while(_time > _animation.frameTime){
				
				_time -= _animation.frameTime;
				
				// Advance the frame index; looping or clamping as appropriate.
				if(_animation.isLooping)
					_frameIndex  = (_frameIndex + 1) % _animation.frameCount;
				else
					_frameIndex = Math.min(_frameIndex + 1, _animation.frameCount - 1);				
				
			}
			
			// Calculate the source rectangle of the current frame.
			var source:Rectangle = new Rectangle(_frameIndex * _animation.texture.height, 0, _animation.texture.height, _animation.texture.height);
			
			// Calculate the matrix.
			cameraTransform.translate(position.x - origin.x, position.y - origin.y);
			if(flip == true){
				cameraTransform.a = -1;
				cameraTransform.tx += _animation.frameWidth;
			}
			
			// Draw the current frame.
			_frame.fillRect(_frame.rect, 0x00000000);
			_frame.copyPixels(_animation.texture, source, new Point(), null, null, true);
			canvasBD.draw(_frame, cameraTransform, colour);
		}
		
	}
	
}