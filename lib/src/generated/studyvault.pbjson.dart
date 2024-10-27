//
//  Generated code. Do not modify.
//  source: studyvault.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use channelRequestDescriptor instead')
const ChannelRequest$json = {
  '1': 'ChannelRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 13, '10': 'channelId'},
  ],
};

/// Descriptor for `ChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelRequestDescriptor = $convert.base64Decode(
    'Cg5DaGFubmVsUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgNUgljaGFubmVsSWQ=');

@$core.Deprecated('Use postsResponseDescriptor instead')
const PostsResponse$json = {
  '1': 'PostsResponse',
  '2': [
    {'1': 'posts', '3': 7, '4': 3, '5': 11, '6': '.studyvault.PostsResponse.PostInfo', '10': 'posts'},
  ],
  '3': [PostsResponse_PostInfo$json],
};

@$core.Deprecated('Use postsResponseDescriptor instead')
const PostsResponse_PostInfo$json = {
  '1': 'PostInfo',
  '2': [
    {'1': 'post_id', '3': 1, '4': 1, '5': 13, '10': 'postId'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 13, '10': 'channelId'},
    {'1': 'file_id', '3': 3, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'publish_date', '3': 6, '4': 1, '5': 9, '10': 'publishDate'},
  ],
};

/// Descriptor for `PostsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postsResponseDescriptor = $convert.base64Decode(
    'Cg1Qb3N0c1Jlc3BvbnNlEjgKBXBvc3RzGAcgAygLMiIuc3R1ZHl2YXVsdC5Qb3N0c1Jlc3Bvbn'
    'NlLlBvc3RJbmZvUgVwb3N0cxq2AQoIUG9zdEluZm8SFwoHcG9zdF9pZBgBIAEoDVIGcG9zdElk'
    'Eh0KCmNoYW5uZWxfaWQYAiABKA1SCWNoYW5uZWxJZBIXCgdmaWxlX2lkGAMgASgJUgZmaWxlSW'
    'QSFAoFdGl0bGUYBCABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGAUgASgJUgtkZXNjcmlwdGlv'
    'bhIhCgxwdWJsaXNoX2RhdGUYBiABKAlSC3B1Ymxpc2hEYXRl');

@$core.Deprecated('Use fileChunkDescriptor instead')
const FileChunk$json = {
  '1': 'FileChunk',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
    {'1': 'filename', '3': 2, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'channel_id', '3': 3, '4': 1, '5': 13, '10': 'channelId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `FileChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileChunkDescriptor = $convert.base64Decode(
    'CglGaWxlQ2h1bmsSGAoHY29udGVudBgBIAEoDFIHY29udGVudBIaCghmaWxlbmFtZRgCIAEoCV'
    'IIZmlsZW5hbWUSHQoKY2hhbm5lbF9pZBgDIAEoDVIJY2hhbm5lbElkEhQKBXRpdGxlGAQgASgJ'
    'UgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24=');

@$core.Deprecated('Use uploadStatusResponseDescriptor instead')
const UploadStatusResponse$json = {
  '1': 'UploadStatusResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UploadStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadStatusResponseDescriptor = $convert.base64Decode(
    'ChRVcGxvYWRTdGF0dXNSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3'
    'NhZ2UYAiABKAlSB21lc3NhZ2U=');

