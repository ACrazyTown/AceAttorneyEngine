package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

class Sprite extends FlxSprite
{
    public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
    {
        super(X, Y, SimpleGraphic);
        antialiasing = Globals.antialias;
    }
}