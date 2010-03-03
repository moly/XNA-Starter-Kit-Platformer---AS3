package dee.moly.platformer{
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Layer{
	
		public var textures:Vector.<BitmapData>;
		public var scrollRate:Number;
		private var _levelHeight:Number;
		
		public function Layer(content:ContentManager, path:String, scrollRate:Number, levelHeight:Number):void{
		
			_levelHeight = levelHeight;
			this.scrollRate = scrollRate;
			
			// Assumes each layer only has 3 vertical segments.
			textures = new Vector.<BitmapData>(3, true);
			for(var i:int = 0; i < 3; ++i){
				textures[i] = content.load(ContentManager.BITMAP, "/Backgrounds/" + path + "_" + i);
			}
			
		}
		
		// Calculate which segments to draw and how much to offset them
		public function draw(canvasBD:BitmapData, cameraPosition:Point):void{
			
			// Assume each segment is the same width and height.
			var segmentWidth:int = textures[0].width;
			var segmentHeight:int = textures[0].height;
			
			// Calculate which segments to draw and how to offset them.
			var x:Number = cameraPosition.x * scrollRate;
            var leftSegment:int = int(x / segmentWidth);
            var rightSegment:int = leftSegment + 1;
            x = (x / segmentWidth - leftSegment) * -segmentWidth;
		
			var y:Number = (cameraPosition.y - _levelHeight + segmentHeight) * -scrollRate;
			var bottomSegment:int = int(y / segmentHeight);
			var topSegment:int = bottomSegment + 1;
			
			var texturesLength:int = textures.length;
			
			canvasBD.copyPixels(textures[leftSegment % texturesLength], new Rectangle(-x, 0, segmentWidth + x, segmentHeight), new Point(0, y), null, null, true);
			canvasBD.copyPixels(textures[rightSegment % texturesLength], new Rectangle(0, 0, -x, segmentHeight), new Point(x + segmentWidth, y), null, null, true);
			
		}
		
	}
	
}