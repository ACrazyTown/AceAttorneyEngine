package wright.courtrecord;

class CourtRecord
{
    public var evidence:Array<Evidence> = [];
    public var profiles:Array<Profile> = [];

    public function new(?evidence:Array<Evidence>, ?profiles:Array<Profile>):Void
    {
        var badge:Evidence = new Evidence("Attorney's Badge", "Placeholder", "Placeholder");

        if (evidence == null)
            this.evidence.push(badge);

        // TODO: Clean up, push regular defaults.
        // Dont hardcode stuff THAT much.
    }

    public inline function getEvidenceList():Array<Evidence>
        return evidence;

    public inline function getProfileList():Array<Profile>
        return profiles;
}