module Page.Cart exposing (Model, Msg(..), ExternalMsg(..), init, toSession, update, view)

import Session exposing (Session)
import Cart exposing (Cart)
import Sample exposing (Sample)--, SampleGroup)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Route
import Task exposing (Task)
import Set
import List.Extra
import Icon
--import Debug exposing (toString)



---- MODEL ----


type alias Model =
    { session : Session
    , samples : Maybe (List Sample)
--    , sampleGroups : List SampleGroup
--    , showSaveCartDialog : Bool
--    , showSaveCartBusy : Bool
--    , showShareCartDialog : Bool
--    , cartName : String
--    , selectedCartId : Maybe Int
--    , userId : Maybe Int
    }


init : Session -> ( Model, Cmd Msg ) --Maybe Int -> ( Model, Cmd Msg )
init session = --id =
    let
        id_list =
            Cart.toList (Session.getCart session)

--        loadSampleList =
--            if id_list == [] then
--                Task.succeed []
--            else
--                Request.Sample.getSome session.token id_list |> Http.toTask
--
--        loadSampleGroup id =
--            Request.SampleGroup.get session.token id |> Http.toTask
--
--        loadSamples =
--            case id of
--                Nothing -> -- Current
--                    loadSampleList
--
--                Just id ->
--                    loadSampleGroup id |> Task.map .samples
--
--        loadSampleGroups =
--            Request.SampleGroup.list session.token |> Http.toTask
    in
--    loadSamples
--        |> Task.andThen
--            (\samples ->
--                (loadSampleGroups
--                    |> Task.andThen
--                        (\groups ->
--                            Task.succeed
--                                { pageTitle = "Cart"
--                                , cart = Cart.init session.cart Cart.Editable
--                                , samples = samples
--                                , sampleGroups = groups
--                                , showSaveCartDialog = False
--                                , showSaveCartBusy = False
--                                , showShareCartDialog = False
--                                , cartName = ""
--                                , selectedCartId = id
--                                , userId = Maybe.map .user_id session.user
--                                }
--                        )
--                )
--            )
--            |> Task.mapError Error.handleLoadError
    ( { session = session
      , samples = Nothing
      }
    , Cmd.batch
        [ Sample.fetchSome id_list |> Http.toTask |> Task.attempt GetSamplesCompleted
        ]
    )


toSession : Model -> Session
toSession model =
    model.session



-- UPDATE --


type Msg
    = CartMsg Cart.Msg
    | GetSamplesCompleted (Result Http.Error (List Sample))
--    | RemoveSampleCompleted (Result Http.Error SampleGroup)
--    | OpenSaveCartDialog
--    | CloseSaveCartDialog
--    | OpenShareCartDialog
--    | CloseShareCartDialog
--    | SetCartName String
--    | CopyCart
--    | SaveCart
--    | SaveCartCompleted (Result Http.Error SampleGroup)
    | EmptyCart
--    | RemoveAllSamplesCompleted (Result Http.Error SampleGroup)
--    | RemoveCart
--    | RemoveCartCompleted (Result Http.Error String)
--    | SetSamples (List Sample)
--    | SelectCart Int
--    | SetSession Session


type ExternalMsg
    = NoOp
    | SetCart Cart


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetSamplesCompleted (Ok samples) ->
            ( { model | samples = Just samples }, Cmd.none )

        GetSamplesCompleted (Err error) -> --TODO
--            let
--                _ = Debug.log "GetSamplesCompleted" (toString error)
--            in
            ( model, Cmd.none )

--        CartMsg subMsg ->
--            let
--                _ = Debug.log "Cart.CartMsg" (toString subMsg)
--
--                cartUpdate cartMsg =
--                    let
--                        ( ( newCart, subCmd ), msgFromPage ) =
--                            Cart.update session cartMsg model.cart
--                    in
--                    ( ( { model | cart = newCart }, Cmd.map CartMsg subCmd ), SetCart newCart.cart )
--            in
--            case subMsg of
--                Cart.RemoveFromCart sampleId ->
--                    case model.selectedCartId of
--                        Nothing -> -- Current
--                            cartUpdate subMsg
--
--                        Just id ->
--                            let
--                                removeSample =
--                                    Request.SampleGroup.removeSample session.token id sampleId |> Http.toTask
--                            in
--                            ( ( model, Task.attempt RemoveSampleCompleted removeSample ), NoOp )
--
--                _ ->
--                    cartUpdate subMsg
        CartMsg subMsg ->
            let
                newCart =
                    Cart.update subMsg (Session.getCart model.session)

                newSession =
                    Session.setCart model.session newCart
            in
            ( { model | session = newSession }
            , Cmd.batch
                [ --Cmd.map CartMsg subCmd
                Cart.store newCart
                ]
            )

