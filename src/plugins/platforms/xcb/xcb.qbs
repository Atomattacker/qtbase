import qbs
import QtGuiPrivateConfig

QtModuleProject {
    name: "QtXcbQpa"
    simpleName: "xcbqpa"
    internal: true
    qbsSearchPaths: [project.qtbaseShadowDir + "/src/gui/qbs"]
    conditionFunction: (function() {
        return Qt.global.privateConfig.gui && QtGuiPrivateConfig.xcb;
    })
    references: [
        "xcb-static"
    ]

    QtPlugin {
        name: "qxcb"
        condition: project.conditionFunction()
        pluginType: "platforms"
        pluginClassName: "QXcbIntegrationPlugin"

        Depends { name: project.moduleName }
        Depends { name: "Qt.core_private" }
        Depends { name: "Qt.gui_private" }
        files: [
            "README",
            "qxcbmain.cpp",
            "xcb.json",
        ]
        /*
            !equals(TARGET, $$QT_DEFAULT_QPA_PLUGIN): PLUGIN_EXTENDS = -
        */
    }
    QtModule {
        name: project.moduleName
        simpleName: project.simpleName
        type: Qt.global.config.staticBuild ? "staticlibrary" : "dynamiclibrary"

        Depends { name: "Qt.core_private" }
        Depends { name: "Qt.gui_private" }
        Depends { name: "Qt.edid_support_private" }
        Depends { name: "Qt.eventdispatcher_support_private" }
        Depends { name: "Qt.fontdatabase_support_private" }
        Depends { name: "Qt.service_support_private" }
        Depends { name: "Qt.theme_support_private" }
        Depends {
            name: "Qt.linuxaccessibility_support_private"
            required: false
        }
        Depends { name: "Qt.platform_headers" }

        Depends { name: "Xcb_xlib"; condition: QtGuiPrivateConfig.xcb_xlib }
        Depends { name: "X11sm"; condition: QtGuiPrivateConfig.xcb_sm }
        Depends { name: "Xcb_syslibs"; condition: QtGuiPrivateConfig.system_xcb }
        Depends { name: "qt_xkbcommon" }
        Depends {
            name: "Xcb_xkb"
            condition: QtGuiPrivateConfig.system_xcb && QtGuiPrivateConfig.xkb
        }
        Depends {
            name: "Xcb_render" // to support custom cursors with depth > 1
            condition: QtGuiPrivateConfig.system_xcb && QtGuiPrivateConfig.xcb_render
        }
        Depends {
            name: "Xcb_xinput"
            condition: QtGuiPrivateConfig.xcb_xlib && QtGuiPrivateConfig.xcb_xinput
        }

        Depends { name: "cpp" }

        cpp.defines: {
            var defines = base.concat("QT_NO_FOREACH", "QT_BUILD_XCB_PLUGIN");
            if (QtGuiPrivateConfig.xcb_xlib)
                defines.push("XCB_USE_XLIB");
            if (QtGuiPrivateConfig.xcb_sm)
                defines.push("XCB_USE_SM");
            if (!QtGuiPrivateConfig.system_xcb || QtGuiPrivateConfig.xcb_render)
                defines.push("XCB_USE_RENDER");
            return defines;
        }
        cpp.dynamicLibraries: QtGuiPrivateConfig.system_xcb ? ["xcb-xinerama"] : []
        cpp.includePaths: base.concat([".", "gl_integrations", "nativepainting"])

        files: [
           "qxcbclipboard.cpp",
           "qxcbconnection.cpp",
           "qxcbintegration.cpp",
           "qxcbkeyboard.cpp",
           "qxcbmime.cpp",
           "qxcbdrag.cpp",
           "qxcbscreen.cpp",
           "qxcbwindow.cpp",
           "qxcbbackingstore.cpp",
           "qxcbwmsupport.cpp",
           "qxcbnativeinterface.cpp",
           "qxcbcursor.cpp",
           "qxcbimage.cpp",
           "qxcbxsettings.cpp",
           "qxcbsystemtraytracker.cpp",
           "qxcbclipboard.h",
           "qxcbconnection.h",
           "qxcbintegration.h",
           "qxcbkeyboard.h",
           "qxcbdrag.h",
           "qxcbmime.h",
           "qxcbobject.h",
           "qxcbscreen.h",
           "qxcbwindow.h",
           "qxcbbackingstore.h",
           "qxcbwmsupport.h",
           "qxcbnativeinterface.h",
           "qxcbcursor.h",
           "qxcbimage.h",
           "qxcbxsettings.h",
           "qxcbsystemtraytracker.h",
        ]

        Group {
            name: "session management"
            condition: QtGuiPrivateConfig.xcb_sm
            files: [
                "qxcbsessionmanager.cpp",
                "qxcbsessionmanager.h",
            ]
        }

        Group {
            name: "GL integrations"
            prefix: "gl_integrations/"
            files: [
                "qxcbglintegration.cpp",
                "qxcbglintegration.h",
                "qxcbglintegrationfactory.cpp",
                "qxcbglintegrationfactory.h",
                "qxcbglintegrationplugin.h",
                "qxcbnativeinterfacehandler.cpp",
                "qxcbnativeinterfacehandler.h",
            ]
        }
        Group {
            condition: QtGuiPrivateConfig.xcb_native_painting
            name: "native painting"
            prefix: "nativepainting/"
            files: [
                "qbackingstore_x11.cpp",
                "qbackingstore_x11_p.h",
                "qcolormap_x11.cpp",
                "qcolormap_x11_p.h",
                "qpaintengine_x11.cpp",
                "qpaintengine_x11_p.h",
                "qpixmap_x11.cpp",
                "qpixmap_x11_p.h",
                "qt_x11_p.h",
                "qtessellator.cpp",
                "qtessellator_p.h",
                "qxcbnativepainting.cpp",
                "qxcbnativepainting.h",
            ]
        }
        Group {
            condition: QtGuiPrivateConfig.xcb_xinput
            files: "qxcbconnection_xi2.cpp"
        }
    }
}
