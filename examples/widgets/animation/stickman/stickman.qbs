import qbs
import qbs.FileInfo

CppApplication {
    name: "stickman"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "animation.cpp",
        "animation.h",
        "graphicsview.cpp",
        "graphicsview.h",
        "lifecycle.cpp",
        "lifecycle.h",
        "main.cpp",
        "node.cpp",
        "node.h",
        "rectbutton.cpp",
        "rectbutton.h",
        "stickman.cpp",
        "stickman.h",
        "stickman.qrc",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "animation",
                                           "stickman")
    }
}
