package states;

import props.anim.AnimatedChar;
import wright.data.Character;
import states.substate.BubbleSubState;
import openfl.Assets;
import flixel.graphics.frames.FlxAtlasFrames;
import props.DialogueBox;
import props.BGFGSprite;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import wright.data.CaseFile;
import props.YellBubble;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;

class TrialState extends FlxState
{
	public static var instance:TrialState;

	var day:Int = 0;
	var CASE:ParsedCase;

	var curChar:String;

	var bg:BGFGSprite;
	var character:AnimatedChar;
	var fg:BGFGSprite;

	public var dialogue:DialogueBox;

	var bubble:YellBubble;

	override public function create():Void
	{
		instance = this;

		FlxG.mouse.load("assets/images/ui/cursor.png", 2);
		CASE = CaseFile.parse("assets/data/case0");

		bg = new BGFGSprite();
		bg.visible = false;
		fg = new BGFGSprite();
		fg.visible = false;

		add(bg);

		character = new AnimatedChar();
		character.playAnim("stand");
		add(character);

		add(fg);

		dialogue = new DialogueBox("Phoenix");
		dialogue.y = 408;
		add(dialogue);

		var shit:FlxSprite = new FlxSprite().loadGraphic("assets/images/ui/chatbox.png");
		shit.y = FlxG.height - shit.height;
		//add(shit);

		super.create();
	}

	var dia:Array<Frame> = [];
	override public function update(elapsed:Float):Void
	{
		/*
		if (CASE != null) {
			var cf:Array<Frame> = CASE.days[0].day.intro;
			@:privateAccess
			if (!txt._typing)
			{
				txt.text = cf[frameo].text;
				txt.start();
			}
		}*/

		if (CASE != null && !dStarted)
			startDialogue();
		if (dStarted && FlxG.keys.justPressed.ENTER) {
			if (dia[1] != null) {
				dia.remove(dia[0]);
				startDialogue();
			}
			else {
				//txt.color = FlxColor.RED;
				trace("DONE???????????????????");
			}
		}

		super.update(elapsed);
	}

	var dStarted:Bool = false;
	function startDialogue():Void
	{
		// prepare dialogue
		if (!dStarted)
			dia = CASE.days[day].day.intro.frames;
		//trace(dia);
		dStarted = true;
		var frame:Frame = dia[0];

		curChar = (frame.character == null) ? curChar : frame.character;
		var cDat:Character = Characters.get(curChar);

		if (frame.bubble != null)
		{
			super.openSubState(new BubbleSubState(frame.bubble, curChar));
		}

		if (frame.bg != null) 
		{
			bg.load("bg", frame.bg);
			if (!bg.visible)
				bg.visible = true;
		}

		if (frame.fg != null) 
		{
			fg.load("fg", frame.fg);
			if (!fg.visible)
				fg.visible = true;
		}

		dialogue.updateCharacter(curChar);
		dialogue.text.resetText(frame.text);
		dialogue.text.start(0.04, true);
		character.playAnim(character.curAnim.name + "-talk");
		dialogue.text.completeCallback = () -> 
		{
			if (character != null)
			{
				if (character.curAnim != null)
					character.playAnim(character.curAnim.name.split("-")[0]);

			}
		};

		Main.instance.debug.incFrame(1);
	}
}