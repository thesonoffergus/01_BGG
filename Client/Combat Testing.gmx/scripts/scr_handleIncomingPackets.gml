var buffer = argument[0];
var msgId = buffer_read(buffer, buffer_u8);

switch(msgId){
    case 1:
        var time = buffer_read(buffer, buffer_u32);
        latency = current_time - time;
        break;
    
    case 4:
        global.playerId = buffer_read(buffer, buffer_u32);
        break;
        
    case 5:
        var pId = buffer_read(buffer, buffer_u32);
        with (obj_remoteplayer){
            if (remotePlayerId == pId){
                instance_destroy();
            }
        }
        break;
    
}
