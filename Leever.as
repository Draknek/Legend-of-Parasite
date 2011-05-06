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
		public var underground:Boolean = false;
		public var switching:Boolean = false;
		
		public function Leever (_x:Number = 0, _y:Number = 0)
		{
			super(_x, _y);
			
			graphic = sprite = new Spritemap(LeeverGfx, 16, 16);
			
			sprite.centerOO();
			
			sprite.add("spin", [0, 1, 2], 0.2);
			sprite.add("halfway", [3, 4, 5], 0.2, false);
			sprite.add("buried", [6, 7, 8], 0.2, false);
			sprite.play("buried");
			
			setHitbox(14, 8, 7, 0);
			
			type = "leever";
			
			hurtBy = ["octorok_spit", "spike"];
			
			underground = true;
			undergrounding = true;
			collidable = false;
			sprite.visible = false;
		}
		
		public override function nativeBehaviour (): void
		{
			super.nativeBehaviour();
			
			if (underground && moveTimer == 16 && FP.rand(4) == 0) {
				doAction1 = true;
			}
		}
		
		public override function checkDeath (): void
		{
			if (! underground) {
				super.checkDeath();
			}
		}
		
		public override function doMovement (): void
		{
			var solidTypes:Array = ["leever_solid", "spike"];
			
			if (! underground) {
				solidTypes.push("leever", "solid");
			}
			
			moveBy(dx, dy, solidTypes);
			
			if (underground) {
				solidTypes.push("leever", "solid");
			}
			
			if (doAction1) {
				if (underground && collideTypes(solidTypes, x, y)) return;
				
				switching = true;
				
				if (sprite.complete || (sprite.currentAnim != "buried" && sprite.currentAnim != "halfway")) {
					if (undergrounding) sprite.play("buried", true);
					else sprite.play("halfway", true);
				}
				
				undergrounding = ! undergrounding;
			} else if (sprite.complete) {
				
				collidable = true;
				sprite.visible = true;
				underground = false;
			
				if (undergrounding) {
					if (sprite.currentAnim == "buried") {
						sprite.visible = false;
						collidable = false;
						underground = true;
					}
					else if (sprite.currentAnim == "halfway") sprite.play("buried");
				} else {
					if (sprite.currentAnim == "buried") sprite.play("halfway");
					else if (sprite.currentAnim == "halfway") sprite.play("spin");
					
				}
			}
		}
		
	}
}

