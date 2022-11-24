class UTChatReplacement extends Info Config(UTChat);

var UTChatGRI  UTGRI;

struct WordConfig
{
	var string Word;
	var string With;
};

var() config int WordsPerMessage;
var() config WordConfig Replace[25];

function PostBeginPlay()
{
    local int i, j;

    Super.PostBeginPlay();

    SaveConfig();

    if (UTGRI == None)
    {
        foreach AllActors(class'UTChatGRI', UTGRI)
        break;
    }

    j = 0;
    if (UTGRI != None)
    {
        UTGRI.WordsPerMesg = WordsPerMessage;

        for (i=0; i<25; i++)
        {
            if (Replace[i].Word != "")
            {
                UTGRI.Word1[j] = Replace[i].Word;
                UTGRI.Word2[j] = Replace[i].With;
                j++;
            }
        }
    }
}

defaultproperties
{
    WordsPerMessage=3
}
