#!/usr/bin/env dart
// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library enum_generator_tests;

import 'dart:io';
import 'package:protoc-plugin/src/descriptor.pb.dart';
import 'package:protoc-plugin/protoc.dart';
import 'package:unittest/unittest.dart';

void main() {
  test('testEnumGenerator', () {
    String expected = r'''
class PhoneType extends ProtobufEnum {
  static const PhoneType MOBILE = const PhoneType._(0, 'MOBILE');
  static const PhoneType HOME = const PhoneType._(1, 'HOME');
  static const PhoneType WORK = const PhoneType._(2, 'WORK');

  static const PhoneType BUSINESS = WORK;

  static const List<PhoneType> values = const <PhoneType> [
    MOBILE,
    HOME,
    WORK,
  ];

  static final Map<int, PhoneType> _byValue = ProtobufEnum.initByValue(values);
  static PhoneType valueOf(int value) => _byValue[value];

  const PhoneType._(int v, String n) : super(v, n);
}

''';
    EnumDescriptorProto ed = new EnumDescriptorProto()
        ..name = 'PhoneType'
        ..value.addAll([
            new EnumValueDescriptorProto()
                ..name = 'MOBILE'
                ..number = 0,
            new EnumValueDescriptorProto()
                ..name = 'HOME'
                ..number = 1,
            new EnumValueDescriptorProto()
                ..name = 'WORK'
                ..number = 2,
            new EnumValueDescriptorProto()
                ..name = 'BUSINESS'
                ..number = 2]);
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    EnumGenerator eg = new EnumGenerator(ed, null,
        new GenerationContext(new OutputStreamWriter(stderr)));
    eg.generate(writer);
    expect(buffer.toString(), expected);
  });
}