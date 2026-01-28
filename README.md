# EPUB builder (epub_builder)
Simple epub creating

## Features

Creating from list of chapters

## Getting started
```shell
dart pub add epub_builder
# or
flutter pub add epub_builder
```

Add from git

```shell
dart pub add epub_builder --git-url=git@github.com:adkrix/epub_builder.git --git-ref=main # --git-ref=v0.1.0
#or
flutter pub add epub_builder --git-url=git@github.com:adkrix/epub_builder.git --git-ref=main # --git-ref=v0.1.0
```

## Usage

```dart
import 'package:epub_builder/epub_builder.dart';

void main() {

  final book = EpubBook.create(
    title: 'Do it stupendously!',
    authors: ['John Doe', 'Jane Doe'],
  );

  book.add(
      EpubChapter.fromBodyHtml('Chapter 1', '<p>Conent of Chapter 1</p>')
  );
  book.add(
      EpubChapter.fromBodyHtml('Chapter 2', '<p>Conent of Chapter 2</p>')
  );
  File('../example_out/new.epub').writeAsBytesSync(EpubWriter(book).encode()!);

}
```

- [minimalistic example](example/epub_builder_example_min.dart)
- [Full example](example/epub_builder_example_max.dart)

## Development
Install `dart`
Install `yq` (optional for `./wrk` shell script)

## Publishing
- Commit changes 
- Update version
- Update CHANGELOG.md
- create version commit
```shell
./wrk -cp
```
- publish release 
```shell
dart pub publish epub_builder
```

## Add tag
```shell
git ciam 'v0.1.0'
git tag -a v0.1.0 -m "v0.1.0"
```
