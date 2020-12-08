dofile( "Miscs/Context.nut" );
dofile( "Miscs/ContextManager.nut" );
dofile( "Miscs/Handler.nut" );
dofile( "Miscs/Misc.nut" );
dofile( "Miscs/Timer.nut" );
dofile( "Miscs/Execute.nut" );
dofile( "updatelog.nut" );

dofile( "Events/Events.nut" );

dofile( "Classes/World.nut" );
dofile( "Classes/Memo_mem.nut" );
dofile( "Classes/BuyVehicle_mem.nut" );
dofile( "Classes/GetVeh_mem.nut" );
dofile( "Classes/PlayerHud_mem.nut" );
dofile( "Classes/Gagjik_mem.nut" );
dofile( "Classes/TopPlayer_mem.nut" );
dofile( "Classes/WorldSelect_mem.nut" );
dofile( "Classes/Register_mem.nut" );
dofile( "Classes/Login_mem.nut" );
dofile( "Classes/ModeSelector_mem.nut" );
dofile( "Classes/PlayerTitle_mem.nut" );
dofile( "Classes/News_mem.nut" );
dofile( "Classes/Lobbycredits_mem.nut" );
dofile( "Classes/Announce_mem.nut" );
dofile( "Classes/Updatelog_mem.nut" );
dofile( "Classes/Deathwindow_mem.nut" );

seterrorhandler( errorHandling );

ContextManager <- CContextManager();
Handler <- CHandler();

Handler.Create( "Excute", CExecute( "CExecute" ) );
Handler.Create( "Memobox", CMemobox( "Memobox" ) );
Handler.Create( "BuyVeh", CBuyvehicle( "BuyVeh" ) );
Handler.Create( "GetVeh", CGetVehicle( "GetVeh" ) );
Handler.Create( "PlayerHud", CPlayerHud( "PlayerHud" ) );
Handler.Create( "Gagjik", CSpecialShop( "Gagjik" ) );
Handler.Create( "TopPlayers", CTopPlayer( "TopPlayers") );
Handler.Create( "WorldSelector", CWorldSelector( "WorldSelector" ) );
Handler.Create( "Register", CRegister( "Register" ) );
Handler.Create( "Login", CLogin( "Login" ) );
Handler.Create( "Modeselect", CMSelector( "Modeselect" ) );
Handler.Create( "Playertitle", CPTitle( "Playertitle" ) );
Handler.Create( "News", CNews( "News" ) );
Handler.Create( "LobbyC", CLobbyCds( "LobbyC" ) );
Handler.Create( "Announce", CAnnounce( "Announce" ) );
Handler.Create( "Updatelog", CUpdateLog( "Updatelog" ) );
Handler.Create( "Deathwindow", CDeathWindow( "Deathwindow" ) );

