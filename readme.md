[![Gem Version](https://badge.fury.io/rb/vcs4sql.svg)](https://rubygems.org/gems/vcs4sql)
[![License: MIT](https://img.shields.io/github/license/mashape/apistatus.svg)](./license.txt)
[![Commit activity](https://img.shields.io/github/commit-activity/y/dgroup/vcs4sql.svg?style=flat-square)](https://github.com/dgroup/vcs4sql/graphs/commit-activity)
[![Hits-of-Code](https://hitsofcode.com/github/dgroup/vcs4sql)](https://hitsofcode.com/view/github/dgroup/vcs4sql)

[![Build status circleci](https://circleci.com/gh/dgroup/vcs4sql.svg?style=shield)](https://circleci.com/gh/dgroup/vcs4sql)
[![Build Status travis](https://img.shields.io/travis/dgroup/vcs4sql.svg?label=travis)](https://travis-ci.org/dgroup/vcs4sql)
[![0pdd](http://www.0pdd.com/svg?name=dgroup/vcs4sql)](http://www.0pdd.com/p?name=dgroup/vcs4sql)
[![Dependency Status](https://requires.io/github/dgroup/vcs4sql/requirements.svg?branch=master)](https://requires.io/github/dgroup/vcs4sql/requirements/?branch=master)
[![Known Vulnerabilities](https://snyk.io/test/github/dgroup/vcs4sql/badge.svg)](https://snyk.io/org/dgroup/project/<TBD>/?tab=dependencies&vulns=vulnerable)
[![DevOps By Rultor.com](http://www.rultor.com/b/dgroup/vcs4sql)](http://www.rultor.com/p/dgroup/vcs4sql)

[![EO badge](http://www.elegantobjects.org/badge.svg)](http://www.elegantobjects.org/#principles)
[![SQ maintainability](https://sonarcloud.io/api/project_badges/measure?project=io.github.dgroup%3Avcs4sql&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=io.github.dgroup%3Avcs4sql)
[![Codebeat](https://codebeat.co/badges/<TBD>)](https://codebeat.co/projects/github-com-dgroup-vcs4sql-master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/<TBD>)](https://www.codacy.com/app/dgroup/vcs4sql?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=dgroup/vcs4sql&amp;utm_campaign=Badge_Grade)
[![Codecov](https://codecov.io/gh/dgroup/vcs4sql/branch/master/graph/badge.svg)](https://codecov.io/gh/dgroup/vcs4sql)
[![Code Climate](https://codeclimate.com/github/dgroup/vcs4sql/badges/gpa.svg)](https://codeclimate.com/github/dgroup/vcs4sql)

In the last few years, version control for database became best practice.
There are several implementations/ways for ruby, however, most of them are focused/dependent on particular
frameworks that restrict the migration outside the framework.
vcs4sql allows organizing version control for the database(s) in a simple, elegant and lightweight way without any dependencies on existing frameworks.

The main idea is to keep changes as simple as possible and be able to have full control of the database structure without hidden frameworks "magic".
Initial PoC is designed for [sqlite](https://www.sqlite.org). 

---

- [Quick start](#quick-start)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

### Quick start

```
$ gem install vcs4sql
```
```bash
# Define the database migration scripts
$ tree
.
├── bin
├── Gemfile
├── Guardfile
├── Rakefile
├── ...
│   ├── ...
├── sqlite.db
├── ...
└── upgrades
    └── sqlite
        ├── 001-install-main-tables.sql
        ├── 002-add-missing-indexes.sql
        ├── 003-add-missing-foreigh-keys.sql
        ├── ...
        └── 999.testdata.sql
```
```ruby
require "vcs4sql"
 
Vcs4sql::Sqlite::Migration.new "sqlite.db"
                          .upgrade "upgrades/sqlite"
```
The scripts will be executed in a natural order based on name, so far.

### Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/dgroup/vcs4sql/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

### License

The gem is available as open source under the terms of the [MIT License](license.txt).

### Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](.github/CODE_OF_CONDUCT.md).

### Contribution guide

Pull requests are welcome!
