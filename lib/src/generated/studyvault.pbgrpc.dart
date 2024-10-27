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
  static final _$getPostsByChannelId = $grpc.ClientMethod<$0.Channel, $0.Posts>(
      '/studyvault.PostsService/GetPostsByChannelId',
      ($0.Channel value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Posts.fromBuffer(value));
  static final _$uploadPost = $grpc.ClientMethod<$0.FileChunk, $0.UploadStatus>(
      '/studyvault.PostsService/UploadPost',
      ($0.FileChunk value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UploadStatus.fromBuffer(value));

  PostsServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Posts> getPostsByChannelId($0.Channel request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPostsByChannelId, request, options: options);
  }

  $grpc.ResponseFuture<$0.UploadStatus> uploadPost($async.Stream<$0.FileChunk> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$uploadPost, request, options: options).single;
  }
}

@$pb.GrpcServiceName('studyvault.PostsService')
abstract class PostsServiceBase extends $grpc.Service {
  $core.String get $name => 'studyvault.PostsService';

  PostsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Channel, $0.Posts>(
        'GetPostsByChannelId',
        getPostsByChannelId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Channel.fromBuffer(value),
        ($0.Posts value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FileChunk, $0.UploadStatus>(
        'UploadPost',
        uploadPost,
        true,
        false,
        ($core.List<$core.int> value) => $0.FileChunk.fromBuffer(value),
        ($0.UploadStatus value) => value.writeToBuffer()));
  }

  $async.Future<$0.Posts> getPostsByChannelId_Pre($grpc.ServiceCall call, $async.Future<$0.Channel> request) async {
    return getPostsByChannelId(call, await request);
  }

  $async.Future<$0.Posts> getPostsByChannelId($grpc.ServiceCall call, $0.Channel request);
  $async.Future<$0.UploadStatus> uploadPost($grpc.ServiceCall call, $async.Stream<$0.FileChunk> request);
}
