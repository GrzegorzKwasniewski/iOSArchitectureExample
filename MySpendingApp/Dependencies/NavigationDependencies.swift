import Factory

extension Container {
    
    var appNavigation: Factory<AppNavigation> {
        self { AppNavigation() }
    }
}
