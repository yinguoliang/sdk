import '../descriptor.dart' as d;
import '../test_pub.dart';
import '../serve/utils.dart';
const SCRIPT = """
const TOKEN = "hi";
main() {
  print(TOKEN);
}
""";
main() {
  initConfig();
  withBarbackVersions("any", () {
    integration('runs transformers in the entrypoint package', () {
      d.dir(appPath, [d.pubspec({
          "name": "myapp",
          "transformers": ["myapp/src/transformer"]
        }),
            d.dir(
                "lib",
                [d.dir("src", [d.file("transformer.dart", dartTransformer("transformed"))])]),
            d.dir("bin", [d.file("hi.dart", SCRIPT)])]).create();
      createLockFile('myapp', pkg: ['barback']);
      var pub = pubRun(args: ["hi"]);
      pub.stdout.expect("(hi, transformed)");
      pub.shouldExit();
    });
  });
}
