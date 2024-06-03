{
  "targets": [{
    "target_name": "auth",
    "sources": [ ],
    "conditions": [
      ['OS=="mac"', {
        "sources": [
          "auth.mm",
        ],
      }]
    ],
    'include_dirs': [
      "<!@(node -p \"require('node-addon-api').include\")"
    ],
    'libraries': [],
    'dependencies': [
      "<!(node -p \"require('node-addon-api').gyp\")"
    ],
    'defines': [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ],
    "xcode_settings": {
      "MACOSX_DEPLOYMENT_TARGET": "10.15",
      "OTHER_CPLUSPLUSFLAGS": ["-std=c++17", "-stdlib=libc++"],
      "OTHER_LDFLAGS": [
        "-framework CoreFoundation",
        "-framework LocalAuthentication",
        "-framework AppKit"
      ]
    }
  }]
}