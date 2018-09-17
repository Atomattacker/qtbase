import qbs
import qbs.FileInfo
import QtGlobalConfig
import QtGlobalPrivateConfig

Project {
    property stringList qtModuleNames: [
        "corelib",
        "gui",
        "network",
        "printsupport",
        "sql",
        "testlib",
        "widgets",
        "xml",
    ]
    qbsSearchPaths: qtModuleNames.map(function(name) {
        return qtbaseShadowDir + "/src/" + name + "/qbs";
    });
    references: qtModuleNames.concat([
        "3rdparty/3rdparty.qbs",
        // "android/android.qbs",
        "concurrent/concurrent.qbs",
        "dbus/dbus.qbs",
        "opengl",
        "openglextensions",
        "platformheaders/platformheaders.qbs",
        "platformsupport/platformsupport.qbs",
        "plugins/plugins.qbs",
        "tools/tools.qbs",
        "winmain/winmain.qbs",
    ])
    Product {
        name: "Qt.global"

        property path actualProjectSourceDirectory: FileInfo.path(project.qtbaseQbsFilePath)
        Group {
            prefix: actualProjectSourceDirectory + "/qbs/"
            files: [
                "imports/**/*.qbs",
                "imports/**/*.js",
                "imports/*.qbs",
                "imports/*.js",
                "modules/**/*.qbs",
                "modules/**/*.js",
            ]
            qbs.install: true
            qbs.installSourceBase: actualProjectSourceDirectory + "/qbs/"
            qbs.installDir: "lib/qbs"
        }
        Group {
            files: [
                project.qtbaseShadowDir + "/qbs/imports/QtGlobalConfig/QtGlobalConfig.js",
                project.qtbaseShadowDir
                    + "/qbs/imports/QtGlobalPrivateConfig/QtGlobalPrivateConfig.js",
                project.qtbaseShadowDir
                    + "/qbs/imports/QtMultiplexConfig/multiplexconfig.js",
            ]
            qbs.install: true
            qbs.installSourceBase: project.qtbaseShadowDir + "/qbs/imports/"
            qbs.installDir: "lib/qbs/imports"
        }

        property bool consideredBySync: true
        property var config: QtGlobalConfig
        property var privateConfig: QtGlobalPrivateConfig

        Export {
            property var config: QtGlobalConfig
            property var privateConfig: QtGlobalPrivateConfig
        }
    }
}
