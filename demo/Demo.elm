module Demo
    exposing
        ( Model
        , Msg(..)
        , init
        , main
        , update
        )

import Html exposing (Html)
import Html.Attributes as Attributes
import Selectize


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { selection : Maybe String
    , menu : Selectize.State String
    }


init : ( Model, Cmd Msg )
init =
    ( { selection = Nothing
      , menu = Selectize.empty
      }
    , Cmd.none
    )



{- update -}


type Msg
    = MenuMsg (Selectize.Msg String)
    | SelectLicense (Maybe String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MenuMsg selectizeMsg ->
            let
                ( newMenu, menuCmd, maybeMsg ) =
                    Selectize.update updateConfig model selectizeMsg

                newModel =
                    { model | menu = newMenu }

                cmd =
                    menuCmd |> Cmd.map MenuMsg
            in
            case maybeMsg of
                Just nextMsg ->
                    update nextMsg newModel
                        |> andDo cmd

                Nothing ->
                    ( newModel, cmd )

        SelectLicense newSelection ->
            ( { model | selection = newSelection }, Cmd.none )


andDo : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
andDo cmd ( model, cmds ) =
    ( model
    , Cmd.batch [ cmd, cmds ]
    )


sharedConfig : Selectize.SharedConfig String Model
sharedConfig =
    Selectize.sharedConfig
        { toLabel = toLabel
        , state = .menu
        , entries = \_ -> licenses
        , selection = .selection
        , id = "license-menu"
        }


updateConfig : Selectize.UpdateConfig String Msg Model
updateConfig =
    Selectize.updateConfig sharedConfig
        { select = SelectLicense }


viewConfig : Selectize.ViewConfig String Model
viewConfig =
    Selectize.viewConfig sharedConfig
        { placeholder = "Select a License"
        , container =
            [ Attributes.class "selectize__container" ]
        , input =
            \sthSelected open ->
                [ Attributes.class "selectize__textfield"
                , Attributes.classList
                    [ ( "selectize__textfield--selection", sthSelected )
                    , ( "selectize__textfield--no-selection", not sthSelected )
                    , ( "selectize__textfield--menu-open", open )
                    ]
                ]
        , toggle =
            \open ->
                Html.div
                    [ Attributes.class "selectize__menu-toggle"
                    , Attributes.classList
                        [ ( "selectize__menu-toggle--menu-open", open ) ]
                    ]
                    [ Html.i
                        [ Attributes.class "material-icons"
                        , Attributes.class "selectize__icon"
                        ]
                        [ if open then
                            Html.text "arrow_drop_up"
                          else
                            Html.text "arrow_drop_down"
                        ]
                    ]
        , menu =
            [ Attributes.class "selectize__menu" ]
        , ul =
            [ Attributes.class "selectize__list" ]
        , entry =
            \tree mouseFocused keyboardFocused ->
                { attributes =
                    [ Attributes.class "selectize__item"
                    , Attributes.classList
                        [ ( "selectize__item--mouse-selected"
                          , mouseFocused
                          )
                        , ( "selectize__item--key-selected"
                          , keyboardFocused
                          )
                        ]
                    ]
                , children =
                    [ Html.text tree ]
                }
        , divider =
            \title ->
                { attributes =
                    [ Attributes.class "selectize__divider" ]
                , children =
                    [ Html.text title ]
                }
        }



{- subscriptions -}


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



{- view -}


view : Model -> Html Msg
view model =
    Html.div
        [ Attributes.style
            [ ( "width", "40rem" ) ]
        ]
        [ Selectize.view viewConfig model |> Html.map MenuMsg ]



{- trees -}


toLabel : String -> String
toLabel license =
    license


licenses : List (Selectize.Entry String)
licenses =
    List.concat
        [ [ Selectize.divider "GPL-Compatible Free Software Licenses" ]
        , gplCompatible |> List.map Selectize.entry
        , [ Selectize.divider "GPL-Incompatible Free Software Licenses" ]
        , gplIncompatible |> List.map Selectize.entry
        , [ Selectize.divider "Nonfree Software Licenses" ]
        , nonfree |> List.map Selectize.entry
        ]


gplCompatible : List String
gplCompatible =
    [ "GNU General Public License (GPL) version 3 (#GNUGPL) (#GNUGPLv3)"
    , "GNU General Public License (GPL) version 2 (#GPLv2)"
    , "GNU Lesser General Public License (LGPL) version 3 (#LGPL) (#LGPLv3)"
    , "GNU Lesser General Public License (LGPL) version 2.1 (#LGPLv2.1)"
    , "GNU Affero General Public License (AGPL) version 3 (#AGPL) (#AGPLv3.0)"
    , "GNU All-Permissive License (#GNUAllPermissive)"
    , "Apache License, Version 2.0 (#apache2)"
    , "Artistic License 2.0 (#ArtisticLicense2)"
    , "Clarified Artistic License"
    , "Berkeley Database License (a.k.a. the Sleepycat Software Product License) (#BerkeleyDB)"
    , "Boost Software License (#boost)"
    , "Modified BSD license (#ModifiedBSD)"
    , "CC0 (#CC0)"
    , "CeCILL version 2 (#CeCILL)"
    , "The Clear BSD License (#clearbsd)"
    , "Cryptix General License (#CryptixGeneralLicense)"
    , "eCos license version 2.0 (#eCos2.0)"
    , "Educational Community License 2.0 (#ECL2.0)"
    , "Eiffel Forum License, version 2 (#Eiffel)"
    , "EU DataGrid Software License (#EUDataGrid)"
    , "Expat License (#Expat)"
    , "FreeBSD license (#FreeBSD)"
    , "Freetype Project License (#freetype)"
    , "Historical Permission Notice and Disclaimer (#HPND)"
    , "License of the iMatix Standard Function Library (#iMatix)"
    , "License of imlib2 (#imlib)"
    , "Independent JPEG Group License (#ijg)"
    , "Informal license (#informal)"
    , "Intel Open Source License (#intel)"
    , "ISC License (#ISC)"
    , "Mozilla Public License (MPL) version 2.0 (#MPL-2.0)"
    , "NCSA/University of Illinois Open Source License (#NCSA)"
    , "License of Netscape JavaScript (#NetscapeJavaScript)"
    , "OpenLDAP License, Version 2.7 (#newOpenLDAP)"
    , "License of Perl 5 and below (#PerlLicense)"
    , "Public Domain (#PublicDomain)"
    , "License of Python 2.0.1, 2.1.1, and newer versions (#Python)"
    , "License of Python 1.6a2 and earlier versions (#Python1.6a2)"
    , "License of Ruby (#Ruby)"
    , "SGI Free Software License B, version 2.0 (#SGIFreeB)"
    , "Standard ML of New Jersey Copyright License (#StandardMLofNJ)"
    , "Unicode, Inc. License Agreement for Data Files and Software (#Unicode)"
    , "Universal Permissive License (UPL) (#UPL)"
    , "The Unlicense (#Unlicense)"
    , "License of Vim, Version 6.1 or later (#Vim)"
    , "W3C Software Notice and License (#W3C)"
    , "License of WebM (#WebM)"
    , "WTFPL, Version 2 (#WTFPL)"
    , "WxWidgets License (#Wx)"
    , "X11 License (#X11License)"
    , "XFree86 1.1 License (#XFree861.1License)"
    , "License of ZLib (#ZLib)"
    , "Zope Public License, versions 2.0 and 2.1 (#Zope2.0)"
    ]


gplIncompatible : List String
gplIncompatible =
    [ "Affero General Public License version 1 (#AGPLv1.0)"
    , "Academic Free License, all versions through 3.0 (#AcademicFreeLicense)"
    , "Apache License, Version 1.1 (#apache1.1)"
    , "Apache License, Version 1.0 (#apache1)"
    , "Apple Public Source License (APSL), version 2 (#apsl2)"
    , "BitTorrent Open Source License (#bittorrent)"
    , "Original BSD license (#OriginalBSD)"
    , "Common Development and Distribution License (CDDL), version 1.0 (#CDDL)"
    , "Common Public Attribution License 1.0 (CPAL) (#CPAL)"
    , "Common Public License Version 1.0 (#CommonPublicLicense10)"
    , "Condor Public License (#Condor)"
    , "Eclipse Public License Version 1.0 (#EPL)"
    , "European Union Public License (EUPL) version 1.1 (#EUPL)"
    , "Gnuplot license (#gnuplot)"
    , "IBM Public License, Version 1.0 (#IBMPL)"
    , "Jabber Open Source License, Version 1.0 (#josl)"
    , "LaTeX Project Public License 1.3a (#LPPL-1.3a)"
    , "LaTeX Project Public License 1.2 (#LPPL-1.2)"
    , "Lucent Public License Version 1.02 (Plan 9 license) (#lucent102)"
    , "Microsoft Public License (Ms-PL) (#ms-pl)"
    , "Microsoft Reciprocal License (Ms-RL) (#ms-rl)"
    , "Mozilla Public License (MPL) version 1.1 (#MPL)"
    , "Netizen Open Source License (NOSL), Version 1.0 (#NOSL)"
    , "Netscape Public License (NPL), versions 1.0 and 1.1 (#NPL)"
    , "Nokia Open Source License (#Nokia)"
    , "Old OpenLDAP License, Version 2.3 (#oldOpenLDAP)"
    , "Open Software License, all versions through 3.0 (#OSL)"
    , "OpenSSL license (#OpenSSL)"
    , "Phorum License, Version 2.0 (#Phorum)"
    , "PHP License, Version 3.01 (#PHP-3.01)"
    , "License of Python 1.6b1 through 2.0 and 2.1 (#PythonOld)"
    , "Q Public License (QPL), Version 1.0 (#QPL)"
    , "RealNetworks Public Source License (RPSL), Version 1.0 (#RPSL)"
    , "Sun Industry Standards Source License 1.0 (#SISSL)"
    , "Sun Public License (#SPL)"
    , "License of xinetd (#xinetd)"
    , "Yahoo! Public License 1.1 (#Yahoo)"
    , "Zend License, Version 2.0 (#Zend)"
    , "Zimbra Public License 1.3 (#Zimbra)"
    , "Zope Public License version 1 (#Zope)"
    ]


nonfree : List String
nonfree =
    [ "No license (#NoLicense)"
    , "Aladdin Free Public License (#Aladdin)"
    , "Apple Public Source License (APSL), version 1.x (#apsl1)"
    , "Artistic License 1.0 (#ArtisticLicense)"
    , "AT&T Public License (#ATTPublicLicense)"
    , "eCos Public License, version 1.1 (#eCos11)"
    , "CNRI Digital Object Repository License Agreement (#DOR)"
    , "GPL for Computer Programs of the Public Administration (#GPL-PA)"
    , "Jahia Community Source License (#Jahia)"
    , "The JSON License (#JSON)"
    , "Old license of ksh93 (#ksh93)"
    , "License of Lha (#Lha)"
    , "Microsoft's Shared Source CLI, C#, and Jscript License (#Ms-SS)"
    , "NASA Open Source Agreement (#NASA)"
    , "Oculus Rift SDK License (#OculusRiftSDK)"
    , "Peer-Production License (#PPL)"
    , "License of PINE (#PINE)"
    , "Old Plan 9 license (#Plan9)"
    , "Reciprocal Public License (#RPL)"
    , "Scilab license (#Scilab)"
    , "Scratch 1.4 license (#Scratch)"
    , "Simple Machines License (#SML)"
    , "Sun Community Source License (#SunCommunitySourceLicense)"
    , "Sun Solaris Source Code (Foundation Release) License, Version 1.1 (#SunSolarisSourceCode)"
    , "Sybase Open Watcom Public License version 1.0 (#Watcom)"
    , "SystemC “Open Source” License, Version 3.0 (#SystemC-3.0)"
    , "Truecrypt license 3.0 (#Truecrypt-3.0)"
    , "University of Utah Public License (#UtahPublicLicense)"
    , "YaST License (#YaST)"
    ]
