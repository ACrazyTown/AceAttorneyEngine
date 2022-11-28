package wright.courtrecord;

import wright.courtrecord.ICourtRecordItem.CourtRecordItemType;

class Evidence implements ICourtRecordItem
{
	public var type:CourtRecordItemType;

	public var name:String;
	public var description:String;
	public var image:String;

    public function new(name:String, description:String, image:String):Void 
    {
        this.type = Evidence;

        this.name = name;
        this.description = description;
        this.image = image;
    }
}