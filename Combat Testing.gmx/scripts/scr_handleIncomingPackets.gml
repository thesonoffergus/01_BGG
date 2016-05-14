var buffer = argument[0];
var socket = argument[1];
var msgId = buffer_read(buffer, buffer_u8);

switch(msgId){

    case 1: //latency request
    
        var time = buffer_read(buffer, buffer_u32);
        buffer_seek(global.buffer, buffer_seek_start, 0);
        buffer_write(global.buffer, buffer_u8, 1);
        buffer_write(global.buffer, buffer_u32, time);
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));    
    
        break;       

    case 6:
        var pId = buffer_read(buffer, buffer_u32);
        var pName = "";
    
        with(obj_player){
            if(playerIdentifier == pId){
                playerInGame = !playerInGame;
                pName = playerName;
            }
        }
        
        //tell other players about this change
        for(var i = 0; i < ds_list_size(global.players); i++){
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            if(storedPlayersocket != socket){ 
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 6);
                buffer_write(global.buffer, buffer_u32, pId);
                buffer_write(global.buffer, buffer_string, pName);
                network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
            }
        }
        
        //tell me about current players
        for(var i = 0; i < ds_list_size(global.players); i++){
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            if(storedPlayersocket != socket){ 
                var player = noone;
                with(obj_player){
                    if(self.playerSocket == storedPlayerSocket){
                        player = id;
                    }
                }
                
                if( player.playerInGame and player != noone ){
                    buffer_seek(global.buffer, buffer_seek_start, 0);
                    buffer_write(global.buffer, buffer_u8, 6);
                    buffer_write(global.buffer, buffer_u32, player.playerIdentifier);
                    buffer_write(global.buffer, buffer_string, player.playerName);
                    network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
                }
            }
        }
        
        break;
}

