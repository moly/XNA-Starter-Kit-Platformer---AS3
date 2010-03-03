package dee.moly.platformer{

	import flash.display.BitmapData;
	import flash.geom.Point;
	
	// Controls the collision detection and response behavior of a tile.
	public class Tile{
		
		// A passable tile is one which does not hinder player motion at all.
		public static const PASSABLE:int = 0;
		
		// An impassable tile is one which does not allow the player to move through
		// it at all. It is completely solid.
		public static const IMPASSABLE:int = 1;
		
		// A platform tile is one which behaves like a passable tile except when the
        // player is above it. A player can jump up through a platform as well as move
        // past it to the left and right, but can not fall down through the top of it.
		public static const PLATFORM:int = 2;
		
		public static const WIDTH:int = 40;
		public static const HEIGHT:int = 30;
		
		// Stores the appearence and collision behaviour of a tile
		public var texture:BitmapData;
		public var collision:int;
		
		public static const SIZE:Point = new Point(WIDTH, HEIGHT);
		
		// Constructs a new tile
		public function Tile(tileTexture:BitmapData, collisionType:int):void{
		
			texture = tileTexture;
			collision = collisionType;
		
		}
		
	}
	
}