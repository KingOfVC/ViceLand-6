class CDeathWindow extends CContext
{
	PosY		=	null;
	TextInfo	=	null;
	TextInfo2	=	null;
	SpriteInfo	=	null;
	space		=	null;
	sX          =   null;
	sY          =   null;
	sY1 		= 	null;
	leftNamePos = 1.16;
	rightNamePos = 1.175;
	centerNamePos = 1.175;

	function constructor( Key )
	{
		base.constructor();

        Establish();
        UpdateCount();
    }

	function Establish()
	{
		this.PosY	=	[0.3,0.35,0.4,0.45,0.5];
		this.TextInfo	=	array(5);
		this.TextInfo2	=	array(5);
		this.SpriteInfo	=	array(5);
		this.space		=		0;
		this.sX = GUI.GetScreenSize().X;
		this.sY = ( GUI.GetScreenSize().Y >= 685 ) ? 685 : GUI.GetScreenSize().Y;
			//	this.sX = ( GUI.GetScreenSize().X >= 1024 ) ? 1024 : GUI.GetScreenSize().X;
		this.sY1 = GUI.GetScreenSize().Y;

	}
	
	function GetFontSize()
	{
		local rel = GUI.GetScreenSize();

	//	local f = 7;
	//	local size = f.tofloat() * (sqrt((this.sX.tofloat() * this.sY.tofloat()) / (640*480).tofloat())).tofloat();

		local size = ( rel.Y * 0.0138888888888889 );
		return size;
	}
	
	function GetTFontSize()
	{
		local f = 14;
		local size = f.tofloat() * (sqrt((this.sX.tofloat() * this.sY.tofloat()) / (640*480).tofloat())).tofloat();
		return size;
	}
	
	function UpdateCount()
	{
		this.SpriteInfo[4] 				=	GUISprite("2_dw.png", Relative1(centerNamePos,0.5));
		this.SpriteInfo[4].Size			=	Relative(40.0/640.0, 40/480.0);
		this.SpriteInfo[4].Alpha		=	0;
		this.TextInfo[4] 				=	GUILabel();
		this.TextInfo[4].Text			=	"Test";
		this.TextInfo[4].FontName 		=   "Tahoma";
		this.TextInfo[4].FontSize		=	GetFontSize();
		this.TextInfo[4].Alpha 			= 	0;
		this.TextInfo[4].FontFlags		=   GUI_FFLAG_BOLD | GUI_FFLAG_OUTLINE;
		this.TextInfo[4].Position		=	Relative1((this.leftNamePos*this.sX.tofloat() - this.TextInfo[4].TextSize.X.tofloat())/this.sX.tofloat(), 0.5);
		this.TextInfo2[4] 				=	GUILabel();
		this.TextInfo2[4].Position		=	Relative1((rightNamePos * this.sX.tofloat() + ((20.0/640.0)*this.sX.tofloat()))/this.sX.tofloat(), 0.5);
		this.TextInfo2[4].Text			=	"LLLLLLLLLLLLLLLLLLLLLLL";
		this.TextInfo2[4].FontName 		=   "Tahoma";
		this.TextInfo2[4].FontSize		=	GetFontSize();
		this.TextInfo2[4].Alpha 		= 	0;
		this.TextInfo2[4].FontFlags		=   GUI_FFLAG_BOLD | GUI_FFLAG_OUTLINE;
		
		this.space						=	(this.sX.tofloat() - (this.TextInfo2[4].Position.X.tofloat() + this.TextInfo2[4].TextSize.X.tofloat())).tofloat() - GetTFontSize();
	}
	
	function DeathWindow(leftName, reason, rightName, r,g,b, r1, g1, b1)
	{
		local rel = GUI.GetScreenSize();

		switch( reason ) 
		{
			case "43":
			reason = "44";
			break;

			case "32":
			reason = "70";
			break;
		}
		
		local image = "" + reason + "_dw.png"; 
		if (this.TextInfo[0]) 
		{
			this.TextInfo[0] 	=	null;
		}
		if(this.SpriteInfo[0])
		{
			this.SpriteInfo[0] 	=	null;
		}
		if (this.TextInfo2[0]) 
		{
			this.TextInfo2[0]	=	null;
		}
		for (local i=0; i<4; i++)
		{
			if (TextInfo[i+1])
			{
				this.TextInfo[i]			=	this.TextInfo[i+1];
				this.TextInfo[i].Position.Y = 	Relative1( 0, this.PosY[i] ).Y;

			}
  
			if(SpriteInfo[i+1])
			{
				this.SpriteInfo[i]			=	this.SpriteInfo[i+1];
				this.SpriteInfo[i].Position.Y = Relative1( 0, this.PosY[i] ).Y;
			}
  
			if(TextInfo2[i+1])
			{	
				this.TextInfo2[i] 			=	this.TextInfo2[i+1];
				this.TextInfo2[i].Position.Y	= Relative1( 0, this.PosY[i] ).Y;
			}
		}

		this.SpriteInfo[4] 				=	GUISprite(image, Relative1(((centerNamePos * this.sX.tofloat()) + space.tofloat())/this.sX.tofloat(), 0.5));
		this.SpriteInfo[4].Size			=	VectorScreen( rel.X * 0.0260416666666667, rel.Y * 0.0462962962962963 );//Relative(20.0/640.0, 20/480.0);
		this.TextInfo[4] 				=	GUILabel();
		this.TextInfo[4].Text			=	leftName;
		this.TextInfo[4].FontSize		=	GetFontSize();
		this.TextInfo[4].FontName 		=   "Tahoma";
		this.TextInfo[4].TextColour 	= 	Colour(r.tointeger(), g.tointeger(), b.tointeger());
		this.TextInfo[4].FontFlags		=   GUI_FFLAG_BOLD | GUI_FFLAG_OUTLINE;
		this.TextInfo[4].Position		=	Relative1((this.leftNamePos*this.sX.tofloat() - this.TextInfo[4].TextSize.X.tofloat() + space.tofloat())/this.sX.tofloat(), 0.5);
		this.TextInfo2[4] 				=	GUILabel();
		this.TextInfo2[4].Position		=	Relative1((rightNamePos * this.sX.tofloat() + ((20.0/640.0)*this.sX.tofloat()) + space.tofloat())/this.sX.tofloat(), 0.5);
		this.TextInfo2[4].Text			=	rightName;
		this.TextInfo2[4].FontName 		=   "Tahoma";
		this.TextInfo2[4].FontSize		=	GetFontSize();
		this.TextInfo2[4].TextColour 	= 	Colour(r1.tointeger(), g1.tointeger(), b1.tointeger());
		this.TextInfo2[4].FontFlags		=   GUI_FFLAG_BOLD | GUI_FFLAG_OUTLINE;
	}

    function Relative(x, y) 
    {
        return VectorScreen(::floor(x * this.sX), ::floor(y * this.sY));
    }

    function Relative1(x, y) 
    {
        return VectorScreen(::floor(x * this.sX), ::floor(y * this.sY1));
    }

	function onServerData( type, str )
    {
        switch( type )
        {
			case 3000:
			local sp = split( str, ";" );
			this.DeathWindow( sp[0], sp[1], sp[2], sp[3],sp[4],sp[5], sp[6], sp[7], sp[8] );
			break;

			case 3010:
			local sp = split( str, ";" );
			this.DeathWindow( "", sp[1], sp[0], 255, 255, 255, sp[2],sp[3],sp[4] );
			break;

			case 3020:
			local sp = split( str, ";" );
			this.DeathWindow( sp[0], sp[1], "", sp[2],sp[3],sp[4], 255, 255, 255 );
			break;
		}
	}

}
