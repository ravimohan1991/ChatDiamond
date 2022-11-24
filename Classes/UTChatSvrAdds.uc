class UTChatSvrAdds extends Info config(UTChat);

var() config string  ServerAddsSymbol;
var() config Color   ServerAddsColor;

var UTChatGRI UTGRI;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ( UTGRI == None )
    {
        foreach AllActors( class'UTChatGRI', UTGRI )
        break;
    }

    UTGRI.ServerAddsSymbol = ServerAddsSymbol;
    UTGRI.ServerAddsColor  = ServerAddsColor;

    SaveConfig();
}

defaultproperties
{
    ServerAddsSymbol="-"
    ServerAddsColor=(R=250,G=250,B=0,A=0)
}
