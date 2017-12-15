#!/bin/bash

svn checkout --username anonsvn --password anonsvn https://smlnj-gforge.cs.uchicago.edu/svn/smlnj/sml/releases/release-110.82 `dirname $0`/src
