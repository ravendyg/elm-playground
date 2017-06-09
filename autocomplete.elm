

type Model =
  { keySelected : Maybee Int
  , mouseSelected : Maybee Int
  }


type Msg
  = KeyUp KeyCode
  | MouseEnter Int

update : (KeyCode -> Maybe msg) -> Msg -> Model -> (Model, Maybe msg)


view : Config a -> Int -> Model -> List a -> Html Msg
view config howManyToShow model =
  ul []
    [ li customAttributes customChildren
    ]


type alias Config a =
  { ul : List (Attribute Never)
  , li : Bool -> a -> HtmlDetails Never
  }
