SqCore.On().ScriptLoaded.Connect(this, function ()
{	
	SqLog.Usr( "--------------------------------------------------------------------" );
	SqLog.Usr( "Loading ViceLand SqMod" );
	SqLog.Usr( "Author: KingOfVC" );
	SqLog.Usr( "--------------------------------------------------------------------" );

	SqDatabase  		<- SQLite.Connection( "viceland_db.db" );
	SqCountry			<- SqMMDB.Database( "GeoLite2-City.mmdb" );

/*	CmdAccount 			<- CCmdAccount( SqCmd.Manager() );
	CmdDeathmatch 		<- CCmdDeathmatch( SqCmd.Manager() );
	CmdLocation 		<- CCmdLocation( SqCmd.Manager() );
	CmdWorld			<- CCmdWorld( SqCmd.Manager() );
	CmdObject 			<- CCmdObject( SqCmd.Manager() );
	CmdPickup 			<- CCmdPickup( SqCmd.Manager() );
	CmdVehicle			<- CCmdVehicle( SqCmd.Manager() );
	CmdMisc				<- CCmdMisc( SqCmd.Manager() );
	CmdBlip				<- CCmdBlip( SqCmd.Manager() );
	CmdAdmin			<- CCmdAdmin( SqCmd.Manager() );*/

	CmdVehicle2			<- CCmdVehicle2( SqCmd.Manager() );
	CmdGang				<- CCmdGang( SqCmd.Manager() );
	CmdJob				<- CCmdJob( SqCmd.Manager() );
	CmdMisc2			<- CCmdMisc2( SqCmd.Manager() );
	CmdAdmin2			<- CCmdAdmin2( SqCmd.Manager() );
	CmdAccount2 		<- CCmdAccount2( SqCmd.Manager() );
	CmdLocation2 		<- CCmdLocation2( SqCmd.Manager() );
	CmdEvent	 		<- CCmdEvent( SqCmd.Manager() );
	CmdObject2	 		<- CCmdObject2( SqCmd.Manager() );

	CmdObject 			<- CCmdObject();
	CmdAccount 			<- CCmdAccount();
	CmdLocation 		<- CCmdLocation();
	CmdDeathmatch 		<- CCmdDeathmatch();
	CmdMisc				<- CCmdMisc();
	CmdPickup 			<- CCmdPickup();
	CmdBlip				<- CCmdBlip();
	CmdVehicle			<- CCmdVehicle();
	CmdWorld			<- CCmdWorld();
	CmdAdmin			<- CCmdAdmin();
	CmdAnim				<- CCmdAnim();
	CmdSound 			<- CCmdSound();

	SqVehicles 			<- CVehicle();
	SqWorld 			<- CWorld();
	SqObj	 			<- CObject();
	SqPick	 			<- CPickup();
	SqMarker 			<- CBlip();
	SqAdmin 			<- CAdmin();
	SqKeybinds 			<- CKeybind();
	SqAnim 				<- CAnim();
	SqSound 			<- CSound();
	SqGang 				<- CGang();
	SqDiscord2 			<- CDiscord();
	SqPanel 			<- CPanel();

	SqAD 				<- CAttDef();
	SqJob 				<- CJob();
	
	LoadCheckpoint();
	LoadKeybind();
	LoadArea();

	SqDM.LoadScore();

	SqWeapon.InitCustomWeaponName();

	local tim = SqRoutine( this, AutoMessage, 600000, 0 );
	tim.Quiet = false;
	
	//SqRoutine( SqDM, SqDM.ChangeArena, 1000, 0 );

	//EchoBot.Connect( Server.DiscordBot.EchoBot.Token );

	//StaffBot.Connect( Server.DiscordBot.StaffBot.Token );

	//SqDatabase.Exec( format( "INSERT INTO Checkpoints ( 'UID', 'Pos', 'Size', 'Type', 'World', 'Color' ) VALUES ( '%s', '%s', '%f', '%s', '%d', '%s' )", "2729C40846B3432DCCC74237A9E7F150", "1378.702881,363.178894,27.975609", 1.5, "EnterDM", 100, "255, 255, 255, 255" ) );

	//SqGang.Create( "Team F1ers", "TF1", 3092 );

	//SqDatabase.Exec( format( "DELETE FROM Gangs WHERE Founder = '%d'", 3092 ) );
//	print( SqGang.GetPlayerLevel( 1, 2 ) );

	//SqGang.EditRank( 2, "Girl", 69 );


	local int = time(), generateUID = "Session-" + ( rand() % 9 ) + "" + ( rand() % 9 ) + "" + ( rand() % 9 ) + "" + ( rand() % 9 ) + "" + ( rand() % 9 );
	Server.Logname = generateUID + "_" + date( int ).day + "-" + ( date( int ).month+1 ) + "-" + date( int ).year;

	SqLog.Usr( "Logging started. Session ID: %s", generateUID );

	WriteToFile( "[" + SqInteger.TimestampToDate( time() ) + "] " + SqStr.Center('-', 72, " LOGGIN STARTED ") );

	seterrorhandler( errorHandling );

});