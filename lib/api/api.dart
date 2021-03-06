import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:focial/api/urls.dart';
import 'package:focial/services/auth.dart';
import 'package:focial/services/finder.dart';

part 'api.chopper.dart';

final auth = find<AuthService>();

@ChopperApi()
abstract class FocialAPI extends ChopperService {
  /// auth apis
  @Post(path: Urls.REGISTER)
  Future<Response<dynamic>> register(
      {@Field() String name, @Field() String email, @Field() String password});

  @Post(path: Urls.LOGIN)
  Future<Response<dynamic>> login(
      {@Field() String email, @Field() String password});

  @Post(path: Urls.RESEND_ACC_VERIFICATION_LINK)
  Future<Response<dynamic>> resendAccountVerifyLink(
      {@Field() String email, @Field() String password});

  @Patch(path: Urls.UPDATE_PASSWORD)
  Future<Response<dynamic>> updatePassword(
      {@Field() String oldPassword, @Field() String newPassword});

  @Post(path: Urls.SEND_PASSWORD_RESET_CODE)
  Future<Response<dynamic>> sendPasswordResetCode({@Field() String email});

  @Post(path: Urls.RE_SEND_PASSWORD_RESET_CODE)
  Future<Response<dynamic>> resendPasswordResetCode({@Field() String email});

  @Post(path: Urls.RESET_PASSWORD)
  Future<Response<dynamic>> resetPassword(
      {@Field() String email, @Field() String otp, @Field() String password});

  @Get(path: Urls.USER)
  Future<Response<dynamic>> getUser();

  @Patch(path: Urls.USER)
  Future<Response<dynamic>> updateUser(@body Map<String, dynamic> body);

  @Get(path: Urls.CHECK_USERNAME + "{username}")
  Future<Response<dynamic>> checkUsername(@Path() String username);

  @Post(path: Urls.UPLOAD_PROFILE_PICTURE)
  @multipart
  Future<Response> uploadProfilePicture(@PartFile("file") String file);

  @Post(path: Urls.UPLOAD_COVER_PICTURE)
  @multipart
  Future<Response> uploadCoverPicture(@PartFile("file") String file);

  @Get(path: Urls.STORY)
  Future<Response<dynamic>> getStoryFeed();

  @Post(path: Urls.STORY)
  Future<Response<dynamic>> newStory(@body Map<String, dynamic> body);

  @Post(path: Urls.POST)
  Future<Response<dynamic>> newPost(@body Map<String, dynamic> body);

  @Post(path: Urls.POST_IMAGE_UPLOAD)
  @multipart
  Future<Response> uploadPostImage(@PartFile("file") String file);

  @Get(path: Urls.POST)
  Future<Response<dynamic>> getPosts();

  static FocialAPI create() {
    final client = ChopperClient(
        baseUrl: Urls.BASE_URL,
        services: [
          _$FocialAPI(),
        ],
        interceptors: [HttpLoggingInterceptor(), HeadersInterceptor()],
        converter: JsonConverter());
    return _$FocialAPI(client);
  }
}

class HeadersInterceptor extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    var headers = {
      "Content-Type": "application/json",
    };

    print(auth.authData.accessToken);
    // print(request.body);
    headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer ${auth.authData.accessToken}"
    });

    return request.copyWith(headers: headers);
  }
}
