function json_encode( table )
{
	if(typeof(table) == "table" || typeof(table)  == "array")
	{
		json <- "{";
		json_recurse( table );
		json += "}"; 
		return json;
	}
	else return null;
}
	

function json_recurse( table )
{
	local len = table.len();
	local i = 1;
	local typ = typeof(table);
		
	foreach (key, value in table) 
	{
		switch (typeof(value))
		{
			case "array":
			json += "\"" + key + "\": [";
			json_recurse( value );
			json += "]";	
			break;
					
			case "table":
			json += "\"" + key + "\": {";
			json_recurse( value );
			json += "}";
			break;
					
			case "bool":
			local boolvalue = value ? "true" : "false";
			typ == "array" ? json += boolvalue : json += "\"" + key + "\": " + boolvalue;			
			break;
				
			case "integer":
			typ == "array" ? json += value : json += "\"" + key + "\": " + value; 
			break;
					
			case "float":
			typ == "array" ? json += value : json += "\"" + key + "\": " + value; 
			break;
					
			case "null":	
			typ == "array" ? json += "null" : json += "\"" + key + "\": " + "null";
			break;
					
			case "string":
			typ == "array" ? json += "\"" + this.Esacape(value) + "\"" : json += "\"" + key + "\":\"" + json_escape(value) + "\"";
			break;
				
			default:
			typ == "array" ? json += "false" : json += "\"" + key + "\": " + "false";
			break; 
		}
			
		if(i < len)
		{
			json += ",";
		}
		i++;
	}
}

function json_escape( string )
{
	local breaks = split( string, "\"" );
	local outputstring = "";
			
	foreach (key, value in breaks) 
	{
		if(key > 0)
		{
			outputstring += "\\\"" + value;
		}
		else
		{
			outputstring += value;
		}
	}	

	return outputstring;
}
	
function json_decode( string )
{
	try
	{
		string = strip( string );
		local json = ::compilestring("return " + string);
		return json();
	}
	catch( _ ) _;
}