--        RemoveSampleCompleted (Ok sampleGroup) ->
--            let
--                sampleGroups =
--                    model.sampleGroups |> List.Extra.replaceIf (\g -> g.sample_group_id == sampleGroup.sample_group_id) sampleGroup
--            in
--            { model | sampleGroups = sampleGroups } => Cmd.none => NoOp
--
--        RemoveSampleCompleted (Err error) -> --TODO show error to user
--            let
--                _ = Debug.log "error" (toString error)
--            in
--            model => Cmd.none => NoOp
--
--        OpenSaveCartDialog ->
--            { model | showSaveCartDialog = True, showSaveCartBusy = False } => Cmd.none => NoOp
--
--        CloseSaveCartDialog ->
--            { model | showSaveCartDialog = False } => Cmd.none => NoOp
--
--        OpenShareCartDialog ->
--            { model | showShareCartDialog = True } => Cmd.none => NoOp
--
--        CloseShareCartDialog ->
--            { model | showShareCartDialog = False } => Cmd.none => NoOp
--
--        SetCartName name ->
--            { model | cartName = name } => Cmd.none => NoOp
--
--        CopyCart ->
--            let
--                samples =
--                    model.sampleGroups
--                        |> List.filter (\g -> g.sample_group_id == (model.selectedCartId |> Maybe.withDefault 0))
--                        |> List.map .samples
--                        |> List.concat
--
--                newCart =
--                    samples |> List.map .sample_id |> Set.fromList |> Data.Cart.Cart
--
--                newCartModel =
--                    Cart.init newCart Cart.Editable
--
--                newSession =
--                    { session | cart = newCart }
--            in
--            { model | cart = newCartModel, selectedCartId = Nothing } => Session.store newSession => NoOp --FIXME Need (Route.modifyUrl (Route.Cart Nothing)) but doesn't work due to race condition
--
--        SaveCart ->
--            let
--                sampleIds =
--                    case model.selectedCartId of
--                        Nothing ->
--                            model.cart.cart.contents |> Set.toList
--
--                        Just id ->
--                            model.sampleGroups
--                                |> List.filter (\g -> g.sample_group_id == id)
--                                |> List.map .samples
--                                |> List.concat
--                                |> List.map .sample_id
--                                |> Set.fromList -- remove duplicates
--                                |> Set.toList
--
--                saveCart =
--                    Request.SampleGroup.create session.token model.cartName sampleIds |> Http.toTask
--            in
--            { model | showSaveCartBusy = True } => Task.attempt SaveCartCompleted saveCart => NoOp
--
--        SaveCartCompleted (Ok sampleGroup) ->
--            model => Route.modifyUrl (Route.Cart (Just sampleGroup.sample_group_id)) => NoOp
--
--        SaveCartCompleted (Err error) -> --TODO show error to user
--            let
--                _ = Debug.log "error" (toString error)
--            in
--            { model | showSaveCartDialog = False } => Cmd.none => NoOp

        EmptyCart ->
--            case model.selectedCartId of
--                Nothing ->
                    let
                        newSession =
                            Session.setCart model.session Cart.empty
                    in
                    ( { model | session = newSession, samples = Just [] }
                    , Cart.store Cart.empty
                    ) -- => SetCart newCart

--                Just id ->
--                    let
--                        removeAllSamples =
--                            Request.SampleGroup.removeAllSamples session.token id |> Http.toTask
--                    in
--                    ( model, Task.attempt RemoveAllSamplesCompleted removeAllSamples ) -- => NoOp

