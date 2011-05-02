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
		[Embed(source="images/creatures.png")] public static const CreaturesGfx: Class;
		
		[Embed(source="map.lvl", mimeType="application/octet-stream")] public static const MapData: Class;
		
		public static var tiles:Tilemap;
		public static var creatures:Tilemap;
		
		public static const WIDTH:int = Room.MOD_WIDTH * 4 + 16;
		public static const HEIGHT:int = Room.MOD_HEIGHT * 5 + 16;
		
		public static function init ():void
		{
			tiles = new Tilemap(TilesGfx, WIDTH, HEIGHT, 16, 16);
			creatures = new Tilemap(CreaturesGfx, WIDTH, HEIGHT, 16, 16);
			
			fromString(new MapData);
		}
		
		public static function toString ():String
		{
			return tiles.saveToString() + "@SPLIT@" + creatures.saveToString();
		}
		
		public static function fromString (data:String):void
		{
			var split:Array = data.split("@SPLIT@");
			
			tiles.setRect(0, 0, tiles.columns, tiles.rows, Room.ROCK);
			tiles.setRect(1, 1, tiles.columns-2, tiles.rows-2, Room.GRASS);
			tiles.loadFromString(split[0]);
			creatures.loadFromString(split[1]);
			
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

