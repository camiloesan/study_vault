//
//  Generated code. Do not modify.
//  source: studyvault.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ChannelRequest extends $pb.GeneratedMessage {
  factory ChannelRequest({
    $core.int? channelId,
  }) {
    final $result = create();
    if (channelId != null) {
      $result.channelId = channelId;
    }
    return $result;
  }
  ChannelRequest._() : super();
  factory ChannelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChannelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChannelRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'studyvault'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'channelId', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChannelRequest clone() => ChannelRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChannelRequest copyWith(void Function(ChannelRequest) updates) => super.copyWith((message) => updates(message as ChannelRequest)) as ChannelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChannelRequest create() => ChannelRequest._();
  ChannelRequest createEmptyInstance() => create();
  static $pb.PbList<ChannelRequest> createRepeated() => $pb.PbList<ChannelRequest>();
  @$core.pragma('dart2js:noInline')
  static ChannelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChannelRequest>(create);
  static ChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get channelId => $_getIZ(0);
  @$pb.TagNumber(1)
  set channelId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => clearField(1);
}

class PostsResponse_PostInfo extends $pb.GeneratedMessage {
  factory PostsResponse_PostInfo({
    $core.int? postId,
    $core.int? channelId,
    $core.String? fileId,
    $core.String? title,
    $core.String? description,
    $core.String? publishDate,
  }) {
    final $result = create();
    if (postId != null) {
      $result.postId = postId;
    }
    if (channelId != null) {
      $result.channelId = channelId;
    }
    if (fileId != null) {
      $result.fileId = fileId;
    }
    if (title != null) {
      $result.title = title;
    }
    if (description != null) {
      $result.description = description;
    }
    if (publishDate != null) {
      $result.publishDate = publishDate;
    }
    return $result;
  }
  PostsResponse_PostInfo._() : super();
  factory PostsResponse_PostInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PostsResponse_PostInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PostsResponse.PostInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'studyvault'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'postId', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'channelId', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'fileId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'publishDate')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PostsResponse_PostInfo clone() => PostsResponse_PostInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PostsResponse_PostInfo copyWith(void Function(PostsResponse_PostInfo) updates) => super.copyWith((message) => updates(message as PostsResponse_PostInfo)) as PostsResponse_PostInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostsResponse_PostInfo create() => PostsResponse_PostInfo._();
  PostsResponse_PostInfo createEmptyInstance() => create();
  static $pb.PbList<PostsResponse_PostInfo> createRepeated() => $pb.PbList<PostsResponse_PostInfo>();
  @$core.pragma('dart2js:noInline')
  static PostsResponse_PostInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PostsResponse_PostInfo>(create);
  static PostsResponse_PostInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get postId => $_getIZ(0);
  @$pb.TagNumber(1)
  set postId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPostId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get channelId => $_getIZ(1);
  @$pb.TagNumber(2)
  set channelId($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChannelId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileId => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFileId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get publishDate => $_getSZ(5);
  @$pb.TagNumber(6)
  set publishDate($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPublishDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearPublishDate() => clearField(6);
}

class PostsResponse extends $pb.GeneratedMessage {
  factory PostsResponse({
    $core.Iterable<PostsResponse_PostInfo>? posts,
  }) {
    final $result = create();
    if (posts != null) {
      $result.posts.addAll(posts);
    }
    return $result;
  }
  PostsResponse._() : super();
  factory PostsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PostsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PostsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'studyvault'), createEmptyInstance: create)
    ..pc<PostsResponse_PostInfo>(7, _omitFieldNames ? '' : 'posts', $pb.PbFieldType.PM, subBuilder: PostsResponse_PostInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PostsResponse clone() => PostsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PostsResponse copyWith(void Function(PostsResponse) updates) => super.copyWith((message) => updates(message as PostsResponse)) as PostsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostsResponse create() => PostsResponse._();
  PostsResponse createEmptyInstance() => create();
  static $pb.PbList<PostsResponse> createRepeated() => $pb.PbList<PostsResponse>();
  @$core.pragma('dart2js:noInline')
  static PostsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PostsResponse>(create);
  static PostsResponse? _defaultInstance;

  @$pb.TagNumber(7)
  $core.List<PostsResponse_PostInfo> get posts => $_getList(0);
}

class FileChunk extends $pb.GeneratedMessage {
  factory FileChunk({
    $core.List<$core.int>? content,
    $core.String? filename,
    $core.int? channelId,
    $core.String? title,
    $core.String? description,
  }) {
    final $result = create();
    if (content != null) {
      $result.content = content;
    }
    if (filename != null) {
      $result.filename = filename;
    }
    if (channelId != null) {
      $result.channelId = channelId;
    }
    if (title != null) {
      $result.title = title;
    }
    if (description != null) {
      $result.description = description;
    }
    return $result;
  }
  FileChunk._() : super();
  factory FileChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileChunk', package: const $pb.PackageName(_omitMessageNames ? '' : 'studyvault'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'filename')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'channelId', $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileChunk clone() => FileChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileChunk copyWith(void Function(FileChunk) updates) => super.copyWith((message) => updates(message as FileChunk)) as FileChunk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileChunk create() => FileChunk._();
  FileChunk createEmptyInstance() => create();
  static $pb.PbList<FileChunk> createRepeated() => $pb.PbList<FileChunk>();
  @$core.pragma('dart2js:noInline')
  static FileChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileChunk>(create);
  static FileChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get content => $_getN(0);
  @$pb.TagNumber(1)
  set content($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get filename => $_getSZ(1);
  @$pb.TagNumber(2)
  set filename($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFilename() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilename() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get channelId => $_getIZ(2);
  @$pb.TagNumber(3)
  set channelId($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => clearField(5);
}

class UploadStatusResponse extends $pb.GeneratedMessage {
  factory UploadStatusResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  UploadStatusResponse._() : super();
  factory UploadStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'studyvault'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadStatusResponse clone() => UploadStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadStatusResponse copyWith(void Function(UploadStatusResponse) updates) => super.copyWith((message) => updates(message as UploadStatusResponse)) as UploadStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadStatusResponse create() => UploadStatusResponse._();
  UploadStatusResponse createEmptyInstance() => create();
  static $pb.PbList<UploadStatusResponse> createRepeated() => $pb.PbList<UploadStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static UploadStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadStatusResponse>(create);
  static UploadStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
