package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		[Embed(source="images/tiles.png")] public static const TilesGfx: Class;
		
		public function Level ()
		{
			var g:Tilemap = new Tilemap(TilesGfx, 256, 160, 16, 16);
			
			for (var i:int = 0; i < g.columns; i++) {
				for (var j:int = 0; j < g.rows; j++) {
					g.setTile(i, j, FP.rand(3));
				}
			}
			
			addGraphic(g);
			
			var player:Creature = new Hero();
			
			player.isPlayer = true;
			
			add(player);
		}
		
		public override function update (): void
		{
			super.update();
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

