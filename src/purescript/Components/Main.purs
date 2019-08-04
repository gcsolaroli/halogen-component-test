module Components.Main where

{-
- `surface` is the type that will be rendered by the component, usually `HTML`               :: Type -> Type -> Type
- `query` is the query algebra; the requests that can be made of the component               :: Type -> Type
- `input` is the input value that will be received when the parent of this component renders :: Type
- `output` is the type of messages the component can raise                                   :: Type
- `m` is the effect monad used during evaluation                                             :: Type -> Type
-}

type Surface = HTML.HTML
type Query = 
type Input = Void
type Output = Void

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
initialState _ = {
    passwordSettings: {
        strength: Left VeryStrong,
        characters: Left (arrayToSet [UppercaseLetters, LowercaseLetters, Digits])
    },
    password: Nothing
}

component :: forall m. MonadAff m => Halogen.Component Surface Query Input Output m
component = Halogen.mkComponent {
    initialState,   -- :: input -> state
    render,         -- :: state -> surface (ComponentSlot surface slots m action) action
    eval: Halogen.mkEval $ Halogen.defaultEval { handleAction = handleAction }
                    -- :: HalogenQ query action input ~> HalogenM state action slots output m
}