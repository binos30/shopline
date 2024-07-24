import globals from "globals";
import pluginJs from "@eslint/js";

export default [
  { languageOptions: { globals: { ...globals.browser, ...globals.node } } },
  pluginJs.configs.recommended,
  {
    ignores: [
      ".yarn/",
      "app/assets/builds/*",
      "db/",
      "docs/",
      "lib/",
      "log/*",
      "public/assets/*",
      "spec/",
      "storage/",
      "tmp/",
      "vendor/"
    ]
  }
];
