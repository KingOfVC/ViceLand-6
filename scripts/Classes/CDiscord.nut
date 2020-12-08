class CDiscord
{
    FromDiscord = null;

    Data = 
    {
        ID = 0,
        Time = 0,
        "Text" : null
    }

    function constructor()
    {
        receiveFromBot();

        DontSend();
    }

    function ToDiscord( id, ... )
    {
        vargv.insert( 0, this );

        local text = format.acall( vargv )

        this.Data.Text = text;
        this.Data.ID = id;
        this.Data.Time = ::time();

        this.WriteTextToFile( "\n" + ::json_encode( this.Data ) );
    }

    function ToDiscord2( id, data )
    {
        this.Data.Text = data;
        this.Data.ID = id;
        this.Data.Time = ::time();

        this.WriteTextToFile( "\n" + ::json_encode( this.Data ) );
    }

    function ToDiscord3( id, text )
    {
        this.Data.Text = text;
        this.Data.ID = id;
        this.Data.Time = ::time();

        this.WriteTextToFile( "\n" + ::json_encode( this.Data ) );
    }

    function DontSend()
    {
        this.Data.Text = "dont_send";
        this.Data.ID = 0;
        this.Data.Time = ::time();

        this.WriteTextToFile( "\n" + ::json_encode( this.Data ) );
    }

    function SendPlayerCount( left = false )
    {
        local getcount = 0;
        SqForeach.Player.Active( this, function( player ) 
        {
            getcount ++;
        });

        local a = {};

        if( left ) getcount --;
        
        a.rawset( "Count", getcount );

        this.WriteTextToFile2( "\n" + ::json_encode( a ) );
    }

    function PartReason( player, reason )
    {
       	switch( reason )
		{
			case 1: reason = "**%s** disconnected from the server."; break;
			case 0: reason = "**%s** lost connection to server."; break;
			case 2: reason = "**%s** has been kicked from the server."; break;
			case 3: reason = "**%s** game crashed."; break;
		}

        this.ToDiscord( reason, player );
    }

    function receiveFromBot()
    {
        local tim = SqRoutine( this, function()
        {
            try 
            {
                local read_json = json_decode( ReadTextFromFile( "discord/messages/from_discord.json" ) );

                if( read_json.Text != "dont_send" )
                {
                    if( this.FromDiscord != read_json.Text )
                    {
                        this.FromDiscord = read_json.Text;

                        this.ProcessMessage( read_json.User, read_json.Text );
                    }
                }
            }
            catch( _ ) _;
        }, 100, 0 );

        tim.Quiet = false;
    }

    function ProcessMessage( user, message )
    {
        local 
		isadmin = 0,
        plr = user,
        cmds = split( message.slice( 0 ), " " )[0],
	    arr = split( message," " ).len() > 1 ? message.slice( message.find( " " ) + 1 ) : "";
		
        switch( cmds )
        {
		/*	case "!cmds":
			this.ToDiscord( 3, "**!players, !stats, !pinfo, !roundinfo, !serverinfo**" );
			break;
			
			case "!acmds":
			if ( isadmin > 1 )
			{
				if ( isadmin == 3 )	this.ToDiscord( 10, "**!setweather**" );
				else if ( isadmin == 4 )	this.ToDiscord( 10, "**!setweather, !removeacc**" );
				else if ( isadmin == 5 )	this.ToDiscord( 10, "**!setweather, !removeacc, !lockserver, !unlockserver**" );
				else if ( isadmin == 6 )	this.ToDiscord( 10, "**!setweather, !removeacc, !lockserver, !unlockserver, !exe**" );
			}
			break;				
		
            case "!players":
            local count = 0, unknowncount = 0, blue = null, red = null, unknown = null;
            local gameplay = Handler.Handlers.Gameplay;
            local pdata = {};

            SqForeach.Player.Active( this, function( player ) 
            {
                if( player.Team == 1 && player.Spawned )
                {
                    if( red ) red = red + ", " + player.Name;
                    else red = player.Name;
                }

                if( player.Team == 2 && player.Spawned )
                {
                    if( blue ) blue = blue + ", " + player.Name;
                    else blue = player.Name;
                }

                if( !player.Spawned || player.Team == 7 )
                {                    
                    if( unknown ) unknown += ", " + player.Name;
                    else unknown = player.Name;
                    unknowncount ++;     
                }

                count ++;
            });

            if( !red ) red = "None";
			if( !blue ) blue = "None";
			if( !unknown ) unknown = "None";

            if( red ) pdata.rawset( "Red", red );
            if( blue ) pdata.rawset( "Blue", blue );
            if( unknown ) pdata.rawset( "Unspawn", unknown );

            if( count > 0 )
            {
                pdata.rawset( "Total", count );

                this.ToDiscord2( 2, pdata );
            }
            else this.ToDiscord( 3, "**No player online** :sob:" );
            break;

            case "!stats":
            if( arr != " " )
            {
            	local q = Handler.Handlers.Script.Database.QueryF( "SELECT * FROM rtv3_account INNER JOIN rtv3_pstats ON rtv3_account.ID = rtv3_pstats.ID WHERE Lower(Name) = '%s'", arr.tolower() );
				local pdata = {};

				if( q.Step() )
				{
                	local ratio = ( typeof( q.GetFloat( "Kills" ) / q.GetFloat( "Deaths" ) ) != "float" ) ? 0.0 : q.GetFloat( "Kills" ) / q.GetFloat( "Deaths" );

                    pdata.rawset( "Name", q.GetString( "Name" ) );
                    pdata.rawset( "Kills", q.GetInteger( "Kills" ) );
                    pdata.rawset( "Deaths", q.GetInteger( "Deaths" ) );
                    pdata.rawset( "Ratio", ratio );

                    pdata.rawset( "TopSpree", q.GetInteger( "TopSpree" ) );
                    pdata.rawset( "Stolen", q.GetInteger( "Stolen" ) );

                    pdata.rawset( "RoundPlayed", q.GetInteger( "RoundPlayed" ) );
                    pdata.rawset( "WinAtt", q.GetInteger( "AttWon" ) );
                    pdata.rawset( "WinDef", q.GetInteger( "DefWon" ) );
                    pdata.rawset( "MVP", q.GetInteger( "MVP" ) );

                    if( arr.tolower().find( "kiki" ) >= 0 || arr.tolower().find( "kingofvc" ) >= 0 ) pdata.rawset( "Image", "https://a.rsg.sc//n/kikita0106/n" );
                    else pdata.rawset( "Image", "https://cdn.discordapp.com/icons/339341411860086784/ed4f466c9825284242b8ffa9d674b820.webp" );

                    this.ToDiscord2( 4, pdata );
                }
                else this.ToDiscord( 1, "**Error: ** Player does not exist." );
            }
            else this.ToDiscord( 1, "**Syntax: ** !stats [player]" );
            break;

            case "!pinfo":
            case "!playerinfo":
            if( arr != " " )
            {
            	local q = Handler.Handlers.Script.Database.QueryF( "SELECT * FROM rtv3_account INNER JOIN rtv3_pstats ON rtv3_account.ID = rtv3_pstats.ID WHERE Lower(Name) = '%s'", arr.tolower() );
				local pdata = {};

				if( q.Step() )
				{
                    pdata.rawset( "Name", q.GetString( "Name" ) );
                    pdata.rawset( "DateReg", ::GetDate( q.GetInteger( "DateReg" ) ) );
                    pdata.rawset( "DateLog", ::GetDate( q.GetInteger( "DateLog" ) ) );
                    pdata.rawset( "Playtime", ::GetTiming( q.GetInteger( "Playtime" ) ) );
                    pdata.rawset( "Position", ::GetRank( q.GetInteger( "AdminLevel" ) ) );

                    if( arr.tolower().find( "kiki" ) >= 0 || arr.tolower().find( "kingofvc" ) >= 0 ) pdata.rawset( "Image", "https://a.rsg.sc//n/kikita0106/n" );
                    else pdata.rawset( "Image", "https://cdn.discordapp.com/icons/339341411860086784/ed4f466c9825284242b8ffa9d674b820.webp" );

                    this.ToDiscord2( 5, pdata );
                }
                else this.ToDiscord( 1, "**Error: ** Player does not exist." );
            }
            else this.ToDiscord( 1, "**Syntax: ** %s [player]", cmds );
            break;
			
			case "!round":
            case "!roundinfo":
			local gameplay = Handler.Handlers.Gameplay;
			local roundtime = ::seconds_to_mmss( gameplay.RoundTime );
			local basename = "None";
            if ( gameplay.Status > 2 )
            {
				if ( gameplay.Status == 3 ) roundtime = "Preparing round, it will start in " + roundtime + " seconds.";
				basename = Handler.Handlers.Bases.Bases[ gameplay.Bases ].Name;
				local pdata = {};
                pdata.rawset( "Name", basename );
                pdata.rawset( "Time", roundtime );
				pdata.rawset( "Sprees", ::GetSprees() );
				
                this.ToDiscord2( 9, pdata );
            }
            else this.ToDiscord( 3, "**Round is not active.**" );
            break;
			
			case "!exe":
			if ( isadmin > 5 )
			{
				if( arr != " " )
				{
					try
					{
						local script = compilestring( arr );
						if( script )
						{
							this.ToDiscord( 10, "Code [ %s ] executed.", arr );
							SqCast.MsgAllAdmin( "DiscordExecSucs", plr );
							script();
						}
					}
					catch( e ) this.ToDiscord( 10, "Execute error [ %s ]", e );
				}
				else this.ToDiscord( 10, "**Syntax: ** %s [code]", cmds );	
			}
			break;
			
			case "!removeacc":
			if ( isadmin > 3 )
			{
				if( arr != " " )
				{
					local nick = Handler.Handlers.Script.Database.QueryF( "SELECT Name FROM rtv3_account WHERE Name LIKE '%s';", arr );
					if ( nick.Step() )
					{
						local target = ::FindPlayer( arr );
						if ( !target )
						{
							Handler.Handlers.Script.Database.ExecuteF( "DELETE FROM rtv3_account WHERE Name = '%s';", arr );
							this.ToDiscord( 10, "Account [ %s ] has been removed successfully.", arr );
							SqCast.MsgAllAdmin( "DiscRemoveAcc", plr, arr );
						}
						else this.ToDiscord( 10, "Target in the server right now." );
					}
					else this.ToDiscord( 10, "Given name does not exist." );
				}
				else this.ToDiscord( 10, "**Syntax: ** %s [full nick]", cmds );	
			}
			break;
			
			case "!lockserver":
			if ( isadmin > 4 )
			{
				if( arr != " " )
				{
					local servp = Handler.Handlers.Script.Database.QueryF( "SELECT ServPass FROM rtv3_server;"); 
					SqServer.SetPassword( arr );
					if ( servp.Step() ) Handler.Handlers.Script.Database.ExecuteF( "UPDATE rtv3_server SET ServPass = '%s';", arr ); 
					else Handler.Handlers.Script.Database.ExecuteF( "INSERT INTO rtv3_server VALUES( '%s' );", arr );
					
					this.ToDiscord( 10, "Server has been locked with password [ %s ].", arr );
					SqCast.MsgAllAdmin( "DiscLockServer", plr );
				}
				else this.ToDiscord( 10, "**Syntax: ** %s [password]", cmds );	
			}		
			break;
			
			case "!unlockserver":
			if ( isadmin > 4 )
			{
				local servp = Handler.Handlers.Script.Database.QueryF( "SELECT ServPass FROM rtv3_server;"); 
				if ( servp.Step() )
				{
					SqServer.SetPassword( "" );
					Handler.Handlers.Script.Database.ExecuteF( "DELETE FROM rtv3_server;" ); 

					SqCast.MsgAllAdmin( "DiscUnlockServer", plr );
					this.ToDiscord( 10, "Server has been unlocked." );
				}
				else this.ToDiscord( 10, "Server is already unlocked." );	
			}		
			break;
			
			case "!setweather":
			if ( isadmin > 2 )
			{
				if( arr != " " )
				{
					SqServer.SetWeather( arr.tointeger() );

					SqCast.MsgAll( "DiscSW", plr, ::GetWeatherName( arr.tointeger() ) );
					this.ToDiscord( 10, "Server weather changed: **[ " + ::GetWeatherName( arr.tointeger() ) + " ]**" );
				}
				else this.ToDiscord( 10, "**Syntax: ** %s [ID]", cmds );	
			}		
			break;*/
			
            default:
			if ( isadmin > 1 ) 
			{
				Handler.Handlers.Script.AC = 1;
				SqCast.MsgAllAdmin( "DiscordAdminChat", plr, cmds + " " + arr );
				this.ToDiscord( 0, "**%s [Staff Discord]:** %s", plr, cmds + " " + arr );
			}
			else 
			{
			//	SqCast.MsgAll( "DiscordChat", plr, cmds + " " + arr );

                SqCast.MsgAll( TextColor.Info, Lang.onDiscordChat, HexColour.White, StripCol( plr ), cmds + " " + arr );

				this.ToDiscord( 1, "**%s [Discord]:** %s", plr, cmds + " " + arr );
			}
        //    else this.ToDiscord( 1, "**Syntax: ** !say [text]" );
            break;
        }
    }

    function WriteTextToFile( text )
    {
        local filename = "discord/messages/discord_server.json";
        local fhnd = file(filename, "w");
        foreach(char in text) fhnd.writen(char, 'c'); 
        fhnd.writen('\n', 'c');
        fhnd.close();
        fhnd=null;
    }

    function WriteTextToFile2( text )
    {
        local filename = "discord/messages/playercount.json";
        local fhnd = file(filename, "w");
        foreach(char in text) fhnd.writen(char, 'c'); 
        fhnd.writen('\n', 'c');
        fhnd.close();
        fhnd=null;
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

  /*  function SendToPrivate( text, type )
    {
        local urlType = "Rob The Vehicle", urlName = "";
        
        switch( type )
        {
            case "pm":
            urlType = "discordapp.com/api/webhooks/702055784040890378/EyjWHejdoKYm_I-Xm0FTJtQQDyeEF1scgEJqA5cuXyGa3f5IG9Pq-Ph7zz-WEgA9kwXm";
            urlName = "Private Message";
            break;
            
            case "tc":
            urlType = "discordapp.com/api/webhooks/702059738451542116/6aO3B1AxRYCrq4faGZ7ul34qhvRLO-I4JbJtBmSlnXsIRGczWKd-TPqsQ2zsSEgxbVqX"
            urlName = "Team Chat";
            break;
            
        }
        return system("curl -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '{\"content\":\"" + text + "\", \"username\":\"" + urlName + "\"}' https://" + urlType );
   //     return print( "curl -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '{\"embeds\": [{ \"title\": \"Private Message\", \"description\": \"" + text + "\", \"color\": 16056320,\"footer\": {\"text\": \"" + GetDate( time() ) + "\"}}], \"username\": \"" + urlName + "\"}' https://" + urlType );

    
    }*/



}

