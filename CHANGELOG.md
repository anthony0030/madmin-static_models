# Changelog

## 0.1.1

- Restrict madmin to >= 2.6, < 3. Madmin 3 replaced Pagy with its own pagination, which breaks static resource index pages on 0.1.x; use 0.2 for Madmin 3.

## 0.1.0

- Initial release: ActiveHash adapter (covers ActiveHash, ActiveYaml, ActiveJson and ActiveFile models), read-only resources, in-memory search/sort/pagination, generator support, and an adapter API for other static backends.
- Requires madmin >= 2.6 (extension load hooks and seams).
