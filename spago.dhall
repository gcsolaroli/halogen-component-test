{
    name = "my-project",
    sources = [ "src/**/*.purs", "test/**/*.purs" ],
    dependencies = [ 
        "effect",
        "console",
        "halogen",
        "psci-support"
    ],
    packages = ./packages.dhall
}
