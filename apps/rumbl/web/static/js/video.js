let Video = {

    init(socket, element){ socket.connect()
                           let vidChannel   = socket.channel("matches:lobby") 

                           vidChannel.join()
                           .receive("ok", resp => console.log("joined the video channel", resp) )
                           .receive("error", reason => console.log("join failed", reason) ) 
    }
}

export default Video
