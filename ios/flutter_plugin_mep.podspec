#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_plugin_mep.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_plugin_mep'
  s.version          = '10.6.1'
  s.summary          = 'flutter plugin for moxo sdk'
  s.description      = <<-DESC
  flutter plugin for moxo sdk
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Moxo' => 'john.hu@moxo.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/*'
  s.public_header_files = 'Classes/*.h'
  s.swift_version = '5.0'
  s.dependency 'Flutter'
  s.static_framework = true
  s.platform = :ios, '13.0'
  s.libraries = "c++", "xml2.2", "z"

  # MEPSDK version and CDN download
  mepsdk_version = '10.6.1'
  s.prepare_command = <<-CMD
    set -e
    SDK_VERSION="#{mepsdk_version}"
    DOWNLOAD_URL="https://cdn.moxtra.com/mepsdk/dynamic/Dynamic_MEPSDK_iOS_v${SDK_VERSION}.zip"
    FRAMEWORK_DIR="Frameworks"
    ZIP_FILE="${FRAMEWORK_DIR}/MEPSDK.zip"
    XCFRAMEWORK_PATH="${FRAMEWORK_DIR}/MEPSDK.xcframework"
    
    echo "================================================"
    echo "Downloading MEPSDK ${SDK_VERSION} from CDN..."
    echo "URL: ${DOWNLOAD_URL}"
    echo "================================================"
    
    mkdir -p "${FRAMEWORK_DIR}"
    
    # Download with error handling
    HTTP_CODE=$(curl -L -w "%{http_code}" -o "${ZIP_FILE}" "${DOWNLOAD_URL}" 2>/dev/null)
    
    if [ "${HTTP_CODE}" != "200" ]; then
      echo "================================================"
      echo "ERROR: Failed to download MEPSDK!"
      echo "HTTP Status Code: ${HTTP_CODE}"
      echo "URL: ${DOWNLOAD_URL}"
      echo ""
      echo "Possible causes:"
      echo "  - Network connection issue"
      echo "  - SDK version ${SDK_VERSION} does not exist on CDN"
      echo "  - CDN server is temporarily unavailable"
      echo ""
      echo "Please verify the SDK version and try again."
      echo "================================================"
      rm -f "${ZIP_FILE}"
      exit 1
    fi
    
    # Verify downloaded file is not empty
    if [ ! -s "${ZIP_FILE}" ]; then
      echo "================================================"
      echo "ERROR: Downloaded file is empty!"
      echo "URL: ${DOWNLOAD_URL}"
      echo "================================================"
      rm -f "${ZIP_FILE}"
      exit 1
    fi
    
    # Verify it's a valid zip file
    if ! unzip -t "${ZIP_FILE}" > /dev/null 2>&1; then
      echo "================================================"
      echo "ERROR: Downloaded file is not a valid ZIP archive!"
      echo "The server may have returned an error page instead of the SDK."
      echo "URL: ${DOWNLOAD_URL}"
      echo "================================================"
      rm -f "${ZIP_FILE}"
      exit 1
    fi
    
    echo "Download successful. Extracting MEPSDK..."
    unzip -o "${ZIP_FILE}" -d "${FRAMEWORK_DIR}"
    rm -f "${ZIP_FILE}"
    
    # Verify xcframework exists after extraction
    if [ ! -d "${XCFRAMEWORK_PATH}" ]; then
      echo "================================================"
      echo "ERROR: MEPSDK.xcframework not found after extraction!"
      echo "The ZIP file may have an unexpected structure."
      echo "Expected path: ${XCFRAMEWORK_PATH}"
      echo "================================================"
      exit 1
    fi
    
    echo "================================================"
    echo "MEPSDK ${SDK_VERSION} installed successfully!"
    echo "================================================"
  CMD

  s.vendored_frameworks = 'Frameworks/MEPSDK.xcframework'
end
