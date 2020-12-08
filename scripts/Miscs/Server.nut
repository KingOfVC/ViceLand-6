Server <-
{
	Name			=   "ViceLand :: Team Deathmatch | Mapping | Private World | Gangs"
    Gamemode		=   "VL 6.2",
    Password        =   "",
    IPAddress       =   "",
    Author          =   "",
    Forum           =   "https://vl.kingofvc.best",
    Echo            =   "",
    Credits         =   "",
    Discord 		= 	"https://discord.gg/8P566V6",
    LastUpdate 		= 	"11/3/2019",
    Version 		=   "v6",
  	EnableEcho 		=   false,
  	Logname 		= 	null,
  	PlayerCount 	= 	0,
  	
  	DiscordBot 		= 
  	{
  		EchoBot =
  		{
  			Token = "MjkxMDkzMjA1NDIyODMzNjY1.D3UGCA.fk7EmMLtoiPnjxpcv7CJChr5RGM",
  			Channel = "552023566040825867",
  		}

  		StaffBot =
  		{
  			Token = "NDcyMzgwOTk1NzA2OTQ1NTQ3.D3UFjA.lRTO7MZlKuecbTNllYZfWz2TtKo",
  			Channel = "554172799753912324",
  		}
  	}
  	
    Uptime		    =	time(),

    PlayerTitle 	= {},
    
    PremiumObj		= 
    [
    	6435,
    ]
	
	Discount		=
	{
		Vehicle 	= 
		{
			VIP		= 25,
			
			Handling	= 0,
			
			Changename 	= 0,
			CustomColor	= 0,
			ModFlying	= 75,
			
			Model	=
			{
				"171": { "Price": 15 }
			}
		}
		
		World		= 
		{
			World	= 30,
			Admin	= 0,
			FPSP	= 0,
		}
		
		Special		=
		{
			VIP 	= 25,
			
			Item	=
			{
			
			
			
			}
		}
	}
	
	DoubleEvent		=
	{
		LMS			= 0,
		Minigun		= 0,
		Derby		= 0,
		Glass		= 0,
		WeaponDM	= 2,

		Kill 		= 2,
		Pizza 		= 1,
		Robbery 	=
		{
			MaxCash		= 50000,
			MP 			= 6,
		}
	}
	
	Coin 			= 
	{
		StartPrice	= 20000,
		ChangeRate	= 0,
	}
	
	MainWorld 		=
	{
		Ping		= 500,
		FPS			= 5,
	}

	RankName 		= 
	{
		Admin		=
		[
			"None",
			"Moderator",
			"Adminstrator",
			"Senior Adminstrator",
			"Manager",
			"Owner",
		],

		Mapper		=
		[
			"None",
			"Mapper",
		]

		VIP		=
		[
			"None",
			"Temporary",
			"Permanent",
		]
	}

	AutoMessage 	=
	{	
		State = 0,
		Place = 0,

		RTText 	= null,
		RTPrice	= 0,
		RTTime 	= time(),
	}

	DMArena			=
	{
		Count		= 600,
		Lenght		= 600,
		Position 	= 1,

		Arena		=
		{
			"1":
			{
				Pos 	= "-900.078369,389.996796,11.153002",
				Name 	= "BF",
			}

			"2":
			{
				Pos 	= "121.526787,-370.969696,114.163658",
				Name 	= "Contruction Yard",
			}

			"3":
			{
				Pos 	= "-1281.076294,1353.964966,83.888184",
				Name 	= "Stadium Roof",
			}

			"4":
			{
				Pos 	= "687.191345,-515.257507,11.071210",
				Name 	= "Beach",
			}

			"5":
			{
				Pos 	= "1240.846558,-569.702759,9.563089",
				Name 	= "Marks Fun Island",
			}

			"6":
			{
				Pos 	= "568.124390,-5.646159,156.853210",
				Name 	= "Vice Point Roof",
			}

			"7":
			{
				Pos 	= " 1180.714844,1627.817993,142.411438",
				Name 	= "Vice Mountain",
			}
		}
	}

	DiscordEchoCount  = 0,

	TDM				=
	[
		{
			TeamID = 0,
			TeamName = "Red",
			TeamColor = Color3( 255, 0, 0 ),
			TeamSkin = 45,
			TeamSpawnPos = Vector3( 479.906677,29.917393,11.071223 ),
			TeamScore = 0,
		}

		{
			TeamID = 1,
			TeamName = "Blue",
			TeamColor = Color3( 0, 0, 255 ),
			TeamSkin = 25,
			TeamSpawnPos = Vector3( 529.116882,31.528242,13.473069 ),
			TeamScore = 0,
		}
	]

	Area 			=
	{
		"Blue Base":
		{
			Pos 	= 
			[ 
				-1780.669312,-304.540680,14.868327
				-1780.664795,-86.136108,19.760216
				-1588.447510,-86.135567,14.868327
				-1588.505981,-304.495911,19.760216			
			]

			World 	= 104,
		}

		"Red Base":
		{
			Pos 	=
			[
				-652.768066,-1699.033813,33.963867
				-585.086792,-1533.474854,33.274506
				-806.123413,-1447.813599,52.857334
				-904.567017,-1592.932495,58.652740			
			]
			World 	= 104,
		}
	}

	Event 	=
	{
		WaterFight =
		{
			isEvent = 0,
			Price 	= 0,
			Host 	= null,
			XP 		= 100,
			PartXP 	= 15,
		}
	}

	ReactionText =
	{
		Text = null,
		Price =
		{
			Type = "Cash",
			Price = 0,
		}
		Time = 0,
	}

	TeamDMScore =
	{
		"Team1":
		{
			Score = 0,
		}

		"Team2":
		{
			Score = 0,
		}

		"Team3":
		{
			Score = 0,
		}

		"Team4":
		{
			Score = 0,
		}

		"Team5":
		{
			Score = 0,
		}

		"Team6":
		{
			Score = 0,
		}
	}

	Updatelog 		= @"
	
	Merry Christmas and Happy New Year! Script is now updated to v6.2! Use /updatelog to view complete update log.

	You will get 30days VIP rank, x2 crate and Santa Hat after you logged.

	- ViceLand Management
	",
}