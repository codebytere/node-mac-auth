{
  "targets": [{
    "target_name": "auth",
    "sources": [ ],
    "conditions": [
      ['OS=="mac"', {
        "sources": [
          "auth.cc",
          "src/mac_auth.mm"
        ],
      }]
    ],
    "include_dirs": [
      "<!(node -e \"require('nan')\")"
    ],
    "xcode_settings": {
      "OTHER_CPLUSPLUSFLAGS": ["-std=c++11", "-stdlib=libc++", "-mmacosx-version-min=10.8"],
      "OTHER_LDFLAGS": ["-framework CoreFoundation -framework LocalAuthentication -framework AppKit"]
    }
  }]
}