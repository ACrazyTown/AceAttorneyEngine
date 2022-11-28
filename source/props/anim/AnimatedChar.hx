package props.anim;

import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.xml.Access;
import openfl.Assets;

typedef AnimFrame = 
{
	repeat:Int,
	sprites:Array<SpriteRect>
}

typedef Animation =
{
	graphic:FlxGraphicAsset,
	xml:String,
	name:String,
	frames:Array<AnimFrame>,
	loop:Bool,
	fps:Int
}

typedef SpriteRect =
{
	id:Int,
	rx:Float,
	ry:Float,
	rw:Int,
	rh:Int,
	x:Float,
	y:Float
}

class AnimatedChar extends FlxSpriteGroup
{
	public var animations:Map<String, Animation>;

	var loadedSprites:Map<String, Array<SpriteRect>>;

	var curDrawn:Array<Sprite>;

	public var curAnim:Animation;
	var curFrame:Int = 0;

	public function new()
	{
		super(0, 0);

		loadedSprites = new Map<String, Array<SpriteRect>>();
		animations = new Map<String, Animation>();
		curDrawn = [];

		var stfuPenis:String = "assets/images/characters/test2/trite";
		loadAnim('$stfuPenis.png', '$stfuPenis.xml');
	}

	var frameTimer:Float = 0;
	var frameDelay:Float = 1 / 24;
	var done:Bool = false;

	var repeater:Int = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (curAnim != null)
		{
			/*
			frameTimer += elapsed;
			if (frameTimer > frameDelay && !done)
			{
				var frame:AnimFrame = curAnim.frames[curFrame];
				trace(frame + "|" + curFrame + "|" + curAnim.frames.length);
				if (frame != null)
				{
					if (frame.repeat != 0 && repeater < frame.repeat)
						repeater++;
					else
					{
						curFrame++;
						drawFrames();
						if (curFrame > curAnim.frames.length)
						{
							if (!curAnim.loop)
								done = true;
							else {
								curFrame = 0;
								drawFrames();
							}
						}
					}
					frameTimer = 0;
				}
			}
			*/
			
			var _frame:AnimFrame = curAnim.frames[curFrame];
			if (_frame != null)
			{
				if (_frame.repeat > 0)
					frameDelay = (1/curAnim.fps) * _frame.repeat;
				else {
					if (frameDelay != (1/curAnim.fps))
						frameDelay = 1/curAnim.fps;
				}
			}

			frameTimer += elapsed;
			if (frameTimer >= frameDelay && !done)
			{
				curFrame++;
				if (curFrame > curAnim.frames.length)
					curFrame = 0;

				drawFrames();
				frameTimer = 0;
			}
		}
	}

	private function setFrameDelay(fps:Int):Float
	{
		return frameDelay = 1 / fps;
	}

	private function drawFrames():Void
	{
		if (curAnim != null)
		{
			var curFrame:AnimFrame = curAnim.frames[curFrame];
			if (curFrame != null)
			{
				for (sprite in curDrawn)
				{
					for (newSprite in curFrame.sprites)
					{
						// assuming `curAnim.graphic` is the same
						if (compareSpriteRect(sprite.clipRect, newSprite))
							continue;
						else
						{
							sprite.kill();
							curDrawn.remove(sprite);
							remove(sprite);
							sprite.destroy();
						}
					}
				}

				for (sprRect in curFrame.sprites)
				{
					var sprite:Sprite = new Sprite();
					sprite.loadGraphic(curAnim.graphic);
					sprite.clipRect = new FlxRect(sprRect.rx, sprRect.ry, sprRect.rw, sprRect.rh);
					sprite.x += sprRect.x;
					sprite.y += sprRect.y;
					add(sprite);
					curDrawn.push(sprite);
				}
			}
		}
	}

	public function playAnim(name:String):Void
	{
		if (done)
			done = false;

		if (!animations.exists(name))
			return;

		curAnim = animations.get(name);
		setFrameDelay(curAnim.fps);
	}

	public function loadAnim(src:FlxGraphicAsset, desc:String):Void
	{
		var graphic:FlxGraphic = FlxG.bitmap.add(src);
		if (graphic == null)
			return;

		if (src == null || desc == null)
			return;

		if (Assets.exists(desc))
			desc = Assets.getText(desc);

		var xml:Access = new Access(Xml.parse(desc).firstElement());

		for (sprite in xml.nodes.Sprite)
		{
			if (loadedSprites.get(desc) == null)
				loadedSprites.set(desc, []);

			var id:Int = Std.parseInt(sprite.att.id);
			var rx:Float = Std.parseFloat(sprite.att.rx);
			var ry:Float = Std.parseFloat(sprite.att.ry);
			var rw:Int = Std.parseInt(sprite.att.rw);
			var rh:Int = Std.parseInt(sprite.att.rh);
			var _x:Float = Std.parseFloat(sprite.att.x);
			var _y:Float = Std.parseFloat(sprite.att.y);

			loadedSprites.get(desc).push({
				id: id,
				rx: rx,
				ry: ry,
				rw: rw,
				rh: rh,
				x: _x,
				y: _y
			});
		}

		var currentSprites:Array<SpriteRect> = loadedSprites.get(desc);
		for (anim in xml.nodes.Animation)
		{
			var name:String = anim.att.name;
			if (name == null)
			{
				continue;
			}

			var loop:Bool = (anim.att.loop.toLowerCase() == "true") ? true : false;
			var fps:Int = Std.parseInt(anim.att.fps);

			var animation:Animation = animations.get(name);
			if (animation == null)
			{
				animation = {
					graphic: src,
					xml: desc,
					name: name,
					fps: fps,
					loop: loop,
					frames: []
				};
			}
			else
				continue; // anim already exists so fucking skip it lmao

			for (frame in anim.nodes.Frame)
			{
				var repeat:Int = 0;
				if (frame.has.repeat)
					repeat = Std.parseInt(frame.att.repeat);

				var aFrame:AnimFrame = 
				{
					repeat: repeat,
					sprites: []
				};

				for (frameSpr in frame.nodes.FrameSprite)
				{
					if (!frameSpr.has.sprite)
						continue;

					var spriteId:Int = Std.parseInt(frameSpr.att.sprite);
					aFrame.sprites.push(currentSprites[spriteId]);
				}

				//if (repeat != 0)
				//	for (i in 0...repeat)
				//		animation.frames.push(aFrame);
				//else
				animation.frames.push(aFrame);
			}

			animations.set(animation.name, animation);
		}
	}

	private function compareSpriteRect(rect1:FlxRect, rect2:SpriteRect):Bool
	{
		var values:Array<String> = ["id", "rx", "ry", "rw", "rh", "x", "y"];
		var crValues:Map<String, Dynamic> = [
			"id" => null,
			"rx" => "x",
			"ry" => "y",
			"rw" => "width",
			"rh" => "height",
			"x" => null,
			"y" => null
		];

		for (value in values)
		{
			var crValue:Dynamic = crValues.get(value);
			if (Reflect.hasField(rect1, crValue) && Reflect.hasField(rect2, value))
			{
				if (Reflect.getProperty(rect1, crValue) != Reflect.getProperty(rect2, value))
					return false;
			}
		}

		return true;
	}
}

// TODOS:
// XML PARSING THE FRAMES INCORRECTLY?
// PLACING BAD???
// INVESTIGATE MY BROTEHR