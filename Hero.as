package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Hero extends Creature
	{
		[Embed(source="images/hero.png")] public static const HeroGfx: Class;
		
		public var speed:Number = 2;
		
		public var sprite:Spritemap;
		
		public function Hero (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(HeroGfx, 16, 16);
			
			sprite.centerOO();
			
			sprite.add("down", [0, 1], 0.1);
			
			sprite.play("down");
			
			setHitbox(8, 8, 4, 0);
			
			isPlayer = true;
		}
		
		public override function doMovement (): void
		{
			moveBy(dx, dy, "hero_solid");
			
			sprite.rate = isMoving ? 1 : 0;
			
			if (isMoving && ! wasMoving) { sprite.index++; }
		}
		
	}
}
