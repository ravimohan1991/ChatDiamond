//=========================================================
// UTChatActor
//=========================================================

class UTChatActor expands Actor;

function PostBeginPlay()
{
  if ( DeathMatchPlus( Level.Game ) != None )
  {
     Log( "ServerActor, Spawning and adding Mutator...", 'UTChat' );
     Level.Game.BaseMutator.AddMutator( Level.Game.Spawn( class'UTChat' ) );
  }
  Destroy();
}

defaultproperties
{
     bHidden=True
}
