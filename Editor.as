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
		
		public var activeTilemap:Tilemap;
		
		public function Editor (i:int, j:int)
		{
			tiles = Overworld.tiles;
			creatures = Overworld.creatures;
			
			activeTilemap = tiles;
			
			addGraphic(tiles);
			addGraphic(creatures);
			
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
			FP.screen.scale = 2;
			
			Overworld.reloadData();
		}
		
		public override function update (): void
		{
			if (Input.pressed(Key.TAB)) {
				activeTilemap = (activeTilemap == tiles) ? creatures : tiles;
			}
			
			if (Input.pressed(Key.E)) {
				var i:int = Math.floor(camera.x / Room.MOD_WIDTH) + 1;
				var j:int = Math.floor(camera.y / Room.MOD_HEIGHT) + 1;
				FP.world = new Room(i, j);
				return;
			}
			
			camera.x += (Number(Input.pressed(Key.RIGHT)) - Number(Input.pressed(Key.LEFT)))
				* Room.MOD_WIDTH;
			
			camera.y += (Number(Input.pressed(Key.DOWN)) - Number(Input.pressed(Key.UP)))
				* Room.MOD_HEIGHT;
			
			for (var k:int = 0; k <= 9; k++) {
				if (Input.check(k + Key.DIGIT_0)) {
					activeTilemap.usePositions = true;
					
					activeTilemap.setTile(mouseX, mouseY, k);
					
					activeTilemap.usePositions = false;
				}
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

