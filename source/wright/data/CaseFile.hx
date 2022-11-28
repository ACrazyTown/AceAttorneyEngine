package wright.data;

import haxe.Json;
//import wright.sequence.SequenceFrame;
import haxe.io.Path as HxPath;
import openfl.Assets;
import haxe.xml.Access;

enum DayType
{
	Trial;
	Investigation;
}

typedef Frame =
{
    bg:String,
	fg:String,
    character:String,
    animation:String,
    text:String,
    events:Array<String>,
    bubble:String
}

typedef Sequence =
{
    frames:Array<Frame>
}

typedef Day =
{
	type:String,
    main:Sequence,
    intro:Sequence
}

typedef DayData = 
{
    day:Day,
    version:Int
}

typedef ParsedCase =
{
    title:String,
    version:String,
    days:Array<DayData>
}

class CaseFile 
{
    public static function parse(path:String):ParsedCase
    {
		path = HxPath.addTrailingSlash(path);

        if (!Assets.exists('${path}case.xml'))
            return null;

		var _xml:Xml = Xml.parse(Assets.getText('${path}case.xml'));
        var xml:Access = new Access(_xml.firstElement());

        var parsedCase:ParsedCase = 
        {
            title: "",
            version: "",
            days: []
        };

        if (xml.name == "case")
        {
            if (xml.has.title)
                parsedCase.title = xml.att.title;
            if (xml.has.version)
                parsedCase.version = xml.att.version;
        }

		if (xml.hasNode.days) 
        {
            var days:Access = xml.node.days;
            var curDay:Int = 1;
            for (day in days.nodes.day) {
                // do stuff for each day obj
                for (i in 0...Std.parseInt(day.att.parts))
                {
					var ddPath:String = '${path}data/$curDay-${i + 1}.json';
                    if (!Assets.exists(ddPath))
                    {
                        trace("[WARNING] Missing day data! Removing day from case");
                        continue;
                    }

                    var data:DayData = Json.parse(Assets.getText(ddPath));
                    trace(data);
                    parsedCase.days.push(data);
                }

                curDay++;
            }
        }

        if (parsedCase.title == "" || parsedCase.days == [])
            return null;

        return parsedCase;
    }

    static function strToType(v:String):DayType
    {
        return switch(v.toLowerCase()) 
        {
            case "trial": Trial;
            case "investigation": Investigation;
            default: Trial;
        }
    }
}