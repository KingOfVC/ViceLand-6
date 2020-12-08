class CCmdAdmin2
{
    Cmd                 = null;

    Hightchat 			= null;
    Alogin              = null;
    Unban               = null;
    Setworldowner       = null;
    ResetPerm           = null;

    constructor( instance )
    {
        this.Cmd = instance;
        
        this.Cmd.BindFail( this, this.funcFailCommand );

        this.Hightchat          = this.Cmd.Create( "hc", "g", [ "Text" ], 1, 1, -1, true, true );
        this.Alogin             = this.Cmd.Create( "alogin", "s|g", [ "Account", "Password" ], 2, 2, -1, true, true );
        this.Unban              = this.Cmd.Create( "unban", "g", [ "Text" ], 1, 1, -1, true, true );
        this.Setworldowner      = this.Cmd.Create( "setworldowner", "s", [ "Victim" ], 1, 1, -1, true, true );
        this.ResetPerm          = this.Cmd.Create( "resetpermission", "s", [ "Victim" ], 1, 1, -1, true, true );

        this.Hightchat.BindExec( this.Hightchat, this.HightCmdChat );        
        this.Alogin.BindExec( this.Alogin, this.AdminLogin );  
        this.Unban.BindExec( this.Unban, this.UnbanPlayer );        
        this.Setworldowner.BindExec( this.Setworldowner, this.SetWorldOwner );        
        this.ResetPerm.BindExec( this.ResetPerm, this.ResetPermission );        
    }

    function funcFailCommand( type, msg, payload )
    {
        local player = this.Cmd.Invoker, cmd = this.Cmd.Command;

        switch( type )
        {
            case SqCmdErr.IncompleteArgs:
            case SqCmdErr.UnsupportedArg:
            switch( cmd )
            {
                case "hc":
                return player.Msg( TextColor.Error, Lang.AHCSyntax[ player.Data.Language ] );

                case "alogin":
                return player.Msg( TextColor.Error, Lang.AdminLoginSyntax[ player.Data.Language ] );


                case "unban":
                return player.Msg( TextColor.Error, Lang.UnbanSyntax[ player.Data.Language ] );

                case "setworldowner":
                return player.Msg( TextColor.Error, Lang.SetworldOwnerSyntax[ player.Data.Language ] );

                case "resetpermission":
                return player.Msg( TextColor.Error, Lang.ResetPermSyntax[ player.Data.Language ] );
            }
        }
    }

    function HightCmdChat( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 3 )
                {
                    SqCast.MsgManager( TextColor.Staff, Lang.AAdminChat6, player.Data.Player.Permission.Staff.Name, player.Name, args.Text );         
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function AdminLogin( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                local target = SqPlayer.FindPlayer( args.Account );
                if( !target )
                {
                    if( SqAccount.FindAccountByName( args.Account ) )
                    {
                        if( SqAccount.GetAccountPassword( args.Account ) == SqHash.GetSHA256( args.Password ).tolower() )
                        {
                            if( SqAccount.GetAccounPermission( args.Account ) )
                            {
                                if( SqAccount.GetAccounPermission( args.Account ).Staff.Position.tointeger() > 1 )
                                {
                                	if( SqAccount.GetAccountUIDs( args.Account )[0] == player.UID && SqAccount.GetAccountUIDs( args.Account )[1] == player.UID2 )
                                	{
	                                   player.Data.TempAdmin            = player.Data.Player.Permission;
	                                   player.Data.Player.Permission    = SqAccount.GetAccounPermission( args.Account );

	                                    SqCast.MsgStaff( TextColor.Staff, Lang.ALogin, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Account );    
                                	}
                                	else player.Msg( TextColor.Error, Lang.ATargetUIDMismatch[ player.Data.Language ] );
                                }
                                else player.Msg( TextColor.Error, Lang.ATargetNotAdmin[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.ATargetNotAdmin[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.WrongPassword[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.ATargetNotFound[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.ATargetOnline[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function UnbanPlayer( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                {
                    if( SqAccount.FindAccountByName( args.Text ) )
                    {
                        local isBanned = false;
                        local uid1 = SqAccount.GetUID1ByName( args.Text );
                        local uid2 = SqAccount.GetUID2ByName( args.Text );

                        if( SqAdmin.UID.rawin( SqAccount.GetUID1ByName( args.Text ) ) )
                        {
                            if( SqAdmin.UID[ uid1 ].Ban != null ) 
                            {
                                SqAdmin.UID[ uid1 ].Ban = null;

                                SqAdmin.Save( uid1, false );

                                isBanned = true;
                            }
                        }

                        if( SqAdmin.UID2.rawin( uid2 ) )
                        {
                            if( SqAdmin.UID2[ uid2 ].Ban != null ) 
                            {
                                SqAdmin.UID2[ uid2 ].Ban = null;

                                SqAdmin.Save( false, uid2 );

                                isBanned = true;
                            }
                        }

                        if( isBanned )
                        {
                            SqCast.MsgAll( TextColor.Admin, Lang.AUnbanAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Admin, args.Text );
                        }
                        else player.Msg( TextColor.Error, Lang.APlrNotBanned[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.ATargetNotFound[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function SetWorldOwner( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
                {
                    if( SqWorld.GetPrivateWorld( player.World ) )
                    {
                        local target = SqPlayer.FindPlayer( args.Victim );
                        if( target )
                        {
                            if( target.Data.IsReg )
                            {
                                if( target.Data.Logged )
                                {
                                    local world = SqWorld.World[ player.World ];
                                    SqWorld.World[ player.World ].Owner = target.Data.AccID;
                                    SqWorld.Save( player.World );

                                    SqCast.MsgStaff( TextColor.Staff, Lang.SetWorldOwnerAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, player.World, TextColor.Staff, target.Name );    

                                    target.Msg( TextColor.InfoS, Lang.GiveWorld3[ player.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS, player.World, TextColor.InfoS );
                                }
                                else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function ResetPermission( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 4 )
                {
                    local perms = {};

                    perms.rawset( "Staff",
                    {
                        Time        = "0",
                        Duration    = "0",
                        Position    = "0",
                        Name        = "Player",
                    });
                    
                    perms.rawset( "Mapper",
                    {
                        Time        = "0",
                        Duration    = "0",
                        Position    = "0",
                        Name        = "Player",
                    });

                    perms.rawset( "VIP",
                    {
                        Time        = "0",
                        Duration    = "0",
                        Position    = "0",
                        Name        = "Player",
                    });                    

                    local target = SqPlayer.FindPlayer( args.Victim );
                    if( target )
                    {
                        if( target.Data.IsReg )
                        {
                            if( target.Data.Logged )
                            {
                                target.Data.Player.Permission = perms;

                                SqCast.MsgStaff( TextColor.Staff, Lang.ResetPermAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, target.Name, TextColor.Staff );    

                                target.Msg( TextColor.InfoS, Lang.ResetPermPM[ player.Data.Language ], player.Data.Player.Permission.Staff.Name, player.Name, TextColor.InfoS );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
                    }

                    else 
                    {
                        if( SqAccount.FindAccountByName( args.Victim ) )
                        {
                            SqDatabase.Exec( format( "UPDATE PlayerData SET Permission = '%s' WHERE ID = '%d' "::json_encode( perms ), SqAccount.GetIDFromName( args.Victim ) ) );
                        
                            SqCast.MsgStaff( TextColor.Staff, Lang.ResetPermAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Victim, TextColor.Staff );    
                        }
                        else player.Msg( TextColor.Error, Lang.ATargetNotFound[ player.Data.Language ] );
                    }
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }
}