--        RemoveAllSamplesCompleted (Ok sampleGroup) ->
--            let
--                sampleGroups =
--                    model.sampleGroups |> List.Extra.replaceIf (\g -> g.sample_group_id == sampleGroup.sample_group_id) sampleGroup
--            in
--            { model | sampleGroups = sampleGroups } => Cmd.none => NoOp
--
--        RemoveAllSamplesCompleted (Err error) -> --TODO show error to user
--            let
--                _ = Debug.log "error" (toString error)
--            in
--            model => Cmd.none => NoOp
--
--        RemoveCart ->
--            case model.selectedCartId of
--                Nothing ->
--                    model => Cmd.none => NoOp
--
--                Just id ->
--                    let
--                        removeCart =
--                            Request.SampleGroup.remove session.token id |> Http.toTask
--                    in
--                    model => Task.attempt RemoveCartCompleted removeCart => NoOp
--
--        RemoveCartCompleted (Ok _) ->
--            model => Route.modifyUrl (Route.Cart Nothing) => NoOp
--
--        RemoveCartCompleted (Err error) -> --TODO show error to user
--            let
--                _ = Debug.log "error" (toString error)
--            in
--            model => Cmd.none => NoOp
--
--        SetSamples newSamples ->
--            ( { model | samples = newSamples }, Cmd.none )
--
--        SelectCart id ->
--            let
--                maybeId =
--                    if id == 0 then
--                        Nothing
--                    else
--                        Just id
--            in
--            model => Route.modifyUrl (Route.Cart maybeId) => NoOp
--
--        SetSession newSession ->
--            let
--                _ = Debug.log "Page.Cart.SetSession" (toString newSession)
--
--                newCart =
--                    Cart.init newSession.cart Cart.Editable
--
--                id_list =
--                    newSession.cart.contents |> Set.toList
--
--                loadSamples =
--                    Request.Sample.getSome session.token id_list |> Http.toTask
--
--                handleSamples samples =
--                    case samples of
--                        Ok samples ->
--                            let
--                                (subModel, cmd) = Cart.update newSession (Cart.SetSession newSession) model.cart
--                            in
--                            SetSamples samples
--
--                        Err _ ->
--                            let
--                                _ = Debug.log "Error" "could not retrieve samples"
--                            in
--                            SetSamples []
--            in
--            { model | cart = newCart } => Task.attempt handleSamples loadSamples => NoOp



-- VIEW --


view : Model -> Html Msg
view model =
    let
--        isCurrent =
--            model.selectedCartId == Nothing

        isLoggedIn =
            False --model.userId /= Nothing

--        (samples, groupName) =
--            if isCurrent || not isLoggedIn then
--                (model.samples, "")
--            else
--                case List.Extra.find (\g -> g.sample_group_id == (model.selectedCartId |> Maybe.withDefault 0)) model.sampleGroups of
--                    Nothing ->
--                        (model.samples, "")
--
--                    Just group ->
--                        (group.samples, group.group_name)

        cart =
--            if isCurrent then
                Session.getCart model.session
--            else
--                Cart.init (Data.Cart.Cart (samples |> List.map .sample_id |> Set.fromList)) Cart.Editable

        count =
            Cart.size cart

        isEmpty =
            count == 0
    in
    case model.samples of
        Nothing ->
            text ""

        Just samples ->
            div [ class "container" ]
                [ div [ class "pb-2 mt-5 mb-2", style "width" "100%" ]
                    [ h1 [ class "font-weight-bold d-inline" ]
                        [ span [ style "color" "dimgray" ] [ text "Cart" ]
                        ]
                    , span [ class "float-right" ]
                        [ viewCartControls isEmpty isLoggedIn --model.selectedCartId model.sampleGroups
--                        , button [ type_ "button", class "btn btn-primary", classList [ ("disabled", isEmpty) ] ]
--                            [ Icon.file
--                            , text " Show Files"
--                            ]
                        ]
                    ]
                , viewCart cart samples
                ]
        --            , Dialog.view
        --                (if model.showSaveCartDialog then
        --                    Just (saveCartDialogConfig model)
        --                else if model.showShareCartDialog then
        --                    Just (shareCartDialogConfig model)
        --                else
        --                    Nothing
        --                )


