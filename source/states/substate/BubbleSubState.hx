package states.substate;

import props.YellBubble;
import flixel.FlxSubState;

class BubbleSubState extends FlxSubState
{
    var bubble:YellBubble;

    public function new(type:String, character:String)
    {
        super();

        persistentUpdate = false;

        if (TrialState.instance != null)
        {
            if (TrialState.instance.dialogue != null)
                TrialState.instance.dialogue.visible = false;
        }

		bubble = new YellBubble(YellBubble.typifyString(type), character);
		add(bubble);
		bubble.trigger(() ->
		{
			close();

            persistentUpdate = true;
			if (TrialState.instance != null)
			{
				if (TrialState.instance.dialogue != null)
					TrialState.instance.dialogue.visible = true;
			}
		});
    }
}