import 'package:flutter_guid/flutter_guid_error.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Equality Tests:", () {
    test("Case insensitive equality works", () {
      final guidAlpha = new Guid("ac3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");
      final guidBeta = new Guid("AC3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");

      final areEqual = guidAlpha == guidBeta;

      expect(true, areEqual);
    });

    test("Null values in testing don't throw exception", () {
      final guidAlpha = new Guid("");
      Guid? guidBeta;

      final areEqual = guidAlpha == guidBeta;

      expect(areEqual, false);
    });

    test("Hashcodes for GUIDs with the same value should be the same", () {
      final guidAlpha = new Guid("ac3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");
      final guidBeta = new Guid("ac3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");

      expect(guidAlpha.hashCode, guidBeta.hashCode);
    });

     test("GUID value casing should not affect hashcodes", () {
      final guidAlpha = new Guid("ac3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");
      final guidBeta = new Guid("AC3FA00F-8F5B-4E93-B7A5-2EE3051A12B9");

      expect(guidAlpha.hashCode, guidBeta.hashCode);
    });

    test("Hashcodes for GUIDs with different values should be different", () {
      final guidAlpha = new Guid("ac3fa00f-8f5b-4e93-b7a5-2ee3051a12b9");
      final guidBeta = new Guid("f841928c-5393-4c6e-9b22-85de1fcf317a");

      expect(guidAlpha.hashCode != guidBeta.hashCode, true);
    });

    test("Separate GUIDs with the same underlying value should point to the same Map value", () {
      final guidValue = "ac3fa00f-8f5b-4e93-b7a5-2ee3051a12b9";
      final guidAlpha = Guid(guidValue);
      final guidBeta = Guid(guidValue);

      final Map<Guid, int> map = <Guid, int>{
        guidAlpha: 2
      };

      expect(map.containsKey(guidAlpha), true);
      expect(map.containsKey(guidBeta), true);
    });
  });

  group("Validity Tests", () {
    _initializer(String? value, bool expectException) {
      if (expectException) {
        expect(() => new Guid(value), throwsA((e) {
          return e != null && e is FlutterGuidError;
        }));
      } else {
        final guid = new Guid(value);
        final expectedValue =
            (value == null || value.isEmpty) ? Guid.defaultValue.value : value;
        expect(guid.value, expectedValue);
        expect(guid.toString(), expectedValue);
      }
    }

    test("Invalid decimal values not accepted",
        () => _initializer("12345", true));
    test("Invalid hex values not accepted", () => _initializer("bad", true));

    test("Invalid random values not accepted",
        () => _initializer("thequickbrown", true));

    test("Invalid decimal and hex values not accepted",
        () => _initializer("12345", true));

    test("Default Guid is allowed",
        () => _initializer("00000000-0000-0000-0000-000000000000", false));

    test("Valid Guid is allowed",
        () => _initializer("f841928c-5393-4c6e-9b22-85de1fcf317a", false));

    test("Null is allowed", () => _initializer(null, false));

    test("Empty string is allowed", () => _initializer("", false));

    test("Get newGuid works", () {
      final guid = Guid.newGuid;
      final isValid = Guid.isValid(guid);
      expect(isValid, true);
    });
  });
}
