package dee.moly.platformer{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	// A set of helpful methods for working with rectangles.
	public class RectangleExtensions{
	
		// Calculates the amount of overlap between two intersecting rectangles. These
        // depth values can be negative depending on which sides the rectangles
        // intersect. This allows callers to determine the correct direction
        // to push objects in order to resolve collisions.
        // If the rectangles are not intersecting, (0, 0) is returned.
		public static function getIntersectionDepth(rectA:Rectangle, rectB:Rectangle):Point{
			
			// Calculate half sizes.
            var halfWidthA:Number = rectA.width / 2;
            var halfHeightA:Number = rectA.height / 2;
            var halfWidthB:Number = rectB.width / 2;
            var halfHeightB:Number = rectB.height / 2;

            // Calculate centers.
            var centerA:Point = new Point(rectA.left + halfWidthA, rectA.top + halfHeightA);
            var centerB:Point = new Point(rectB.left + halfWidthB, rectB.top + halfHeightB);

            // Calculate current and minimum-non-intersecting distances between centers.
            var distanceX:Number = centerA.x - centerB.x;
            var distanceY:Number = centerA.y - centerB.y;
            var minDistanceX:Number = halfWidthA + halfWidthB;
            var minDistanceY:Number = halfHeightA + halfHeightB;

            // If we are not intersecting at all, return (0, 0).
            if (Math.abs(distanceX) >= minDistanceX || Math.abs(distanceY) >= minDistanceY)
                return new Point(0, 0);

            // Calculate and return intersection depths.
            var depthX:Number = distanceX > 0 ? minDistanceX - distanceX : -minDistanceX - distanceX;
            var depthY:Number = distanceY > 0 ? minDistanceY - distanceY : -minDistanceY - distanceY;
            return new Point(depthX, depthY);
			
		}
		
		// Gets the position of the center of the bottom edge of the rectangle.
        public static function getBottomCenter(rect:Rectangle):Point{
        	
            return new Point(rect.x + rect.width / 2.0, rect.bottom);
            
        }
        
        // Restricts a value to be within a specified range.
        public static function clamp(value:Number, min:Number, max:Number):Number{
			
			if(value < min)
				return min;
				
			if(value > max)
				return max;
				
			return value <= 0 || value >= 0 ? value : 0;
			
		}
		
	}
	
}