package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Zola extends Creature
	{
		[Embed(source="images/zola.png")] public static const ZolaGfx: Class;
		
		public var sprite:Spritemap;
		
		public function Zola (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(ZolaGfx, 16, 16);
			
			sprite.centerOO();
			
			//sprite.add("down", [0, 1], 0.1);
			
			//sprite.play("down");
		}
		
		public override function doMovement (): void
		{
			x += dx;
			y += dy;
		}
		
	}
}

