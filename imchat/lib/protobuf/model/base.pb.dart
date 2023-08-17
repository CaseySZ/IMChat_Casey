//
//  Generated code. Do not modify.
//  source: base.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Protocol extends $pb.GeneratedMessage {
  factory Protocol({
    $core.String? token,
    $core.String? cmd,
    $core.String? params,
    $core.String? response,
    $core.String? connectIp,
    $core.String? connectId,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (cmd != null) {
      $result.cmd = cmd;
    }
    if (params != null) {
      $result.params = params;
    }
    if (response != null) {
      $result.response = response;
    }
    if (connectIp != null) {
      $result.connectIp = connectIp;
    }
    if (connectId != null) {
      $result.connectId = connectId;
    }
    return $result;
  }
  Protocol._() : super();
  factory Protocol.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Protocol.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Protocol', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'cmd')
    ..aOS(3, _omitFieldNames ? '' : 'params')
    ..aOS(4, _omitFieldNames ? '' : 'response')
    ..aOS(5, _omitFieldNames ? '' : 'connectIp', protoName: 'connectIp')
    ..aOS(6, _omitFieldNames ? '' : 'connectId', protoName: 'connectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Protocol clone() => Protocol()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Protocol copyWith(void Function(Protocol) updates) => super.copyWith((message) => updates(message as Protocol)) as Protocol;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Protocol create() => Protocol._();
  Protocol createEmptyInstance() => create();
  static $pb.PbList<Protocol> createRepeated() => $pb.PbList<Protocol>();
  @$core.pragma('dart2js:noInline')
  static Protocol getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Protocol>(create);
  static Protocol? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cmd => $_getSZ(1);
  @$pb.TagNumber(2)
  set cmd($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCmd() => $_has(1);
  @$pb.TagNumber(2)
  void clearCmd() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get params => $_getSZ(2);
  @$pb.TagNumber(3)
  set params($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasParams() => $_has(2);
  @$pb.TagNumber(3)
  void clearParams() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get response => $_getSZ(3);
  @$pb.TagNumber(4)
  set response($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearResponse() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get connectIp => $_getSZ(4);
  @$pb.TagNumber(5)
  set connectIp($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConnectIp() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectIp() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get connectId => $_getSZ(5);
  @$pb.TagNumber(6)
  set connectId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasConnectId() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectId() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
