/*
	Author: S.L.C
	Coded for Map Editor,
	You are not allowed to release it as a snippet/script as yours.
*/

const filePath = "mapexport/";

xmlData <- "";

function ReadTextFromFile( path )
{
    local f = file(path,"rb"), s = "", n = 0;
    f.seek(0, 'e');
    n = f.tell();
    if (n == 0)
        return s;
    f.seek(0, 'b');
    local b = f.readblob(n+1);
    f.close();
    for (local i = 0; i < n; ++i)
        s += format(@"%c", b.readn('b'));
    return s;
}

function WriteTextToFile( path, text )
{
    local f = file(path,"wb+"), s = "";

    f.seek(0, 'e');

    foreach(c in text)
    {
        f.writen(c, 'b');
    }

    f.close();
}

function exportMapToFile( mapName, data ) {
	local mapFile = mapName;
	local segments = split( data, "\n" );
	data = "";
	foreach( segment in segments )
	{
		data += segment;
		data += "\r\n";
	}
	WriteTextToFile( filePath + mapFile + ".nut", data );
}

function setXMLBase( mapFile, world, owner, ti ) {
	xmlData = "<?xml version=\"1.0\" encoding=\"ASCII\" ?> \n";
	xmlData += "<!-- Generate from ViceLand. World: [" + world + "] Generate by: [" + owner + "] Date: [" + SqInteger.TimestampToDate( ti ) + "]--> \n";
	xmlData += "	<itemlist> \n";
	WriteTextToFile( filePath + "" + mapFile + ".xml", xmlData );
}

function addXMLObjectItem( mapFile, object, model, x, y, z, axisX, axisY, axisZ, axisW )
{
	xmlData += "		<item model=\"" + model + "\" name=\"" + object + "\"> \n";
	xmlData += "			<position x=\"" + x + "\" y=\"" + y + "\" z=\"" + z + "\" /> \n";
	//xmlData += "			<rotation format=\"axisangle\" x=\"" + axisX + "\" y=\"" + axisY + "\" z=\"" + axisZ + "\" angle=\"0\" /> \n";
	xmlData += "			<rotation format=\"quaternion\" x=\"" + axisX + "\" y=\"" + axisY + "\" z=\"" + axisZ + "\" w=\"" + axisW + "\" /> \n";
	xmlData += "		</item> \n";
	
	//if( object >= objCreated ) {
		WriteTextToFile( filePath + "" + mapFile + ".xml", xmlData );
	//}
}

function setXMLEnd( mapFile )
{
	xmlData += "	</itemlist> \n";
	WriteTextToFile( filePath + "" + mapFile + ".xml", xmlData );
	xmlData = "";
}