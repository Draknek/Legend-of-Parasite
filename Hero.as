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
		
		public var dir:String = "Down";
		
		public function Hero (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(HeroGfx, 32, 32);
			
			sprite.centerOO();
			
			sprite.add("Down", [0, 1], 0.1);
			sprite.add("Up", [2, 3], 0.1);
			sprite.add("Left", [4, 5], 0.1);
			sprite.add("Right", [6, 7], 0.1);
			
			sprite.play("Down");
			
			setHitbox(8, 8, 4, 0);
			
			isPlayer = true;
			
			type = "hero";
			
			hurtBy = ["leever", "octorok", "stalfos", "octorok_spit", "spike", "likelike", "gel", "tektite"];
		}
		
		public override function doMovement (): void
		{
			moveBy(dx, dy, ["hero_solid", "solid", "spike"]);
			
			if (isMoving) {	
				if (dy > 0.4) dir = "Down";
				else if (dy < -0.4) dir = "Up";
				else if (dx > 0.4) dir = "Right";
				else if (dx < -0.4) dir = "Left";
				
				sprite.play(dir);
			}
			
			sprite.rate = isMoving ? 1 : 0;
			
			if (isMoving && ! wasMoving) { sprite.index++; }
		}
		
	}
}

