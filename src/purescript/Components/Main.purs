module Components.Main where

import Components.Component as SubComponent

import Control.Applicative (pure)
import Control.Semigroupoid ((<<<))
import Data.Eq (class Eq)
import Data.Function (($), const)
import Data.Maybe (Maybe(..))
import Data.Ord (class Ord)
import Data.Semiring ((+))
import Data.Show (show)
import Data.Symbol (SProxy(..))
import Data.Unit (Unit, unit)
import Effect.Aff.Class (class MonadAff)
import Halogen as Halogen
import Halogen.HTML as HTML

-- import Halogen.Query.EventSource (finalize)

{-
- `surface` is the type that will be rendered by the component, usually `HTML`               :: Type -> Type -> Type
- `query` is the query algebra; the requests that can be made of the component               :: Type -> Type
- `input` is the input value that will be received when the parent of this component renders :: Type
- `output` is the type of messages the component can raise                                   :: Type
- `m` is the effect monad used during evaluation                                             :: Type -> Type
-}

type Surface    = HTML.HTML
data Action     = NoAction | SubComponentOutput SubComponent.S_Output
data Query a    = SampleQuery a
data Input      = EmptyInput
data Output     = NoOutput      -- aka Message
data State      = State Int

newtype SlotIdentifier = SlotIdentifier Int
derive instance eqSlotIdentifier  :: Eq  SlotIdentifier
derive instance ordSlotIdentifier :: Ord SlotIdentifier

type Slots = (
    component :: SubComponent.Slot SlotIdentifier
)

_component :: SProxy "component"
_component = SProxy

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
initialState _ = State 0

component :: forall m. MonadAff m => Halogen.Component Surface Query Input Output m
component = Halogen.mkComponent {
    initialState,   -- :: Input -> State
    render,         -- :: State -> Surface (ComponentSlot Surface Slots m Action) Action
    eval: Halogen.mkEval $ Halogen.defaultEval {
        handleAction = handleAction,    --  handleAction    :: forall m. MonadAff m => Action → Halogen.HalogenM State Action Slots Output m Unit
        handleQuery  = handleQuery,     --  handleQuery     :: forall m a. Query a -> Halogen.HalogenM State Action Slots Output m (Maybe a)
        receive      = receive,         --  receive         :: Input -> Maybe Action
        initialize   = initialize,      --  initialize      :: Maybe Action
        finalize     = finalize         --  finalize        :: Maybe Action
    }
                    -- :: HalogenQ Query Action Input ~> HalogenM State Action Slots Output m
}

render :: forall m. {-MonadAff m =>-} State -> Halogen.ComponentHTML Action Slots m
render (State counter) = HTML.div [] [
    HTML.h1  [] [HTML.text "Hello!"],
    HTML.div [] [HTML.slot _component (SlotIdentifier 1) SubComponent.component (SubComponent.S_Input_Label "Label parameter") (Just <<< SubComponentOutput)],
    HTML.div [] [HTML.text (show counter)]
]

handleAction ∷ forall m. MonadAff m => Action → Halogen.HalogenM State Action Slots Output m Unit
handleAction = case _ of
    NoAction ->
        pure unit
    SubComponentOutput (SubComponent.S_NoOutput) ->
        pure unit
    SubComponentOutput (SubComponent.S_Click_Happened) ->
        Halogen.modify_ (\(State counter) -> State (counter + 1))

handleQuery :: forall m a. Query a -> Halogen.HalogenM State Action Slots Output m (Maybe a)
handleQuery = const (pure Nothing)
--handleQuery = case _ of
--  SampleQuery k -> do
--    pure (Just (k))

receive :: Input -> Maybe Action
receive = const Nothing

initialize :: Maybe Action
initialize = Just NoAction

finalize :: Maybe Action
finalize = Nothing