viewCartControls : Bool -> Bool -> Html Msg -- -> Maybe Int -> List SampleGroup -> Html Msg
viewCartControls isEmpty isLoggedIn = -- selectedCartId sampleGroups =
--    let
--        mkOption (id, label) =
--            li [] [ a [ onClick (SelectCart id) ] [ text label ] ]
--
--        currentOpt =
--            (0, "Current")
--
--        labels =
--            currentOpt :: (sampleGroups |> List.sortBy .group_name |> List.map (\g -> (g.sample_group_id, g.group_name)))
--
--        options =
--            labels |> List.map mkOption
--
--        btnLabel =
--            List.Extra.find (\l -> Tuple.first l == (selectedCartId |> Maybe.withDefault 0)) labels |> Maybe.withDefault currentOpt |> Tuple.second
--
--        dropdown =
--            if not isLoggedIn then
--                span [ class "margin-right", style [ ("font-size", "0.5em"), ("font-weight", "normal"), ("vertical-align", "middle") ] ] [ text "Login to save or share the cart " ]
--            else if sampleGroups == [] then
--                text ""
--            else
--                div [ style [ ("display", "inline-block") ] ]
--                    [ span [ class "info", style [ ("font-size", "0.5em"), ("font-weight", "normal"), ("vertical-align", "middle") ] ] [ text "Showing: " ]
--                    , div [ class "dropdown margin-right", style [ ("display", "inline-block") ] ]
--                        [ button [ class "btn btn-default dropdown-toggle margin-top-bottom", attribute "type" "button", id "dropdownMenu1", attribute "data-toggle" "dropdown", attribute "aria-haspopup" "true", attribute "aria-expanded" "true" ]
--                            [ text btnLabel
--                            , text " "
--                            , span [ class "caret" ] []
--                            ]
--                        , ul [ class "dropdown-menu", attribute "aria-labelledby" "dropdownMenu1" ]
--                            options
--                        ]
--                    ]
--
--        isCurrent =
--            selectedCartId == Nothing
--    in
    div [ class "d-inline-block ml-3" ]
        [ --dropdown
        div [ class "d-inline-block" ]
            [ --if not isCurrent then
--                button [ class "margin-right btn btn-default btn-sm", onClick CopyCart, disabled (isEmpty || not isLoggedIn) ] [ span [ class "glyphicon glyphicon-arrow-right"] [], text " Copy to Current" ]
--              else
                text ""
--            , button [ class "margin-right btn btn-default btn-sm", onClick OpenSaveCartDialog, disabled (isEmpty || not isLoggedIn) ] [ span [ class "glyphicon glyphicon-floppy-disk"] [], text " Save As" ]
--            , button [ class "margin-right btn btn-default btn-sm", onClick OpenShareCartDialog, disabled (isEmpty || not isLoggedIn) ] [ span [ class "glyphicon glyphicon-user"] [], text " Share" ]
--            , button [ class "margin-right btn btn-default btn-sm", attribute "type" "submit" ] [ text "Download" ]
            , button [ class "btn btn-primary mr-3", onClick EmptyCart, disabled isEmpty ]
                [ Icon.ban, text " Empty" ]
--            , button [ class "btn btn-default btn-sm", onClick RemoveCart, disabled (isCurrent || not isLoggedIn) ] [ span [ class "glyphicon glyphicon-trash"] [], text " Delete" ]
            ]
        ]


viewCart : Cart -> List Sample -> Html Msg
viewCart cart samples =
    if Cart.size cart == 0 then
        div [ class "alert alert-secondary" ] [ text "The cart is empty" ]
    else
        Cart.view cart samples Cart.Editable |> Html.map CartMsg


--saveCartDialogConfig : Model -> Dialog.Config Msg
--saveCartDialogConfig model =
--    let
--        content =
--            if model.showSaveCartBusy then
--                spinner
--            else
--                input [ class "form-control", type_ "text", size 20, autofocus True, placeholder "Enter the name of the new cart", onInput SetCartName ] []
--
--        footer =
--            let
--                disable =
--                    disabled model.showSaveCartBusy
--            in
--                div []
--                    [ button [ class "btn btn-default pull-left", onClick CloseSaveCartDialog, disable ] [ text "Cancel" ]
--                    , button [ class "btn btn-primary", onClick SaveCart, disable ] [ text "OK" ]
--                    ]
--    in
--    { closeMessage = Just CloseSaveCartDialog
--    , containerClass = Nothing
--    , header = Just (h3 [] [ text "Save Cart" ])
--    , body = Just content
--    , footer = Just footer
--    }
--
--
--shareCartDialogConfig : Model -> Dialog.Config Msg
--shareCartDialogConfig model =
--    let
--        routeUrl =
--            "https://www.imicrobe.us/" ++ (Route.Cart model.selectedCartId |> Route.routeToString) --FIXME hardcoded base url
--
--        content =
--            if model.selectedCartId == Nothing then
--                text "In order to share the current cart you must first save it by clicking 'Save As'"
--            else
--                div []
--                [ text "Here is a public link to this cart. Copy and paste to share:"
--                , input [ class "form-control", type_ "text", size 20, autofocus True, value routeUrl ] []
--                ]
--
--        footer =
--            button [ class "btn btn-primary", onClick CloseShareCartDialog ] [ text "OK" ]
--    in
--    { closeMessage = Just CloseShareCartDialog
--    , containerClass = Nothing
--    , header = Just (h3 [] [ text "Share Cart" ])
--    , body = Just content
--    , footer = Just footer
--    }
