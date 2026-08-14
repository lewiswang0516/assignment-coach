# Java Repository Inspection

This reference covers Phase 3.
Prefer facts read from files over model guesses; record the file that established each fact.

## Checklist

Determine each of the following, with its evidence path:

1. Build system: look for `build.gradle`, `build.gradle.kts`, `settings.gradle*`, `pom.xml`, `build.xml`, or a plain `src/` javac layout.
2. Java version: `sourceCompatibility`, `targetCompatibility`, or toolchain blocks in Gradle; `maven.compiler.source`/`release` in Maven; `.java-version`; spec statements.
3. Test framework: JUnit 4 vs JUnit 5 from build dependencies and from imports in provided tests.
4. Source roots and test roots: from build configuration, falling back to conventional `src/main/java` and `src/test/java`, or the layout actually present.
5. Package structure: enumerate packages under the source roots.
6. Public API: for skeleton files, list public types and public/protected members; these anchor API-lock rules.
7. Style configuration: Checkstyle, Spotless, or editorconfig files and how the build invokes them.
8. Submission structure: expected archive layout or directory structure from submission instructions, cross-checked against the repository.

## Conflict handling

When the spec and the build configuration disagree (for example the spec says Java 17 but Gradle targets 11), record a `version_conflict` in the source inventory and a `conflicting` rule; do not pick silently.

## Output

Facts feed three places: repository facts inform `official_derived` rules, source and test roots feed artifact classification path patterns, and build/test commands feed the preflight configuration.
