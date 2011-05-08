package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import flash.utils.ByteArray;
	
	public class Editor extends LoadableWorld
	{
		public var tiles:Tilemap;
		public var creatures:Tilemap;
		
		public static var palette:Boolean = false;
		
		public var drawable:Boolean = true;
		
		public static var tilesGfx:Image = new Image(Overworld.TilesGfx);
		public static var creaturesGfx:Image = new Image(Overworld.CreaturesGfx);
		
		public static var tilesBrush:Spritemap = new Spritemap(Overworld.TilesGfx, 16, 16);
		public static var creaturesBrush:Spritemap = new Spritemap(Overworld.CreaturesGfx, 16, 16);
		
		public static var brush:Spritemap = tilesBrush;
		
		public var px:int;
		public var py:int;
		public var pw:int;
		public var ph:int;
		
		public function Editor (i:int, j:int)
		{
			tiles = Overworld.tiles;
			creatures = Overworld.creatures;
			
			addGraphic(tiles);
			addGraphic(creatures);
			
			tilesGfx.scrollX = tilesGfx.scrollY = creaturesGfx.scrollX = creaturesGfx.scrollY = 0;
			tilesGfx.scale = creaturesGfx.scale = 2;
			
			pw = tilesGfx.width * 2;
			ph = tilesGfx.height * 2 + creaturesGfx.height * 2;
			
			px = FP.width - pw*0.5;
			py = FP.height - ph*0.5;
			
			tilesGfx.x = px;
			tilesGfx.y = py;
			creaturesGfx.x = px;
			creaturesGfx.y = py + tilesGfx.height*2;
			
			camera.x = i * Room.MOD_WIDTH - FP.width*0.5;
			camera.y = j * Room.MOD_HEIGHT - FP.height*0.5;
		}
		
		public override function begin (): void
		{
			super.begin();
			FP.screen.scale = 1;
		}
		
		public override function end (): void
		{
			super.end();
			FP.screen.scale = 2;
		}
		
		public override function update (): void
		{
			if (Input.pressed(Key.SPACE)) {
				palette = ! palette;
			}
			
			if (Input.pressed(Key.E)) {
				Overworld.reloadData();
				
				var i:int = Math.floor(camera.x / Room.MOD_WIDTH) + 1;
				var j:int = Math.floor(camera.y / Room.MOD_HEIGHT) + 1;
				FP.world = new Room(i, j);
				
				return;
			}
			
			camera.x += (Number(Input.pressed(Key.RIGHT)) - Number(Input.pressed(Key.LEFT)))
				* Room.MOD_WIDTH;
			
			camera.y += (Number(Input.pressed(Key.DOWN)) - Number(Input.pressed(Key.UP)))
				* Room.MOD_HEIGHT;
			
			if (Input.mouseDown) {
				if (palette) {
					palette = false;
					drawable = false;
					
					var mx:int = Input.mouseX;
					var my:int = Input.mouseY;
					
					if (mx < px || mx >= px + pw || my < py || my >= py+ph) return;
					
					mx -= px;
					my -= py;
					
					if (my < tilesGfx.height*2) {
						brush = tilesBrush;
					} else {
						brush = creaturesBrush;
						my -= tilesGfx.height*2;
					}
					
					brush.setFrame(mx / 32, my / 32);
				} else if (drawable) {
					var map:Tilemap = (brush == tilesBrush) ? tiles : creatures;
					
					map.usePositions = true;
					
					map.setTile(mouseX, mouseY, brush.frame);
					
					map.usePositions = false;
				}
			} else {
				drawable = true;
			}
		}
		
		public override function render (): void
		{
			super.render();
			
			FP.point.x = 0;
			FP.point.y = 0;
			
			Draw.setTarget(FP.buffer, FP.point);
			
			Draw.line(FP.width*0.5 + 8, -FP.height, FP.width*0.5 + 8, FP.height*2, 0x0);
			Draw.line(-FP.width, FP.height*0.5 + 8, FP.width*2, FP.height*0.5 + 8, 0x0);
			
			FP.point.x = -Room.MOD_WIDTH;
			FP.point.y = -Room.MOD_HEIGHT;
			
			Draw.line(FP.width*0.5 + 8, -FP.height, FP.width*0.5 + 8, FP.height*2, 0x0);
			Draw.line(-FP.width, FP.height*0.5 + 8, FP.width*2, FP.height*0.5 + 8, 0x0);
			
			if (palette) {
				FP.point.x = 0;
				FP.point.y = 0;
			
				Draw.rect(px-2, py-2, pw+4, ph+4, Room.WHITE);
				tilesGfx.render(FP.buffer, FP.zero, FP.zero);
				creaturesGfx.render(FP.buffer, FP.zero, FP.zero);
			} else {
				FP.point.x = int(mouseX/16)*16;
				FP.point.y = int(mouseY/16)*16;
			
				brush.render(FP.buffer, FP.point, camera);
			}
		}
		
		public override function getWorldData (): *
		{
			return Overworld.toString();
		}
		
		public override function setWorldData (data: ByteArray): void {
			Overworld.fromString(data.toString());
		}
		
	}
}

