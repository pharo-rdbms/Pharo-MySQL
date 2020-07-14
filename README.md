# Pharo-MySQL

[![GitHub release](https://img.shields.io/github/release/pharo-rdbms/Pharo-MySQL.svg)](https://github.com/pharo-rdbms/Pharo-MySQL/releases/latest)
[![Build Status](https://github.com/pharo-rdbms/Pharo-MySQL/workflows/Build/badge.svg?branch=master)](https://github.com/pharo-rdbms/Pharo-MySQL/actions?query=workflow%3ABuild)
[![Coverage Status](https://codecov.io/github/pharo-rdbms/Pharo-MySQL/coverage.svg?branch=master)](https://codecov.io/gh/pharo-rdbms/Pharo-MySQL/branch/master)
[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)

Pharo Drivers for MySQL and MariaDB, including a [Glorp](https://github.com/pharo-rdbms/Glorp) adaptor.

# Quick Start

## Installation

```Smalltalk
Metacello new
	repository: 'github://pharo-rdbms/Pharo-MySQL';
	baseline: 'MySQL';
	load
```
