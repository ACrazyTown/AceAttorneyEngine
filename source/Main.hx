package;

import tools.openfl.DebugMonitor;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var instance:Main;

	public var debug:DebugMonitor;
	public function new()
	{
		instance = this;
		super();

		addChild(new FlxGame(1920, 1080, states.TrialState));

		#if debug
		debug = new DebugMonitor(5, 5);
		addChild(debug);
		#end

		//var b = Assets.getBytes("assets/test/sss.gif");
		//var ggs:AnimatedGif = new AnimatedGif(b);
		//addChild(ggs);
		//ggs.play();
	}
}
