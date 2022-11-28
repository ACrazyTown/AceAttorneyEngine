package wright.data;

typedef CharData = 
{
    id:String,
    name:String,
    nameplateName:String
}

class Characters
{
    public static var charList:Map<String, CharData> =
    [
        "phoenixwright" => {id: "phoenixwright", name: "Phoenix Wright", nameplateName: "Phoenix"},
        "edgeworth" => {id: "edgeworth", name: "Miles Edgeworth", nameplateName: "Edgeworth"}
    ];

	public static function get(id:String):Character
	{
		return new Character(id);
	}
}

class Character
{
    public var id:String;
    public var name:String;
    public var nameplateName:String;

    public function new(id:String)
    {
        var c:String = id;
		if (!Characters.charList.exists(id.toLowerCase()))
            c = "phoenixwright";

        var dat:CharData = Characters.charList.get(c);
        this.id = dat.id;
        name = dat.name;
        nameplateName = dat.nameplateName;
    }
}