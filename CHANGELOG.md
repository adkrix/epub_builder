## 0.2.3

- Fix invalid XHTML (self-closing `<link/>`) — корректное открытие на PocketBook.
- Escape `title` in `bodyToXhtml` via `HtmlEscape`.
- Use `pub-identifier` for `dc:identifier` / `unique-identifier` (valid NCName).
- Remove `toc="ncx"` from `<spine>` (NCX is not generated).
- Cover page: `title = book.title` (no empty `<title>`).
- Rename `_anifestCss` → `_manifestCss`.

## 0.2.2
- fix ImageMimeType; add docs
- 
## 0.2.1
fix dependencies

## 0.2.0
Add metadata fields:
- identifier
- language
- description
- published

## 0.1.1
- update reference information

## 0.1.0
- Initial version.
- bais functionality
- book authors
- book title
- list of chapters like title and html body content objects
- cover image (optional)
- anchors in chapter (optional)

