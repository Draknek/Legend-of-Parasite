package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Leever extends Creature
	{
		[Embed(source="images/leever.png")] public static const LeeverGfx: Class;
		
		public var sprite:Spritemap;
		
		public var undergrounding:Boolean = false;
		public var switching:Boolean = false;
		
		public function Leever (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(LeeverGfx, 16, 16);
			
			sprite.centerOO();
			
			sprite.add("spin", [0, 1, 2], 0.2);
			sprite.add("halfway", [3, 4, 5], 0.2, false);
			sprite.add("buried", [6, 7, 8], 0.2, false);
			sprite.play("spin");
			
			setHitbox(14, 8, 7, 0);
		}
		
		public override function doMovement (): void
		{
			moveBy(dx, dy, "leever_solid");
			
			sprite.visible = true;
			
			if (doAction1) {
				switching = true;
				
				if (sprite.complete || (sprite.currentAnim != "buried" && sprite.currentAnim != "halfway")) {
					if (undergrounding) sprite.play("buried", true);
					else sprite.play("halfway", true);
				}
				
				undergrounding = ! undergrounding;
			} else if (sprite.complete) {
				if (undergrounding) {
					if (sprite.currentAnim == "buried") sprite.visible = false;
					else if (sprite.currentAnim == "halfway") sprite.play("buried");
				} else {
					if (sprite.currentAnim == "buried") sprite.play("halfway");
					else if (sprite.currentAnim == "halfway") sprite.play("spin");
					
				}
			}
		}
		
	}
}

