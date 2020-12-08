SqCore.On().ServerStartup.Connect(this, function ()
{
	SqServer.SetServerName(Server.Name);
	SqServer.SetGameModeText(Server.Gamemode);
	SqServer.SetPassword(Server.Password);
	SqServer.SetMaxPlayers(100);
	SqServer.SetTimeRate(30000);
	SqServer.SetKillCommandDelay(20);
	SqServer.SetWastedSettings(500, 200, 0.3, 3, Color3(0, 0, 0), 5000, 3000);
	SqServer.SetVehiclesForcedRespawnHeight(5000);

	SqServer.SetOption(SqServerOption.TaxiBoostJump, true);
	SqServer.SetOption(SqServerOption.FastSwitch, true);
	SqServer.SetOption(SqServerOption.JoinMessages, false);
	SqServer.SetOption(SqServerOption.DeathMessages, false);
	SqServer.SetOption(SqServerOption.UseClasses, true);
	SqServer.SetOption(SqServerOption.WallGlitch, false);
	SqServer.SetOption(SqServerOption.DisableBackfaceCulling, true);
	SqServer.SetOption(SqServerOption.StuntBike, true);	
	SqServer.SetOption(SqServerOption.FriendlyFire, true);
	SqServer.SetOption(SqServerOption.DriveOnWater, true);

	SqServer.SetSpawnPlayerPosition( Vector3( -1471.725586,550.064453,2009.357422 ) );
	SqServer.SetSpawnCameraPosition( Vector3( -1472.346069,554.965027,2009.979980 ) );
	SqServer.SetSpawnCameraLookAt( Vector3( -1471.725586,550.064453,2009.357422 ) );

	SqServer.HideMapObject( 1864, Vector3( -808.318,1238.95,40.633 ) );

	SqServer.HideMapObject(1259, Vector3(-880.552, -575.726, 11.3371 ) );
	SqServer.HideMapObjectRaw(2426,-3542,-4980,118);
	SqServer.HideMapObjectRaw(2501,-2791,-5820,132);
	SqServer.HideMapObjectRaw(2372,-3726,-4633,113);
	SqServer.HideMapObjectRaw(2403,-4998,-4677,116);
	SqServer.HideMapObjectRaw(2401,-3836,-2914,105);
	SqServer.HideMapObjectRaw(2420,-3781,-3359,118);
	SqServer.HideMapObjectRaw(429,-6698,11937,145);
	SqServer.HideMapObjectRaw(428,-6718,11904,132);
	SqServer.HideMapObjectRaw(2417,-2479,-3639,238);
	SqServer.HideMapObjectRaw(2454,-2076,-4369,199);
	SqServer.HideMapObjectRaw(2370,-2076,-4331,209);
	SqServer.HideMapObjectRaw(357,-2159,-3990,124);
	SqServer.HideMapObjectRaw(357,-1948,-3861,124);
	SqServer.HideMapObjectRaw(2382,-1681,-3989,178);
	SqServer.HideMapObjectRaw(524,-1801,-4208,121);
	SqServer.HideMapObjectRaw(449,-1797,-4386,92);
	SqServer.HideMapObjectRaw(474,-1819,-4533,100);
	SqServer.HideMapObjectRaw(449,-1966,-4545,92);
	SqServer.HideMapObjectRaw(449,-2157,-4577,92);
	SqServer.HideMapObjectRaw(474,-2320,-4597,100);
	SqServer.HideMapObjectRaw(474,-2369,-4270,100);
	SqServer.HideMapObjectRaw(468,-2346,-3681,101);
	SqServer.HideMapObjectRaw(468,-2144,-3556,101);
	SqServer.HideMapObjectRaw(468,-2015,-3620,101);
	SqServer.HideMapObjectRaw(468,-1927,-3762,99);
	SqServer.HideMapObjectRaw(468,-2341,-3819,101);
	SqServer.HideMapObjectRaw(472,-2399,-3717,97);
	SqServer.HideMapObjectRaw(453,-2081,-3527,114);
	SqServer.HideMapObjectRaw(2540,-3818,-5047,154);
	SqServer.HideMapObjectRaw(2492,-4159,-5123,164);

	/* Free Team */
	SqServer.AddPlayerClass( 255, Color3( 255, 255, 255 ), 0, Vector3( -599.382, 631.536, 11.6765 ), 158.7135, 0, 0, 0, 0, 0, 0 );

	/* Business */
	SqServer.AddPlayerClass( 1, Color3( 255, 0, 0 ), 13, Vector3( -37.9819, -936.916, 24.573 ), 158.7135, 0, 0, 0, 0, 0, 0 );
	SqServer.AddPlayerClass( 1, Color3( 255, 0, 0 ), 16, Vector3( -37.9819, -936.916, 24.573 ), 158.7135, 0, 0, 0, 0, 0, 0 );
	SqServer.AddPlayerClass( 1, Color3( 255, 0, 0 ), 68, Vector3( -37.9819, -936.916, 24.573 ), 158.7135, 0, 0, 0, 0, 0, 0 );

	/* Medic */
	SqServer.AddPlayerClass( 2, Color3( 128, 0, 0 ), 5, Vector3( -1060.32, 86.1638, 11.4368 ), 158.7135, 0, 0, 0, 0, 0, 0 );
	SqServer.AddPlayerClass( 2, Color3( 128, 0, 0 ), 202, Vector3( -1060.32, 86.1638, 11.4368 ), 158.7135, 0, 0, 0, 0, 0, 0 );

	/* Taxi */
	SqServer.AddPlayerClass( 3, Color3( 255, 125, 18 ), 133, Vector3( -1000.78, 185.642, 11.4288 ), 158.7135, 0, 0, 0, 0, 0, 0 );
	SqServer.AddPlayerClass( 3, Color3( 255, 125, 18 ), 134, Vector3( -1000.78, 185.642, 11.4288 ), 158.7135, 0, 0, 0, 0, 0, 0 );

	/* Haitian */
	SqServer.AddPlayerClass( 4, Color3( 0, 234, 255 ), 85, Vector3( -1189.95, 77.9542, 11.1281 ), 158.7135, 0, 0, 0, 0, 0, 0 );
	SqServer.AddPlayerClass( 4, Color3( 0, 234, 255 ), 86, Vector3( -1189.95, 77.9542, 11.1281 ), 158.7135, 0, 0, 0, 0, 0, 0 );

	/*  Police */
	SqServer.AddPlayerClass( 5, Color3( 0, 81, 255 ), 2, Vector3( -657.629, 761.639, 11.5997 ), 158.7135, 0, 0, 0, 0, 0, 0 );
	SqServer.AddPlayerClass( 5, Color3( 0, 81, 255 ), 3, Vector3( -657.629, 761.639, 11.5997 ), 158.7135, 0, 0, 0, 0, 0, 0 );

	/* Biker */
	SqServer.AddPlayerClass( 6, Color3( 255, 0, 191 ), 93, Vector3( -599.382, 631.536, 11.6765 ), 158.7135, 0, 0, 0, 0, 0, 0 );
	SqServer.AddPlayerClass( 6, Color3( 255, 0, 191 ), 94, Vector3( -599.382, 631.536, 11.6765 ), 158.7135, 0, 0, 0, 0, 0, 0 );

});