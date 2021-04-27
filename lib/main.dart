import 'dart:async';

import 'package:googleapis_auth/auth_io.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart' as auth;


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/drive.readonly',
  ],
);
const scope = [drive.DriveApi.driveScope];
final accountCredentials = auth.ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "fiqh-app-311721",
  "private_key_id": "bb8ecebea13997eec6a5d00c10a7755187db3998",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCqOCe1tHkrcdMG\nASXnja1Kduj/5EW6KbDtd+OvG4Oynx+2rBUvarDQx+/rwjI2ydI7MOk0leXbsVoR\nq209Ky290NUOPojfhQ8IhZt0Jp4Bl//HLGjGnDwjEZoBArbG+hXjQXRZaGR4zBe/\nosiivxBfq9zEGuKfRd23JuHXdr9jTChz57iStqMSo/4tTbbr+w3DJAkJ7DVRuRqT\nPMrC50WAOiYLYH3JwhU7a0C5J955dqrzcBFP3Jrt0ytRqbdknujnArDTfpjsplsB\nNYQL2MLVfsOTG/4vZ3ykJoMjmfakfpXTOlRvP/vFJT9XBXXZORhqjZN3LRmDFGFH\ndJkaf6LVAgMBAAECggEADdufhAAK41oTc4gxZU4X/xl6M6cKdDMDt/mMPEvRp3+j\n7dPJr8AQYBb+9eMsAmDg8De1rLXNblrcedbKgHHc+fif99Zof0YOaMOz2btxHrEY\nvkbjytOaY8KBlrZ5We6vTH6eMc85aso23r+qdPF4LEnKId8MdyoReGE+frOotjUx\nPkG+uYQfwYK+qVMIGg0i99+Emq1qPtO/s/n9+IY4DlFEdEmURcRqq+TIQ5531AMz\nToiuqYn4quXfwweJ4eBo6tcfgpT9YR/M9N3xSQx4HHs73sfna6zGvB6+sdbXipc1\ny3Xyh1S9KklnOUG0HkDPjUacF4p3PWGWtezreE9XawKBgQDv46Mu3GKN8Nb7DgQf\nc+CrFKBPCkOJfxvHA0ivczHmc5uogtey6RrapNlU76ZVD/qZx9mwk05pJ3DsuviP\n0zYpt9bIjMps5WEzllzjgAynfpaQ8ufj4NMeTaZM5T0gZQcRSbwlmfWvR03Yq3yL\nlRcz4QX/jC3+P5FMvUQJ+WiQbwKBgQC1prL9bb2/HtmZTEKKxjpW7Q7MlOzhEcf6\nyZ3jY6jFxhiivVXVlaaPYPpd9iQGeWOIoWdxiwh8oXwZKyEY6f28dhvXTiQKVzJw\nDUPbM+KBilNYaOSQvjiDn6wNDF19iQJIaMhWWxIvjt8HioD00u0A6d3giR0OjmTS\n+UhEOH1a+wKBgQDKyatDzOe/R63kUufnUsTEus39oxaOoBXyOXNzZbT0NByM6fa/\ndlDOLfbO1zvLwpM89nWu0AfD2qSaaj//DTRHNfJqXKIuRgXSXzSs2K1Z1igf5kdj\nGsY9YrTHYi43OVAtLCDRxIGtJ2DGXckOEf2oTHwOmAi1WjVRItnmeKENHwKBgEgg\nRpXGCz9l2nS6CPndN7DoM6Ybw+qiCsuTXnO5UHwm6gVENF64KwhnM0I3x5oifNj1\nbYNx9w61d/buXxfrYOqB4xAcYMcSVF6Vhcn10gwphmpmS8sFHJ92uPP9YunDivqB\nUHqpcpEbo4b1Abs0PRLNyWGsT7NF6tayUHV2EKAdAoGBAMYBxHNbiZ2spTFEyDUZ\n6hzywtuF0bQsfyn6jjJ5FtQ9Di4pmCFBLM04NGHupl1aIXzGPuq3imHL+KZgOZ6d\nPZUXttcHd3YNPySwoq5ikNDa2NKceYEF57kbqtb2++TiG/VfU5HeEnhrMtEdaanx\nKoQhqm5tepOQXFt1TqFJFc5b\n-----END PRIVATE KEY-----\n",
  "client_email": "al-feqh-al-manhagy@fiqh-app-311721.iam.gserviceaccount.com",
  "client_id": "114646491203103271927",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/al-feqh-al-manhagy%40fiqh-app-311721.iam.gserviceaccount.com"
}
''');
void main() {
  runApp(
    MaterialApp(
      title: 'Google Sign In',
      debugShowCheckedModeBanner: false,
      home: SignInDemo(),
    ),
  );
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class AuthClient extends http.BaseClient {
  final http.Client _baseClient;
  final Map<String, String> _headers;

  AuthClient(this._baseClient, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _baseClient.send(request);
  }
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount _currentUser;
  List<drive.File> _documents = [];

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _getDocuments();
      }
    });
    _googleSignIn.signInSilently();
  }

  void _getDocuments() async {
     print('hello .. entered get data fn');
    var client = http.Client();
    var header = await _currentUser.authHeaders;
    var authClient = AuthClient(client, header);
    var api = drive.DriveApi(authClient);
    obtainAccessCredentialsViaServiceAccount(
            accountCredentials, scope, authClient)
        .then((AccessCredentials credentials) async {
      print('hello ... entered access cred. fn');
      var pageToken;

      var fileList = await api.files.list(
          q: 'mimeType=\'application/vnd.google-apps.folder\'',
          pageSize: 50,
          pageToken: pageToken,
          supportsAllDrives: false,
          spaces: "drive",
          $fields: "nextPageToken, files(id, name, mimeType, thumbnailLink)");
      pageToken = fileList.nextPageToken;

      setState(() {
        _documents = fileList.files;
        print('hello set state');
        print('set state documents length....... ${_documents.length}');
      });
      client.close();
    });
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          Expanded(
            child: ListView.builder(
              itemCount: _documents.length,
              itemBuilder: (BuildContext context, int index) {
                var file = _documents[index];
                if (file.thumbnailLink != null &&
                    file.mimeType.contains("image")) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: Image.network(
                              file.thumbnailLink,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(file.name),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  Widget leadingIcon;
                  if (file.mimeType.contains("folder")) {
                    leadingIcon = Icon(Icons.folder);
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        leading: leadingIcon,
                        title: Text(file.name),
                        subtitle: Text(file.mimeType),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('REFRESH'),
            onPressed: null,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
