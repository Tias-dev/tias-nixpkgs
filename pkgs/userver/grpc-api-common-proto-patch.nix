{
  writeText,
  api-common-protos,
}:
writeText "api-common-protos.patch" ''
  diff --git a/cmake/SetupGoogleProtoApis.cmake b/cmake/SetupGoogleProtoApis.cmake
  index 44da6e6..93b07c7 100644
  --- a/cmake/SetupGoogleProtoApis.cmake
  +++ b/cmake/SetupGoogleProtoApis.cmake
  @@ -5,7 +5,7 @@ set(USERVER_GOOGLE_COMMON_PROTOS_TARGET
   )
   # @ingroup dependencies
   set(USERVER_GOOGLE_COMMON_PROTOS
  -    ""
  +    "${api-common-protos}"
       CACHE PATH "Path to the folder with google common proto files"
   )
''
