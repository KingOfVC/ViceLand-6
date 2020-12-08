SqCore.On().PlayerCommand.Connect( this, function( player, command ) 
{
/*	CmdAccount.Cmd.Run( player, command.tostring() );
	CmdDeathmatch.Cmd.Run( player, command.tostring() );
	CmdLocation.Cmd.Run( player, command.tostring() );
    CmdWorld.Cmd.Run( player, command.tostring() );	
	CmdPickup.Cmd.Run( player, command.tostring() );	
	CmdVehicle.Cmd.Run( player, command.tostring() );
	CmdMisc.Cmd.Run( player, command.tostring() );
	CmdBlip.Cmd.Run( player, command.tostring() );
	CmdAdmin.Cmd.Run( player, command.tostring() );*/

	CmdGang.Cmd.Run( player, command );
	CmdJob.Cmd.Run( player, command );
	CmdEvent.Cmd.Run( player, command );
	CmdVehicle2.Cmd.Run( player, command.tostring() );
	CmdMisc2.Cmd.Run( player, command.tostring() );
	CmdAdmin2.Cmd.Run( player, command.tostring() );
	CmdAccount2.Cmd.Run( player, command.tostring() );	
	CmdLocation2.Cmd.Run( player, command.tostring() );
	CmdObject2.Cmd.Run( player, command.tostring() );	
	WriteToFile( "[" + SqInteger.TimestampToDate( time() ) + "] " + player.Name + " used command " + command );

	local getCmd = "";
	if( command.len() > 0 ) getCmd = split( command.tostring(), " " )[0];

	switch( getCmd )
	{
		/* scripts/commands/Object.nut */
		case "addobject":
		CmdObject.funcAddObj( player, command.tostring() );
		break;

		case "editobject":
		CmdObject.funcEditObj( player, command.tostring() );
		break;

		case "findobject":
		CmdObject.funcFindObj( player, command.tostring() );
		break;

		case "objectlist":
		CmdObject.funcObjList( player, command.tostring() );
		break;

		/* scripts/commands/Account.nut */		
		case "changepass":
		CmdAccount.funcChangePass( player, command.tostring() );
		break;
		
		case "cash":
		CmdAccount.GetCashCoin( player, command.tostring() );
		break;
		
		case "buycoin":
		CmdAccount.BuyCoin( player, command.tostring() );
		break;
		
		case "sellcoin":
		CmdAccount.SellCoin( player, command.tostring() );
		break;
		
		case "coinprice":
		CmdAccount.CoinPrice( player, command.tostring() );
		break;

		/* scripts/commands/Misc.nut */
		case "psetting":
		case "pset":
		CmdMisc.PlayerSettings( player, command.tostring() );
		break;

		case "msetting":
		case "mset":
		CmdMisc.MessageSettings( player, command.tostring() );
		break;

		case "rank":
		CmdMisc.CheckRank( player, command.tostring() );
		break;
		
		case "country":
		CmdMisc.CheckCountry( player, command.tostring() );
		break;
		
		case "fps":
		CmdMisc.CheckPingFPS( player, command.tostring() );
		break;
		
		case "ping":
		CmdMisc.CheckPingFPS( player, command.tostring() );
		break;
		
		case "forum":
		CmdMisc.ShowForum( player, command.tostring() );
		break;
		
		case "discord":
		CmdMisc.ShowDiscord( player, command.tostring() );
		break;
		
		case "admins":
		CmdMisc.ShowOnlineAdmins( player, command.tostring() );
		break;
		
		case "server":
		CmdMisc.ShowServerInfo( player, command.tostring() );
		break;
		
		case "keybinds":
		CmdMisc.ShowKeybinds( player, command.tostring() );
		break;
		
		case "cmds":
		CmdMisc.ShowCommands( player, command.tostring() );
		break;
		
		case "report":
		CmdMisc.ReportPlayer( player, command.tostring() );
		break;
		
		case "nuke":
		CmdMisc.NukePlayer( player, command.tostring() );
		break;
		
		case "inventory":
		CmdMisc.GetInventory( player, command.tostring() );
		break;
		
		case "changewepname":
		CmdMisc.ChangeWeaponName( player, command.tostring() );
		break;
		
		case "editsens":
		CmdMisc.EditSensitivity( player, command.tostring() );
		break;
		
		case "changename":
		CmdMisc.ChangePlayerName( player, command.tostring() );
		break;
				
		case "magicstick":
		CmdMisc.GetMagicStick( player, command.tostring() );
		break;

		case "l":
		CmdMisc.MessageLocal( player, command.tostring() );
		break;

		case "s":
		CmdMisc.MessageShout( player, command.tostring() );
		break;

		case "me":
		CmdMisc.MessageME( player, command.tostring() );
		break;

		case "cd":
		CmdMisc.Countdown( player, command.tostring() );
		break;

		case "loc":
		CmdMisc.GetLocation( player, command.tostring() );
		break;

		/* scripts/commands/Location.nut */
		case "spawnloc":
		CmdLocation.SpawnLoc( player, command.tostring() );
		break;

		case "gotoloc":
		CmdLocation.GotoLoc( player, command.tostring() );
		break;
		
		case "saveloc":
		CmdLocation.SaveLoc( player, command.tostring() );
		break;
		
	/*	case "locinfo":
		CmdLocation.LocInfo( player, command.tostring() );
		break;
	*/	
		case "goto":
		CmdLocation.GoTo( player, command.tostring() );
		break;
		
		case "lobby":
		CmdLocation.TeleportLobby( player, command.tostring() );
		break;		

		/* scripts/commands/Deathmatch.nut */
		case "we":
		case "wep":
		CmdDeathmatch.GetWeapon( player, command.tostring() );
		break;

		case "stats":
		CmdDeathmatch.GetStats( player, command.tostring() );
		break;
		
		case "currentstats":
		CmdDeathmatch.GetCurrentStats( player, command.tostring() );
		break;
		
		case "spawnwep":
		CmdDeathmatch.Spawnwep( player, command.tostring() );
		break;
		
		case "disarm":
		CmdDeathmatch.PlayerDisarm( player, command.tostring() );
		break;
		
		case "heal":
		CmdDeathmatch.PlayerHeal( player, command.tostring() );
		break;
		
		case "equiparmour":
		case "armour":
		CmdDeathmatch.PlayerArmour( player, command.tostring() );
		break;

		/* scripts/commands/Pickup.nut */
		case "addpickup":
		CmdPickup.Addpickup( player, command.tostring() );
		break;

		case "findpickup":
		CmdPickup.Findpickup( player, command.tostring() );
		break;

		case "pickuplist":
		CmdPickup.Pickuplist( player, command.tostring() );
		break;

		case "editpickup":
		CmdPickup.Editpickup( player, command.tostring() );
		break;

		/* scripts/commands/Blip.nut */
		case "addblip":
		CmdBlip.AddBlip( player, command.tostring() );
		break;

		case "deleteblip":
		CmdBlip.DeleteBlip( player, command.tostring() );
		break;

		case "findblip":
		CmdBlip.FindBlip( player, command.tostring() );
		break;

		case "bliplist":
		CmdBlip.GetBlipList( player, command.tostring() );
		break;

		/* scripts/commands/Vehicle.nut */
		case "getveh":
		CmdVehicle.GetVehicle( player, command.tostring() );
		break;

		case "buyveh":
		CmdVehicle.BuyVehicle( player, command.tostring() );
		break;

		case "vehinfo":
		CmdVehicle.GetVehicleInfo( player, command.tostring() );
		break;
		
	/*	case "editvehhandling":
		CmdVehicle.EditVehicleHandling( player, command.tostring() );
		break;
	*/	
		case "sellveh":
		case "releaseveh":
		CmdVehicle.SellVehicle( player, command.tostring() );
		break;
		
		case "parkveh":
		CmdVehicle.ParkVehicle( player, command.tostring() );
		break;
		
		case "vehsetting":
		CmdVehicle.VehicleSetting( player, command.tostring() );
		break;
		
		case "eject":
		CmdVehicle.EjectFromVehicle( player, command.tostring() );
		break;
		
		case "fix":
		CmdVehicle.FixVehicle( player, command.tostring() );
		break;
		
		case "flip":
		CmdVehicle.FlipVehicle( player, command.tostring() );
		break;
		
		case "vehradio":
		CmdVehicle.SetVehicleRadioURL( player, command.tostring() );
		break;
		
		case "despawnveh":
		CmdVehicle.DespawnVeh( player, command.tostring() );
		break;

		/* scripts/commands/World.nut */
		case "buyworld":
	//	case "claimworld":
		CmdWorld.funcBuyworld( player, command.tostring() );
		break;

		case "worldsetting":
		CmdWorld.funcWorldsetting( player, command.tostring() );
		break;

		case "worldkick":
		CmdWorld.funcWorldkick( player, command.tostring() );
		break;

		case "worldban":
		CmdWorld.funcWorldban( player, command.tostring() );
		break;

		case "worldunban":
		CmdWorld.funcWorldunban( player, command.tostring() );
		break;

		case "worldsetlevel":
		CmdWorld.funcWorldsetlevel( player, command.tostring() );
		break;

		case "worldpermission":
		CmdWorld.funcWorldpermission( player, command.tostring() );
		break;

		case "worldlock":
		CmdWorld.funcWorldlock( player, command.tostring() );
		break;

		case "worldann":
		CmdWorld.funcWorldAnn( player, command.tostring() );
		break;

		case "gotoworld":
		CmdWorld.funcWorldGoto( player, command.tostring() );
		break;

		case "worldinfo":
		CmdWorld.funcWorldInfo( player, command.tostring() );
		break;

		case "worldpermission2":
		CmdWorld.funcWorldpermission2( player, command.tostring() );
		break;

		case "sellworld":
		case "releaseworld":
		CmdWorld.SellWorld( player, command.tostring() );
		break;

	/*	case "modworld":
		CmdWorld.ModWorld( player, command.tostring() );
		break;
	*/
		case "worldlevel":
		CmdWorld.GetLevel( player, command.tostring() );
		break;

		case "worldnamelist":
		CmdWorld.GetNamelist( player, command.tostring() );
		break;

		case "worldgetpermissions":
		CmdWorld.GetPermission( player, command.tostring() );
		break;

		case "worldgetpermissions2":
		CmdWorld.GetPermission2( player, command.tostring() );
		break;

		case "myworlds":
		CmdWorld.GetOwnedWorld( player, command.tostring() );
		break;

		case "giveworld":
		CmdWorld.GiveWorld( player, command.tostring() );
		break;

		/* scripts/commands/Admin.nut */
		case "kick":
		CmdAdmin.KickPlayer( player, command.tostring() );
		break;

		case "mute":
		CmdAdmin.MutePlayer( player, command.tostring() );
		break;
		
		case "unmute":
		CmdAdmin.UnmutePlayer( player, command.tostring() );
		break;
		
		case "agoto":
		CmdAdmin.GotoPlayer( player, command.tostring() );
		break;
		
		case "agotoloc":
		CmdAdmin.GotoLocation( player, command.tostring() );
		break;
		
		case "agotoworld":
		CmdAdmin.GotoWorld( player, command.tostring() );
		break;
		
		case "get":
		CmdAdmin.GetPlayer( player, command.tostring() );
		break;
		
		case "settime":
		CmdAdmin.SetServerTime( player, command.tostring() );
		break;
		
		case "setweather":
		CmdAdmin.SetServerWeather( player, command.tostring() );
		break;
		
		case "sethp":
		CmdAdmin.SetPlayerHP( player, command.tostring() );
		break;
		
		case "ann":
		CmdAdmin.SendAnnounce( player, command.tostring() );
		break;
				
		case "setwep":
		CmdAdmin.SetPlayerWeapon( player, command.tostring() );
		break;
		
		case "setplayeroption":
		CmdAdmin.SetPlayerOption( player, command.tostring() );
		break;
		
		case "aduty":
		CmdAdmin.ToggleAdminDuty( player, command.tostring() );
		break;
		
		case "ac":
		CmdAdmin.AdminChat( player, command.tostring() );
		break;
		
		case "sc":
		CmdAdmin.StaffChat( player, command.tostring() );
		break;
		
		case "mc":
		CmdAdmin.MapperChat( player, command.tostring() );
		break;
		
		case "vipchat":
		CmdAdmin.VIPChat( player, command.tostring() );
		break;
		
		case "alias":
		CmdAdmin.GetPlayerAlias( player, command.tostring() );
		break;
		
		case "getuid":
		CmdAdmin.GetPlayerUID( player, command.tostring() );
		break;
		
		case "getinfo":
		CmdAdmin.GetPlayerInfo( player, command.tostring() );
		break;
		
		case "genpass":
		CmdAdmin.GeneratePassword( player, command.tostring() );
		break;
		
		case "ban":
		CmdAdmin.BanPlayer( player, command.tostring() );
		break;
		
		case "restartserver":
		CmdAdmin.RestartServer( player, command.tostring() );
		break;

		case "rewardcash":
		CmdAdmin.RewardCash( player, command.tostring() );
		break;
		
		case "rewardcoin":
		CmdAdmin.RewardCoin( player, command.tostring() );
		break;
		
		case "setspawnloc":
		CmdAdmin.SetSpawnloc( player, command.tostring() );
		break;
		
		case "setarm":
		CmdAdmin.SetPlayerArmour( player, command.tostring() );
		break;
		
		case "setpermission":
		CmdAdmin.SetPermissions( player, command.tostring() );
		break;
		
		case "setrank":
		CmdAdmin.SetPlayerRank( player, command.tostring() );
		break;
		
		case "setvip":
		CmdAdmin.SetPlayerVIP( player, command.tostring() );
		break;
		
		case "exe":
		CmdAdmin.Execute( player, command.tostring() );
		break;
		
		case "exec":
		CmdAdmin.ExecuteClient( player, command.tostring() );
		break;
		
		case "spec":
		CmdAdmin.SpectatePlayer( player, command.tostring() );
		break;
		
		case "exitspec":
		CmdAdmin.ExitSpectate( player, command.tostring() );
		break;
		
		case "letmeattack":
	//	player.SetOption( SqPlayerOption.CanAttack, true );
		break;

		case "achangename":
		CmdAdmin.ChangeName( player, command.tostring() );
		break;

		case "addrobpoint":
		CmdAdmin.AddRobbingPoint( player, command.tostring() );
		break;
		
		/* scripts/commands/Anims.nut */
		case "doanim":
		CmdAnim.DoAnim( player, command );
		break;

		case "addanim":
		CmdAnim.AddAnim( player, command );
		break;

		case "deleteanim":
		CmdAnim.DeleteAnim( player, command );
		break;

		case "animlist":
		CmdAnim.AnimList( player, command );
		break;

		/* scripts/commands/Sound.nut */
		case "dosound":
		CmdSound.DoSound( player, command );
		break;

		case "addsound":
		CmdSound.AddSound( player, command );
		break;

		case "deletesound":
		CmdSound.DeleteSound( player, command );
		break;

		case "soundlist":
		CmdSound.SoundList( player, command );
		break;
	}
});

