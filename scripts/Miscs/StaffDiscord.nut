class StaffDiscord extends SqDiscord.Session
{
	function constructor() 
	{
		base.constructor();
		
		base.Bind(SqDiscordEvent.Ready, this, onReady);
    	base.Bind(SqDiscordEvent.Message, this, onMessage);
   // 	base.Bind(SqDiscordEvent.GuildLoaded, this, onLoaded);
	}
	
	function onReady() 
	{
		
	}
	
	function onLoaded() 
	{
		SqLog.Scs("Sucessfully connected to Discord. (Staff)");
	}
	
	function onMessage(channelID, author, authorNick, authorID, roles, message)
	{
		if( author != "Purple" && author != "MoMo" )
		{
		    if( channelID == Server.DiscordBot.StaffBot.Channel )
			{
				if ( message.slice( 0, 1 ) == "!" )
				{
					local
					cmds = ( message == "!" ) ? "" : split( message.slice( 1 ), " " )[0],
		    		arr = split( message," " ).len() > 1 ? message.slice( message.find( " " ) + 1 ) : null;

					if ( arr == null ) ::onStaffDiscordCommand( author, authorNick, cmds, roles, null );
					else ::onStaffDiscordCommand( author, authorNick, cmds, roles, arr );
				}
			}
		}
	}

	function SendMessage( text )
	{
		//if( Server.EnableEcho ) this.Message( Server.DiscordBot.StaffBot.Channel.tostring(), text );
	}

	function getRank( roles )
	{
		foreach( value in roles )
		{
			switch( value )
			{
				case "549536263645036545":
				return 4;

				case "549543058547671050":
				return 3;

				case "549557178818756619":
				return 2;

				case "549558117487345675":
				return 1;
			}	
		}

		return 0;
	}
	
}

// Create an instance of our Session
StaffBot <- StaffDiscord();

