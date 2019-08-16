module Components.Main where

import Control.Applicative (pure)
-- import Data.Either (Either(..))
import Data.Function (($), const)
import Data.Maybe (Maybe(..))
import Data.Unit (Unit, unit)
-- import Data.Void (Void)
import Effect.Aff.Class (class MonadAff)
import Halogen as Halogen
-- import Halogen.Data.Slot (SlotStorage)
import Halogen.HTML as HTML

{-
- `surface` is the type that will be rendered by the component, usually `HTML`               :: Type -> Type -> Type
- `query` is the query algebra; the requests that can be made of the component               :: Type -> Type
- `input` is the input value that will be received when the parent of this component renders :: Type
- `output` is the type of messages the component can raise                                   :: Type
- `m` is the effect monad used during evaluation                                             :: Type -> Type
-}

type Surface = HTML.HTML
data Action = NoAction
data Query a = SampleQuery a
--type Message = ()
data Input = EmptyInput
data Output = NoOutput
data State = EmptyState
type Slots = ()

{-
The type variables involved:
- `surface` is the type that will be rendered by the component, usually `HTML`
* `state` is the component's state
- `query` is the query algebra; the requests that can be made of the component
* `action` is the type of actions; messages internal to the component that can be evaluated
* `slots` is the set of slots for addressing child components
- `input` is the input value that will be received when the parent of this component renders
- `output` is the type of messages the component can raise
- `m` is the effect monad used during evaluation


The values in the record:
- `initialState` is a function that accepts an input value and produces the state the component will start with.
  If the input value is unused (`Unit`), or irrelevant to the state construction, this will often be `const ?someInitialStateValue`.
- `render` is a function that accepts the component's current state and produces a value to render (`HTML` usually).
  The rendered output can raise actions that will be handled in `eval`.
- `eval` is a function that handles the `HalogenQ` algebra that deals with component lifecycle, handling actions, and responding to requests.

-}

initialState :: Input -> State
initialState _ = EmptyState

component :: forall m. MonadAff m => Halogen.Component Surface Query Input Output m
component = Halogen.mkComponent {
    initialState,   -- :: input -> state
    render,         -- :: state -> surface (ComponentSlot surface slots m action) action
    eval: Halogen.mkEval $ Halogen.defaultEval {
        handleAction = handleAction,
        handleQuery  = handleQuery
    }
                    -- :: HalogenQ query action input ~> HalogenM state action slots output m
}

render :: forall m. State -> Halogen.ComponentHTML Action () m
render state = HTML.div [] [
            HTML.h1 [] [HTML.text "Hello!"]
        ]

handleAction ∷ forall m. MonadAff m => Action → Halogen.HalogenM State Action Slots Output m Unit
handleAction = const (pure unit)

handleQuery :: forall m a. Query a -> Halogen.HalogenM State Action Slots Output m (Maybe a)
handleQuery = case _ of
  SampleQuery k -> do
    pure (Just (k))
