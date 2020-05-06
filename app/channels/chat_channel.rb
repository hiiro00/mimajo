class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat:message' 
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def put_message(data) #ここが変わった
    logger.debug("data内容:#{data}")
    ChatChannel.broadcast_to('message', data) #ここが変わった
  end
  
  def join_room(data) 
    logger.debug("data内容:#{data}")
    ChatChannel.broadcast_to('message', data) 
  end
end
