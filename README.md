# README

This project can provide a starting point for any Rails 5.2 app that needs to
handle Ethereum signatures (secp256k1) on Heroku.

If you deploy this codebase as a new Heroku app, be sure to do the following:

```
heroku config:set SECP256K1_CPPFLAGS='--sysroot=/app/.apt'
heroku config:set LD_LIBRARY_PATH=/app/.apt/usr/lib:/app/tmp/cache/secp256k1/lib
heroku buildpacks:add --index=1 https://github.com/eugeneotto/heroku-buildpack-secp256k1
heroku buildpacks:add --index=2 https://github.com/heroku/heroku-buildpack-apt/
```

## We stand on the shoulders of giants

* [https://github.com/heroku/heroku-buildpack-testrunner/issues/15#issuecomment-346595628](https://github.com/heroku/heroku-buildpack-testrunner/issues/15#issuecomment-346595628)
* [https://github.com/numaverse/money-tree/commit/1538ccf773c48822378c6e06d1c0ff3038968b1c](https://github.com/numaverse/money-tree/commit/1538ccf773c48822378c6e06d1c0ff3038968b1c)

