module Main where

import Control.Bind (bind)
import Components.Main as MainComponent
import Control.Applicative (pure)
import Data.Unit (Unit, unit)
import Effect (Effect)
import Halogen.Aff (runHalogenAff, awaitBody)
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runHalogenAff do
    body <- awaitBody
    mainComponent <- runUI MainComponent.component unit body
    pure ""

