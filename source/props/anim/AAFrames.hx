package props.anim;

import haxe.xml.Access;
import openfl.Assets;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;

typedef AAXmlSprite =
{
    id:String,
    x:Float,
    y:Float,
    w:Int,
    h:Int
}

class AAFrames
{
    public static function get(source:FlxGraphicAsset, description:String) {
        // taken from `FlxAtlasFrames.fromSparrow()` lol
		var graphic:FlxGraphic = FlxG.bitmap.add(source);
        if (graphic == null)
            return null;

        var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(source);
        if (frames != null)
            return frames;

        if (graphic == null || description == null)
            return null;

        frames = new FlxAtlasFrames(graphic);

        if (Assets.exists(description))
            description = Assets.getText(description);

        var data:Access = new Access(Xml.parse(description).firstElement());

        var sprites:Array<AAXmlSprite> = [];
        for (sprite in data.nodes.Sprite)
        {
            sprites.push({
                id: sprite.att.id,
                x: Std.parseFloat(sprite.att.x),
                y: Std.parseFloat(sprite.att.y),
                w: Std.parseInt(sprite.att.w),
                h: Std.parseInt(sprite.att.h)
            });
        }
        

        return null;
    }
}