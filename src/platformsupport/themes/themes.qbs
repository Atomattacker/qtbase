import qbs

QtModuleProject {
    name: "QtThemeSupport"
    simpleName: "theme_support"
    internal: true

    QtHeaders {
    }

    QtModule {
        Export {
            Depends { name: "cpp" }
            Depends { name: "Qt.core" }
            cpp.includePaths: project.includePaths
        }

        Depends { name: project.headersName }
        Depends { name: "Qt.core_private" }
        Depends { name: "Qt.gui_private" }
        Depends {
            name: "Qt.dbus"
            condition: qbs.targetOS.contains("unix")
                && !hasUiKit
                && Qt.global.privateConfig.dbus
        }

        cpp.includePaths: project.includePaths.concat(base)
        cpp.defines: base.concat("QT_NO_CAST_FROM_ASCII")

        files: [
            "qabstractfileiconengine.cpp",
            "qabstractfileiconengine_p.h",
        ]

        Group {
            condition: (qbs.targetOS.contains("unix") && !hasUiKit)
                || Qt.gui_private.config.xcb
            prefix: "genericunix/"
            files: [
                "qgenericunixthemes_p.h",
                "qgenericunixthemes.cpp",
            ]
            Group {
                condition: Qt.global.privateConfig.dbus
                name: "dbus"
                prefix: "genericunix/dbusmenu/"
                files: [
                    "qdbusmenuadaptor.cpp",
                    "qdbusmenuadaptor_p.h",
                    "qdbusmenubar.cpp",
                    "qdbusmenubar_p.h",
                    "qdbusmenuconnection.cpp",
                    "qdbusmenuconnection_p.h",
                    "qdbusmenuregistrarproxy.cpp",
                    "qdbusmenuregistrarproxy_p.h",
                    "qdbusmenutypes.cpp",
                    "qdbusmenutypes_p.h",
                    "qdbusplatformmenu.cpp",
                    "qdbusplatformmenu_p.h",
                ]
                Group {
                    condition: Qt.global.privateConfig.systemtrayicon
                    name: "dbus system tray icon"
                    prefix: "genericunix/dbustray/"
                    files: [
                        "qdbustrayicon.cpp",
                        "qdbustrayicon_p.h",
                        "qdbustraytypes.cpp",
                        "qdbustraytypes_p.h",
                        "qstatusnotifieritemadaptor.cpp",
                        "qstatusnotifieritemadaptor_p.h",
                        "qxdgnotificationproxy.cpp",
                        "qxdgnotificationproxy_p.h",
                    ]
                }
            }
        }
    }
}
