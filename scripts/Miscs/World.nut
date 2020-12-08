class SqWorld
{
	function GetPrivateWorld( id )
	{
		if( SqMath.IsGreater( id, 999 ) && SqMath.IsLess( id, 4000 ) ) return true;
		else return false;
	}
				
	function ConvertToJSON( string )
	{
		if( string == "N/A" ) return null;
		if( string.find("null") >= 0 ) return null;

		else return ::json_decode( string );
	}

	function ConvertFromJson( string )
	{
		local result = ::json_encode( string );
		
		if( typeof result == "string" ) return result;

		else return "N/A";
	}
	
	function GetCorrectValue( value )
	{
		if( SqMath.IsLess( value, 1000000 ) ) return true;
		if( SqMath.IsGreaterEqual( value, 0 ) ) return true;
		
		else return false;
	}
}
