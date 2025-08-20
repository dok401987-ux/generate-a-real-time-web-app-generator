import Foundation
import Vapor

class RealTimeWebAppGenerator {
    let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
    func generateApp(template: String, appName: String) throws -> String {
        let templatePath = "templates/\(template)"
        let projectName = "\(appName).swift"
        
        let fileManager = FileManager.default
        let projectDirectory = fileManager.currentDirectoryPath
        
        do {
            try fileManager.createDirectory(atPath: "\(projectDirectory)/\(appName)", withIntermediateDirectories: true)
            try fileManager.copyItem(atPath: templatePath, toPath: "\(projectDirectory)/\(appName)/\(projectName)")
            
            return "App \(appName) generated successfully!"
        } catch {
            throw error
        }
    }
}

func routes(_ app: Application) throws {
    let generator = RealTimeWebAppGenerator(app: app)
    
    app.get("generate", ":template", ":appName") { req -> String in
        let template = req.parameters.get("template", else: "")
        let appName = req.parameters.get("appName", else: "")
        
        do {
            return try generator.generateApp(template: template, appName: appName)
        } catch {
            return "Error generating app: \(error.localizedDescription)"
        }
    }
}

let app = Application()
try routes(app)
try app.run()