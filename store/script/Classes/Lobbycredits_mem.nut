class CLobbyCds extends CContext
{
	Background = null;

	Title = null;

	List = null;

	function constructor( Key )
	{
		base.constructor();

		this.List = [];

		this.Load();
	}

	function Load()
	{
		this.Background = GUICanvas();
		this.Background.Size = VectorScreen( 560, 220 );
		this.Background.Colour = Colour( 47, 49, 54, 0 );
		this.Background.AddFlags( GUI_FLAG_3D_ENTITY );
		this.Background.Pos3D = Vector( 398.458, -905.82, 299 );
		this.Background.Size3D = Vector( 3.5, 4, 0 );
		this.Background.Rotation3D = Vector( 11, 0, 6.15 );

		this.Title = GUILabel();
		this.Title.TextColour = Colour( 255,0,0 );
		this.Title.FontName = "Tahoma";
		this.Title.FontFlags = GUI_FFLAG_BOLD;
		this.Title.Text = "Credits";
		this.Title.TextAlignment = GUI_ALIGN_LEFT;
		this.Title.FontSize = 15;
		this.Title.Pos = VectorScreen( 0, 10 );
		this.Background.AddChild( this.Title );
		this.centerinchildX( this.Background, this.Title );

		this.AddTitle( "Map" );
		this.AddName( "Myriad Island Team" );

		this.AddTitle( "" );

		this.AddTitle( "Script" );
		this.AddName( "KingOfVC" );
	
		this.AddTitle( "" );

		this.AddTitle( "Plugins" );
		this.AddName( "SLC (SqMod), [VU]Luckshya (Discord)" );

		this.AddTitle( "" );

		this.AddTitle( "Host" );
		this.AddName( "[Ka]SuriAttacker" );

		this.AddTitle( "" );

		this.AddTitle( "Special Thanks to" );
		this.AddName( "[SS]Yandel_PL, iNS.Ronnie, [DU]DeViL_Jin" );
	}

	function AddTitle( text )
	{
		local element = GUILabel();

		this.Background.AddChild( element );
		element.TextColour = Colour( 255,0,0 );
		element.FontSize = 11;
		element.FontName = "Tahoma";
		element.FontFlags = GUI_FFLAG_BOLD;
		element.Text = text;
		element.TextAlignment = GUI_ALIGN_LEFT;
		element.Pos = VectorScreen( 40, ( 40 + ( 20 * this.List.len() ) ) );

		this.centerinchildX( this.Background, element );

		this.List.append(
		{
			Element = element,
		});
	}

	function AddName( text )
	{
		local element = GUILabel();

		this.Background.AddChild( element );
		element.TextColour = Colour( 255,255,0 );
		element.FontSize = 11;
		element.FontName = "Tahoma";
		element.FontFlags = GUI_FFLAG_BOLD;
		element.Text = text;
		element.TextAlignment = GUI_ALIGN_LEFT;
		element.Pos = VectorScreen( 40, ( 40 + ( 20 * this.List.len() ) ) );

		this.centerinchildX( this.Background, element );

		this.List.append(
		{
			Element = element,
		});
	}

	function StripLine( str )
	{
		local strip = split( str, ":" );

		foreach( value in strip )
		{
			local strip2 = split( value, "~" );

			AddList( strip2[0], strip2[1] );
		}
	}

	function onServerData( type, str )
	{
		switch( type )
		{
			case 402:
			this.StripLine( str );
			break;
		}
	}







	function centerinchildX( parents, child )
	{
		local parentElement = parents.Size;
		local childElement = child.Size;
		local x = ( parentElement.X/2 )-( childElement.X/2 );

		child.Pos.X = x;
	}
}