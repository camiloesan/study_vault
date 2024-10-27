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

@$core.Deprecated('Use channelDescriptor instead')
const Channel$json = {
  '1': 'Channel',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 13, '10': 'channelId'},
  ],
};

/// Descriptor for `Channel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDescriptor = $convert.base64Decode(
    'CgdDaGFubmVsEh0KCmNoYW5uZWxfaWQYASABKA1SCWNoYW5uZWxJZA==');

@$core.Deprecated('Use postsDescriptor instead')
const Posts$json = {
  '1': 'Posts',
  '2': [
    {'1': 'posts', '3': 7, '4': 3, '5': 11, '6': '.studyvault.Posts.PostInfo', '10': 'posts'},
  ],
  '3': [Posts_PostInfo$json],
};

@$core.Deprecated('Use postsDescriptor instead')
const Posts_PostInfo$json = {
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

/// Descriptor for `Posts`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postsDescriptor = $convert.base64Decode(
    'CgVQb3N0cxIwCgVwb3N0cxgHIAMoCzIaLnN0dWR5dmF1bHQuUG9zdHMuUG9zdEluZm9SBXBvc3'
    'RzGrYBCghQb3N0SW5mbxIXCgdwb3N0X2lkGAEgASgNUgZwb3N0SWQSHQoKY2hhbm5lbF9pZBgC'
    'IAEoDVIJY2hhbm5lbElkEhcKB2ZpbGVfaWQYAyABKAlSBmZpbGVJZBIUCgV0aXRsZRgEIAEoCV'
    'IFdGl0bGUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEiEKDHB1Ymxpc2hfZGF0'
    'ZRgGIAEoCVILcHVibGlzaERhdGU=');

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

@$core.Deprecated('Use uploadStatusDescriptor instead')
const UploadStatus$json = {
  '1': 'UploadStatus',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UploadStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadStatusDescriptor = $convert.base64Decode(
    'CgxVcGxvYWRTdGF0dXMSGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgAS'
    'gJUgdtZXNzYWdl');

