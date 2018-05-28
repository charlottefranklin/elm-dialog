module Dialog exposing (Config, view, map, mapMaybe)

{-| Elm Modal Dialogs.

@docs Config, view, map, mapMaybe

-}

import ElmDialog.Exts.Maybe exposing (maybe, isJust)
import Html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Maybe exposing (andThen)
import Common.View.HtmlExt exposing (..)

view : Maybe (Config msg) -> Html msg
view maybeConfig =
    let
        displayed =
            isJust maybeConfig
    in
        div
            ([ classList
                [ ( "modal", True )
                , ( "in", displayed )
                ]
             , style
                [ ( "display"
                  , if displayed then
                        "block"
                    else
                        "none"
                  )
                ]
             ]
            )
            [ div [ class "modal-dialog" ]
                [ div [ class "modal-content" ]
                    (case maybeConfig of
                        Nothing ->
                            [ empty ]

                        Just config ->
                            [ wrapHeader config.closeMessage config.header
                            , maybe empty wrapBody config.body
                            , maybe empty wrapFooter config.footer
                            ]
                    )
                ]
            , backdrop maybeConfig
            ]



wrapHeader : Maybe msg -> Maybe (Html msg) -> Html msg
wrapHeader closeMessage header =
    if closeMessage == Nothing && header == Nothing then
        empty
    else
        div []
            [ maybe empty closeButton closeMessage
            , Maybe.withDefault empty header
            ]


closeButton : msg -> Html msg
closeButton closeMessage =
    button [ class "secondary", onClick closeMessage ]
        [ text "Close" ]


wrapBody : Html msg -> Html msg
wrapBody body =
    div []
        [ body ]


wrapFooter : Html msg -> Html msg
wrapFooter footer =
    div []
        [ footer ]


backdrop : Maybe (Config msg) -> Html msg
backdrop config =
    div [ classList [ ( "modal-backdrop in", isJust config ) ] ]
        []


type alias Config msg =
    { closeMessage : Maybe msg
    , header : Maybe (Html msg)
    , body : Maybe (Html msg)
    , footer : Maybe (Html msg)
    }


map : (a -> b) -> Config a -> Config b
map f config =
    { closeMessage = Maybe.map f config.closeMessage
    , header = Maybe.map (Html.map f) config.header
    , body = Maybe.map (Html.map f) config.body
    , footer = Maybe.map (Html.map f) config.footer
    }


mapMaybe : (a -> b) -> Maybe (Config a) -> Maybe (Config b)
mapMaybe =
    Maybe.map << map
