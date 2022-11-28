package wright.courtrecord;

enum CourtRecordItemType
{
    Evidence;
    Profile;
}

interface ICourtRecordItem
{
    var type:CourtRecordItemType;

    var name:String;
    var description:String;
    var image:String;
}