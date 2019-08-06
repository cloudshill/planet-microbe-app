module Page exposing (Page(..), view, viewErrors, viewTitle, viewTitle1, viewTitle2, viewBlank, viewSpinner, viewDialog)

--import Api exposing (Cred)
--import Avatar
import Browser exposing (Document)
import Html exposing (Html, a, button, h1, h2, h5, div, span, img, i, li, nav, p, text, ul, small, footer)
import Html.Attributes exposing (id, class, classList, src, style, title, type_, attribute, tabindex)
import Html.Events exposing (onClick)
import Icon
--import Profile
import Route exposing (Route)
import Session exposing (Session)
--import Username exposing (Username)
--import Viewer exposing (Viewer)
import Cart
import Config


{-| Determines which navbar link (if any) will be rendered as active.

Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.

-}
type Page
    = Other
    | Home
    | Browse
    | Search
    | Analyze
    | App
    | Job
    | Project
    | Sample
    | Campaign
    | SamplingEvent
    | Experiment
    | Contact
    | Account
    | Cart


{-| Take a page's Html and frames it with a header and footer.

The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.

isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)

-}
--view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
--view maybeViewer page { title, content } =
--    { title = title ++ " - Conduit"
--    , body = viewHeader page maybeViewer :: content --:: [ viewFooter ]
--    }


view : Session -> Page -> Html msg -> Document msg
view session page content =
    { title = "Planet Microbe"
    , body =
        [ viewHeader session page
--        , br [] []
        , content
        , viewFooter
        ]
    }


viewHeader : Session -> Page -> Html msg
viewHeader session page =
    let
        loginButton =
            case session of
                Session.Guest _ _ ->
                    a [ class "nav-link text-nowrap", Route.href Route.Login ]
                        [ Icon.signIn
                        , text " Sign-in to CyVerse"
                        ]

                Session.LoggedIn _ _ _ ->
                    a [ class "nav-link text-nowrap", classList [ ("active", page == Account) ], Route.href Route.Account ]
                        [ Icon.user
                        , text " My Account"
                        ]

        cartButton =
            let
                numItemsInCart =
                    Cart.size (Session.getCart session)

                label =
                    if numItemsInCart == 0 then
                        ""
                    else
                        String.fromInt numItemsInCart
            in
            a [ class "nav-link text-nowrap", classList [ ("active", page == Cart) ], Route.href Route.Cart ]
                [ Icon.shoppingCartLg
                , text " "
                , span [ class "gray absolute" ] [ text label ]
                ]
    in
    div []
        [ (case Config.alertBannerText of
            Nothing ->
                text ""

            Just alertBannerText ->
                div [ class "text-center border-bottom", style "color" "gray", style "background-color" "PowderBlue" ]
                    [ Icon.exclamationTriangle
                    , text " "
                    , text alertBannerText
                    ]
          )
        , div [ style "background-color" "#f8f8f8", style "border-bottom" "1px solid lightgray" ]
            [ nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
                [ a [ class "navbar-brand", style "margin-right" "5em", Route.href Route.Home ]
                    [ img [ src "assets/images/pm-logo.png", style "width" "238px", style "height" "49px" ] [] ]
                , div [ class "navbar-collapse collapse", id "navbarNav" ]
                    [ ul [ class "navbar-nav" ]
                        [ li [ class "nav-item", style "width" "9em" ]
                            [ a [ class "nav-link", classList [ ("active", page == Browse) ], Route.href Route.Browse ]
                                [ Icon.table
                                , text " Browse"
                                ]
                            ]
                        , li [ class "nav-item", style "width" "9em" ]
                            [ a [ class "nav-link", classList [ ("active", page == Search) ], Route.href Route.Search ]
                                [ Icon.search
                                , text " Search"
                                ]
                            ]
                        , li [ class "nav-item", style "width" "9em" ]
                            [ a [ class "nav-link", classList [ ("active", page == Analyze) ], Route.href Route.Analyze  ]
                                [ Icon.barChart
                                , text " Analyze"
                                ]
                            ]
                        ]
                    , ul [ class "navbar-nav ml-auto" ]
                        [ li [ class "nav-item mr-5" ]
                            [ loginButton ]
                        , li [ class "nav-item mr-5" ]
                            [ cartButton]
                        , li [ class "nav-item" ]
                            [ a [ class "nav-link", title "Get Help", Route.href Route.Contact ]
                                [ Icon.questionCircle ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer [ style "min-height" "3em" ] []


--navbarLink : Page -> Route -> List (Html msg) -> Html msg
--navbarLink page route linkContent =
--    li [ classList [ ( "nav-item", True ), ( "active", isActive page route ) ] ]
--        [ a [ class "nav-link", Route.href route ] linkContent ]


--isActive : Page -> Route -> Bool
--isActive page route =
--    case ( page, route ) of
--        ( Home, Route.Home ) ->
--            True
--
--        ( Login, Route.Login ) ->
--            True
--
--        ( Register, Route.Register ) ->
--            True
--
--        ( Settings, Route.Settings ) ->
--            True
--
--        ( Profile pageUsername, Route.Profile routeUsername ) ->
--            pageUsername == routeUsername
--
--        ( NewArticle, Route.NewArticle ) ->
--            True
--
--        _ ->
--            False


{-| Render dismissable errors. We use this all over the place!
-}
viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        div
            [ class "error-messages"
            , style "position" "fixed"
            , style "top" "0"
            , style "background" "rgb(250, 250, 250)"
            , style "padding" "20px"
            , style "border" "1px solid"
            ]
        <|
            List.map (\error -> p [] [ text error ]) errors
                ++ [ button [ onClick dismissErrors ] [ text "Ok" ] ]


viewTitle : String -> String -> Html msg
viewTitle title subTitle =
    h1 [ class "pb-2 mt-5 mb-2 font-weight-bold border-bottom", style "width" "100%" ]
        [ span [ style "color" "dimgray" ] [ text title ]
        , small [ class "ml-3", style "color" "gray" ] [ text subTitle ]
        ]


viewTitle1 : String -> Bool -> Html msg
viewTitle1 title border =
    h1 [ class "pb-2 mt-4 mb-2 font-weight-bold align-middle d-inline", classList [("border-bottom", border)], style "color" "dimgray" ]
        [ text title ]


viewTitle2 : String -> Bool -> Html msg
viewTitle2 title border =
    h2 [ class "pb-2 mt-4 mb-2 font-weight-bold align-middle d-inline", classList [("border-bottom", border)], style "color" "dimgray" ]
        [ text title ]


viewBlank : Html msg
viewBlank =
    text ""


viewSpinner : Html msg
viewSpinner =
    div [ class "ml-loader", style "position" "absolute", style "height" "100vh", style "top" "50%", style "left" "60%" ]
        [ div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        , div [] []
        ]


-- TODO move into module.  This is our own Boostrap modal since elm-dialog has not yet been ported to Elm 0.19
viewDialog : String -> List (Html msg) -> List (Html msg) -> msg -> Html msg
viewDialog title body footer closeMsg =
    div []
        [ div [ class "modal fade show", tabindex -1, style "display" "block", attribute "role" "dialog" ]
            [ div [ class "modal-dialog", attribute "role" "document", style "min-width" "35em" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ h5 [ class "modal-title" ] [ text title ]
                        , button [ type_ "button", class "close", onClick closeMsg ] [ span [] [ text (String.fromChar (Char.fromCode 215)) ] ]
                        ]
                    , div [ class "modal-body" ] body
                    , div [ class "modal-footer" ] footer
                    ]
                ]
            ]
        , div [ class "modal-backdrop fade show" ] []
        ]
