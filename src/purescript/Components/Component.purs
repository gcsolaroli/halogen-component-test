module Components.Component where

import Control.Applicative (pure)
import Data.Function (($), const)
import Data.Maybe (Maybe(..))
import Data.Unit (Unit, unit)
import Effect.Aff.Class (class MonadAff)
import Halogen as Halogen
import Halogen.HTML as HTML
import Halogen.HTML.Events as Events
import Halogen.HTML.Properties as Properties

-- import Halogen.Query.EventSource (finalize)

{-
- `surface` is the type that will be rendered by the component, usually `HTML`               :: Type -> Type -> Type
- `query` is the query algebra; the requests that can be made of the component               :: Type -> Type
- `input` is the input value that will be received when the parent of this component renders :: Type
- `output` is the type of messages the component can raise                                   :: Type
- `m` is the effect monad used during evaluation                                             :: Type -> Type
-}

type Slot = Halogen.Slot S_Query S_Output

type S_Surface = HTML.HTML
data S_Action = S_NoAction | S_Click
data S_Query a = S_SampleQuery a
data S_Input = S_Input_Label String
data S_Output = S_NoOutput | S_Click_Happened
data S_State = S_State_Label String
type S_Slots = ()

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

initialState :: S_Input -> S_State
initialState (S_Input_Label label) = S_State_Label label

component :: forall m. {- MonadAff m => -} Halogen.Component S_Surface S_Query S_Input S_Output m
component = Halogen.mkComponent {
    initialState,   -- :: Input -> State
    render,         -- :: State -> Surface (ComponentSlot Surface Slots m Action) Action
    eval: Halogen.mkEval $ Halogen.defaultEval {
        handleAction = handleAction,    --  handleAction    :: forall m. MonadAff m => Action → Halogen.HalogenM State Action Slots Output m Unit
        handleQuery  = handleQuery,     --  handleQuery     :: forall m a. Query a -> Halogen.HalogenM State Action Slots Output m (Maybe a)
        receive      = receive,         --  receive         :: Input -> Maybe Action
        initialize   = initialize,      --  initialize      :: Maybe Action
        finalize     = finalize         --  finalize        :: Maybe Action
    }               -- :: HalogenQ Query Action Input ~> HalogenM State Action Slots Output m
}

render :: forall m. S_State -> Halogen.ComponentHTML S_Action S_Slots m
render (S_State_Label label) = HTML.button [Properties.title label, Events.onClick \_ -> Just S_Click] [HTML.text label]

handleAction ∷ forall m. {- MonadAff m => -} S_Action → Halogen.HalogenM S_State S_Action S_Slots S_Output m Unit
handleAction = case _ of
    S_NoAction  -> do
        pure unit
    S_Click     -> do
        Halogen.raise S_Click_Happened

handleQuery :: forall m a. S_Query a -> Halogen.HalogenM S_State S_Action S_Slots S_Output m (Maybe a)
handleQuery = const (pure Nothing)
--handleQuery = case _ of
--  SampleQuery k -> do
--    pure (Just (k))

receive :: S_Input -> Maybe S_Action
receive = const Nothing

initialize :: Maybe S_Action
initialize = Just S_NoAction

finalize :: Maybe S_Action
finalize = Nothing