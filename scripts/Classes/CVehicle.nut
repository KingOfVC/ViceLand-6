class CVehicle
{
	Vehicles	= {};

	function constructor()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM Vehicles" ) ), count = 0;

		while( result.Step() )
		{
			this.Vehicles.rawset( result.GetString( "ID" ),
			{
				SpawnData		=
				{
					Model		= result.GetInteger( "Model" ),
					Pos			= Vector3.FromStr( result.GetString( "Pos" ) ),
					Rotation	= Vector3.FromStr( result.GetString( "Rotation" ) ),
					World		= result.GetInteger( "World" ),
					Color1		= result.GetInteger( "Color1" ),
					Color2		= result.GetInteger( "Color2" ),
					Armour		= result.GetInteger( "Armour" ),
					Vehicle 	= SqVehicle.NullInst(),
				}
				
				Prop			=
				{
					Name		= result.GetString( "Name" ),
					Owner		= result.GetInteger( "Owner" ),
					Locked		= SToB( result.GetString( "Locked" ) ),
					Radio		= result.GetString( "Radio" ),
					RadioURL	= result.GetString( "RadioURL" ),
					Handling	= ::json_decode( result.GetString( "Handling" ) ),
					Price		= result.GetInteger( "Price" ),
					Hydraulics  = SToB( result.GetString( "Hydraulics" ) ),
				}
			});

			count ++;
		}

		SqLog.Scs( "Total vehicles loaded in table: %s", SqInteger.ToThousands( count ) );
	}
	
	function Register( owner, model, world, pos, rot, col1, col2, price )
	{
		local handling1 = {}, handling = null, getID = 0;
		
		handling1.rawset( "0", 
		{
			Origin	= "0",
			Modify	= "0",
		});
		
		handling = ::json_encode( handling1 );
		
		SqDatabase.Exec( format( "INSERT INTO Vehicles ( 'Model', 'World', 'Pos', 'Rotation', 'Color1', 'Color2', 'Handling' ) VALUES ( '%d', '%d', '%s', '%s', '%d', '%d', '%s' )", model, world, pos.tostring(), rot.tostring(), col1, col2, handling ) );
	
		getID	= SqDatabase.LastInsertRowId.tostring();
		
		this.Vehicles.rawset( getID,
		{
			SpawnData		=
			{
				Model		= model,
				Pos			= pos,
				Rotation	= rot,
				World		= world,
				Color1		= col1,
				Color2		= col2,
				Armour		= 1000,
				Vehicle 	= SqVehicle.NullInst(),
			}
				
			Prop			=
			{
				Name		= "N/A",
				Owner		= owner,
				Locked		= false,
				Handling	= handling1,
				Price		= price,
				Radio		= "off",
				RadioURL	= "N/A",
				Hydraulics	= false,
			}
		});
		
		this.Save( getID );
	}

	function CreateAdmin( model, world, pos, rot )
	{
		if( typeof( model ) == "integer" )
		{
			local handling1 = {}, handling = null, getID = 0;
				
			handling1.rawset( "0", 
			{
				Origin	= "0",
				Modify	= "0",
			});
				
			handling = ::json_encode( handling1 );
					
			getID	= time().tostring();
				
			this.Vehicles.rawset( getID,
			{
				SpawnData		=
				{
					Model		= model,
					Pos			= pos,
					Rotation	= Vector3( 0,0,0 ),
					World		= world,
					Color1		= 0,
					Color2		= 0,
					Armour		= 1000,
					Vehicle 	= SqVehicle.Create( model.tointeger(), world, pos, rot, 0, 0 ),
				}
						
				Prop			=
				{
					Name		= "VL-Admin-69",
					Owner		= 100000,
					Locked		= false,
					Handling	= handling1,
					Price		= 0,
					Radio		= "off",
					RadioURL	= "N/A",
					Hydraulics	= false,
				}
			});
				
			this.Vehicles[ getID ].SpawnData.Vehicle.SetTag( getID );

			return this.Vehicles[ getID ].SpawnData.Vehicle;
		}
		else throw "Given model ID is string not integer.";
	}		

	function CreateAdmin2( model, world, pos, rot, col1, col2, team )
	{
		if( typeof( model ) == "integer" )
		{
			local handling1 = {}, handling = null, getID = 0;
				
			handling1.rawset( "0", 
			{
				Origin	= "0",
				Modify	= "0",
			});
				
			handling = ::json_encode( handling1 );
					
			SqDatabase.Exec( format( "INSERT INTO Vehicles ( 'Model', 'World', 'Pos', 'Rotation', 'Color1', 'Color2', 'Handling' ) VALUES ( '%d', '%d', '%s', '%s', '%d', '%d', '%s' )", model, world, pos.tostring(), rot.tostring(), col1, col2, handling ) );
	
			getID	= SqDatabase.LastInsertRowId.tostring();
				
			this.Vehicles.rawset( getID,
			{
				SpawnData		=
				{
					Model		= model,
					Pos			= pos,
					Rotation	= Vector3( 0,0,0 ),
					World		= world,
					Color1		= col1,
					Color2		= col2,
					Armour		= 1000,
					Vehicle 	= SqVehicle.Create( model.tointeger(), world, pos, rot, col1, col2 ),
				}
						
				Prop			=
				{
					Name		= "VL-TDM-" + team,
					Owner		= 100000,
					Locked		= false,
					Handling	= handling1,
					Price		= 0,
					Radio		= "off",
					RadioURL	= "N/A",
					Hydraulics	= false,
				}
			});
				
			this.Vehicles[ getID ].SpawnData.Vehicle.SetTag( getID );

			return this.Vehicles[ getID ].SpawnData.Vehicle;
		}
		else throw "Given model ID is string not integer.";
	}		

	function GetPlayerVehicleCountInWorld( player, world )
	{
		local getCount = 0;
		
		SqForeach.Vehicle.Active( this, function( vehicle )
		{
			if( this.Vehicles.rawin( vehicle.Tag ) )
			{
				if( this.Vehicles[ vehicle.Tag ].Prop.Owner == player && vehicle.World == world ) getCount++;
			}
		});
		
		return getCount;
	}
	
	function GetPlayerVehicleCount( player )
	{
		local getCount = 0;
		
		foreach( value in this.Vehicles )
		{
			if( value.Prop.Owner == player ) getCount++;
		}
		
		return getCount;
	}

	function UpdateHandling( uid, rule, origin, value )
	{
		local getHandling = this.Vehicles[ uid ].Prop.Handling;
		
		if( getHandling.rawin( rule.tostring() ) ) getHandling[ rule.tostring() ].Modify = value.tostring();
		
		else
		{
			getHandling.rawset( rule.tostring(), 
			{
				Origin	= origin.tostring(),
				Modify	= value.tostring(),
			});
		}
	}
	
	function Save( uid )
	{
		local getVeh = this.Vehicles[ uid ];
		
		SqDatabase.Exec( format( "UPDATE Vehicles SET Pos = '%s', Rotation = '%s', World = '%d', Color1 = '%d', Color2 = '%d', Armour = '%d', Name = '%s', Locked = '%s', Handling = '%s', Owner = '%d', Radio = '%s', RadioURL = '%s', Price = '%d', Hydraulics = '%s' WHERE ID = '%s'", getVeh.SpawnData.Pos.tostring(), getVeh.SpawnData.Rotation.tostring(), getVeh.SpawnData.World, getVeh.SpawnData.Color1, getVeh.SpawnData.Color2, getVeh.SpawnData.Armour, ::EscapeString( getVeh.Prop.Name ), getVeh.Prop.Locked.tostring(), ::json_encode( getVeh.Prop.Handling ), getVeh.Prop.Owner, getVeh.Prop.Radio, SQLite.EscapeString( getVeh.Prop.RadioURL ), getVeh.Prop.Price, getVeh.Prop.Hydraulics.tostring(), uid ) );
	}
	
	function CanIParkHere( player )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions2[ "vehmanage" ].tointeger() ) ) return true;
		}
		else return false;
	}

	function GetHealingPrice( player, health )
	{
		if( player.Data.Player.Permission.VIP.Position == "0" ) return ( health * 150 );
		else return 0;
	}

	function GetWorldVehicleCount( world )
	{
		local getCount = 0;
		SqForeach.Vehicle.Active(this, function( Vehicle )
		{
			if( Vehicle.World == world ) getCount++;
		});
		
		return getCount;
	}

	function RemoveAllVehicleInWorld( world )
	{
		SqForeach.Vehicle.Active(this, function( Vehicle )
		{
			if( Vehicle.World == world )
			{
				if( this.Vehicles.rawin( Vehicle.Tag ) )
				{
					if( this.Vehicles[ Vehicle.Tag ].Prop.Name == "VL-Admin-69" )
					{
						Vehicle.Destroy();

						SqVehicles.Vehicles.rawdelete( Vehicle.Tag );
					}

					else 
					{
						this.Vehicles[ Vehicle.Tag ].SpawnData.Vehicle = SqVehicle.NullInst();
						Vehicle.Destroy();
					}
				}
			}
		});
	}
	
	function GetPrice( player, model )
	{
		local originPrice = 0;
		
		switch( model )
		{
			case 130: 
			originPrice = 35; break; 

			case 131: 
			originPrice = 30; break;

			case 132: 
			originPrice = 45; break;

			case 133: 
			originPrice = 45; break;

			case 134: 
			originPrice = 20; break;

			case 135: 
			originPrice = 45; break;

			case 200: 
			originPrice = 50; break;

			case 137: 
			originPrice = 25; break;

			case 138: 
			originPrice = 15; break;

			case 139: 
			originPrice = 50; break;

			case 140: 
			originPrice = 19; break;

			case 141: 
			originPrice = 105; break;

			case 143: 
			originPrice = 30; break;

			case 144: 
			originPrice = 32; break;

			case 145: 
			originPrice = 115; break;

			case 146: 
			originPrice = 20; break;

			case 148: 
			originPrice = 26; break;

			case 149: 
			originPrice = 29; break;

			case 150: 
			originPrice = 30; break;

			case 216: 
			originPrice = 28; break;

			case 152: 
			originPrice = 36; break;

			case 153: 
			originPrice = 39; break;

			case 154: 
			originPrice = 25; break;

			case 156: 
			originPrice = 35; break;

			case 157: 
			originPrice = 50; break;

			case 158: 
			originPrice = 50; break;

			case 159: 
			originPrice = 55; break;

			case 161: 
			originPrice = 25; break;

			case 162: 
			originPrice = 120; break;

			case 163: 
			originPrice = 20; break;

			case 138: 
			originPrice = 20; break;

			case 165: 
			originPrice = 20; break;

			case 167: 
			originPrice = 30; break;

			case 168: 
			originPrice = 20; break;

			case 169: 
			originPrice = 29; break;

			case 170: 
			originPrice = 36; break;

			case 171: 
			originPrice = 48; break;

			case 180: 
			originPrice = 20; break;

			case 211: 
			originPrice = 20; break;

			case 185: 
			originPrice = 20; break;

			case 186: 
			originPrice = 32; break;

			case 187: 
			originPrice = 19; break;

			case 142: 
			originPrice = 40; break;

			case 151: 
			originPrice = 28; break;

			case 164: 
			originPrice = 20; break;

			case 172: 
			originPrice = 20; break;

			case 173: 
			originPrice = 30; break;

			case 175: 
			originPrice = 45; break;

			case 179: 
			originPrice = 36; break;

			case 188: 
			originPrice = 20; break;

			case 189: 
			originPrice = 30; break;

			case 196: 
			originPrice = 30; break;

			case 197: 
			originPrice = 30; break;

			case 204: 
			originPrice = 29; break;

			case 206: 
			originPrice = 29; break;

			case 206: 
			originPrice = 55; break;

			case 207: 
			originPrice = 55; break;

			case 208: 
			originPrice = 36; break;

			case 209: 
			originPrice = 28; break;

			case 210: 
			originPrice = 45; break;

			case 211: 
			originPrice = 45; break;

			case 212: 
			originPrice = 36; break;

			case 213: 
			originPrice = 26; break;

			case 215: 
			originPrice = 19; break;

			case 216: 
			originPrice = 20; break;

			case 219: 
			originPrice = 50; break;

			case 221: 
			originPrice = 19; break;

			case 222: 
			originPrice = 29; break;

			case 224: 
			originPrice = 55; break;

			case 225: 
			originPrice = 50; break;

			case 226: 
			originPrice = 45; break;

			case 228: 
			originPrice = 32; break;

			case 229: 
			originPrice = 32; break;

			case 211: 
			originPrice = 35; break;

			case 201: 
			originPrice = 50; break;

			case 234: 
			originPrice = 48; break;

			case 235: 
			originPrice = 48; break;

			case 191: 
			originPrice = 20; break;

			case 148: 
			originPrice = 20; break;

			case 203: 
			originPrice = 20; break;

			case 166: 
			originPrice = 20; break;

			case 193: 
			originPrice = 20; break;

			case 160: 
			originPrice = 50; break;

			case 182: 
			originPrice = 40; break;

			case 183: 
			originPrice = 35; break;

			case 136: 
			originPrice = 46; break;

			case 176: 
			originPrice = 70; break;

			case 184: 
			originPrice = 83; break;

			case 202: 
			originPrice = 20; break;

			case 203: 
			originPrice = 46; break;

			case 214: 
			originPrice = 109; break;

			case 223: 
			originPrice = 58; break;

			case 177: 
			originPrice = 20; break;

			case 199: 
			originPrice = 35; break;

			case 177: 
			originPrice = 38; break;

			case 217: 
			originPrice = 55; break;

			case 202: 
			originPrice = 60; break;

			case 156: 
			originPrice = 62; break;

			case 155: 
			originPrice = 109; break;

			case 194: 
			originPrice = 48; break;

			case 231: 
			originPrice = 48; break;

			case 6400:
			originPrice = 29; break;

			case 6401:
			originPrice = 120; break;
			
			case 6402:
			originPrice = 85; break;
			
			case 6403:
			originPrice = 120; break;
			
			case 6404:
			originPrice = 32; break;
			
			case 6405:
			originPrice = 52; break;
			
			case 6406:
			originPrice = 320; break;
			
			case 6407:
			originPrice = 500; break;
			
			case 6408:
			originPrice = 320; break;
			
			case 6409:
			originPrice = 102; break;

			case 6410:
			originPrice = 500; break;

			case 6411:
			originPrice = 650; break;

			case 6412:
			originPrice	= 120; break;

			case 6413:
			originPrice = 160; break;

			case 6414:
			originPrice = 190; break;

			default:
			originPrice = ( rand() % 100 ); break;
		}
		
		if( Server.Discount.Vehicle.Model.rawin( model ) )
		{
			local getDiscount = ( ( originPrice/100 ) * Server.Discount.Vehicle.Model[ model ].Price ), countPrice = ( originPrice - getDiscount );
	
			if( player.Data.Player.Permission.VIP.Position == "0" )
			{
				local getVIPDiscount = ( ( originPrice/100 ) * 25 );
				return ( originPrice - getVIPDiscount );
			}
			else return countPrice;
		}
		
		else
		{
			if( player.Data.Player.Permission.VIP.Position == "0" )
			{
				local getVIPDiscount = ( ( originPrice/100 ) * 25 );
				return ( originPrice - getVIPDiscount );
			}
			else return originPrice;
		}
		
		return "Invalid vehicle data. " + this.GetVehicleModelFromName( model );
	}
	
	function BuyVehicle( player, str )
	{
		str = str.tointeger();

		if( this.GetValidModel( str ) != -1 )
		{
			if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, this.GetPrice( player, str ) ) )
			{
				this.Register( player.Data.AccID, str, 123456, Vector3( 0,0,0 ), Vector3( 0,0,0 ), 0, 0, this.GetPrice( player, str ) );
				
				player.Data.Stats.Coin -= this.GetPrice( player, str );
			
				player.Msg( TextColor.Sucess, Lang.BuyVehicleSucess[ player.Data.Language ] );
				
				if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.BuyVehicleHelp[ player.Data.Language ], TextColor.InfoS );

				player.StreamInt( 203 );
				player.StreamString( "" );
				player.FlushStream( true );
			}
			
			else
			{
				player.StreamInt( 201 );
				player.StreamString( format( Lang.NotEnoughBuyVeh[ player.Data.Language ], SqInteger.ToThousands( this.GetPrice( player, str ) ) ) );
				player.FlushStream( true );
			}
		}
		
		else
		{
			player.StreamInt( 201 );
			player.StreamString( format( Lang.InvalidErrorVehID[ player.Data.Language ] ) );
			player.FlushStream( true );
		}
	}
	
	function VehicleType( model )
	{
		switch ( model ) {
			case 136:
			case 160:
			case 176:
			case 182:
			case 183:
			case 184:
			case 190:
			case 202:
			case 203:
			case 214:
			case 223:
				return "Boat";
			case 155:
			case 165:
			case 217:
			case 218:
			case 227:
			case 6407:
			case 6409:
				return "Heli";
			case 166:
			case 178:
			case 191:
			case 192:
			case 193:
			case 198:
				return "Bike";
			case 171:
			case 194:
			case 195:
			case 231:
				return "RC";
			case 180:
			case 181:
			case 6401:
			case 6403:
			case 6406:
			case 6408:
				return "Plane";
			default:
				return "Car";
		}
	}
	
	function SendPriceData( player, str )
	{
		player.StreamInt( 202 );
		player.StreamString( this.GetPrice( player, str.tointeger() ).tostring() );
		player.FlushStream( true );
	}

	function GetVehicle( player, str )
	{
		try 
		{
			local getID = ( str ).tostring();

			if( this.Vehicles.rawin( getID ) )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqMath.IsLess( this.GetPlayerVehicleCountInWorld( player.Data.AccID, player.World ), 10 ) )
					{
						local value = this.Vehicles[ getID ];

						if( value.SpawnData.Vehicle.tostring() == "-1" )
						{
							local getPos = "" + ( player.PosX + 2 ) + ", " + ( player.PosY + 2 ) + ", " + player.PosZ;

							value.SpawnData.Vehicle 				= SqVehicle.Create( value.SpawnData.Model, player.World, Vector3.FromStr( getPos ), 0, value.SpawnData.Color1, value.SpawnData.Color2 );
							value.SpawnData.Vehicle.EulerRotation	= value.SpawnData.Rotation;
							value.SpawnData.Vehicle.SecondaryColor = value.SpawnData.Color2;
							value.SpawnData.Vehicle.Radio 			= ( value.Prop.Radio == "off" ) ? 0 : player.ID;
							if( value.SpawnData.Vehicle.Health == 2000 ) value.SpawnData.Vehicle.Health += 1000;
							value.SpawnData.Vehicle.SetTag( getID );
						}
						else
						{
							local getPos = "" + ( player.PosX + 2 ) + ", " + ( player.PosY + 2 ) + ", " + player.PosZ;

							value.SpawnData.Vehicle.Pos 	= Vector3.FromStr( getPos );
							value.SpawnData.Vehicle.World 	= player.World;
						}
						
						player.Msg( TextColor.Sucess, Lang.VehSpawned[ player.Data.Language ], this.GetVehicleNameFromModel( value.SpawnData.Model ) );

						player.StreamInt( 204 );
						player.StreamString( "" );
						player.FlushStream( true );
					}

					else 
					{
						player.StreamInt( 206 );
						player.StreamString( format( Lang.Maximum10ActiveVeh[ player.Data.Language ] ) );
						player.FlushStream( true );
					}
				}

				else 
				{
					if( SqMath.IsLess( this.GetPlayerVehicleCountInWorld( player.Data.AccID, player.World ), 2 ) )
					{
						local value = this.Vehicles[ getID ], getPos = Vector3( ( player.PosX + 2 ), ( player.PosY + 2 ), player.PosZ )

						if( value.SpawnData.Vehicle.tostring() == "-1" )
						{
							value.SpawnData.Vehicle 				= SqVehicle.Create( value.SpawnData.Model.tointeger(), player.World, getPos, 0, value.SpawnData.Color1, value.SpawnData.Color2 );
							value.SpawnData.Vehicle.EulerRotation	= value.SpawnData.Rotation;
							value.SpawnData.Vehicle.SecondaryColor 	= value.SpawnData.Color2;
							value.SpawnData.Vehicle.Radio 			= ( value.Prop.Radio == "off" ) ? 0 : player.ID;
							if( value.SpawnData.Vehicle.Health == 2000 ) value.SpawnData.Vehicle.Health += 1000;
							value.SpawnData.Vehicle.SetTag( getID );
						}
						else 
						{
							local getPos = Vector3( ( player.PosX + 2 ), ( player.PosY + 2 ), player.PosZ );

							value.SpawnData.Vehicle.Pos 	= getPos;
							value.SpawnData.Vehicle.World 	= player.World;
						}

						player.Msg( TextColor.Sucess, Lang.VehSpawned[ player.Data.Language ], this.GetVehicleNameFromModel( value.SpawnData.Model ) );

						player.StreamInt( 204 );
						player.StreamString( "" );
						player.FlushStream( true );
					}

					else 
					{
					    player.StreamInt( 206 );
						player.StreamString( format( Lang.Maximum1ActiveVeh[ player.Data.Language ] ) );
						player.FlushStream( true );
					}
				}	
			}

			else
			{
			    player.StreamInt( 206 );
				player.StreamString( format( Lang.CantPurchaseVehError[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
		}
		catch( e ) player.Msg( TextColor.Error, Lang.CreateVehicleError[ player.Data.Language ], e );
	}

	function GetVehicleModelFromName( text )
	{
		foreach( index, value in CustomVehicles )
		{
			if( value.Vehicle.tolower() == text.tolower() ) return value.ID.tointeger();
		}

		return GetAutomobileID( text ).tointeger();
	}

	function GetVehicleNameFromModel( id )
	{
		foreach( index, value in CustomVehicles )
		{
			if( value.ID == id.tointeger() ) return value.Vehicle;
		}

		return GetAutomobileName( id.tointeger() );
	}

	function GetValidModel( id )
	{
		foreach( index, value in CustomVehicles )
		{
			if( value.ID == id.tointeger() ) return true;
		}

		return IsAutomobileValid( id );
	}

	function GetNearestSupplyVehicle( team )
	{
		SqForeach.Vehicle.Active( this, function( vehicle )
		{
			if( this.Vehicles.rawin( vehicle.Tag ) )
			{
				if( this.Vehicles[ vehicle.Tag ].Prop.Owner == 100000 && this.Vehicles[ vehicle.Tag ].Prop.Name == "TDM-Supply-" + team )
				{
					if( vehicle.Pos.DistanceTo( player.Pos ) < 2 ) return 1;
				} 
			}
		});

		return;
	}

}

CustomVehicles <-
[
	{ "Vehicle": "Hilux", "ID": 6400 },
	{ "Vehicle": "Shamal", "ID": 6401 },
	{ "Vehicle": "Batmobile", "ID": 6402 },
	{ "Vehicle": "Hydra", "ID": 6403 },
	{ "Vehicle": "LaFerrari", "ID": 6404 },
	{ "Vehicle": "911 GT22", "ID": 6405 },
	{ "Vehicle": "Jetpack", "ID": 6406 },
	{ "Vehicle": "Buzzard", "ID": 6407 },
	{ "Vehicle": "Carpet", "ID": 6408 },
	{ "Vehicle": "Maverick Custom", "ID": 6409 },
	{ "Vehicle": "Gallardo LP 560-4", "ID": 6410 },
	{ "Vehicle": "Cabrio", "ID": 6411 },
	{ "Vehicle": "ISIS Patriot", "ID": 6412 },	
	{ "Vehicle": "Police Bike", "ID": 6413 },	
	{ "Vehicle": "Ferrari F50", "ID": 6414 },	

]