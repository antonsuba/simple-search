# simple-search
Ruby CLI app for finding matching entries and duplicates.

## Usage

### Partial Text Search
Use the `search` command with the `-q` option to partially match the query string with the clients dataset. By default, the app will match the query string to the dataset's `name` field.
```bash
./simple-search search -q 'query-here'
```

You can choose to search through a different field of the dataset by using the `-f` option.
```bash
./simple-search search -q 'query-here' -f 'field-here'
```

### Search for Duplicates
Use the `duplicates` command find all clients with duplicate values. By default, the app will find duplicates using the dataset's `email` field.
```bash
./simple-search duplicates
```

You can choose find duplicates from a different field of the dataset using the `-f` option
```bash
./simple-search duplicates -f 'field-here'
```

## Tests
Test coverage is available for both the search engine and the main CLI app. To run tests:
1. Run `bundle install` to install `rspec`
2. Use `rspec` to run the tests

## Notes
1. This app assumes that the ruby file `./simple-search` has the correct executable permissions.
2. This version of the app assumes that the `clients.json` dataset is available in the `data` directory.
3. This app assumes that the dataset will remain within a reasonable size. Given the scope of the project, substring search was used to reduce complexity. Further optimizations might be necessary if ever the data grows to be too much for the app to handle.
