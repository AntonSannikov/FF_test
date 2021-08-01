library globals;

import 'package:flutter/material.dart';

String? access_token;
final String bearer_token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTksImlhdCI6MTYyMDQ5MTYxNCwiZXhwIjoxMDAxNjIwNDkxNjE0fQ.zGqmT0dH2bUMkG5DltUciML5CCXDbXsdO3p5a6AH5Z8';
final Color loginDarkerColor = Color.fromRGBO(187, 78, 117, 1);
final Color loginLighterColor = Color.fromRGBO(231, 66, 73, 1);

Map<String, double> pixelRatio = {'height': 0, 'width': 0, 'received': 0};
