let mkPackage = https://github.com/purescript/package-sets/releases/download/psc-0.13.2-20190804/packages.dhall sha256:2230fc547841b54bca815eb0058414aa03ed7b675042f8b3dda644e1952824e5
let upstream  = https://github.com/purescript/package-sets/releases/download/psc-0.13.2-20190804/packages.dhall sha256:2230fc547841b54bca815eb0058414aa03ed7b675042f8b3dda644e1952824e5

let overrides = {
    halogen             = upstream.halogen              // { version = "v5.0.0-rc.4" },
    halogen-vdom        = upstream.halogen-vdom         // { version = "v6.1.0" }
--  svg-parser-halogen  = upstream.svg-parser-halogen   // { version = "halogen-5" }
}

-- let additions = {
-- }
in  upstream // overrides -- // additions
