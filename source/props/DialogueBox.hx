package props;

import flixel.util.FlxDestroyUtil;
import wright.data.Character;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;

class DialogueBox extends FlxSpriteGroup
{
    var box:Sprite;

    var nameplate:Sprite;
    var nameplateTxt:FlxText;

    public var text:FlxTypeText;

    public function new(?character:String = null)
    {
        super();

		nameplate = new Sprite(x, y, "assets/images/ui/nameplate.png");

        var char:Character = Characters.get(character);

        scale.set(1.333333333333, 1.125);

        nameplateTxt = new FlxText(x, y, 0, char.nameplateName, 32);
        nameplateTxt.setFormat("Igiari", 32);
        nameplateTxt.antialiasing = false;
        nameplateTxt.x = (nameplate.width - nameplateTxt.width) / 2;
        nameplateTxt.y = (nameplate.height - nameplateTxt.height) / 2;

		box = new Sprite(x, (y + nameplate.height), "assets/images/ui/chatbox.png");

        text = new FlxTypeText(box.x + 15, box.y + 10, 630, "", 48);
        text.font = "Igiari";
		text.sounds = [FlxG.sound.load("assets/sounds/blip.ogg")];
		text.finishSounds = true;

		add(box);
        add(nameplate);
        add(nameplateTxt);
		if (character == null)
		{
		    nameplate.exists = false;
            nameplateTxt.exists = false;
        }
		add(text);
    }

	public function updateCharacter(?character:String = null)
	{
		var char:Character = Characters.get(character);
        nameplateTxt.text = char.nameplateName;
		nameplateTxt.x = x + (nameplate.width - nameplateTxt.width) / 2;
		nameplateTxt.y = y + (nameplate.height - nameplateTxt.height) / 2;

		if (character == null)
		{
			nameplate.exists = false;
			nameplateTxt.exists = false;
		}
        else
        {
            nameplate.exists = true;
            nameplateTxt.exists = true;
        }
    }

	override function destroy():Void
	{
		FlxDestroyUtil.destroy(box);
		FlxDestroyUtil.destroy(nameplate);
		FlxDestroyUtil.destroy(nameplateTxt);
		FlxDestroyUtil.destroy(text);
		super.destroy();
	}
}