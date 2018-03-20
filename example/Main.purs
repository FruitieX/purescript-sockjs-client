module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log)
import SockJS.Client as SockJS

main
  :: forall e
   . Eff _ Unit
main = do
  sock <- SockJS.connect "http://localhost:8080/sockjs"

  SockJS.onOpen sock $ do
    log "Connected!"

    SockJS.send sock "Hello, world!"
    SockJS.send sock "Hello again, world!"

  SockJS.onMessage sock $ \message -> log $ message
  SockJS.onClose sock $ log "Disconnected!"
