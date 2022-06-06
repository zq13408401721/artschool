import 'dart:async' show Future, StreamController;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart'
    show ImageRenderMethodForWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';


import 'package:path_provider/path_provider.dart';

import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart'
if (dart.library.io) '_image_loader.dart'
if (dart.library.html) 'package:cached_network_image_web/cached_network_image_web.dart'
    show ImageLoader;

import 'BaseImageProvider.dart';

/// Function which is called after loading the image failed.
typedef ErrorListener = void Function();

/// IO implementation of the CachedNetworkImageProvider; the ImageProvider to
/// load network images using a cache.
class DownImageProvider extends BaseImageProvider<DownImageProvider> {
  /// Creates an ImageProvider which loads an image from the [url], using the [scale].
  /// When the image fails to load [errorListener] is called.
  const DownImageProvider(
      this.url, {
        this.maxHeight,
        this.maxWidth,
        this.scale = 1.0,
        this.errorListener,
        this.headers,
        this.cacheManager,
        this.cacheKey,
        this.isdown,
        this.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage,
      });

  final BaseCacheManager cacheManager;

  /// Web url of the image to load
  final String url;

  /// Cache key of the image to cache
  final String cacheKey;

  /// Scale of the image
  final double scale;

  /// Listener to be called when images fails to load.
  final ErrorListener errorListener;

  /// Set headers for the image provider, for example for authentication
  final Map<String, String> headers;

  final int maxHeight;

  final int maxWidth;

  final bool isdown;

  final ImageRenderMethodForWeb imageRenderMethodForWeb;

  @override
  Future<DownImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DownImageProvider>(this);
  }

  @override
  Future<ImageStreamCompleter> load(DownImageProvider key, DecoderCallback decode) async{
    final chunkEvents = StreamController<ImageChunkEvent>();
    return MultiImageStreamCompleter(
      codec: await _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<BaseImageProvider>(
          'Image provider: $this \n Image key: $key',
          this,
          style: DiagnosticsTreeStyle.errorProperty,
        );
      },
    );
  }

  Future<Stream<ui.Codec>> _loadAsync(
      DownImageProvider key,
      StreamController<ImageChunkEvent> chunkEvents,
      DecoderCallback decode,
      ) async{
    assert(key == this);
    if(isdown){
      final Uint8List bytes = await _getImageForSdk(key.url);
      if(bytes != null && bytes.lengthInBytes != null && bytes.lengthInBytes != 0){
        print("本地图片获取成功：${key.url}");
        return PaintingBinding.instance.instantiateImageCodec(bytes).asStream();
      }
    }
    return ImageLoader().loadAsync(
      url,
      cacheKey,
      chunkEvents,
      decode,
      cacheManager ?? DefaultCacheManager(),
      maxHeight,
      maxWidth,
      headers,
      errorListener,
      imageRenderMethodForWeb,
          () => PaintingBinding.instance?.imageCache?.evict(key),
    );
  }

  /**
   * 保存图片到本地
   */
  void _saveImageToSdk(Uint8List _list,String name) async{
    name = md5.convert(Utf8Encoder().convert(name)).toString();
    Directory dir = await getTemporaryDirectory();
    String path = "${dir.path}/${name}";
    var file = File(path);
    bool exist = await file.exists();
    if(!exist){
      File(path).writeAsBytesSync(_list);
    }
  }

  /**
   * 从sdk卡获取图片
   */
  _getImageForSdk(String name)async{
    name = md5.convert(Utf8Encoder().convert(name)).toString();
    Directory dir = await getTemporaryDirectory();
    String path = "${dir.path}/${name}";
    var file = File(path);
    bool exist = await file.exists();
    if(exist){
      final Uint8List bytes = await file.readAsBytes();
      return bytes;
    }
    return null;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is CachedNetworkImageProvider) {
      return ((cacheKey ?? url) == (other.cacheKey ?? other.url)) &&
          scale == other.scale &&
          maxHeight == other.maxHeight &&
          maxWidth == other.maxWidth;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(cacheKey ?? url, scale, maxHeight, maxWidth);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';
}
