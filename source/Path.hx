package;

import flixel.system.FlxAssets;
import openfl.Assets;
import props.YellBubble;
import props.YellBubble.YellBubbleType;

class Path
{
    public static inline final SND_EXT:String = #if web ".mp3" #else ".ogg" #end;

    public static inline function yellSound(?character:String, ?type:YellBubbleType):String
    {
		var path:String = 'assets/sounds/$character/${YellBubble.stringifyType(type).toLowerCase()}$SND_EXT';

        if ((character == null || type == null) || !Assets.exists(path))
            return 'assets/sounds/yell$SND_EXT';

        return path;
    }

    public static function bgfg(type:String, id:String):String
    {
        return 'assets/images/$type/$id.png';
    }
}