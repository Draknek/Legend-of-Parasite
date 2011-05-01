package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import flash.utils.ByteArray;
	
	public class Overworld
	{
		[Embed(source="images/tiles.png")] public static const TilesGfx: Class;
		
		[Embed(source="map.lvl", mimeType="application/octet-stream")] public static const MapData: Class;
		
		public static var tiles:Tilemap;
		
		public static const WIDTH:int = 512 - 16;
		public static const HEIGHT:int = 320 - 16;
		
		public static function init ():void
		{
			tiles = new Tilemap(TilesGfx, WIDTH, HEIGHT, 16, 16);
			
			tiles.loadFromString(new MapData);
			
			reloadData();
		}
		
		public static function reloadData ():void
		{
			drawEdges();
		}
		
		public static function drawEdges ():void
		{
			tiles.updateAll();
			
			var i:int, j:int;
			var a:uint, b:uint, c:uint;
			
			tiles.usePositions = true;
			
			for (i = 0; i < WIDTH; i += 1) {
				for (j = 16; j < HEIGHT; j += 16) {
					a = tiles.getTile(i, j - 1);
					b = tiles.getTile(i, j);
					
					if (a == b) continue;
					
					tiles.setPixel(i, j - FP.rand(2), Room.BLACK);
					
					var d:int = tileDiff(a, b);
					
					if (d) {
						c = color(a, b, d);
						
						d -= FP.rand(2);
						
						//c = FP.colorLerp(Room.BLACK, tiles.getPixel(i, j + d), 0.25);
						
						tiles.setPixel(i, j + d, c);
					}
				}
			}
			
			for (i = 16; i < WIDTH; i += 16) {
				for (j = 0; j < HEIGHT; j += 1) {
					a = tiles.getTile(i - 1, j);
					b = tiles.getTile(i, j);
					
					if (a == b) continue;
					
					tiles.setPixel(i - FP.rand(2), j, Room.BLACK);
					
					d = tileDiff(a, b);
					
					if (d) {
						c = color(a, b, d);
						
						d -= FP.rand(2);
						
						//c = FP.colorLerp(Room.BLACK, tiles.getPixel(i, j + d), 0.25);
						
						tiles.setPixel(i + d, j, c);
					}
				}
			}
			
			tiles.usePositions = false;
		}
		
		private static function tileDiff (a:uint, b:uint): int
		{
			if (a == Room.WATER) return 2;
			if (b == Room.WATER) return -2;
			if (a == Room.ROCK) return -3;
			if (b == Room.ROCK) return 3;
			return 0;
		}
		
		private static function color (a:uint, b:uint, diff:int): uint
		{
			var tile:uint = (diff > 0) ? b : a;
			
			if (tile == Room.ROCK) return Room.BLACK;
			if (tile == Room.GRASS) return 0xff265f49;
			
			return Room.BLACK;
		}
		
	}
}

