package props;

import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;

enum YellBubbleType
{
    Objection;
    HoldIt;
    TakeThat;
}

class YellBubble extends Sprite
{
    static final PATH:String = "assets/images/ui/bubble/";

    public var type:YellBubbleType = Objection;
    public var character:String;

    public var sound:FlxSound;

    public function new(type:YellBubbleType, ?character:String = null)
    {
        if (type == null)
            type = Objection;

        this.type = type;
        if (character != null)
            this.character = character;

        super(0, 0);

        sound = new FlxSound();
        sound.persist = true;

        loadGraphic('$PATH${stringifyType(this.type).toLowerCase()}.png');
        correctPositions();
    }

    var shake:Bool = false;
	var shakeIntensityX:Float = 0.02;
    var shakeIntensityY:Float = 0.008;
    var shakeDuration:Float = 0.35;

    public function trigger(?onComplete:Void->Void):Void
    {
        var path:String = (character == null) ? Path.yellSound() : Path.yellSound(character, type);
        sound.loadEmbedded(path);
        sound.play();
		shake = true;

        new FlxTimer().start(shakeDuration, (t:FlxTimer) -> 
        {
            shake = false;
        });

		new FlxTimer().start((sound.length * 1.1) / 1000, (t:FlxTimer) ->
		{
			if (onComplete != null)
				onComplete();
		});    
    
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (shake) 
        {
			offset.x = FlxG.random.float(-shakeIntensityX * width, shakeIntensityX * width);
			offset.y = FlxG.random.float(-shakeIntensityY * height, shakeIntensityY * height);
        }
        else
        {
            if (offset.x != 0 && offset.y != 0)
            {
                offset.x = 0;
                offset.y = 0;
            }
        }
    }

    public function correctPositions():Void
    {
        screenCenter();

        switch (type)
        {
            case Objection:
                y = -4;
            case HoldIt:
                y = -10;
            case TakeThat:
                y = 17;
        }
    }

    public static function stringifyType(type:YellBubbleType):String
    {
        if (type == null)
            return null;

        var type:String = switch (type) 
        {
            case Objection: "Objection";
            case HoldIt: "HoldIt";
            case TakeThat: "TakeThat";
            default: "Objection";
        }

        return type;
    }

    public static function typifyString(type:String):YellBubbleType
    {
        return switch (type.toLowerCase())
        {
            case "objection": Objection;
            case "holdit": HoldIt;
            case "takethat": TakeThat;
            default: Objection;
        }
    }
}