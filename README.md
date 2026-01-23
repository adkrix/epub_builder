# EPUB builder (epub_builder)
Simple epub creating

## Features

Creating from list of chapters

## Getting started

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
  File('../example_out/new.epub')
    ..createSync()
    ..writeAsBytesSync(EpubWriter(book).encode()!);

}
```
