package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class LikeLike extends Creature
	{
		[Embed(source="images/likelike.png")] public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public function LikeLike (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(Gfx, 32, 32);
			
			sprite.centerOO();
			
			sprite.add("wobble", [0, 1], 0.05);
			sprite.add("eat", [2, 3, 2, 3, 2, 3], 0.1, false);
			sprite.play("wobble");
			
			setHitbox(16, 16, 8, 8);
			
			type = "likelike";
			
			hurtBy = ["octorok_spit", "spike"];
		}
		
		public override function nativeBehaviour (): void
		{
			super.nativeBehaviour();
			
			//if (inputDX > -0.6 && inputDX < 0.6) inputDX *= 2;
			//if (inputDY > -0.6 && inputDY < 0.6) inputDY *= 2;
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["hero_solid", "spike", "solid"];
			
			moveBy(dx*0.5, dy*0.5, solidTypes);
			
			if (doAction1) {
				sprite.play("eat");
				/*
				var i:Image = new Spritemap(Hero.HeroGfx, 16, 16);
				i.centerOO();
				i.x = x;
				i.y = y - 4;
				
				var e:Entity = world.addGraphic(i, layer);
				
				//i.alpha = 0.5;
				i.scale = 0.5;
				
				//FP.tween(i, {x: x+32}, 60);
				FP.tween(i, {y: y-16, alpha: 1, scale: 1}, 30, function ():void {FP.tween(i, {y: y-4, scale: 0.5}, 30, function():void{world.remove(e)}); });
				
				FP.tween(i, {}, 30);*/
			} else if (sprite.complete) {
				sprite.play("wobble");
			}
		}
		
	}
}

