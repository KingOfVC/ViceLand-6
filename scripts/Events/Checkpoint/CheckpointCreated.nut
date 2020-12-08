SqCore.On().CheckpointCreated.Connect( this, function( checkpoint, header, payload ) 
{
	//checkpoint.Data = CCheckpoint( checkpoint.Tag );
});