function onStaffDiscordCommand( author, nick, cmds, roles, arr )
{
	switch( cmds )
	{
		case "players":
        local result = null, getCount = 0;
        SqForeach.Player.Active( this, function( target ) 
        {
            if( result ) result = result + ", " + target.Name;
            else result = target.Name;

            getCount ++;
        });

        if( result ) SendMessageToDiscord( format( "**Players online** %s", result ) ), SqCast.EchoMessage( format( "**Total players** %d", getCount ) )
        else SendMessageToDiscord( format( "**No player online T_T**" ) );
        break;

        case "ac":
        if( StaffDiscord.getRank( roles ) > 0 )
        {
	        if( arr )
	        {
	        	local nick2 = ( nick == "" ) ? author : nick;

                SqCast.MsgAdmin( TextColor.Staff, Lang.AAdminChat3, "Discord", nick2, arr );			

                StaffBot.SendMessage( format( "**%s** %s**:** %s", "Discord", nick2, arr ) );
	    	}
	    	else SendMessageToDiscord( format( "**Syntax,** !ac [text] " ) ); 
	    }
	    else SendMessageToDiscord( format( "**Error,** You dont have permission to use this command." ) ); 
        break;

        case "sc":
        if( StaffDiscord.getRank( roles ) > 0 )
        {
	        if( arr )
	        {
	        	local nick2 = ( nick == "" ) ? author : nick;

                SqCast.MsgStaff( TextColor.Staff, Lang.AAdminChat2, "Discord", nick2, arr );			

                StaffBot.SendMessage( format( "**%s** %s**:** %s", "Discord", nick2, arr ) );
	    	}
	    	else SendMessageToDiscord( format( "**Syntax,** !ac [text] " ) ); 
	    }
	    else SendMessageToDiscord( format( "**Error,** You dont have permission to use this command." ) ); 
        break;

        case "exe":
        if( StaffDiscord.getRank( roles ) > 3 )
        {
	        if( arr )
	        {
                if( ::ExcuteCode( arr ) == true )
                {
                    SendMessageToDiscord( format( "Code ``%s`` has sucessfully executed.", arr.tostring() ) ); 
                }
	    		else SendMessageToDiscord( format( "**Error,** %s", ::ExcuteCode( arr ).tostring() ) ); 
	    	}
	    	else SendMessageToDiscord( format( "**Syntax,** !exe [code]" ) ); 
        }  
	    else SendMessageToDiscord( format( "**Error,** You dont have permission to use this command." ) ); 
        break;

        case "kick":
        if( StaffDiscord.getRank( roles ) > 0 )
        {
        	if( arr )
        	{
	        	local
	        	victim = split( arr," " ).len() > 1 ? split( arr.slice( 1 ), " " )[0] : null,
		    	reason = split( arr," " ).len() > 1 ? arr.slice( arr.find( " " ) + 1 ) : null,
		    	nick2 = ( nick == "" ) ? author : nick;

		    	if( victim && reason )
		    	{
		            local target = SqPlayer.FindPlayer( victim );
		            if( target )
		            {
		                if( SqMath.IsGreaterEqual( StaffDiscord.getRank( roles ), target.Data.Player.Permission.Staff.Position.tointeger() ) )
		               	{
		                    SqCast.MsgAll( TextColor.Admin, Lang.AKickAll, "Discord Admin", nick2, TextColor.Admin, target.Name, TextColor.Admin, reason );

		                    EchoBot.SendMessage( format( "%s **%s** kicked **%s** from the server. Reason **%s**", "Discord Admin", nick2, target.Name, reason ) );

		                    target.Kick();
		                }
		                else SendMessageToDiscord( format( "**Error,** You cannot use on higher admin." ) ); 
		            }
		            else SendMessageToDiscord( format( "**Error,** Target player not online." ) ); 
		        }
				else SendMessageToDiscord( format( "**Error,** !kick [player] [reason]" ) ); 
		    }
			else SendMessageToDiscord( format( "**Error,** !kick [player] [reason]" ) ); 
		}  
	    else SendMessageToDiscord( format( "**Error,** You dont have permission to use this command." ) ); 
        break;

        case "mute":
        if( StaffDiscord.getRank( roles ) > 0 )
        {
        	if( arr )
        	{
	        	local
	        	victim = split( arr, " " )[0],
	        	dur = split( arr," " ).len() > 1 ? split( arr.slice( 1 ), " " )[1] : null,
		    	reason = ::GetTok( arr, " ", 3, ::NumTok( arr, " " ) );
		    	nick2 = ( nick == "" ) ? author : nick;

		    	if( victim && reason && reason )
		    	{
		            local target = SqPlayer.FindPlayer( victim );
		            if( target )
		            {
		                if( SqMath.IsGreaterEqual( StaffDiscord.getRank( roles ), target.Data.Player.Permission.Staff.Position.tointeger() ) )
		               	{
                            try 
                            {
                                SqAdmin.AddMute( target, nick2, reason, SqAdmin.GetDuration( dur ) );

                                SqCast.MsgAll( TextColor.Admin, Lang.AMuteTimeredAll, "Discord Admin", nick2, TextColor.Admin, target.Name, TextColor.Admin, reason, TextColor.Admin, SqInteger.SecondToTime( SqAdmin.GetDuration( dur ) ) );
  
  		                    	EchoBot.SendMessage( format( "%s **%s** muted **%s**. Reason **%s** Duration **%s**", "Discord Admin", nick2, target.Name, reason, SqInteger.SecondToTime( SqAdmin.GetDuration( dur ) ) ) );
                                                  
                                target.MakeTask( function()
                                {  
                                    SqAdmin.UID[ target.UID ].Mute = null;
                                    SqAdmin.UID2[ target.UID2 ].Mute = null;
                                                                
                                    this.Terminate();

                                    SqCast.MsgAll( TextColor.Admin, Lang.AUnmuteTimered, target.Name );

                                    EchoBot.SendMessage( format( "Auto unmuted **%s**", target.Name ) );
                                }, ( SqAdmin.GetDuration( dur ) * 1500 ), 1 ).SetTag( "Mute" );
                            }
                           catch( e ) SendMessageToDiscord( format( "**Error,** Wrong time format. It should be ?y/?w/?d/?h/?m." ) ); 
    		            }
		                else SendMessageToDiscord( format( "**Error,** You cannot use on higher admin." ) ); 
		            }
		            else SendMessageToDiscord( format( "**Error,** Target player not online." ) ); 
		        }
				else SendMessageToDiscord( format( "**Error,** !mute [player] [duration] [reason]" ) ); 
		    }
			else SendMessageToDiscord( format( "**Error,** !mute [player] [duration] [reason]" ) ); 
		}  
	    else SendMessageToDiscord( format( "**Error,** You dont have permission to use this command." ) ); 
        break;

        case "allowaccess":
        if( StaffDiscord.getRank( roles ) > 0 )
        {
        	if( arr )
        	{
        		if( SqAccount.FindAccountByName( arr ) )
                {
                	local q = SqDatabase.Query( format( "SELECT * FROM Accounts INNER JOIN PlayerData ON Accounts.ID = PlayerData.ID WHERE Lower(Name) = '%s'", arr.tolower() ) );

                	if( q.Step() )
					{
	                	if( SToB( q.GetString( "AllowRemoteLogin" ) ) == false )
	                	{
	                		SendMessageToDiscord( format( "You allowed **%s** account access, they may login now.", q.GetString( "Name" )  ) );

	                		SqDatabase.Exec( format( "UPDATE Accounts SET AllowRemoteLogin = '%s' WHERE ID = '%d' ", "true", q.GetInteger( "ID" ) ) );
	                	}
	                	else SendMessageToDiscord( format( "**Error,** Target account already have access." ) ); 
	                }
	            }
               	else SendMessageToDiscord( format( "**Error,** Target player account not found." ) ); 
 		    }
			else SendMessageToDiscord( format( "**Error,** !allowaccess [player]" ) ); 
		}  
	    else SendMessageToDiscord( format( "**Error,** You dont have permission to use this command." ) ); 
        break;
      
        case "cmds":
        {
        	switch( StaffDiscord.getRank( roles ) )
        	{
        		case 1:
        		SendMessageToDiscord( format( "**Commands (!)** players, ac, sc, kick, mute" ) ); 
        		break;
 
        		case 2:
        		SendMessageToDiscord( format( "**Commands (!)** players, ac, sc, kick, mute, allowaccess" ) ); 
        		break;

        		case 3:
        		SendMessageToDiscord( format( "**Commands (!)** players, ac, sc, kick, mute, allowaccess" ) ); 
        		break;

        		case 4:
        		SendMessageToDiscord( format( "**Commands (!)** players, ac, sc, kick, mute, allowaccess" ) ); 
        		break;

        		case 5:
        		SendMessageToDiscord( format( "**Commands (!)** players, ac, sc, kick, mute, exe" ) ); 
        		break;

        		default:
        		SendMessageToDiscord( format( "**Error,** You dont have permission to use this command." ) ); 
        		break;
        	}
        }
        break;

        default:
       	SendMessageToDiscord( format( "**Error**, Unknown command, use !cmds to check available commands." ) );
       	break;
    }
}