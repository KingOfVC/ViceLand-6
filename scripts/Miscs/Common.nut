Authority <-
{
    Member = 1,
    Developer = 10
}

SqPlayer.newmember("FindPlayer", function (player)
{
    if(typeof(player) != "integer" && SqStr.AreAllDigit(player)) player = player.tointeger();

    switch(typeof(player))
    {
        case "integer":
        {
            if( player.tointeger() > 99 ) return false;
            player = SqFind.Player.WithID(player);
        }   break;
        case "string":
        {
            player = SqFind.Player.NameContains(false, false, player);
        }   break;
    }

    if(!player.Active) return false;
    else return player;
});

Vector3.newmember("FromString", function (str)
{
	local sp = split( str, "," );

	return Vector3( sp[0].tofloat(), sp[1].tofloat(), sp[2].tofloat() );
});

function LoadCheckpoint()
{
	local result = SqDatabase.Query( "SELECT * FROM Checkpoints" );
	 
	while( result.Step() ) 
	{
		local checkpoint = SqCheckpoint.Create( result.GetInteger( "World" ), true, Vector3.FromStr( result.GetString( "Pos" ) ), Color4.FromStr( result.GetString( "Color" ) ), result.GetInteger( "Size" ) );
    	checkpoint.SetTag( result.GetString( "UID" ) );
	    checkpoint.Data = CCheckpoint( checkpoint.Tag );
	}
}

function LoadKeybind()
{
	local result = SqDatabase.Query("SELECT * FROM Keybinds");
	
	while(result.Step()) 
	{
		local key = SqKeybind.Create( true, result.GetNumber( "Key" ), 0, 0 );
		key.SetTag( result.GetString( "Type" ) );
	}
	
}

function LoadVehicle()
{
	local result = SqDatabase.Query("SELECT * FROM Vehicle"), girl;

	while(result.Step()) SqVehicle.Create( result.GetInteger("Model"), 0, Vector3.FromStr( result.GetString("Pos") ), 0, result.GetInteger("Col1"), result.GetInteger("Col2") ).EulerRotation = Vector3.FromStr( result.GetString("Angle") ); 


}

function errorHandling( err )
{
	local stackInfos = getstackinfos(2);

	if ( stackInfos )
	{
		local locals = "";

		foreach( index, value in stackInfos.locals )
		{
			if( index != "this" )
				locals = locals + "[" + index + "] " + value + "\n";
		}

		local callStacks = "";
		local level = 2;
		do 
		{
			callStacks += "*FUNCTION [" + stackInfos.func + "()] " + stackInfos.src + " line [" + stackInfos.line + "]\n";
			level++;
		} 
		while( ( stackInfos = getstackinfos( level ) ) );

		local errorMsg = "AN ERROR HAS OCCURRED [" + err + "]\n";
		errorMsg += "\nCALLSTACK\n";
		errorMsg += callStacks;
		errorMsg += "\nLOCALS\n";
		errorMsg += locals;
	
	
		WriteToFile( "[" + SqInteger.TimestampToDate( time() ) + "] " + errorMsg );
	
		SqLog.Err( errorMsg );
	
		SqCast.MsgAdmin( TextColor.Staff, Lang.ErrorShown );
   }

}

function ExcuteCode( code )
{
    try
    {
        local excuteCode = compilestring( code.tostring() );
        excuteCode();

        return true;
    }
    catch( e ) return e;
}

function GetTok( string, separator, n, ... )
{
    local m = vargv.len() > 0 ? vargv[0] : n,
    tokenized = split( string, separator ),
    text = "";
        
    if ( n > tokenized.len() || n < 1 ) return null;
    for ( ; n <= m; n++ )
    {
            text += text == "" ? tokenized[n-1] : separator + tokenized[n-1];
    }
    return text;
}

function NumTok( string, separator )
{
    local tokenized = split( string, separator );
    return tokenized.len();
}

function PlayStaffRoomMuzik()
{
    PlaySound( 100, 50008, Vector3.FromStr( "1249.068726,404.630890,11" ) );
}

function WriteToFile( text )
{
	local filename = "Loggins/" + Server.Logname + ".txt";
	local fhnd = file(filename, "a+");
	foreach(char in text) fhnd.writen(char, 'c'); 
	fhnd.writen('\n', 'c');
	fhnd.close();
	fhnd=null;
}

function LoadArea()
{
   /* foreach( index, value in Server.Area )
    {
        local area = SqArea( index );
        area.AddArray( value.Pos );
        area.Manage();    
    }

    SqLog.Scs( "Total area loaded: %s", SqInteger.ToThousands( Server.Area.len() ) );*/
}

function AutoMessage()
{
	switch( Server.AutoMessage.State )
	{
		case 0:
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" && player.Data.Logged ) player.Msg( HexColour.Cyan, Lang.HelpMessages[ Server.AutoMessage.Place ] );
		});

		Server.AutoMessage.State = 1;
		Server.AutoMessage.Place ++;

		if( Server.AutoMessage.Place == Lang.HelpMessages.len() ) Server.AutoMessage.Place = 0;
		SqDM.SaveTeamScore();
		break;

		case 1:
		SqEvents.RectStart();

		SqRoutine( SqEvents, SqEvents.RectTimeout, 200000, 1 ).SetTag( "EndRT" );
		
		Server.AutoMessage.State = 2;
		break;

		case 2:
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.Logged ) player.Msg( TextColor.Event, Lang.GetTopTeam[ player.Data.Language ], SqDM.GetTeamScore() );
		});

		Server.AutoMessage.State = 0;
		break;
	}
}

function FindTimer( tag )
{
	try 
	{
		return SqFindRoutineByTag( tag );
	}
	catch( _ ) _;
}

function ReadTextFromFile(path)
{
    local f = file(path,"rb"), s = "";

    while (!f.eos())
    {
        s += format(@"%c", f.readn('b'));
    }

    f.close();

    return s;
}