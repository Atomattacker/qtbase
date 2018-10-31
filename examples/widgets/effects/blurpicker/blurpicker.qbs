import qbs
import qbs.FileInfo

CppApplication {
    name: "blurpicker"
    condition: Qt.widgets.present

    Depends { name: "Qt.widgets"; required: false }

    files: [
        "blureffect.cpp",
        "blureffect.h",
        "blurpicker.cpp",
        "blurpicker.h",
        "blurpicker.qrc",
        "main.cpp",
    ]

    Group {
        fileTagsFilter: ["application"]
        qbs.install: true
        qbs.installDir: FileInfo.joinPaths(Qt.core.examplesInstallDir, "widgets", "effects",
                                           "blurpicker")
    }
}
