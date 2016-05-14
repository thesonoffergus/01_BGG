var buffer = argument[0];
var msgId = buffer_read(buffer, buffer_u8);

switch(msgId){
    case 1:
        var time = buffer_read(buffer, buffer_u32);
        latency = current_time - time;
        break;
    
   // case 4:
   //     global.playerId = buffer_read(buffer, buffer_u32);
    //    break;
        
    case 5:
        var pId = buffer_read(buffer, buffer_u32);
        with (obj_remoteplayer){
            if (remotePlayerId == pId){
                instance_destroy();
            }
        }
        break;
        
    case 6:
        var pId = buffer_read(buffer, buffer_u32);
        var pName = buffer_read(buffer, buffer_string);
        var instance = noone;
        
        with(obj_remoteplayer) { if (remotePlayerId == pId) { instance = id; }}
        
        //only if we're in the gameworld and the local player exists
        if( instance == noone){
            if( instance_exists(obj_localplayer) ) {
                //create a remote player
                var remotePlayer = instance_create(room_width/2, room_height/2, obj_remoteplayer);
                remotePlayer.remotePlayerId = pId;
                remotePlayer.remotePlayerName = pName;
            }
        }
        else{ with(instance){ instance_destroy(); }}
 
        break;
    
}
