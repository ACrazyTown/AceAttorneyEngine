package wright.courtrecord;

import wright.courtrecord.ICourtRecordItem.CourtRecordItemType;

class Profile implements ICourtRecordItem
{
	public var type:CourtRecordItemType;

	public var name:String;
	public var description:String;
	public var image:String;

    public function new(name:String, description:String, image:String):Void 
    {
        this.type = Profile;
        
        this.name = name;
        this.description = description;
        this.image = image;
    }
}