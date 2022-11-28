package props;

import flixel.FlxG;

class BGFGSprite extends Sprite
{
    private var type:String;
    private var imgId:String;

    public function new() 
    {
        super(0, 0);
    }

	public function load(type:String, id:String):Void
	{
		this.type = type;
		imgId = id;

		loadGraphic(Path.bgfg(type, correctId(id)));
		correctPositions();
    }

    private function correctId(id:String):String
    {
        return switch (id) 
        {
            case "prosecution": "defense";
            case "prosecution_desk": "defense_desk";
            default: id;
        }
    }

    private function correctPositions():Void
    {
        if (type == "fg")
        {
            switch (imgId)
            {
                case "defense_desk":
                    flipX = false;
                    x = 0;
                    y = FlxG.height - height;

                case "prosecution_desk":
                    flipX = true;
                    x = FlxG.width - width;
                    y = FlxG.height - height;
            }
        }
        else
        {
            // bg
            switch (imgId)
            {
                case "defense":
                    flipX = false;

                case "prosecution":
                    flipX = true;
            }
        }
    }
}