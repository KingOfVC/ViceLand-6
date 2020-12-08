class CCmdAdmin
{
    function KickPlayer( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
        {
            args = { "Victim": stripCmd[1], "Reason": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.ID != player.ID )
                            {
                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                {
                                    SqCast.MsgAll( TextColor.Admin, Lang.AKickAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, target.Name, TextColor.Admin, args.Reason );

                                    // EchoBot.SendMessage( format( "%s **%s** kicked **%s** from the server. Reason **%s**", player.Data.Player.Permission.Staff.Name, player.Name, target.Name, args.Reason ) );

                                    target.Kick();
                                }
                                else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                    }
                     else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AKickSyntax[ player.Data.Language ] );
        
        return true;
    }

    function MutePlayer( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 4 ) )
        {
            args = { "Victim": stripCmd[1], "Duration": stripCmd[2], "Reason": ::GetTok( command, " ", 4, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        if( SqAdmin.GetDuration( args.Duration ) )
                        {
                            switch( args.Victim )
                            {
                                case "all":
                                if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                                {
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) ) 
                                        {
                                            SqAdmin.AddMute( target, player.Name, args.Reason, SqAdmin.GetDuration( args.Duration ) );
                                            
                                            target.MakeTask( function()
                                            {  
                                                SqAdmin.UID[ target.UID ].Mute = null;
                                                SqAdmin.UID2[ target.UID2 ].Mute = null;
                                                            
                                                this.Terminate();

                                                SqCast.MsgAll( TextColor.Admin, Lang.AUnmuteTimered, target.Name );

                                                // EchoBot.SendMessage( format( "Auto unmuted **%s**", target.Name ) );

                                            }, ( SqAdmin.GetDuration( args.Duration ) * 1500 ), 1 ).SetTag( "Mute" );
                                        }
                                    });

                                    SqCast.MsgAll( TextColor.Admin, Lang.AMuteAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Reason, TextColor.Admin, SqInteger.SecondToTime( SqAdmin.GetDuration( args.Duration ) ) );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                break;

                                default:
                                local target = SqPlayer.FindPlayer( args.Victim );
                                if( target )
                                {
                                    if( target.Data.IsReg )
                                    {
                                        if( target.Data.Logged )
                                        {
                                            if( target.ID != player.ID )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    try 
                                                    {
                                                        SqAdmin.AddMute( target, player.Name, args.Reason, SqAdmin.GetDuration( args.Duration ) );

                                                        SqCast.MsgAll( TextColor.Admin, Lang.AMuteTimeredAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, target.Name, TextColor.Admin, args.Reason, TextColor.Admin, SqInteger.SecondToTime( SqAdmin.GetDuration( args.Duration ) ) );
                                                    
                                                        target.MakeTask( function()
                                                        {  
                                                            SqAdmin.UID[ target.UID ].Mute = null;
                                                            SqAdmin.UID2[ target.UID2 ].Mute = null;
                                                                
                                                           this.Terminate();

                                                            SqCast.MsgAll( TextColor.Admin, Lang.AUnmuteTimered, target.Name );

                                                            // EchoBot.SendMessage( format( "Auto unmuted **%s**", target.Name ) );

                                                        }, ( SqAdmin.GetDuration( args.Duration ) * 1500 ), 1 ).SetTag( "Mute" );
                                                    }
                                                    catch( e ) player.Msg( TextColor.Error, Lang.AWrongTimeFormat[ player.Data.Language ] );
                                                }
                                                else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                break;
                            }
                        }
                        else player.Msg( TextColor.Error, Lang.AWrongTimeFormat[ player.Data.Language ] );
                    }
                     else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else 
        {
            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.AMuteSyntax[ player.Data.Language ] );
            else return player.Msg( TextColor.Error, Lang.AMuteSyntaxMod[ player.Data.Language ] );
        }
        
        return true;
    }

    function UnmutePlayer( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Victim": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        switch( args.Victim )
                        {
                            case "all":
                            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                            {
                                SqForeach.Player.Active( this, function( target ) 
                                {
                                    SqAdmin.UID[ target.UID ].Mute = null;
                                    SqAdmin.UID2[ target.UID2 ].Mute = null;

                                    if( SqAdmin.IsTimedMuted( target ) ) target.FindTask( "Mute" ).Terminate();
                                });
                               
                                SqCast.MsgAll( TextColor.Admin, Lang.AUnmuteAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                            break;

                            default:
                            local target = SqPlayer.FindPlayer( args.Victim );
                            if( target )
                            {
                                if( target.Data.IsReg )
                                {
                                    if( target.Data.Logged )
                                    {   
                                        if( SqAdmin.CheckMute( target.UID, target.UID2 ) )
                                        {                         
                                            SqAdmin.UID[ target.UID ].Mute = null;
                                            SqAdmin.UID2[ target.UID2 ].Mute = null;

                                            SqCast.MsgAll( TextColor.Admin, Lang.AUnmuteAllPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, target.Name );
                                        
                                            if( SqAdmin.IsTimedMuted( target ) ) target.FindTask( "Mute" ).Terminate();
                                        }
                                        else player.Msg( TextColor.Error, Lang.ATargetNotMuted[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                            break;
                        }
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else 
        {
            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.AUnmuteSyntax[ player.Data.Language ] );
            else return player.Msg( TextColor.Error, Lang.AUnmuteSyntaxMod[ player.Data.Language ] );
        }

        return true;
    }


    function GotoPlayer( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Victim": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.Data.IsReg )
                            {
                                if( target.Data.Logged )
                                {   
                                    if( target.ID != player.ID )
                                    {
                                        if( SqWorld.GetPrivateWorld( player.World ) && player.World != target.World )
                                        {
                                            local world = SqWorld.World[ player.World ];
                                                                                                        
                                            if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
                                                                                        
                                            player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
                                            player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );
                                        }

                                        player.Pos              = target.Pos;
                                        player.World            = target.World;
                                        player.Data.Interior    = target.Data.Interior;

                                        SqCast.MsgAdmin( TextColor.Staff, Lang.StaffGotoPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name );
                                    }
                                    else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AGotoSyntax[ player.Data.Language ] );

        return true;
    }

    function GotoLocation( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Location": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        if( SqLocation.GetLocation( args.Location ) )
                        {
                            player.Pos = SqLocation.GetLocation( args.Location ).Pos;

                            SqCast.MsgAdmin( TextColor.Staff, Lang.AGotoloc, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Location );
                        }
                        else player.Msg( TextColor.Error, Lang.LocationNotExist[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AGotolocSyntax[ player.Data.Language ] );
        
        return true;
    }

    function GotoWorld( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "World": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        switch( args.World )
                        {
                            case "main":
                            player.World = 0;
                                                                    
                            player.Data.Interior = null;

                            player.SetOption( SqPlayerOption.CanAttack, true );
                            player.SetOption( SqPlayerOption.DriveBy, true );

                            SqCast.MsgAdmin( TextColor.Staff, Lang.StaffGotoWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, "Main" );
                            break;

                            case "lobby":
                            player.World        = 100;
                            player.Pos          = Vector3.FromStr( "-1471.868164,553.079102,2008.979980" );
                            player.Data.Interior = "Lobby";
                           
                            SqCast.MsgAdmin( TextColor.Staff, Lang.StaffGotoWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, "Lobby" );
                            break;

                            default:
                            if( SqInteger.IsNum( args.World ) )
                            {
                                if( SqWorld.GetPrivateWorld( args.World.tointeger() ) )
                                {   
                                    if( !SqWorld.World.rawin( args.World.tointeger() ) ) SqWorld.Register( args.World.tointeger() );
                                    
                                    if( player.World != args.World.tointeger() )
                                    {
                                        local world = SqWorld.World[ args.World.tointeger() ];
                                       
                                        player.World = args.World.tointeger();                                                           

                                        if( world.Settings.WorldSpawn != "0,0,0" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );
                                        if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
                                                                
                                        player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
                                        player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );
                                                                
                                        if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, args.World.tointeger() ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
                                        if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, args.World.tointeger()), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
                                        
                                        SqCast.MsgAdmin( TextColor.Staff, Lang.StaffGotoWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.World.tostring() );
                                    }
                                    else player.Msg( TextColor.Error, Lang.WorldSameWorld[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.WorldInvalidWorld1[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.WorldInvalidWorld2[ player.Data.Language ] );                             
                            break;
                        }
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AGotoworldSyntax[ player.Data.Language ] );
        
        return true;
    }

    function GetPlayer( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Victim": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        switch( args.Victim )
                        {
                            case "all":
                            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                            {
                                SqForeach.Player.Active( this, function( target ) 
                                {
                                    if( target.ID != player.ID )
                                    {
                                        if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                        {
                                            target.World            = player.World;
                                            target.Data.Interior    = player.Data.Interior;
                                            target.Pos              = player.Pos;
                                        }
                                    }
                                });

                                SqCast.MsgAll( TextColor.Admin, Lang.StaffGetPlrAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                            break;

                            case "allworld":
                            SqForeach.Player.Active( this, function( target ) 
                            {
                                if( target.ID != player.ID )
                                {
                                    if( player.World == target.World )
                                    {
                                        if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                        {
                                            target.World            = player.World;
                                            target.Data.Interior    = player.Data.Interior;
                                            target.Pos              = player.Pos;
                                        }
                                    }
                                }
                            });

                            SqCast.MsgWorld( TextColor.Admin, player.World, Lang.StaffGetPlrAllWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );
                                
                            SqCast.MsgAdmin( TextColor.Staff, Lang.StaffGetPlrAllWorld1, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World );
                            break;

                            default:
                            local target = SqPlayer.FindPlayer( args.Victim );
                            if( target )
                            {
                                if( target.Data.IsReg )
                                {
                                    if( target.Data.Logged )
                                    {
                                        if( target.ID != player.ID )
                                        {
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                                target.World            = player.World;
                                                target.Data.Interior    = player.Data.Interior;
                                                target.Pos              = player.Pos;

                                                SqCast.MsgAdmin( TextColor.Staff, Lang.StaffGetPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                            break;
                        }
                    }
                     else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else 
        {
            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.AGetSyntax[ player.Data.Language ] );
            else return player.Msg( TextColor.Error, Lang.AGetSyntaxMod[ player.Data.Language ] );
        }
        
        return true;
    }

    function SetServerTime( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 3 )
        {
            args = { "Hour": stripCmd[1], "Minute": stripCmd[2] };

            if( SqInteger.IsNum( args.Hour ) && SqInteger.IsNum( args.Minute ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                        {
                            if( SqInteger.ValidHour( args.Hour ) )
                            {
                                if( SqInteger.ValidMinute( args.Minute ) )
                                {
                                    SqServer.SetHour( args.Hour.tointeger() );
                                    SqServer.SetMinute( args.Minute.tointeger() );

                                    SqCast.MsgAll( TextColor.Admin, Lang.ASetTimeAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Hour.tointeger(), args.Minute.tointeger() );
                                }
                                else player.Msg( TextColor.Error, Lang.InvalidMinute[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.InvalidHour[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.ASetTimeSyntax[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASetTimeSyntax[ player.Data.Language ] );
        
        return true;
    }

    function SetServerWeather( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Weather": stripCmd[1] };

            if( SqInteger.IsNum( args.Weather ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                        {
                            SqServer.SetWeather( args.Weather.tointeger() );

                            SqCast.MsgAll( TextColor.Admin, Lang.ASetWeatherAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Weather.tointeger() );
                        }
                        else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.ASetWeatherSyntax[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASetWeatherSyntax[ player.Data.Language ] );
        
        return true;
    }

    function SetPlayerHP( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 3 )
        {
            args = { "Victim": stripCmd[1], "Value": stripCmd[2] };

            if( SqInteger.IsNum( args.Value ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                        {
                            switch( args.Victim )
                            {
                                case "all":
                                if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                                {
                                    if( SqInteger.ValidHealOrArmRange( args.Value.tointeger() ) )
                                    {
                                        SqForeach.Player.Active( this, function( target ) 
                                        {
                                            if( target.ID != player.ID )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    target.Health = args.Value.tointeger();
                                                }
                                            }
                                        });

                                        SqCast.MsgAll( TextColor.Admin, Lang.AHealAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Value.tointeger() );
                                    }
                                    else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                break;

                                case "allworld":
                                if( SqInteger.ValidHealOrArmRange( args.Value.tointeger() ) )
                                {
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        if( target.ID != player.ID )
                                        {
                                            if( player.World == target.World )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    target.Health = args.Value.tointeger();
                                                }
                                            }
                                        }
                                    });

                                    SqCast.MsgWorld( TextColor.Admin, player.World, Lang.AHealWorldAll1, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Value.tointeger() );
                                        
                                    SqCast.MsgAdmin( TextColor.Staff, Lang.AHealWorldAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World, TextColor.Staff, args.Value.tointeger() );
                                }
                                else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
                                break;

                                default:
                                local target = SqPlayer.FindPlayer( args.Victim );
                                if( target )
                                {
                                    if( target.Data.IsReg )
                                    {
                                        if( target.Data.Logged )
                                        {
                                            if( target.ID != player.ID )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    if( SqInteger.ValidHealOrArmRange( args.Value.tointeger() ) )
                                                    {
                                                        target.Health = args.Value.tointeger();

                                                        SqCast.MsgAdmin( TextColor.Staff, Lang.SetHealPlrStaff, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, args.Value.tointeger() );
                                                        
                                                        target.Msg( TextColor.InfoS, Lang.SetHP[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, args.Value.tointeger() );
                                                    }
                                                    else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
                                                }
                                                else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                break;
                            }
                        }
                         else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else 
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.AHealSyntax[ player.Data.Language ] );
                else return player.Msg( TextColor.Error, Lang.AHealSyntaxMod[ player.Data.Language ] );
            }
        }
        else 
        {
            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.AHealSyntax[ player.Data.Language ] );
            else return player.Msg( TextColor.Error, Lang.AHealSyntaxMod[ player.Data.Language ] );
        }
                
        return true;
    }

    function SendAnnounce( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
        {
            args = { "Victim": stripCmd[1], "Text": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        switch( args.Victim )
                        {
                            case "all":
                            SqCast.sendAnnounceToAll( args.Text );

                            SqCast.MsgAdmin( TextColor.Staff, Lang.AAnnAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Text, TextColor.Staff );
                            break;

                            case "allworld":
                            SqCast.sendAnnounceToWorld( player.World, args.Text );

                            SqCast.MsgAdmin( TextColor.Staff, Lang.AAnnWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Text, TextColor.Staff, player.World );
                            break;

                            default:
                            local target = SqPlayer.FindPlayer( args.Victim );
                            if( target )
                            {
                                if( target.Data.IsReg )
                                {
                                    if( target.Data.Logged )
                                    {
                                        if( target.ID != player.ID )
                                        {
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                                SqCast.sendAnnounceToPlayer( target, args.Text );

                                                SqCast.MsgAdmin( TextColor.Staff, Lang.AAnnPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Text, TextColor.Staff, target.Name );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                            break;
                        }
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AAnnSyntax[ player.Data.Language ] );

        return true;
    }

    function SetPlayerWeapon( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 4 )
        {
            args = { "Victim": stripCmd[1], "Weapon": stripCmd[2], "Ammo": stripCmd[3] };

            if( SqInteger.IsNum( args.Ammo ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                        {
                            switch( args.Victim )
                            {
                                case "all":
                                if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                                {
                                    local wep = ( SqInteger.IsNum( args.Weapon ) ) ? args.Weapon.tointeger() : GetWeaponID( args.Weapon );
                                    
                                    if( IsWeaponValid( wep ) )
                                    {
                                        if( !IsWeaponNatural( wep ) )
                                        {
                                            if( SqWeapon.GetValidWeaponID( wep ) )
                                            {
                                                SqForeach.Player.Active( this, function( target ) 
                                                {
                                                    target.SetWeapon( wep, args.Ammo.tointeger() );
                                                });

                                                SqCast.MsgAll( TextColor.Admin, Lang.AGiveWepAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, GetWeaponName( wep ), TextColor.Admin, args.Ammo.tointeger(), TextColor.Admin );
                                            }
                                            else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                break;

                                case "allworld":
                                local wep = ( SqInteger.IsNum( args.Weapon ) ) ? args.Weapon.tointeger() : GetWeaponID( args.Weapon );
                                
                                if( IsWeaponValid( wep ) )
                                {
                                    if( !IsWeaponNatural( wep ) )
                                    {
                                        if( SqWeapon.GetValidWeaponID( wep ) )
                                        {
                                            SqForeach.Player.Active( this, function( target ) 
                                            {
                                                if( player.World == target.World ) target.SetWeapon( wep, args.Ammo.tointeger() );
                                            });

                                            SqCast.MsgWorld( TextColor.Admin, player.World, Lang.AGiveWepWorld1, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, GetWeaponName( wep ), TextColor.Admin, args.Ammo.tointeger(), TextColor.Admin );
                                            
                                            SqCast.MsgAdmin( TextColor.Staff, Lang.AGiveWepWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, GetWeaponName( wep ), TextColor.Staff, args.Ammo.tointeger(), TextColor.Staff, player.World );
                                        }
                                        else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                break;

                                default:
                                local target = SqPlayer.FindPlayer( args.Victim );
                                if( target )
                                {
                                    if( target.Data.IsReg )
                                    {
                                        if( target.Data.Logged )
                                        {
                                            local wep = ( SqInteger.IsNum( args.Weapon ) ) ? args.Weapon.tointeger() : GetWeaponID( args.Weapon );
                                           
                                            if( IsWeaponValid( wep ) )
                                            {
                                                if( !IsWeaponNatural( wep ) )
                                                {
                                                    if( SqWeapon.GetValidWeaponID( wep ) )
                                                    {
                                                        target.SetWeapon( wep, args.Ammo.tointeger() );
                                                    
                                                        SqCast.MsgAdmin( TextColor.Staff, Lang.AGiveWepPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, GetWeaponName( wep ), TextColor.Staff, args.Ammo.tointeger(), TextColor.Staff, target.Name );

                                                        target.Msg( TextColor.InfoS, Lang.SetWepPlrWorld[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, GetWeaponName( wep ), TextColor.InfoS, args.Ammo.tointeger() );
                                                    }
                                                    else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                                }
                                                else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                break;
                            }
                        }
                        else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else 
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.ASetWepSyntax[ player.Data.Language ] );
                else return player.Msg( TextColor.Error, Lang.ASetWepSyntaxMod[ player.Data.Language ] );
            }
        }
        else 
        {
            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.ASetWepSyntax[ player.Data.Language ] );
            else return player.Msg( TextColor.Error, Lang.ASetWepSyntaxMod[ player.Data.Language ] );
        }
        
        return true;
    }

    function SetPlayerOption( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 3 )
        {
            args = { "Victim": stripCmd[1], "Option": stripCmd[2] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                        switch( args.Victim )
                        {
                            case "all":
                            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                            {
                                switch( args.Option )
                                {
                                    case "canattack":
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        target.SetOption( SqPlayerOption.CanAttack, true );
                                    });

                                    SqCast.MsgAll( TextColor.Admin, Lang.ACanAttackAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );
                                    break;

                                    case "cantattack":
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        if( target.ID != player.ID )
                                        {
                                            if( player.World == target.World )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    target.SetOption( SqPlayerOption.CanAttack, false );
                                                }
                                            }
                                        }
                                    });

                                    SqCast.MsgAll( TextColor.Admin, Lang.ACantAttackAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );
                                    break;

                                    case "canmove":
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        target.SetOption( SqPlayerOption.Controllable, true );
                                    });

                                    SqCast.MsgAll( TextColor.Admin, Lang.ACanMoveAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );
                                    break;

                                    case "cantmove":
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        if( target.ID != player.ID )
                                        {
                                            if( player.World == target.World )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    target.SetOption( SqPlayerOption.Controllable, false );
                                                }
                                            }
                                        }
                                    });

                                    SqCast.MsgAll( TextColor.Admin, Lang.ACantMoveAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );
                                    break;

                                    default:
                                    player.Msg( TextColor.Error, Lang.PlrOptionAllSyntax[ player.Data.Language ] );
                                    break;
                                }
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                            break;

                            case "allworld":
                            switch( args.Option )
                            {
                                case "canattack":
                                SqForeach.Player.Active( this, function( target ) 
                                {
                                    if( target.World == player.World ) target.SetOption( SqPlayerOption.CanAttack, true );
                                });

                                SqCast.MsgWorld( TextColor.Admin, player.World, Lang.ACanAttackWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );

                                SqCast.MsgAdmin( TextColor.Staff, Lang.ACanAttackWorld1, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World );
                                break;

                                case "cantattack":
                                SqForeach.Player.Active( this, function( target ) 
                                {
                                    if( target.ID != player.ID )
                                    {
                                        if( player.World == target.World )
                                        {
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                                if( target.World == player.World ) target.SetOption( SqPlayerOption.CanAttack, false );
                                            }
                                        }
                                    }
                                });

                                SqCast.MsgWorld( TextColor.Admin, player.World, Lang.ACantAttackWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );

                                SqCast.MsgAdmin( TextColor.Staff, Lang.ACantAttackWorld1, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World );
                                break;

                                case "canmove":
                                SqForeach.Player.Active( this, function( target ) 
                                {
                                    if( target.World == player.World ) target.SetOption( SqPlayerOption.Controllable, true );
                                });

                                SqCast.MsgWorld( TextColor.Admin, player.World, Lang.ACanMoveWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );

                                SqCast.MsgAdmin( TextColor.Staff, Lang.ACanMoveWorld1, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World );
                                break;

                                case "cantmove":
                                SqForeach.Player.Active( this, function( target ) 
                                {
                                    if( target.ID != player.ID )
                                    {
                                        if( player.World == target.World )
                                        {
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                                if( target.World == player.World ) target.SetOption( SqPlayerOption.Controllable, false );
                                            }
                                        }
                                    }
                                });

                                SqCast.MsgWorld( TextColor.Admin, player.World, Lang.ACantMoveWorld, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );

                                SqCast.MsgAdmin( TextColor.Staff, Lang.ACantMoveWorld1, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World );
                                break;

                                default:
                                player.Msg( TextColor.Error, Lang.PlrOptionWorldSyntax[ player.Data.Language ] );
                                break;
                            }
                            break;

                            default:
                            local target = SqPlayer.FindPlayer( args.Victim );
                            if( target )
                            {
                                if( target.Data.IsReg )
                                {
                                    if( target.Data.Logged )
                                    {
                                        switch( args.Option )
                                       	{
                                            case "canattack":
                                            target.SetOption( SqPlayerOption.CanAttack, true );

                                            target.Msg( TextColor.InfoS, Lang.CanAttackTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS );

                                            SqCast.MsgAdmin( TextColor.Staff, Lang.ACanAttackPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff );
                                            break;

                                            case "cantattack":
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                                target.SetOption( SqPlayerOption.CanAttack, false );

                                               	target.Msg( TextColor.InfoS, Lang.CantAttackTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS );

                                                SqCast.MsgAdmin( TextColor.Staff, Lang.ACantAttackPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                            break;

                                            case "canmove":
                                            target.SetOption( SqPlayerOption.Controllable, true );

                                            target.Msg( TextColor.InfoS, Lang.CanMoveTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS );

                                           	SqCast.MsgAdmin( TextColor.Staff, Lang.ACanMovePlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff );
                                            break;

                                            case "cantmove":
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                                 target.SetOption( SqPlayerOption.Controllable, false );

                                               	target.Msg( TextColor.InfoS, Lang.CantMoveTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS );

                                                SqCast.MsgAdmin( TextColor.Staff, Lang.ACantMovePlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff );
                                            }
                                			else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                           	break;

                                            default:
                                            player.Msg( TextColor.Error, Lang.PlrOptionWorldSyntax[ player.Data.Language ] );
                                            break;
                                        }
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                            break;
                        }
                   }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else 
        {
            if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 ) return player.Msg( TextColor.Error, Lang.ASetPlayerOptionSyntax[ player.Data.Language ] );
            else return player.Msg( TextColor.Error, Lang.ASetPlayerOptionSyntaxMod[ player.Data.Language ] );
        }
        
        return true;
    }

    function AdminChat( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Text": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                    	SqCast.MsgAdmin( TextColor.Staff, Lang.AAdminChat3, player.Data.Player.Permission.Staff.Name, player.Name, args.Text );			
                        
                    //    StaffBot.SendMessage( format( "**%s** %s: %s", player.Data.Player.Permission.Staff.Name, player.Name, args.Text ) );
                   	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AAdminChatSyntax[ player.Data.Language ] );

        return true;
    }

    function StaffChat( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Text": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 || player.Data.Player.Permission.Mapper.Position.tointeger() > 0 )
                    {
                    	local getName = ( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) ? player.Data.Player.Permission.Staff.Name : player.Data.Player.Permission.Mapper.Name;
                    	
                    	SqCast.MsgStaff( TextColor.Staff, Lang.AAdminChat2, getName, player.Name, args.Text );			
                   	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AStaffChatSyntax[ player.Data.Language ] );
        
        return true;
    }

    function MapperChat( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Text": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Mapper.Position.tointeger() > 0 )
                    {
                    	local getName = ( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) ? player.Data.Player.Permission.Staff.Name : player.Data.Player.Permission.Mapper.Name;

                    	SqCast.MsgMapper( TextColor.Staff, Lang.AAdminChat4, getName, player.Name, args.Text );			
                   	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AMapperChatSyntax[ player.Data.Language ] );
        
        return true;
    }

    function VIPChat( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Text": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.VIP.Position.tointeger() > 0 )
                    {
                    	SqCast.MsgAdmin( TextColor.Staff, Lang.AAdminChat5, player.Data.Player.Permission.VIP.Name, player.Name, args.Text );			
                   	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AVIPChatSyntax[ player.Data.Language ] );
        
        return true;
    }

    function GetPlayerAlias( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 3 )
        {
            args = { "Victim": stripCmd[1], "Type": stripCmd[2] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                    	local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.Data.IsReg )
                            {
                                if( target.Data.Logged )
                                {
    				                switch( args.Type )
    				                {
    				                	case "uid1":
    				                	local getStr = null;

    				                	foreach( index, value in SqAdmin.UID[ target.UID ].Alias )
    				                	{
    				                		if( getStr ) getStr = getStr + "$" + HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " Used Times " + HexColour.White + value.UsedTimes;
    										else getStr = HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " Used Times " + HexColour.White + value.UsedTimes;
    									}

    									if( getStr )
    									{
    										player.StreamInt( 105 );
    										player.StreamString( "UID1 Alias of " + target.Name + "$" + player.Name );
    										player.FlushStream( true );
    										
    										player.StreamInt( 106 );
    										player.StreamString( getStr );
    										player.FlushStream( true );
    									}
    									else player.Msg( TextColor.Error, Lang.ANoAliasFound[ player.Data.Language ] );
    									break;

    									case "uid2":
    				                	local getStr = null;

    				                	foreach( index, value in SqAdmin.UID2[ target.UID2 ].Alias )
    				                	{
    				                		if( getStr ) getStr = getStr + "$" + HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " Used Times " + HexColour.White + value.UsedTimes;
    										else getStr = HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " Used Times " + HexColour.White + value.UsedTimes;
    									}

    									if( getStr )
    									{
    										player.StreamInt( 105 );
    										player.StreamString( "UID2 Alias of " + target.Name + "$" + player.Name );
    										player.FlushStream( true );
    										
    										player.StreamInt( 106 );
    										player.StreamString( getStr );
    										player.FlushStream( true );
    									}
    									else player.Msg( TextColor.Error, Lang.ANoAliasFound[ player.Data.Language ] );
    									break;

    									default: 
    									player.Msg( TextColor.Error, Lang.AAliasSyntax[ player.Data.Language ] );
    									break;
                                    }
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                        }

                        else 
                        {
                        	if( SqAccount.FindAccountByName( args.Victim ) )
                        	{
                                 switch( args.Type )
                                 {
        				            case "uid1":
        				            if( SqAdmin.UID.rawin( SqAccount.GetUID1ByName( args.Victim ) ) )
        				            {
        					            local getStr = null;

        					           	foreach( index, value in SqAdmin.UID[ SqAccount.GetUID1ByName( args.Victim ) ].Alias )
        					            {
        					                if( getStr ) getStr = getStr + "$" + HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " Used Times " + HexColour.White  + value.UsedTimes;
        									else getStr = HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " Used Times " + HexColour.White  + value.UsedTimes;
        								}

        								if( getStr )
        								{
        									player.StreamInt( 105 );
        									player.StreamString( "UID1 Alias of " + SqAccount.GetUID1ByName( args.Victim ) + "$" + player.Name );
        									player.FlushStream( true );
        											
        									player.StreamInt( 106 );
        									player.StreamString( getStr );
        									player.FlushStream( true );
        								}
        								else player.Msg( TextColor.Error, Lang.ANoAliasFound[ player.Data.Language ] );
        							}
        							else player.Msg( TextColor.Error, Lang.ANoAliasFound[ player.Data.Language ] );
        							break;

        							case "uid2":
        							if( SqAdmin.UID.rawin( SqAccount.GetUID2ByName( args.Victim ) ) )
        				            {
        					            local getStr = null;

        					            foreach( index, value in SqAdmin.UID2[ SqAccount.GetUID2ByName( args.Victim ) ].Alias )
        					            {
        					                if( getStr ) getStr = getStr + "$" + HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " + HexColour.White  Used Times " + value.UsedTimes;
        									else getStr = HexColour.White + index + HexColour.Red + " Last Used " + HexColour.White + SqInteger.TimestampToDate( value.LastUsed.tointeger() ) + HexColour.Red + " Used Times " + HexColour.White  + value.UsedTimes;
        								}

        								if( getStr )
        								{
        									player.StreamInt( 105 );
        									player.StreamString( "UID2 Alias of " + SqAccount.GetUID1ByName( args.Victim ) + "$" + player.Name );
        									player.FlushStream( true );
        											
        									player.StreamInt( 106 );
        									player.StreamString( getStr );
        									player.FlushStream( true );
        								}
        								else player.Msg( TextColor.Error, Lang.ANoAliasFound[ player.Data.Language ] );
        							}
        							else player.Msg( TextColor.Error, Lang.ANoAliasFound[ player.Data.Language ] );
        							break;

        							default: 
        							player.Msg( TextColor.Error, Lang.AAliasSyntax[ player.Data.Language ] );
        							break;
                                }
                            }
                            else player.Msg( TextColor.Error, Lang.ATargetNotFound[ player.Data.Language ] );
                        }
                  	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AAliasSyntax[ player.Data.Language ] );

        return true;
    }

    function GetPlayerUID( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Victim": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                    	local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.Data.IsReg )
                            {
                                if( target.Data.Logged )
                                {
                                	player.Msg( TextColor.InfoS, Lang.GetUIDTitle[ player.Data.Language ], target.Name );	
                                	player.Msg( TextColor.InfoS, Lang.GetUID1[ player.Data.Language ], target.UID, TextColor.InfoS );	
                                	player.Msg( TextColor.InfoS, Lang.GetUID2[ player.Data.Language ], target.UID2, TextColor.InfoS );	
    				            }
    				            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
    				        }
    				        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
    					}
                        
                        else 
                        {
                        	if( SqAccount.FindAccountByName( args.Victim ) )
                        	{
                                player.Msg( TextColor.InfoS, Lang.GetUIDTitle[ player.Data.Language ], args.Victim );	
                                player.Msg( TextColor.InfoS, Lang.GetUID1[ player.Data.Language ], SqAccount.GetUID1ByName( args.Victim ), TextColor.InfoS );	
                                player.Msg( TextColor.InfoS, Lang.GetUID2[ player.Data.Language ], SqAccount.GetUID2ByName( args.Victim ), TextColor.InfoS );	
                        	}
                        	else player.Msg( TextColor.Error, Lang.ATargetNotFound[ player.Data.Language ] );
                        }
                  	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AGetUIDSyntax[ player.Data.Language ] );

        return true;
    }

    function GetPlayerInfo( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Victim": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                    	local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.Data.IsReg )
                            {
                                if( target.Data.Logged )
                                {
                                	player.Msg( TextColor.InfoS, Lang.GetInfoTitle[ player.Data.Language ], target.Name, TextColor.InfoS, target.Data.AccID );	
                                	player.Msg( TextColor.InfoS, Lang.GetInfo1[ player.Data.Language ], target.IP, TextColor.InfoS, SqGeo.GetIPInfo( target.IP ) );
                                	player.Msg( TextColor.InfoS, Lang.GetInfo2[ player.Data.Language ], target.Away.tostring(), TextColor.InfoS, target.World );
                                	player.Msg( TextColor.InfoS, Lang.GetInfo3[ player.Data.Language ], SqInteger.ToThousands( target.Data.Stats.Cash ), TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.Coin ) );
    				            }
    				            else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
    				        }
    				        else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
    					}
                        
                        else 
                        {
                        	if( SqAccount.FindAccountByName( args.Victim ) )
                        	{
                                player.Msg( TextColor.InfoS, Lang.GetInfoTitle[ player.Data.Language ], SqAccount.FindAccountByName( args.Victim ), TextColor.InfoS, SqAccount.GetIDFromName( args.Victim ) );	
                                player.Msg( TextColor.InfoS, Lang.GetInfo1[ player.Data.Language ], SqAccount.GetAccountData( args.Victim, "IP" ), TextColor.InfoS, SqGeo.GetIPInfo( SqAccount.GetAccountData( args.Victim, "IP" ) ) );
                                player.Msg( TextColor.InfoS, Lang.GetInfo3[ player.Data.Language ], SqInteger.ToThousands( SqAccount.GetAccountData( args.Victim, "Cash" ) ), TextColor.InfoS, SqInteger.ToThousands( SqAccount.GetAccountData( args.Victim, "Coin" ) ) );
                        	}
                        	else player.Msg( TextColor.Error, Lang.ATargetNotFound[ player.Data.Language ] );
                        }
                  	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AGetInfoSyntax[ player.Data.Language ] );
        
        return true;
    }

    function GeneratePassword( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Victim": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                    {
                    	local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.Data.IsReg )
                            {
                                if( !target.Data.Logged )
                                {
                                	local genPass = rand() % 9 + "" + rand() % 9 + "" + rand() % 9 + "" + rand() % 9;

                                	target.Data.Password = SqHash.GetSHA256( genPass );

                                	player.Msg( TextColor.Sucess, Lang.GenerateRandomPassScs[ player.Data.Language ], target.Data.OldName );
                                	
                                //	target.Msg( TextColor.InfoS, Lang.GenerateRandomPass[ target.Data.Language ], genPass );

                                    SqCast.sendAnnounceToPlayer( target, "Your new password is " + genPass );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetAlreadyLogged[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                  	}
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AResetPassSyntax[ player.Data.Language ] );

        return true;
    }

    function BanPlayer( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 4 ) )
        {
            args = { "Victim": stripCmd[1], "Duration": stripCmd[2], "Reason": ::GetTok( command, " ", 4, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                    {
                        if( SqAdmin.GetDuration( args.Duration ) )
                        {
    	                    local target = SqPlayer.FindPlayer( args.Victim );
    	                    if( target )
    	                    {
                                if( target.Data.IsReg )
                                {
                                    if( target.Data.Logged )
                                    {   
            	                        if( target.ID != player.ID )
            	                        {
            	                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
            	                            {
                                                try 
                                                {
                                                    SqAdmin.AddBan( target, player.Name, args.Reason, SqAdmin.GetDuration( args.Duration ) );

                                                    SqCast.MsgAll( TextColor.Admin, Lang.ABanTimeredAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, target.Name, TextColor.Admin, args.Reason, TextColor.Admin, SqInteger.SecondToTime( SqAdmin.GetDuration( args.Duration ) ) );

                                                    target.Msg( TextColor.InfoS, Lang.ABannedKick[ target.Data.Language ], Server.Forum );

                                                    ::SendMessageToDiscord( format( "**%s** has been banned by admin **%s**", plr.Name, player.Name ), "report" );

                                                    target.Kick();
                                                }
                                                catch( e ) player.Msg( TextColor.Error, Lang.AWrongTimeFormat[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.AWrongTimeFormat[ player.Data.Language ] );
                    }
                     else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ABanSyntax[ player.Data.Language ] );

        return true;
    }

    function RewardCash( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 3 )
        {
            args = { "Victim": stripCmd[1], "Cash": stripCmd[2] };

            if( SqInteger.IsNum( args.Cash ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                        {
                        	if( SqMath.IsGreaterEqual( args.Cash.tointeger(), 0 ) )
        					{
                                switch( args.Victim )
                                {
                                    case "all":
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        target.Data.Stats.Cash += args.Cash.tointeger();
                                    });

                                    SqCast.MsgAll( TextColor.Admin, Lang.AAddCashAll2, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, SqInteger.ToThousands( args.Cash.tointeger() ) );
                                    break;

                                    default:
            	                    local target = SqPlayer.FindPlayer( args.Victim );
            	                    if( target )
            	                    {
            	                        if( target.Data.IsReg )
            	                        {
            	                            if( target.Data.Logged )
            	                            {   
                                                SqCast.MsgAll( TextColor.Admin, Lang.AAddCashAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, target.Name, SqInteger.ToThousands( args.Cash.tointeger() ) );

                                                target.Data.Stats.Cash += args.Cash.tointeger();
            	                            }
            	                            else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
            	                        }
            	                        else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
            	                    }
            	                    else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                    break;
                                }
            	            }
        	                else player.Msg( TextColor.Error, Lang.InvalidAmount[ player.Data.Language ] );
                        }
                         else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.ARewardCoinSyntax[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ARewardCoinSyntax[ player.Data.Language ] );

        return true;
    }

    function RewardCoin( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 3 )
        {
            args = { "Victim": stripCmd[1], "Coin": stripCmd[2] };

            if( SqInteger.IsNum( args.Coin ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                        {
                        	if( SqMath.IsGreaterEqual( args.Coin.tointeger(), 0 ) )
        					{
        	                    local target = SqPlayer.FindPlayer( args.Victim );
        	                    if( target )
        	                    {
        	                        if( target.Data.IsReg )
        	                        {
        	                            if( target.Data.Logged )
        	                            {   
                                            SqCast.MsgAll( TextColor.Admin, Lang.AAddCoinAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, target.Name, SqInteger.ToThousands( args.Coin.tointeger() ) );

                                            target.Data.Stats.Coin += args.Coin.tointeger();
        	                            }
        	                            else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
        	                        }
        	                        else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
        	                    }
        	                    else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
        	                }
        	                else player.Msg( TextColor.Error, Lang.InvalidAmount[ player.Data.Language ] );
                        }
                         else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.ARewardCoinSyntax[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ARewardCoinSyntax[ player.Data.Language ] );
        
        return true;
    }

    function SetSpawnloc( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
        {
            args = { "Victim": stripCmd[1], "Type": stripCmd[2] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 2 )
                    {
    	                local target = SqPlayer.FindPlayer( args.Victim );
    	                if( target )
    	                {
    	                    if( target.Data.IsReg )
    	                    {
    	                        if( target.Data.Logged )
    	                        {   
    	                        	switch( args.Type )
    	                        	{
    	                        		case "set":
    	                        		target.Data.Player.Spawnloc.SpawnData.Pos 		= player.Pos.x + "," + player.Pos.y + "," + player.Pos.z;
    									target.Data.Player.Spawnloc.SpawnData.World		= player.World.tostring();
    									target.Data.Player.Spawnloc.SpawnData.Enabled 	= "1";

                    					SqCast.MsgAdmin( TextColor.Staff, Lang.ASpawnlocOnPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff );			

    	                        		target.Msg( TextColor.InfoS, Lang.SpawnlocLocAdminOn[ target.Data.Language ], player.Data.Player.Permission.VIP.Name, player.Name, TextColor.InfoS );
    	                        		break;

    	                        		case "off":
    									if( target.Data.Player.Spawnloc.SpawnData.Enabled != "2" )
    									{
    										target.Data.Player.Spawnloc.SpawnData.Enabled 	= "2";
    										
    	                					SqCast.MsgAdmin( TextColor.Staff, Lang.SpawnlocLocAdminOff, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff );			

    		                        		target.Msg( TextColor.InfoS, Lang.ASpawnlocOffPlr[ target.Data.Language ], player.Data.Player.Permission.VIP.Name, player.Name, TextColor.InfoS );
    									}
    									else player.Msg( TextColor.Error, Lang.TargetSpawnlocAlreadyOff[ player.Data.Language ] );
    									break;

    									default:
    									if( SqLocation.GetLocation( args.Type ) )
    									{
    										local getLocation = SqLocation.GetLocation( args.Type )

    										target.Data.Player.Spawnloc.SpawnData.Pos 		= getLocation.Pos.x + "," + getLocation.Pos.y + "," + getLocation.Pos.z;
    										target.Data.Player.Spawnloc.SpawnData.World		= player.World.tostring();
    										target.Data.Player.Spawnloc.SpawnData.Enabled 	= "1";
    	                					
    	                					SqCast.MsgAdmin( TextColor.Staff, Lang.ASpawnlocLocPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, args.Type );			

    		                        		target.Msg( TextColor.InfoS, Lang.SpawnlocLocAdmin[ target.Data.Language ], player.Data.Player.Permission.VIP.Name, player.Name, TextColor.InfoS, args.Type );
    									}
    									else player.Msg( TextColor.Error, Lang.LocationNotExist[ player.Data.Language ] );
    									break;
    								}
    	                       	}
    	                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
    	                    }
    	                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
    	                }
    	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                    }
                     else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASetspawnlocSyntax[ player.Data.Language ] );
        
        return true;
    }

    function SetPlayerArmour( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 3 )
        {
            args = { "Victim": stripCmd[1], "Value": stripCmd[2] };

            if( SqInteger.IsNum( args.Value ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                        {
                            switch( args.Victim )
                            {
                                case "all":
                                if( SqInteger.ValidHealOrArmRange( args.Value.tointeger() ) )
                                {
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        if( target.ID != player.ID )
                                        {
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                                target.Armour = args.Value.tointeger();
                                            }
                                        }
                                    });

                                    SqCast.MsgAll( TextColor.Admin, Lang.AArmAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Value.tointeger() );
                                }
                                else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
                                break;

                                case "allworld":
                                if( SqInteger.ValidHealOrArmRange( args.Value ) )
                                {
                                    SqForeach.Player.Active( this, function( target ) 
                                    {
                                        if( target.ID != player.ID )
                                        {
                                            if( player.World == target.World )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    target.Armour = args.Value.tointeger();
                                                }
                                            }
                                        }
                                    });

                                    SqCast.MsgWorld( TextColor.Admin, player.World, Lang.AArmWorldAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Value.tointeger() );
                                        
                                    SqCast.MsgAdmin( TextColor.Staff, Lang.SetArmStaff, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World, TextColor.Staff, args.Value.tointeger() );
                                }
                                else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
                                break;

                                default:
                                local target = SqPlayer.FindPlayer( args.Victim );
                                if( target )
                                {
                                    if( target.Data.IsReg )
                                    {
                                        if( target.Data.Logged )
                                        {
                                            if( target.ID != player.ID )
                                            {
                                                if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                                {
                                                    if( SqInteger.ValidHealOrArmRange( args.Value.tointeger() ) )
                                                    {
                                                        target.Armour = args.Value.tointeger();

                                                        SqCast.MsgAdmin( TextColor.Staff, Lang.SetArmPlrStaff, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, args.Value.tointeger() );
                                                        
                                                        target.Msg( TextColor.InfoS, Lang.SetArm[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, args.Value.tointeger() );
                                                    }
                                                    else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
                                                }
                                                else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                                break;
                            }
                        }
                        else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.ASetArmSyntax[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASetArmSyntax[ player.Data.Language ] );
        
        return true;
    }

    function SetPermissions( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 4 )
        {
            args = { "Victim": stripCmd[1], "Type": stripCmd[2], "Level": stripCmd[3] };

            if( SqInteger.IsNum( args.Level ) )
            {
                if( player.Data.IsReg )
                {
                    if( player.Data.Logged )
                    {
                        if( player.Data.Player.Permission.Staff.Position.tointeger() > 3 )
                        {
        	                local target = SqPlayer.FindPlayer( args.Victim );
        	                if( target )
        	                {
        	                    if( target.Data.IsReg )
        	                    {
        	                        if( target.Data.Logged )
        	                        {   
        	                        	switch( args.Type )
        	                        	{
        	                        		case "admin":
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                            	if( SqInteger.ValidAdminLevel( args.Level.tointeger() ) )
                                            	{
                                            		if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), args.Level.tointeger() ) )
                                            		{
                                            			target.Data.Player.Permission.Staff.Position = args.Level.tostring();

                                                        SqCast.MsgAdmin( TextColor.Staff, Lang.StaffSetAdminMapperLevel, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, Server.RankName.Admin[ args.Level.tointeger() ] );
                                                        
                                                        target.Msg( TextColor.InfoS, Lang.ChangePermissionAdminTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, Server.RankName.Admin[ args.Level.tointeger() ] );
                                            		}
                                            		else player.Msg( TextColor.Error, Lang.OwnLevelHigherThanOption[ player.Data.Language ] );
                                            	}
                                            	else player.Msg( TextColor.Error, Lang.StaffLevelInvalid[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                            break;

        	                        		case "mapper":
                                            if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                            {
                                            	if( SqInteger.ValidMapperLevel( args.Level.tointeger() ) )
                                            	{
                                            		target.Data.Player.Permission.Mapper.Position = args.Level.tostring();

                                                    SqCast.MsgAdmin( TextColor.Staff, Lang.StaffSetMapperLevel, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, Server.RankName.Mapper[ args.Level.tointeger() ] );
                                                        
                                                    target.Msg( TextColor.InfoS, Lang.ChangePermissionMapperTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, Server.RankName.Mapper[ args.Level.tointeger() ] );
                                            	}
                                            	else player.Msg( TextColor.Error, Lang.MapperLevelInvalid[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                            break;

                                            default:
                                            player.Msg( TextColor.Error, Lang.ASetpermissionSyntax[ player.Data.Language ] );
                                            break;
        	                        	}				
        	                       	}
        	                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
        	                    }
        	                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
        	                }
        	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                    }
                    else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.ASetpermissionSyntax[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASetpermissionSyntax[ player.Data.Language ] );
        
        return true;
    }

    function SetPlayerRank( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 4 ) )
        {
            args = { "Victim": stripCmd[1], "Type": stripCmd[2], "Rank": ::GetTok( command, " ", 4, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 3 )
                    {
    	                local target = SqPlayer.FindPlayer( args.Victim );
    	                if( target )
    	                {
    	                    if( target.Data.IsReg )
    	                    {
    	                        if( target.Data.Logged )
    	                        {   
    	                        	switch( args.Type )
    	                        	{
    	                        		case "admin":
                                        if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                        {
                                        	target.Data.Player.Permission.Staff.Name = args.Rank;

                                            SqCast.MsgAdmin( TextColor.Staff, Lang.StaffSetRank, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, args.Rank );
                                                    
                                            target.Msg( TextColor.InfoS, Lang.ChangeRankTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, args.Rank );
                                        }
                                        else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                        break;

    	                        		case "mapper":
                                        if( SqMath.IsGreaterEqual( player.Data.Player.Permission.Staff.Position.tointeger(), target.Data.Player.Permission.Staff.Position.tointeger() ) )
                                        {
                                        	target.Data.Player.Permission.Mapper.Name = args.Rank;

                                            SqCast.MsgAdmin( TextColor.Staff, Lang.StaffSetRankMapper, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, args.Rank );
                                                    
                                            target.Msg( TextColor.InfoS, Lang.ChangeMapperRankTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, args.Rank );
                                        }
                                        else player.Msg( TextColor.Error, Lang.CantUseOnHighCmd[ player.Data.Language ] );
                                        break;

                                        default:
                                        player.Msg( TextColor.Error, Lang.ASetrankSyntax[ player.Data.Language ] );
                                        break;
    	                        	}				
    	                       	}
    	                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
    	                    }
    	                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
    	                }
    	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASetrankSyntax[ player.Data.Language ] );

        return true;
    }

    function SetPlayerVIP( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
        {
            args = { "Victim": stripCmd[1], "Type": stripCmd[2], "Duration": ( stripCmd.len() == 4 ) ? stripCmd[3] : "" };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 3 )
                    {
    	                local target = SqPlayer.FindPlayer( args.Victim );
    	                if( target )
    	                {
    	                    if( target.Data.IsReg )
    	                    {
    	                        if( target.Data.Logged )
    	                        {   
    	                        	switch( args.Type )
    	                        	{
    	                        		case "temp":
    	                        		if( args.Duration != "" )
    	                        		{
    		                        		if( SqAdmin.GetDuration( args.Duration ) )
    	                   					{
                                                try 
                                                {
        	                   						target.Data.Player.Permission.VIP.Position 		= "1";
        	                   						target.Data.Player.Permission.VIP.Duration 		= SqAdmin.GetDuration( args.Duration ).tostring();
        	                   						target.Data.Player.Permission.VIP.Time  		= time().tostring()
        	                   						target.Data.Player.Permission.VIP.Name 			= "Temporary";

        	                                        SqCast.MsgAdmin( TextColor.Staff, Lang.ASetVIPPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, "Temporary" );
        	                                                
        	                                        target.Msg( TextColor.InfoS, Lang.SetVIPTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, "Temporary" );
        	                                        target.Msg( TextColor.InfoS, Lang.SetVIPTarget1[ target.Data.Language ], SqInteger.SecondToTime( SqAdmin.GetDuration( args.Duration ) ) );
                                                }
                                                catch( e )player.Msg( TextColor.Error, Lang.AWrongTimeFormat[ player.Data.Language ] );
                                            }
    							            else player.Msg( TextColor.Error, Lang.AWrongTimeFormat[ player.Data.Language ] );
    							        }
    							        else player.Msg( TextColor.Error, Lang.ASetVIPTimeredSyntax[ player.Data.Language ] );
    							        break;

    							        case "permanent":
    							        if( target.Data.Player.Permission.VIP.Position != "2" )
    							        {
    	                   					target.Data.Player.Permission.VIP.Position   = "2";

                                            target.Data.Player.Permission.VIP.Name       = "Permanent VIP";
    	                                    
    	                                    SqCast.MsgAdmin( TextColor.Staff, Lang.ASetVIPPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, "Permanent" );
    	                                                
    	                                    target.Msg( TextColor.InfoS, Lang.SetVIPTarget[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, "Permanent" );
    							        }
    							        else player.Msg( TextColor.Error, Lang.TargetAlreadyPermVIP[ player.Data.Language ] );
    							        break;

    							        case "take":
    							        if( target.Data.Player.Permission.VIP.Position != "0" )
    							        {
    	                   					target.Data.Player.Permission.VIP.Position   = "0";

                                            target.Data.Player.Permission.VIP.Name       = "None";
    	                                    
    	                                    SqCast.MsgAdmin( TextColor.Staff, Lang.ATakeVIPPlr, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff, "Permanent" );
    	                                                
    	                                    target.Msg( TextColor.InfoS, Lang.SetVIPTargetOff[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, "Permanent" );
    							        }
    							        else player.Msg( TextColor.Error, Lang.TargetNotVIP[ player.Data.Language ] );
    							        break;

    							        default:
    							        player.Msg( TextColor.Error, Lang.ASetVIPSyntax[ player.Data.Language ] );
    							        break;
    							    }
    	                       	}
    	                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
    	                    }
    	                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
    	                }
    	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASetVIPSyntax[ player.Data.Language ] );
        
        return true;
    }

    function Execute( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Code": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 4 )
                    {
                    	if( ::ExcuteCode( args.Code ) == true )
                    	{
                    		player.Msg( TextColor.Sucess, Lang.AExec[ player.Data.Language ], args.Code.tostring(), TextColor.Sucess );
                    	}
                    	else player.Msg( TextColor.Error, Lang.AExecError[ player.Data.Language ], ::ExcuteCode( args.Code ).tostring() );   
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AExecuteSyntax[ player.Data.Language ] );
        
        return true;
    }

    function ExecuteClient( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Code": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 4 )
                    {
                    	player.StreamInt( 10000 );
    					player.StreamString( args.Code );
    					player.FlushStream( true );
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AExecuteClientSyntax[ player.Data.Language ] );

        return true;
    }

    function SpectatePlayer( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( stripCmd.len() == 2 )
        {
            args = { "Victim": stripCmd[1] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                    {
                    	local target = SqPlayer.FindPlayer( args.Victim );
    	               
                        if( target )
    	                {
    	                    if( target.Data.IsReg )
    	                    {
    	                        if( target.Data.Logged )
    	                        {   
    			                	SqCast.MsgAdmin( TextColor.Staff, Lang.ASpecAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name );

    								player.Msg( TextColor.Sucess, Lang.SpecPlayer[ player.Data.Language ], target.Name, TextColor.Sucess );

                                    player.Data.Muted = player.World;
                                    
                                    player.World = target.World;

                                    player.Spectate( target );
    	                       	}
    	                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
    	                    }
    	                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
    	                }
    	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
    	            }

    	            else 
    	            {
    	            	if( player.Data.Interior == "Lobby" )
    	            	{
                            local target = SqPlayer.FindPlayer( args.Victim );

    		                if( target )
    		                {
    		                    if( target.Data.IsReg )
    		                    {
    		                        if( target.Data.Logged )
    		                        {   
    									if( target.Data.Settings.AllowSpectate == "true" )
    									{
    										if( !target.Data.AdminDuty )
    										{
    											if( !SqWorld.GetLockedWorldStatus( player, target.World ) )
    											{
    												if( !SqWorld.GetPlayerBanInWorld( player.Data.AccID, target.World ) )
    												{
    													player.Spectate( target );

                                                        player.World = target.World;

    													player.Msg( TextColor.Sucess, Lang.SpecPlayer[ player.Data.Language ], target.Name, TextColor.Sucess );
    												}
    												else player.Msg( TextColor.Error, Lang.WorldCantEnterBanned[ player.Data.Language ] );
    											}
    											else player.Msg( TextColor.Error, Lang.TargetOnLockedWorld[ player.Data.Language ] );
    										}
    										else player.Msg( TextColor.Error, Lang.TargetAdminDuty[ player.Data.Language ] );
    									}
    									else player.Msg( TextColor.Error, Lang.TargetDisallowSpec[ player.Data.Language ] );
    		                       	}
    		                        else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
    		                    }
    		                    else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
    		                }
    		                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
    					}
    		            else player.Msg( TextColor.Error, Lang.NotOnLobbySpec[ player.Data.Language ] );
    		        }
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.ASpecSyntax[ player.Data.Language ] ); 
        
        return true;
    }

    function ExitSpectate( player, command )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Spec.tostring() != "-1" )
                {
					player.Msg( TextColor.Sucess, Lang.ExitSpec[ player.Data.Language ] );

			        player.Spec = SqPlayer.NullInst();

                    player.World = player.Data.Muted;

                    if( player.Data.Interior == "Lobby" ) player.World = 100;
	            }
	            else player.Msg( TextColor.Error, Lang.NotSpecAnyTarget[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function ToggleAdminDuty( player, command )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                {
                    switch( player.Data.AdminDuty )
                    {
                        case true:
                        SqCast.MsgAll( TextColor.Admin, Lang.AAdminDutyOff, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );

                        player.Data.AdminDuty = false;

                        player.Immunity = 0;

                        player.SetOption( SqPlayerOption.ShowMarkers, true );

                        SqCast.setTitle( player, ( player.Data.OldTitle == "none" ) ? "" : player.Data.OldTitle );
                        break;

                        case false:
                        SqCast.MsgAll( TextColor.Admin, Lang.AAdminDutyOn, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin );

                        player.Data.AdminDuty = true;

                        player.Immunity = 31;

                        player.SetOption( SqPlayerOption.ShowMarkers, false );

                        player.Data.OldTitle = player.Data.Title;

                        SqCast.setTitle( player, "[#ff2233]on admin duty" );
                        break;
                    }
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function ChangeName( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
        {
            args = { "Victim": stripCmd[1], "New": stripCmd[2] };

            if( player.Data.IsReg )
            {
                if( player.Data.Logged )
                {
                    if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                    {
                        local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.Data.IsReg )
                            {
                                if( target.Data.Logged )
                                {   
                                    if( !args.New.find("@") || !args.New.find("!") || !args.New.find("?") || !args.New.find("-") || !args.New.find(",") || !args.New.find("$") || !args.New.find("%%") || !args.New.find("&") || !args.New.find("+") || !args.New.find("'") || !args.New.find("\\") || !args.New.find("|") )
                                    {
                                        if( args.New.len() < 26 )
                                        {
                                            if( target.Name.tolower() != args.New.tolower() )
                                            {
                                                if( !SqAccount.FindAccountByName( args.New ) )
                                                {
                                                    target.Name = args.New;

                                                    target.Msg( TextColor.Sucess, Lang.ChangeNameNew1[ target.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, args.New );

                                                    SqDatabase.Exec( format( "UPDATE Accounts SET Name = '%s' WHERE ID = '%d' ", args.New, target.Data.AccID ) );
                                                }
                                                else player.Msg( TextColor.Error, Lang.ChangenameNewAlreadyUsed[ player.Data.Language ] );
                                            }
                                            else player.Msg( TextColor.Error, Lang.ChangenameNewAlreadySame[ player.Data.Language ] );
                                        }
                                        else player.Msg( TextColor.Error, Lang.ChangenameNewTooMany[ player.Data.Language ] );
                                    }
                                    else player.Msg( TextColor.Error, Lang.InvalidChar[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.AAChangeNameSyntax[ player.Data.Language ] );
        
        return true;
    }

    function AddRobbingPoint( player, command )
    {
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 4 )
                {
                    local checkpoint = SqCheckpoint.Create( 102, true, player.Pos, Color4( 0, 128, 0, 255 ), 1.5 ), setTag = SqHash.GetMD5( "" + time() );

                    checkpoint.SetTag( setTag );

                    checkpoint.Data = CCheckpoint( setTag );

                    checkpoint.Data.Register( setTag, player.Pos.tostring(), "Robbery", 102, Color4( 0, 128, 0, 255 ).tostring() );

                    player.Msg( TextColor.Sucess, Lang.RobPointAdded[ player.Data.Language ] );   
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
         }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function RestartServer( player, command )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 2 )
                {
                    SqServer.Shutdown();

                    SendMessageToDiscord( format( "**%s** is restarting server.", player.Name ) , "report" );
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
         }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }
}   
