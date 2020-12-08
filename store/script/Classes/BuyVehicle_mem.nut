class CBuyvehicle extends CContext
{
	Titlebar = null;
	Titletext = null;

	Body = null;

	Membox = null;

	Close = null;
	Closetext = null;

	Close1 = null;
	Closetext1 = null;

	Close2 = null;
	Closetext2 = null;

	ErrorText = null;

	State = 0;
	
	Selected = null;

	function constructor( Key )
	{
		base.constructor();

		this.Load();
	}

	function Load()
	{
		local rel = GUI.GetScreenSize();

		this.Titlebar = GUICanvas();
		this.Titlebar.Pos = VectorScreen( rel.X * 0.2862371888726208, rel.Y * 0.1328125 );
		this.Titlebar.Size = VectorScreen( rel.X * 0.4282576866764275, rel.Y * 0.0455729166666667 );
		this.Titlebar.Colour = Colour( 32, 34, 37, 0 );

		this.Titletext = GUILabel();
		this.Titlebar.AddChild( Titletext );
		this.Titletext.TextColour = Colour( 255, 255, 255 );
		this.Titletext.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0104166666666667 );		
		this.Titletext.TextAlignment = GUI_ALIGN_CENTER;
		this.Titletext.FontFlags = GUI_FFLAG_BOLD;		
		this.Titletext.Text = "Purchase Vehicle";
		this.Titletext.FontName = "Tahoma";
		this.Titletext.FontSize = ( rel.Y * 0.0148148148148148 );
		this.centerinchildX( this.Titlebar, this.Titletext );

		this.Body = GUISprite();
		this.Titlebar.AddChild( Body );
		this.Body.SetTexture( "vl-bg.png" );
		this.Body.Pos = VectorScreen( rel.X * -0.0416666666666667, rel.Y * -0.0657407407407407 );
		this.Body.Size = VectorScreen( rel.X * 0.5114583333333333, rel.Y * 0.7166666666666667 );

		this.Membox = GUIListbox();
		this.Membox.FontFlags = GUI_FFLAG_BOLD;
		this.Membox.AddFlags( GUI_FLAG_TEXT_TAGS | GUI_FLAG_KBCTRL );
		this.Membox.FontName = "Tahoma";
		this.Membox.FontSize = ( rel.Y * 0.0148148148148148 );
		this.Membox.Pos = VectorScreen( 0, rel.Y * 0.1783854166666667 );
		this.Membox.Size = VectorScreen( rel.X * 0.4282576866764275, rel.Y * 0.3971354166666667 );
		this.Membox.Colour = Colour( 66, 70, 71, 150 );
		this.Membox.TextColour = Colour( 255, 255, 255 );
		this.Membox.SelectedColour = Colour( 47, 49, 54, 255 );
		this.centerX( this.Membox, this.Titlebar );

		this.Close = GUIWindow();
		this.Close.Pos = VectorScreen( 0, rel.Y * 0.6510416666666667 );
		this.Close.Size = VectorScreen( rel.X * 0.2598828696925329, rel.Y * 0.0455729166666667 );
		this.Close.Colour = Colour( 102, 255, 51, 255 );
		this.Close.AddFlags( GUI_FLAG_MOUSECTRL );
		this.Close.RemoveFlags( GUI_FLAG_SHADOW | GUI_FLAG_WINDOW_TITLEBAR | GUI_FLAG_WINDOW_CLOSEBTN | GUI_FLAG_WINDOW_RESIZABLE );
		this.centerX( this.Close, this.Titlebar );

		this.Closetext = GUILabel();
		this.Close.AddChild( Closetext );
		this.Closetext.TextColour = Colour( 255, 255, 255 );
		this.Closetext.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0065104166666667 );		
		this.Closetext.TextAlignment = GUI_ALIGN_CENTER;
		this.Closetext.FontFlags = GUI_FFLAG_BOLD;		
		this.Closetext.Text = "Close";
		this.Closetext.FontSize = ( rel.Y * 0.0148148148148148 );
		this.Closetext.AddFlags( GUI_FLAG_MOUSECTRL );
		this.centerinchild( this.Close, this.Closetext );

		this.Close1 = GUIWindow();
		this.Close1.Pos = VectorScreen( rel.X * 0.3294289897510981, rel.Y * 0.6510416666666667 );
		this.Close1.Size = VectorScreen( rel.X * 0.0256222547584187, rel.Y * 0.0455729166666667 );
		this.Close1.Colour = Colour( 66, 70, 71, 255 );
		this.Close1.RemoveFlags( GUI_FLAG_SHADOW | GUI_FLAG_WINDOW_TITLEBAR | GUI_FLAG_WINDOW_CLOSEBTN | GUI_FLAG_WINDOW_RESIZABLE );
		this.Close1.AddFlags( GUI_FLAG_MOUSECTRL );

		this.Closetext1 = GUILabel();
		this.Close1.AddChild( Closetext1 );
		this.Closetext1.TextColour = Colour( 255, 255, 255 );
		this.Closetext1.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0065104166666667 );		
		this.Closetext1.TextAlignment = GUI_ALIGN_CENTER;
		this.Closetext1.FontFlags = GUI_FFLAG_BOLD;		
		this.Closetext1.Text = "<";
		this.Closetext1.FontSize = ( rel.Y * 0.0148148148148148 );
		this.Closetext1.AddFlags( GUI_FLAG_MOUSECTRL | GUI_FLAG_KBCTRL );
		this.centerinchild( this.Close1, this.Closetext1 );

		this.Close2 = GUIWindow();
		this.Close2.Pos = VectorScreen( rel.X * 0.6449487554904832, rel.Y * 0.6510416666666667 );
		this.Close2.Size = VectorScreen( rel.X * 0.0256222547584187, rel.Y * 0.0455729166666667 );
		this.Close2.Colour = Colour( 255, 0, 0, 255 );
		this.Close2.RemoveFlags( GUI_FLAG_SHADOW | GUI_FLAG_WINDOW_TITLEBAR | GUI_FLAG_WINDOW_CLOSEBTN | GUI_FLAG_WINDOW_RESIZABLE );
		this.Close2.AddFlags( GUI_FLAG_MOUSECTRL );

		this.Closetext2 = GUILabel();
		this.Close2.AddChild( Closetext2 );
		this.Closetext2.TextColour = Colour( 255, 255, 255 );
		this.Closetext2.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0065104166666667 );		
		this.Closetext2.TextAlignment = GUI_ALIGN_CENTER;
		this.Closetext2.FontFlags = GUI_FFLAG_BOLD;		
		this.Closetext2.Text = "X";
		this.Closetext2.FontSize = ( rel.Y * 0.0148148148148148 );
		this.Closetext2.AddFlags( GUI_FLAG_MOUSECTRL );
		this.centerinchild( this.Close2, this.Closetext2 );

		this.ErrorText = GUILabel();
		this.Titlebar.AddChild( ErrorText );
		this.ErrorText.TextColour = Colour( 255, 0, 0 );
		this.ErrorText.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.46875 );		
		this.ErrorText.TextAlignment = GUI_ALIGN_CENTER;
		this.ErrorText.FontFlags = GUI_FFLAG_BOLD;		
		this.ErrorText.FontName = "Tahoma";
		this.ErrorText.Text = "You cannot carry anymore.";
		this.ErrorText.FontSize = ( rel.Y * 0.0138888888888889 );
		this.centerinchildX( this.Titlebar, this.ErrorText );

		this.Titlebar.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Titletext.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Body.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Membox.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_BORDER | GUI_FLAG_KBCTRL );
		this.Close.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Closetext.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Close1.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Closetext1.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Close2.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Closetext2.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.ErrorText.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
	}


	function Show()
	{
		local rel = GUI.GetScreenSize();

		this.Membox.Clean();

		this.Titlebar.AddFlags( GUI_FLAG_VISIBLE );
		this.Titletext.AddFlags( GUI_FLAG_VISIBLE );
		this.Body.AddFlags( GUI_FLAG_VISIBLE );
		this.Membox.AddFlags( GUI_FLAG_VISIBLE );
		this.Close.AddFlags( GUI_FLAG_VISIBLE );
		this.Closetext.AddFlags( GUI_FLAG_VISIBLE );
		this.ErrorText.AddFlags( GUI_FLAG_VISIBLE );

		this.Close1.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Closetext1.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Close2.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Closetext2.RemoveFlags( GUI_FLAG_VISIBLE );

		this.ErrorText.Text = "";

		this.Membox.AddItem( "Sports" );
		this.Membox.AddItem( "4 WD and Utility" );
		this.Membox.AddItem( "Four doors" );
		this.Membox.AddItem( "Two doors" );
		this.Membox.AddItem( "Vans" );
		this.Membox.AddItem( "Trucks" );
		this.Membox.AddItem( "Public services" );
		this.Membox.AddItem( "Miscellaneous" );
		this.Membox.AddItem( "Aircrafts" );
		this.Membox.AddItem( "Motorcycles" );
		this.Membox.AddItem( "Boats" );

		this.Titletext.Text = "Purchase Vehicle";
		this.centerinchildX( this.Titlebar, this.Titletext );

		this.Closetext.Text = "Close";
		this.centerinchild( this.Close, this.Closetext );

		this.Selected = null;

		this.Titletext.SendToTop();

		GUI.SetMouseEnabled( true );
	}

	function Hide()
	{
		this.Titlebar.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Titletext.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Body.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Membox.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Close.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Closetext.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Close1.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Closetext1.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Close2.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Closetext2.RemoveFlags( GUI_FLAG_VISIBLE );
		this.ErrorText.RemoveFlags( GUI_FLAG_VISIBLE );

		GUI.SetMouseEnabled( false );
	}
	
	function onListboxSelect( element, listbox )
	{
		if( this.Membox == element )
		{
			switch( listbox )
			{
				case "Sports":
				this.Membox.Clean();

				this.Membox.AddItem( "6414 - Ferrari F50" );
				this.Membox.AddItem( "6410 - Gallardo LP 560-4" );
				this.Membox.AddItem( "6411 - Cabrio" );
				this.Membox.AddItem( "6405 - 911 GT22" );
				this.Membox.AddItem( "6404 - LaFerrari" );
				this.Membox.AddItem( "6402 - Batmobile" );
				this.Membox.AddItem( "159 - Banshee" );
				this.Membox.AddItem( "145 - Cheeta" );
				this.Membox.AddItem( "210 - Comet" );
				this.Membox.AddItem( "211 - Deluxo" );
				this.Membox.AddItem( "141 - Infernus" );
				this.Membox.AddItem( "132 - Stinger" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "4 WD and Utility":
				this.Membox.Clean();

				this.Membox.AddItem( "6400 - Hilux" );
				this.Membox.AddItem( "154 - BF Injection" );
				this.Membox.AddItem( "152 - Bobcat" );
				this.Membox.AddItem( "130 - Landstalker" );
				this.Membox.AddItem( "230 - Mesa Grande" );
				this.Membox.AddItem( "200 - Patriot" );
				this.Membox.AddItem( "219 - Rancher" );
				this.Membox.AddItem( "225 - Sandking" );
				this.Membox.AddItem( "208 - Walton" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;

				case "Four doors":
				this.Membox.Clean();

				this.Membox.AddItem( "6412 - ISIS Patriot" );
				this.Membox.AddItem( "175 - Admiral" );
				this.Membox.AddItem( "196 - Glendale" );
				this.Membox.AddItem( "222 - Greenwood" );
				this.Membox.AddItem( "197 - Oceanic" );
				this.Membox.AddItem( "134 - Perennial" );
				this.Membox.AddItem( "209 - Regina" );
				this.Membox.AddItem( "135 - Sentinel" );
				this.Membox.AddItem( "174 - Sentinel XS" );
				this.Membox.AddItem( "139 - Stretch" );
				this.Membox.AddItem( "151 - Washington" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Two doors":
				this.Membox.Clean();

				this.Membox.AddItem( "226 - Blista Compact" );
				this.Membox.AddItem( "164 - Cuban Hermes" );
				this.Membox.AddItem( "149 - Esperanto" );
				this.Membox.AddItem( "204 - Hermes" );
				this.Membox.AddItem( "131 - Idaho" );
				this.Membox.AddItem( "140 - Manana" );
				this.Membox.AddItem( "207 - Phoenix" );
				this.Membox.AddItem( "205 - Sabre" );
				this.Membox.AddItem( "206 - Sabre Turbo" );
				this.Membox.AddItem( "169 - Stallion" );
				this.Membox.AddItem( "221 - Virgo" );
				this.Membox.AddItem( "142 - Voodoo" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Vans":
				this.Membox.Clean();

				this.Membox.AddItem( "212 - Burrito" );
				this.Membox.AddItem( "179 - Gang Burrito" );
				this.Membox.AddItem( "148 - Moonbeam" );
				this.Membox.AddItem( "153 - Mr Whoopee" );
				this.Membox.AddItem( "143 - Pony" );
				this.Membox.AddItem( "170 - Rumpo" );
				this.Membox.AddItem( "158 - Securicar" );
				this.Membox.AddItem( "189 - Top Fun" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Trucks":
				this.Membox.Clean();

				this.Membox.AddItem( "229 - Benson" );
				this.Membox.AddItem( "228 - Boxville" );
				this.Membox.AddItem( "185 - Flatbed" );
				this.Membox.AddItem( "144 - Mule" );
				this.Membox.AddItem( "133 - Linerunner" );
				this.Membox.AddItem( "173 - Packer" );
				this.Membox.AddItem( "213 - Spand Express" );
				this.Membox.AddItem( "186 - Yankee" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Public services":
				this.Membox.Clean();

				this.Membox.AddItem( "161 - Bus" );
				this.Membox.AddItem( "168 - Cabbie" );
				this.Membox.AddItem( "167 - Coach" );
				this.Membox.AddItem( "216 - Kaufman Cab" );
				this.Membox.AddItem( "150 - Taxi" );
				this.Membox.AddItem( "138 - Trashmaster" );
				this.Membox.AddItem( "188 - Zebra Cab" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Miscellaneous":
				this.Membox.Clean();

				this.Membox.AddItem( "215 - Baggage Handler" );
				this.Membox.AddItem( "234 - Bloodring Banger" );
				this.Membox.AddItem( "187 - Caddy" );
				this.Membox.AddItem( "232 - Hotring Racer" );
				this.Membox.AddItem( "201 - Love Fist" );
				this.Membox.AddItem( "172 - Romero's Hearse" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Aircrafts":
				this.Membox.Clean();

				this.Membox.AddItem( "6409 - Maverick Custom" );
				this.Membox.AddItem( "6408 - Carpet" );
				this.Membox.AddItem( "6407 - Buzzard" );
				this.Membox.AddItem( "6403 - Hydra" );
				this.Membox.AddItem( "6401 - Shamal" );
				this.Membox.AddItem( "155 - Hunter" );
				this.Membox.AddItem( "217 - Maverick" );
				this.Membox.AddItem( "177 - Sea Sparrow" );
				this.Membox.AddItem( "190 - Skimmer" );
				this.Membox.AddItem( "213 - Sparrow" );
				this.Membox.AddItem( "218 - VCN Maverick" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Motorcycles":
				this.Membox.Clean();

				this.Membox.AddItem( "166 - Angel" );
				this.Membox.AddItem( "192 - Faggio" );
				this.Membox.AddItem( "178 - Pizza Boy" );
				this.Membox.AddItem( "198 - Sanchez" );
				this.Membox.AddItem( "193 - Freeway" );
				this.Membox.AddItem( "191 - PCJ 600" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				case "Boats":
				this.Membox.Clean();
				
				this.Membox.AddItem( "202 - Coast Guard" );
				this.Membox.AddItem( "223 - Cuban Jetmax" );
				this.Membox.AddItem( "203 - Dinghy" );
				this.Membox.AddItem( "214 - Marquis" );
				this.Membox.AddItem( "160 - Predator" );
				this.Membox.AddItem( "183 - Reefer" );
				this.Membox.AddItem( "136 - Rio" );
				this.Membox.AddItem( "213 - Speeder" );
				this.Membox.AddItem( "176 - Squalo" );
				this.Membox.AddItem( "184 - Tropic" );

				this.Close1.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );

				this.Close2.AddFlags( GUI_FLAG_VISIBLE );
				this.Closetext2.AddFlags( GUI_FLAG_VISIBLE );

				this.Closetext.Text = "Select vehicle to purchase";
				this.centerinchild( this.Close, this.Closetext );

				this.State = 1;
				break;
				
				default:
				local strip = split( listbox, "-" );
				this.Selected = listbox;

				this.ErrorText.Text = "";

				local data = Stream();
				data.WriteInt( 201 );
				data.WriteString( strip[0] );
				Server.SendData( data );

				GUI.SetMouseEnabled( true );
				break;
			}
		}
		this.ErrorText.Text = "";
	}
	
	function onElementHoverOver( element )
	{
		switch( element )
		{
			case this.Close:
			case this.Closetext:

			this.Close.Colour = Colour( 255, 255, 255, 150 );
			this.Closetext.TextColour = Colour( 66, 70, 71, 255 );
			break;

			case this.Close1:
			case this.Closetext1:

			this.Close1.Colour = Colour( 255, 255, 255, 150 );
			this.Closetext1.TextColour = Colour( 66, 70, 71, 255 );
			break;

			case this.Close2:
			case this.Closetext2:

			this.Close2.Colour = Colour( 255, 255, 255, 150 );
			this.Closetext2.TextColour = Colour( 66, 70, 71, 255 );
			break;
		}
	}

	function onElementHoverOut( element )
	{
		switch( element )
		{
			case this.Close:
			case this.Closetext:

			this.Close.Colour = Colour( 66, 70, 71, 150 );
			this.Closetext.TextColour = Colour( 255, 255, 255, 255 );
			break;

			case this.Close1:
			case this.Closetext1:

			this.Close1.Colour = Colour( 66, 70, 71, 150 );
			this.Closetext1.TextColour = Colour( 255, 255, 255, 255 );
			break;

			case this.Close2:
			case this.Closetext2:

			this.Close2.Colour = Colour( 66, 70, 71, 150 );
			this.Closetext2.TextColour = Colour( 255, 255, 255, 255 );
			break;
		}
	}

	function onElementRelease( element, x, y )
	{
		switch( element )
		{
			case this.Close:
			case this.Closetext:
			if( this.State == 0 ) this.Hide();
			else 
			{
				if( this.Selected )
				{
					local data = Stream();
					local strip = split( this.Selected, "-" );

					data.WriteInt( 200 );
					data.WriteString( strip[0] );
					Server.SendData( data );
				}
				else this.setErrorText( "Select one vehicle from the list!" );
			}
			break;

			case this.Close1:
			case this.Closetext1:
			this.State = 0;
			this.Membox.Clean();

			this.Close1.RemoveFlags( GUI_FLAG_VISIBLE );
			this.Closetext1.RemoveFlags( GUI_FLAG_VISIBLE );

			this.Close2.RemoveFlags( GUI_FLAG_VISIBLE );
			this.Closetext2.RemoveFlags( GUI_FLAG_VISIBLE );

			this.Closetext.Text = "Close";
			this.centerinchild( this.Close, this.Closetext );

			this.Membox.AddItem( "Sports" );
			this.Membox.AddItem( "4 WD and Utility" );
			this.Membox.AddItem( "Four doors" );
			this.Membox.AddItem( "Two doors" );
			this.Membox.AddItem( "Vans" );
			this.Membox.AddItem( "Trucks" );
			this.Membox.AddItem( "Public services" );
			this.Membox.AddItem( "Miscellaneous" );
			this.Membox.AddItem( "Aircrafts" );
			this.Membox.AddItem( "Motorcycles" );
			this.Membox.AddItem( "Boats" );

			this.Titletext.Text = "Purchase Vehicle";
			this.centerinchildX( this.Titlebar, this.Titletext );

			this.ErrorText.Text = "";

			this.Selected = null;
			break;

			case this.Close2:
			case this.Closetext2:
			this.Hide();
			break;

		}
	}
	
	function onServerData( type, str )
	{
		switch( type )
		{
			case 200: 
			this.Show();
			break;
			
			case 201:
			this.setErrorText( str );	
			break;

			case 202:
			this.Closetext.Text = "Buy (" + str + " Vice Coin)";
			this.centerinchildX( this.Close, this.Closetext );
			break;

			case 203:
			this.Hide();
			break;
	
		}
	}

	function setErrorText( text )
	{
		this.ErrorText.Text = text;
		this.centerinchildX( this.Titlebar, this.ErrorText );
	}

	function center( instance, instance2 = null )
	{
		if( !instance2 ) 
		{
			local size = instance.Size;
			local screen = ::GUI.GetScreenSize();
			local x = (screen.X/2)-(size.X/2);
			local y = (screen.Y/2)-(size.Y/2);
			
			instance.Position = ::VectorScreen(x, y);
		}

		else 
		{
			local position = instance2.Position;
			local size = instance2.Size;
			instance.Position.X = (position.X + (position.X + size.X) - instance.Size.X)/2;
			instance.Position.Y = (position.Y + (position.Y + size.Y) - instance.Size.Y)/2;
		}
	}

	function centerX( instance, instance2 = null )
	{
		if( !instance2 ) 
		{
			local size = instance.Size;
			local screen = ::GUI.GetScreenSize();
			local x = (screen.X/2)-(size.X/2);
			
			instance.Position.X = x;
		} 

		else 
		{
			local position = instance2.Position;
			local size = instance2.Size;
			instance.Position.X = (position.X + (position.X + size.X) - instance.Size.X)/2;
		}
	}

	function left( instance, instance2 = null ) 
	{
		if( !instance2 ) instance.Position.X = 0;
		else 
		{
			local position = instance2.Position;
			local size = instance2.Size;
			instance.Position.X = position.X;
		}
	}

	function centerinchild( parents, child )
	{
		local parentElement = parents.Size;
		local childElement = child.Size;
		local x = ( parentElement.X/2 )-( childElement.X/2 );
		local y = ( parentElement.Y/2 )-( childElement.Y/2 );

		child.Pos = ::VectorScreen( x, y );
	}

	function centerinchildX( parents, child )
	{
		local parentElement = parents.Size;
		local childElement = child.Size;
		local x = ( parentElement.X/2 )-( childElement.X/2 );

		child.Pos.X = x;
	}		
}