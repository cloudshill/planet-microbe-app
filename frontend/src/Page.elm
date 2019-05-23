module Page exposing (Page(..), view, viewErrors)

--import Api exposing (Cred)
--import Avatar
import Browser exposing (Document)
import Html exposing (Html, a, br, button, div, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (id, class, attribute, href, src, style, title)
import Html.Events exposing (onClick)
--import Profile
--import Route exposing (Route)
import Session exposing (Session)
--import Username exposing (Username)
--import Viewer exposing (Viewer)


{-| Determines which navbar link (if any) will be rendered as active.

Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.

-}
type Page
    = Other
    | Home
--    | Login
--    | Register
--    | Settings
--    | Profile Username
--    | NewArticle


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


--viewHeader : Page -> Maybe Viewer -> Html msg
--viewHeader page maybeViewer =
--    nav [ class "navbar navbar-light" ]
--        [ div [ class "container" ]
--            [ a [ class "navbar-brand", Route.href Route.Home ]
--                [ text "conduit" ]
--            , ul [ class "nav navbar-nav pull-xs-right" ] <|
--                navbarLink page Route.Home [ text "Home" ]
--                    :: viewMenu page maybeViewer
--            ]
--        ]


--viewMenu : Page -> Maybe Viewer -> List (Html msg)
--viewMenu page maybeViewer =
--    let
--        linkTo =
--            navbarLink page
--    in
--    case maybeViewer of
--        Just viewer ->
--            let
--                username =
--                    Viewer.username viewer
--
--                avatar =
--                    Viewer.avatar viewer
--            in
--            [ linkTo Route.NewArticle [ i [ class "ion-compose" ] [], text "\u{00A0}New Post" ]
--            , linkTo Route.Settings [ i [ class "ion-gear-a" ] [], text "\u{00A0}Settings" ]
--            , linkTo
--                (Route.Profile username)
--                [ img [ class "user-pic", Avatar.src avatar ] []
--                , Username.toHtml username
--                ]
--            , linkTo Route.Logout [ text "Sign out" ]
--            ]
--
--        Nothing ->
--            [ linkTo Route.Login [ text "Sign in" ]
--            , linkTo Route.Register [ text "Sign up" ]
--            ]


view : Html msg -> Html msg
view content =
    div []
        [ viewHeader
--        , br [] []
        , content
        ]


viewHeader : Html msg --Page -> Maybe Viewer -> Html msg
viewHeader = --page maybeViewer =
    let
        helpButton =
            a [ title "Contact Us" ]
                [ text "?" ]
    in
    div [ style "background-color" "#f8f8f8", style "border-bottom" "1px solid lightgray" ]
        [ nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
            [ a [ class "navbar-brand", href "/" ]
                [ img [ src "/assets/images/pm-logo.png", style "width" "238px", style "height" "49px" ] [] ]
            , div [ class "navbar-collapse collapse", id "navbarNav" ]
                [ ul [ class "navbar-nav mr-auto" ]
                    [ li [ class "nav-item active" ]
                        [ a [ class "nav-link", href "#" ]
                            [ text "Search"
                            ]
                        ]
                    ]
                , ul [ class "navbar-nav ml-auto" ]
                    [ helpButton
--                    , dashboardButton
--                    , cartButton
                    ]
                ]
            ]
        ]


--viewFooter : Html msg
--viewFooter =
--    footer [] []


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
