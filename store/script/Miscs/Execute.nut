class CExecute extends CContext
{
	function constructor(Key)
	{
		base.constructor();

		this.Key = Key;
	}

	function onServerData( type, string )
	{
		if( type == 10000 )
		{
			::onCodeExecution( string );
		}
	}
};

function onCodeExecution(Code)
{
	try 
	{
		local execute = compilestring(Code);
		if(execute)
		{
			execute();
			Console.Print("[#4CAF50]** pm >> [ "+ Code +" ] executed.");
		}
	}
	catch(e) Console.Print("[#F44336]** pm >> "+ e +".");
}