import PackagePlugin
import Foundation

@main
struct CoreDataModelGenerator: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        // Path to the `.xcdatamodeld` file
        let modelPath = target.directory.appending("Model.xcdatamodeld")

        // Output directory inside the plugin's work directory
        let outputPath = context.pluginWorkDirectory.appending("Generated")

        // Ensure the output directory exists
        try FileManager.default.createDirectory(atPath: outputPath.string, withIntermediateDirectories: true)

        // Define the command to generate classes
        return [
            .buildCommand(
                displayName: "Generate Core Data Classes for \(modelPath.lastComponent)",
                executable: URL(fileURLWithPath: "/usr/bin/momc"), // Path to `momc`
                arguments: [
                    modelPath.string,
                    outputPath.string
                ],
                environment: [:]
            )
        ]
    }
}
