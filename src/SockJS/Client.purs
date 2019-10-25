module SockJS.Client where

import Prelude (Unit, ($))

import Effect
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, runEffectFn1, runEffectFn2)


-- | SockJS connection object
foreign import data Connection :: Type

-- | SockJS message that can be transmitted over a connection
type Url = String

-- TODO! This is incorrect! onmessage receives an event containing e.data which is our String message!
-- | SockJS message that can be transmitted over a connection
type Message = String

foreign import connect_
  :: EffectFn1
       Url
       Connection

-- Event handlers
foreign import onOpen_
  :: EffectFn2
       Connection
       (Effect Unit)
       Unit

foreign import onMessage_
  :: EffectFn2
       Connection
       (EffectFn1 Message Unit)
       Unit

foreign import onClose_
  :: EffectFn2
       Connection
       (Effect Unit)
       Unit

-- Connection methods
foreign import send_
  :: EffectFn2
       Connection
       Message
       Unit

foreign import close_
  :: EffectFn1
       Connection
       Unit

-- Establish a connection with the SockJS server
connect
  :: Url
  -> Effect Connection
connect url =
  runEffectFn1 connect_ url

-- | Attaches an onopen event handler to a Connection
onOpen
  :: Connection
  -> Effect Unit
  -> Effect Unit
onOpen sock callback =
  runEffectFn2 onOpen_ sock callback

-- | Attaches an onmessage event handler to a Connection
onMessage
  :: Connection
  -> (Message -> Effect Unit)
  -> Effect Unit
onMessage sock callback =
  runEffectFn2 onMessage_ sock $ mkEffectFn1 callback

-- | Attaches an onclose event handler to a Connection
onClose
  :: Connection
  -> Effect Unit
  -> Effect Unit
onClose sock callback =
  runEffectFn2 onClose_ sock callback

-- | Send a message over a Connection
send
  :: Connection
  -> Message
  -> Effect Unit
send sock message =
  runEffectFn2 send_ sock message

-- | Close a Connection
close
  :: Connection
  -> Effect Unit
close sock =
  runEffectFn1 close_ sock
