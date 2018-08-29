import qbs
import qbs.FileInfo
import QtGlobalConfig

QtProduct {
    type: [Qt.global.config.staticBuild ? "staticlibrary" : "dynamiclibrary"]
    property string pluginType: {
        throw new Error("QtPlugin.pluginType needs to be defined.")
    }
    property string pluginClassName: {
        throw new Error("QtPlugin.pluginClassName needs to be defined.")
    }
    Depends { name: "cpp" }
    Depends { name: "qt_common_libs_plugins" }
    cpp.defines: base.concat("QT_NO_FOREACH", "QT_PLUGIN")
            .concat(Qt.global.config.staticBuild ? ["QT_STATIC_PLUGIN"] : [])
    property string installDir: FileInfo.joinPaths("plugins", pluginType)
    cpp.rpaths: {
        var result = [];
        if (qbs.toolchain.contains("gcc") && Qt.global.config.rpath) {
            var relativeLibPath = FileInfo.relativePath("/" + installDir, "/lib");
            result.push(cpp.rpathOrigin + "/" + relativeLibPath);
        }
        return result;
    }
    Properties {
        condition: qbs.targetOS.contains("darwin")
        bundle.isBundle: false
    }
    aggregate: false
    Group {
        fileTagsFilter: product.type
        qbs.install: true
        qbs.installDir: product.installDir
        qbs.installSourceBase: product.buildDirectory
    }

    Export {
        Parameters { cpp.link: QtGlobalConfig.staticBuild }
    }
}
