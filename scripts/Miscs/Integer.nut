SqInteger <-
{
	function TimestampToDate( int )
	{
		return date( int ).day + "/" + ( date( int ).month+1 ) + "/" + date( int ).year + " " + date( int ).hour + ":" + date( int ).min;
	}
	
	function SecondToTime( secs )
	{
		try 
		{
			local ret	= "";
			local hr	= 0;
			local mn	= 0;
			local dy	= 0;
			
			mn = secs / 60;
			secs = secs - mn*60;
			hr = mn / 60;
			mn = mn - hr*60;
			dy = hr / 24;
			hr = hr - dy*24	
			
			if ( dy > 0 ) ret = dy + " Days ";
			if ( hr > 0 ) ret = ret + hr + " Hours ";
			if ( mn > 0 ) ret = ret + mn + " Minutes ";
			ret = ret + secs + " Seconds";
			
			return ret;
		}
		catch( e ) return "Unknown";
	}

	function ToThousands( num )
	{
		try
		{
			local num1 = num.tointeger();
			
			num = num1.tostring() + ".";

			local last			= num.find(".") - 1;
			local chk			= last % 3;
			local decimaltrig	= false;
			local output		= "";

			foreach ( idx, digit in num )
			{
				if( digit == 46 ) continue;
				output += digit.tochar();
				if ( digit == 44 ) decimaltrig = true;
				if ( !decimaltrig && idx < last && idx % 3 == chk ) output += ",";
			}
			return output;
		}
		catch( _ ) _;
		
		return num;
	}
	
	function IsFloat( num )
	{
		try
		{
			if( typeof num.tofloat() == "float" ) return true;
		}
		catch( e ) return false;
	}
	
	function IsNum( num )
	{
		try
		{
			num = num.tointeger();
			if( typeof num == "integer" ) return true;
		}
		catch( e ) return false;
	}
	
	function ValidHealOrArmRange( value )
	{
		if( SqMath.IsLess( value, 101 ) && SqMath.IsGreaterEqual( value, -1 ) ) return true;
		
		else return false;
	}
	
	function ValidSecond( value )
	{
		if( SqMath.IsLess( value, 10000 ) && SqMath.IsGreaterEqual( value, 1 ) ) return true;
		
		else return false;
	}

	function ValidMinute( value )
	{
		if( SqMath.IsLess( value, 60 ) && SqMath.IsGreaterEqual( value, 0 ) ) return true;
		
		else return false;
	}

	function ValidHour( value )
	{
		if( SqMath.IsLess( value, 24 ) && SqMath.IsGreaterEqual( value, 0 ) ) return true;
		
		else return false;
	}

	function ValidAnnType( value )
	{
		if( SqMath.IsLess( value, 9 ) && SqMath.IsGreaterEqual( value, 0 ) ) return true;
		
		else return false;
	}

	function ValidAdminLevel( value )
	{
		if( SqMath.IsLess( value, 6 ) && SqMath.IsGreaterEqual( value, -1 ) ) return true;
		
		else return false;
	}

	function ValidMapperLevel( value )
	{
		if( SqMath.IsLess( value, 2 ) && SqMath.IsGreaterEqual( value, -1 ) ) return true;
		
		else return false;
	}

	function ValidSkin( value )
	{
		if( SqMath.IsLess( value, 230 ) && SqMath.IsGreaterEqual( value, -1 ) ) return true;
		
		else return false;
	}

	function GetWorldCorrectValue( value )
	{
		if( SqMath.IsLess( value, 1000 ) && SqMath.IsGreaterEqual( value, -1 ) ) return true;
		
		else return false;
	}

	function GetObjectMaxID( value )
	{
		if( SqMath.IsLess( value, 3000 ) && SqMath.IsGreaterEqual( value, -1 ) ) return true;
		
		else return false;
	}

	function GetPickupMaxID( value )
	{
		if( SqMath.IsLess( value, 2000 ) && SqMath.IsGreaterEqual( value, -1 ) ) return true;
		
		else return false;
	}
	

}