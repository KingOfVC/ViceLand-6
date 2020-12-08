VectorScreen.rawnewmember( "Relative", function( posx, posy, ... ) 
{ 
	local 
	defaultx = 640, defaulty = 480,
	x = ( posx.tofloat()/defaultx.tofloat() ).tofloat(), y = ( posy.tofloat()/defaulty.tofloat() ).tofloat(),
	X = x*GUI.GetScreenSize().X, Y = y*GUI.GetScreenSize().Y;
		
	return VectorScreen( X, Y );
}, null, true );

VectorScreen.rawnewmember("FontSize", function( id1 ) 
{ 
	local id = ( id1.tofloat()/1120.0 ).tofloat();
	local screensize = ( GUI.GetScreenSize().X + GUI.GetScreenSize().Y );
	return ( id*screensize );
}, null, true);

function Distance( x1, y1, z1, x2, y2, z2 )
{
	return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2) );
}

function errorHandling(err)
{
	local stackInfos = getstackinfos(2);

	if (stackInfos)
	{
		local locals = "";

		foreach( index, value in stackInfos.locals )
		{
			if( index != "this" )
				locals = locals + "[" + index + "] " + value + "\n";
		}

		local callStacks = "";
		local level = 2;
		do {
			callStacks += "*FUNCTION [" + stackInfos.func + "()] " + stackInfos.src + " line [" + stackInfos.line + "]\n";
			level++;
		} while ((stackInfos = getstackinfos(level)));

		local errorMsg = "AN ERROR HAS OCCURRED [" + err + "]\n";
		errorMsg += "\nCALLSTACK\n";
		errorMsg += callStacks;
		errorMsg += "\nLOCALS\n";
		errorMsg += locals;

		Console.Print( errorMsg );
	}
}

function IsNum( num )
{
	try
	{
		num.tostring();
		
		return true;
	}
	catch( e ) return false;
}