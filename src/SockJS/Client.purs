module SockJS.Client where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Uncurried (EffFn1, EffFn2, mkEffFn1, runEffFn1, runEffFn2)


-- | SockJS connection object
foreign import data Connection :: Type

-- | SockJS message that can be transmitted over a connection
type Url = String

-- TODO! This is incorrect! onmessage receives an event containing e.data which is our String message!
-- | SockJS message that can be transmitted over a connection
type Message = String

foreign import connect_
  :: forall e
   . EffFn1 e
       Url
       Connection

-- Event handlers
foreign import onOpen_
  :: forall e
   . EffFn2 e
       Connection
       (Eff e Unit)
       Unit

foreign import onMessage_
  :: forall e
   . EffFn2 e
       Connection
       (EffFn1 e Message Unit)
       Unit

foreign import onClose_
  :: forall e
   . EffFn2 e
       Connection
       (Eff e Unit)
       Unit

-- Connection methods
foreign import send_
  :: forall e
   . EffFn2 e
       Connection
       Message
       Unit

foreign import close_
  :: forall e
   . EffFn1 e
       Connection
       Unit

-- Establish a connection with the SockJS server
connect
  :: forall e
   . Url
  -> Eff e Connection
connect url =
  runEffFn1 connect_ url

-- | Attaches an onopen event handler to a Connection
onOpen
  :: forall e
   . Connection
  -> Eff e Unit
  -> Eff e Unit
onOpen sock callback =
  runEffFn2 onOpen_ sock callback

-- | Attaches an onmessage event handler to a Connection
onMessage
  :: forall e
   . Connection
  -> (Message -> Eff e Unit)
  -> Eff e Unit
onMessage sock callback =
  runEffFn2 onMessage_ sock $ mkEffFn1 callback

-- | Attaches an onclose event handler to a Connection
onClose
  :: forall e
   . Connection
  -> Eff e Unit
  -> Eff e Unit
onClose sock callback =
  runEffFn2 onClose_ sock callback

-- | Send a message over a Connection
send
  :: forall e
   . Connection
  -> Message
  -> Eff e Unit
send sock message =
  runEffFn2 send_ sock message

-- | Close a Connection
close
  :: forall e
   . Connection
  -> Eff e Unit
close sock =
  runEffFn1 close_ sock
