//
//  Generated code. Do not modify.
//  source: studyvault.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'studyvault.pb.dart' as $0;

export 'studyvault.pb.dart';

@$pb.GrpcServiceName('studyvault.PostsService')
class PostsServiceClient extends $grpc.Client {
  static final _$getPostsByChannelId = $grpc.ClientMethod<$0.ChannelRequest, $0.PostsResponse>(
      '/studyvault.PostsService/GetPostsByChannelId',
      ($0.ChannelRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PostsResponse.fromBuffer(value));
  static final _$uploadPost = $grpc.ClientMethod<$0.FileChunk, $0.UploadStatusResponse>(
      '/studyvault.PostsService/UploadPost',
      ($0.FileChunk value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UploadStatusResponse.fromBuffer(value));
  static final _$getFileNameByFileId = $grpc.ClientMethod<$0.FileId, $0.FileName>(
      '/studyvault.PostsService/GetFileNameByFileId',
      ($0.FileId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FileName.fromBuffer(value));

  PostsServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.PostsResponse> getPostsByChannelId($0.ChannelRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPostsByChannelId, request, options: options);
  }

  $grpc.ResponseFuture<$0.UploadStatusResponse> uploadPost($async.Stream<$0.FileChunk> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$uploadPost, request, options: options).single;
  }

  $grpc.ResponseFuture<$0.FileName> getFileNameByFileId($0.FileId request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFileNameByFileId, request, options: options);
  }
}

@$pb.GrpcServiceName('studyvault.PostsService')
abstract class PostsServiceBase extends $grpc.Service {
  $core.String get $name => 'studyvault.PostsService';

  PostsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ChannelRequest, $0.PostsResponse>(
        'GetPostsByChannelId',
        getPostsByChannelId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChannelRequest.fromBuffer(value),
        ($0.PostsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FileChunk, $0.UploadStatusResponse>(
        'UploadPost',
        uploadPost,
        true,
        false,
        ($core.List<$core.int> value) => $0.FileChunk.fromBuffer(value),
        ($0.UploadStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FileId, $0.FileName>(
        'GetFileNameByFileId',
        getFileNameByFileId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FileId.fromBuffer(value),
        ($0.FileName value) => value.writeToBuffer()));
  }

  $async.Future<$0.PostsResponse> getPostsByChannelId_Pre($grpc.ServiceCall call, $async.Future<$0.ChannelRequest> request) async {
    return getPostsByChannelId(call, await request);
  }

  $async.Future<$0.FileName> getFileNameByFileId_Pre($grpc.ServiceCall call, $async.Future<$0.FileId> request) async {
    return getFileNameByFileId(call, await request);
  }

  $async.Future<$0.PostsResponse> getPostsByChannelId($grpc.ServiceCall call, $0.ChannelRequest request);
  $async.Future<$0.UploadStatusResponse> uploadPost($grpc.ServiceCall call, $async.Stream<$0.FileChunk> request);
  $async.Future<$0.FileName> getFileNameByFileId($grpc.ServiceCall call, $0.FileId request);
}
