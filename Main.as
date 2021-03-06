package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	public class Main extends Engine
	{
		public function Main () 
		{
			super(256*2, 160*2, 60, true);
			FP.screen.scale = 2;
			//FP.console.enable();
			
			Input.define("ACTION1", Key.Z, Key.X, Key.C, Key.SPACE, Key.ENTER);
			Input.define("ACTION2");
		}
		
		public override function init (): void
		{
			sitelock("draknek.org");
			
			super.init();
			
			FP.width *= 0.5;
			FP.height *= 0.5;
			
			Overworld.init();
			
			FP.world = new Room(1, 3);
		}
		
		public function sitelock (allowed:*):Boolean
		{
			var url:String = FP.stage.loaderInfo.url;
			var startCheck:int = url.indexOf('://' ) + 3;
			
			if (url.substr(0, startCheck) == 'file://') return true;
			
			var domainLen:int = url.indexOf('/', startCheck) - startCheck;
			var host:String = url.substr(startCheck, domainLen);
			
			if (allowed is String) allowed = [allowed];
			for each (var d:String in allowed)
			{
				if (host.substr(-d.length, d.length) == d) return true;
			}
			
			parent.removeChild(this);
			throw new Error("Error: this game is sitelocked");
			
			return false;
		}
	}
}

