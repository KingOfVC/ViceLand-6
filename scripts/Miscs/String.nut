function StripCol( text )
{
	try
	{
		if ( !text ) return text;
		local coltrig, output = "";
		foreach( idx, chr in text )
		{
			switch (chr)
			{
				case '[':
				if ( text[idx + 1] == '#' )
				{
					coltrig = true;
					break;
				}

				case ']':
				if ( coltrig )
				{
					coltrig = false;
					break;
				}

				default:
				if ( !coltrig ) output += chr.tochar();
			}
		}
		return output;
	}
	catch(e) return text;
}

function SearchAndReplace( str, search, replace ) 
{
    local li = 0, ci = str.find(search, li), res = "";
    while(ci != null) 
    {
        if(ci > 0) 
        {
            res += str.slice(li, ci);
            res += replace;
        }
        else res += replace;
        li = ci + search.len(), ci = str.find(search, li);
    }
    if (str.len() > 0) res += str.slice(li);
    return res;
}

function EscapeString( string )
{
	local getInvalidChar = [ "~", "%", "'", "\\", "`", "&", "(", ")", "^" ]

	if( !string ) return;

	foreach( index, value in getInvalidChar )
	{
		if( string.find( value ) >= 0 ) string = SearchAndReplace( string, value, " " );
	}

	return string;
}

function EscapeString2( string )
{
	local getInvalidChar = [ "\"" ]

	if( !string ) return;

	foreach( index, value in getInvalidChar )
	{
		if( string.find( value ) >= 0 ) string = SearchAndReplace( string, value, " " );
	}

	return string;
}

function RandString( num ) 
{
	switch ( num ) 
	{
		case 0: return "a";
		case 1: return "b";
		case 2: return "c";
		case 3: return "d";
		case 4: return "e";
		case 5: return "f";
		case 6: return "g";
		case 7: return "h";
		case 8: return "i";
		case 9: return "j";
		case 10: return "k";
		case 11: return "l";
		case 12: return "m";
		case 13: return "n";
		case 14: return "r";
		case 15: return "s";
		case 16: return "p";
		case 17: return "q";
		case 18: return "w";
		case 19: return "y";
		case 20: return "z";
		case 21: return "x";
		case 22: return "A";
		case 23: return "B";
		case 24: return "C";
		case 25: return "D";
		case 26: return "E";
		case 27: return "F";
		case 28: return "G";
		case 29: return "H";
		case 30: return "I";
		case 31: return "J";
		case 32: return "K";
		case 33: return "10";
		case 34: return "L";
		case 35: return "M";
		case 36: return "N";
		case 37: return "O";
		case 38: return "P";
		case 39: return "Q";
		case 40: return "R";
		case 41: return "S";
		case 42: return "T";
		case 43: return "V";
		case 44: return "W";
		case 45: return "X";
		case 46: return "Y";
		case 47: return "Z";
		case 48: return "1";
		case 49: return "2";
		case 50: return "3";
		case 51: return "4";
		case 52: return "5";
		case 53: return "6";
		case 54: return "7";
		case 55: return "8";
		case 56: return "9";
		case 57: return "10";
	}
}

function ReadTextFromFile(path)
{
    local f = file(path,"rb"), s = "";

    while (!f.eos())
    {
        s += format(@"%c", f.readn('b'));
    }

    f.close();

    return s;
}