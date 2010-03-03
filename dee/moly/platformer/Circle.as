package dee.moly.platformer{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	// Represents a 2D circle.
	public class Circle{
	
		// Centre position of the circle.
		public var centre:Point;
	
		// Radius of the circle.
		public var radius:Number;
		
		// Constructs a new circle.
		public function Circle(position:Point, radius:Number):void{
		
			centre = position;
			this.radius = radius;
		
		}
		
		// Determines if a circle intersects a rectangle.
		public function intersects(rectangle:Rectangle):Boolean{
			
			var v:Point = new Point(RectangleExtensions.clamp(centre.x, rectangle.left, rectangle.right),
									 RectangleExtensions.clamp(centre.y, rectangle.top, rectangle.bottom));
			
			var direction:Point = centre.subtract(v);
			var distanceSquared:Number = direction.length * direction.length;
			
			return((distanceSquared > 0) && (distanceSquared < radius * radius));
			
		}
		
	}
	
}